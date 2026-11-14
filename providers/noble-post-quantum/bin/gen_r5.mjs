#!/usr/bin/env node
// SPDX-License-Identifier: Apache-2.0
// Generates R5 certificate artifacts for the IETF Hackathon PQC certificates project
// (https://github.com/IETF-Hackathon/pqc-certificates) with @noble/post-quantum.
//
// Usage: node bin/gen_r5.mjs <out.zip> [--dir <folder>] [--algs ml-dsa,ml-kem,slh-dsa]
//   --dir   also keep the files in <folder> (otherwise a temporary folder is removed)
//   --algs  which families to produce (default: all three)
//   R5_TEST_SEED=<hex>  derive every key, serial number and signature from this seed and use a
//                       fixed validity period (for tests only; the default is fresh randomness)
//
// Produced, flat, DER (readme "Zip Format (R5)"):
//   ML-DSA-44/65/87     <friendly>-<oid>_ta.der (self-signed), _seed_priv.der, _expandedkey_priv.der,
//                       _both_priv.der                                   (RFC 9881)
//   ML-KEM-512/768/1024 <friendly>-<oid>_ee.der signed by the ML-DSA-44/65/87 TA, the same three key
//                       forms, _ciphertext.bin and _ss.bin                 (RFC 9935)
//   SLH-DSA (12 sets)   <friendly>-<oid>_ta.der (self-signed), _priv.der    (RFC 9909)
// Certificates: v3, AlgorithmIdentifier parameters absent, pure signatures with the empty
// context over the DER TBSCertificate, a distinct subject DN per TA, keyUsage as in the RFC
// examples (TA: digitalSignature, keyCertSign, cRLSign + basicConstraints CA:TRUE; ML-KEM EE:
// keyEncipherment only), SKI = SHA-1 of the public key (RFC 5280 method 1), AKI = the issuer's SKI
// (on the TA it equals its own SKI).

import { mkdtempSync, mkdirSync, writeFileSync, rmSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { tmpdir } from 'node:os';
import { createHash, randomBytes } from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { ml_dsa44, ml_dsa65, ml_dsa87 } from '@noble/post-quantum/ml-dsa.js';
import { ml_kem512, ml_kem768, ml_kem1024 } from '@noble/post-quantum/ml-kem.js';
import * as slh from '@noble/post-quantum/slh-dsa.js';
import * as der from '../lib/der.mjs';

const PROVIDER = 'noble-post-quantum';
const VALIDITY_YEARS = 20; // the readme recommends 10 years or more

export const MLDSA = [
  ['ml-dsa-44', '2.16.840.1.101.3.4.3.17', ml_dsa44],
  ['ml-dsa-65', '2.16.840.1.101.3.4.3.18', ml_dsa65],
  ['ml-dsa-87', '2.16.840.1.101.3.4.3.19', ml_dsa87],
];
export const MLKEM = [ // ML-KEM-512/768/1024 EEs are signed by the ML-DSA-44/65/87 TA (readme)
  ['ml-kem-512', '2.16.840.1.101.3.4.4.1', ml_kem512, 'ml-dsa-44'],
  ['ml-kem-768', '2.16.840.1.101.3.4.4.2', ml_kem768, 'ml-dsa-65'],
  ['ml-kem-1024', '2.16.840.1.101.3.4.4.3', ml_kem1024, 'ml-dsa-87'],
];
export const SLHDSA = [
  ['slh-dsa-sha2-128s', '2.16.840.1.101.3.4.3.20', slh.slh_dsa_sha2_128s],
  ['slh-dsa-sha2-128f', '2.16.840.1.101.3.4.3.21', slh.slh_dsa_sha2_128f],
  ['slh-dsa-sha2-192s', '2.16.840.1.101.3.4.3.22', slh.slh_dsa_sha2_192s],
  ['slh-dsa-sha2-192f', '2.16.840.1.101.3.4.3.23', slh.slh_dsa_sha2_192f],
  ['slh-dsa-sha2-256s', '2.16.840.1.101.3.4.3.24', slh.slh_dsa_sha2_256s],
  ['slh-dsa-sha2-256f', '2.16.840.1.101.3.4.3.25', slh.slh_dsa_sha2_256f],
  ['slh-dsa-shake-128s', '2.16.840.1.101.3.4.3.26', slh.slh_dsa_shake_128s],
  ['slh-dsa-shake-128f', '2.16.840.1.101.3.4.3.27', slh.slh_dsa_shake_128f],
  ['slh-dsa-shake-192s', '2.16.840.1.101.3.4.3.28', slh.slh_dsa_shake_192s],
  ['slh-dsa-shake-192f', '2.16.840.1.101.3.4.3.29', slh.slh_dsa_shake_192f],
  ['slh-dsa-shake-256s', '2.16.840.1.101.3.4.3.30', slh.slh_dsa_shake_256s],
  ['slh-dsa-shake-256f', '2.16.840.1.101.3.4.3.31', slh.slh_dsa_shake_256f],
];

// Randomness: fresh by default; with R5_TEST_SEED every value is SHA-256(seed || label || counter).
function makeRandom(testSeedHex) {
  if (!testSeedHex) return { deterministic: false, bytes: (_label, n) => new Uint8Array(randomBytes(n)) };
  const seed = Buffer.from(testSeedHex, 'hex');
  if (seed.length < 16) throw new Error('R5_TEST_SEED must be at least 16 bytes of hex');
  return {
    deterministic: true,
    bytes(label, n) {
      const out = [];
      for (let i = 0; out.length < n; i++) {
        out.push(...createHash('sha256').update(seed).update(label).update(Uint8Array.of(i)).digest());
      }
      return Uint8Array.from(out.slice(0, n));
    },
  };
}

const sha1 = (bytes) => new Uint8Array(createHash('sha1').update(bytes).digest());

function serialNumber(rnd, label) {
  const s = rnd.bytes(`serial:${label}`, 16);
  s[0] = (s[0] & 0x7f) | 0x01; // positive and 16 octets long
  return s;
}

function validity(rnd) {
  const start = rnd.deterministic ? new Date(Date.UTC(2026, 0, 1)) : new Date(Math.floor(Date.now() / 60000) * 60000);
  const end = new Date(start);
  end.setUTCFullYear(end.getUTCFullYear() + VALIDITY_YEARS);
  return { notBefore: start, notAfter: end };
}

// One self-signed trust anchor for a signature algorithm.
function makeTA(friendly, oid, signer, keys, rnd) {
  const subject = der.name([[der.OID.commonName, `${PROVIDER} ${friendly} Root`]]);
  const skid = sha1(keys.publicKey);
  const { notBefore, notAfter } = validity(rnd);
  const tbs = der.tbsCertificate({
    serial: serialNumber(rnd, friendly), sigAlg: oid, issuer: subject, notBefore, notAfter, subject,
    spkiAlg: oid, publicKey: keys.publicKey,
    extensions: [
      der.extension(der.OID.basicConstraints, true, der.basicConstraints(true)),
      der.extension(der.OID.keyUsage, true, der.keyUsage(der.KEY_USAGE.digitalSignature,
        der.KEY_USAGE.keyCertSign, der.KEY_USAGE.cRLSign)),
      der.extension(der.OID.subjectKeyIdentifier, false, der.subjectKeyIdentifier(skid)),
      // AKI = SKI (as in the ossl35 TAs); OpenSSL treats the TA as self-signed only if they match.
      der.extension(der.OID.authorityKeyIdentifier, false, der.authorityKeyIdentifier(skid)),
    ],
  });
  const sig = signer.sign(tbs, keys.secretKey, rnd.deterministic ? { extraEntropy: false } : undefined);
  return { der: der.certificate(tbs, oid, sig), subject, skid };
}

export function generate(outDir, { algs = ['ml-dsa', 'ml-kem', 'slh-dsa'], testSeed } = {}) {
  const rnd = makeRandom(testSeed);
  const files = [];
  const put = (name, bytes) => { writeFileSync(join(outDir, name), bytes); files.push(name); };
  const tas = new Map(); // ML-DSA friendly name -> { keys, ta }

  const needMlDsa = algs.includes('ml-dsa') || algs.includes('ml-kem');
  if (needMlDsa) {
    for (const [friendly, oid, signer] of MLDSA) {
      const seed = rnd.bytes(`seed:${friendly}`, signer.lengths.seed);
      const keys = signer.keygen(seed);
      const ta = makeTA(friendly, oid, signer, keys, rnd);
      tas.set(friendly, { keys, ta, oid, signer });
      if (!algs.includes('ml-dsa')) continue;
      const p = `${friendly}-${oid}`;
      put(`${p}_ta.der`, ta.der);
      put(`${p}_seed_priv.der`, der.oneAsymmetricKey(oid, der.latticeSeed(seed)));
      put(`${p}_expandedkey_priv.der`, der.oneAsymmetricKey(oid, der.latticeExpanded(keys.secretKey)));
      put(`${p}_both_priv.der`, der.oneAsymmetricKey(oid, der.latticeBoth(seed, keys.secretKey)));
    }
  }

  if (algs.includes('ml-kem')) {
    for (const [friendly, oid, kem, taName] of MLKEM) {
      const { keys: taKeys, ta, oid: taOid, signer } = tas.get(taName);
      const seed = rnd.bytes(`seed:${friendly}`, kem.lengths.seed); // d || z, 64 bytes
      const keys = kem.keygen(seed);
      const subject = der.name([[der.OID.commonName, `${PROVIDER} ${friendly} EE`]]);
      const { notBefore, notAfter } = validity(rnd);
      const tbs = der.tbsCertificate({
        serial: serialNumber(rnd, friendly), sigAlg: taOid, issuer: ta.subject, notBefore, notAfter, subject,
        spkiAlg: oid, publicKey: keys.publicKey,
        extensions: [
          der.extension(der.OID.keyUsage, true, der.keyUsage(der.KEY_USAGE.keyEncipherment)),
          der.extension(der.OID.subjectKeyIdentifier, false, der.subjectKeyIdentifier(sha1(keys.publicKey))),
          der.extension(der.OID.authorityKeyIdentifier, false, der.authorityKeyIdentifier(ta.skid)),
        ],
      });
      const sig = signer.sign(tbs, taKeys.secretKey, rnd.deterministic ? { extraEntropy: false } : undefined);
      const { cipherText, sharedSecret } = kem.encapsulate(keys.publicKey, rnd.bytes(`encap:${friendly}`, kem.lengths.msgRand ?? 32));
      const p = `${friendly}-${oid}`;
      put(`${p}_ee.der`, der.certificate(tbs, taOid, sig));
      put(`${p}_seed_priv.der`, der.oneAsymmetricKey(oid, der.latticeSeed(seed)));
      put(`${p}_expandedkey_priv.der`, der.oneAsymmetricKey(oid, der.latticeExpanded(keys.secretKey)));
      put(`${p}_both_priv.der`, der.oneAsymmetricKey(oid, der.latticeBoth(seed, keys.secretKey)));
      put(`${p}_ciphertext.bin`, cipherText);
      put(`${p}_ss.bin`, sharedSecret);
    }
  }

  if (algs.includes('slh-dsa')) {
    for (const [friendly, oid, signer] of SLHDSA) {
      const keys = signer.keygen(rnd.bytes(`seed:${friendly}`, signer.lengths.seed));
      const ta = makeTA(friendly, oid, signer, keys, rnd);
      const p = `${friendly}-${oid}`;
      put(`${p}_ta.der`, ta.der);
      // RFC 9909: the privateKey OCTET STRING holds SK.seed || SK.prf || PK.seed || PK.root directly.
      put(`${p}_priv.der`, der.oneAsymmetricKey(oid, keys.secretKey));
    }
  }
  return files.sort();
}

// ---------- main ----------
const isMain = import.meta.url === `file://${process.argv[1]}` || process.argv[1]?.endsWith('gen_r5.mjs');
if (isMain) {
  const args = process.argv.slice(2);
  const positional = [];
  let dirArg;
  let algs;
  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--dir') dirArg = args[++i];
    else if (args[i] === '--algs') algs = args[++i].split(',');
    else positional.push(args[i]);
  }
  const out = positional[0];
  if (!out || !out.endsWith('.zip')) {
    console.error('Usage: node bin/gen_r5.mjs <out.zip> [--dir <folder>] [--algs ml-dsa,ml-kem,slh-dsa]');
    process.exit(2);
  }
  const dir = dirArg ? resolve(dirArg) : mkdtempSync(join(tmpdir(), 'r5gen-'));
  mkdirSync(dir, { recursive: true });
  try {
    const t0 = Date.now();
    const files = generate(dir, { algs, testSeed: process.env.R5_TEST_SEED });
    const zip = resolve(out);
    rmSync(zip, { force: true }); // zip(1) would otherwise add to an existing archive
    execFileSync('zip', ['-X', '-j', '-q', '-D', zip, ...files.map((f) => join(dir, f))]);
    console.error(`wrote ${files.length} files to ${zip} in ${((Date.now() - t0) / 1000).toFixed(1)} s`);
  } finally {
    if (!dirArg) rmSync(dir, { recursive: true, force: true });
  }
}
