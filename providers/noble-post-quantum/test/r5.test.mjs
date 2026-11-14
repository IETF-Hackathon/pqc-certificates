// SPDX-License-Identifier: Apache-2.0
// Tests for the R5 generator and verifier. Run with: node --test test/*.test.mjs (or make test)
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, mkdirSync, readFileSync, writeFileSync, copyFileSync, readdirSync, rmSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { tmpdir } from 'node:os';
import { execFileSync, spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { ml_dsa44 } from '@noble/post-quantum/ml-dsa.js';
import * as der from '../lib/der.mjs';
import { generate } from '../bin/gen_r5.mjs';

const here = dirname(fileURLToPath(import.meta.url));
const VERIFY = join(here, '..', 'bin', 'verify_r5.mjs');
const CHECK = join(here, '..', 'check_certs.sh');
const SEED = '00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff';
const hex = (u8) => Buffer.from(u8).toString('hex');

function freshDir(prefix = 'r5test-') { return mkdtempSync(join(tmpdir(), prefix)); }

function verify(dir, env = {}) {
  const r = spawnSync(process.execPath, [VERIFY, dir], { encoding: 'utf8', env: { ...process.env, ...env } });
  if (r.status !== 0) throw new Error(`verifier exited ${r.status}: ${r.stderr}`);
  const rows = new Map();
  for (const line of r.stdout.trim().split('\n').slice(1)) {
    const [oid, type, result] = line.split(',');
    rows.set(`${oid},${type}`, result);
  }
  return { rows, stderr: r.stderr };
}

// One deterministic ML-DSA + ML-KEM set shared by the tests that do not modify it.
const base = freshDir();
const baseFiles = generate(base, { algs: ['ml-dsa', 'ml-kem'], testSeed: SEED });
const OIDS = { mldsa44: '2.16.840.1.101.3.4.3.17', mldsa65: '2.16.840.1.101.3.4.3.18', mlkem512: '2.16.840.1.101.3.4.4.1' };
const file = (dir, prefix, suffix) => join(dir, readdirSync(dir).find((f) => f.startsWith(prefix) && f.endsWith(suffix)));
function copyBase() {
  const d = freshDir();
  for (const f of baseFiles) copyFileSync(join(base, f), join(d, f));
  return d;
}

// ---------- DER writer ----------
test('DER: minimal INTEGERs', () => {
  assert.equal(hex(der.integer(0n)), '020100');
  assert.equal(hex(der.integer(127n)), '02017f');
  assert.equal(hex(der.integer(128n)), '02020080');
  assert.equal(hex(der.integer(Uint8Array.of(0, 0, 0x12))), '020112');
  assert.equal(hex(der.integer(Uint8Array.of(0x80))), '02020080');
});

test('DER: OID, BOOLEAN, long lengths', () => {
  assert.equal(hex(der.oid('2.16.840.1.101.3.4.3.17')), '0609608648016503040311');
  assert.equal(hex(der.oid('2.5.29.19')), '0603551d13');
  assert.equal(hex(der.bool(true)), '0101ff');
  const long = der.octetString(new Uint8Array(300));
  assert.equal(hex(long.subarray(0, 4)), '0482012c');
});

test('DER: KeyUsage named bit lists drop trailing zero bits', () => {
  const ku = der.KEY_USAGE;
  assert.equal(hex(der.keyUsage(ku.keyCertSign, ku.cRLSign)), '03020106');
  assert.equal(hex(der.keyUsage(ku.digitalSignature, ku.keyCertSign, ku.cRLSign)), '03020186');
  assert.equal(hex(der.keyUsage(ku.keyEncipherment)), '03020520');
  assert.equal(hex(der.keyUsage(ku.digitalSignature)), '03020780');
  assert.equal(hex(der.keyUsage(ku.decipherOnly)), '0303070080');
});

test('DER: BasicConstraints and Time', () => {
  assert.equal(hex(der.basicConstraints(false)), '3000');
  assert.equal(hex(der.basicConstraints(true)), '30030101ff');
  assert.equal(der.time(new Date(Date.UTC(2049, 11, 31, 23, 59, 59)))[0], 0x17); // UTCTime
  assert.equal(der.time(new Date(Date.UTC(2050, 0, 1)))[0], 0x18); // GeneralizedTime
  assert.equal(Buffer.from(der.time(new Date(Date.UTC(2026, 10, 14, 5, 6, 7)))).toString('latin1').slice(2), '261114050607Z');
});

// ---------- generator + verifier ----------
test('generated ML-DSA and ML-KEM artifacts verify (30 files, every row Y)', () => {
  assert.equal(baseFiles.length, 30);
  const { rows, stderr } = verify(base);
  assert.equal(rows.size, 30);
  for (const [k, v] of rows) assert.equal(v, 'Y', k);
  assert.equal(stderr.trim(), '');
});

test('generation is reproducible with R5_TEST_SEED', () => {
  const d = freshDir();
  generate(d, { algs: ['ml-dsa', 'ml-kem'], testSeed: SEED });
  for (const f of baseFiles) assert.deepEqual(readFileSync(join(d, f)), readFileSync(join(base, f)), f);
});

test('a tampered TA signature gives cert N, and the EEs it issued N too', () => {
  const d = copyBase();
  const ta = file(d, 'ml-dsa-44-', '_ta.der');
  const b = readFileSync(ta);
  b[b.length - 1] ^= 0x01;
  writeFileSync(ta, b);
  const { rows } = verify(d);
  assert.equal(rows.get(`${OIDS.mldsa44},cert`), 'N');
  assert.equal(rows.get(`${OIDS.mlkem512},cert`), 'N');
  assert.equal(rows.get(`${OIDS.mldsa65},cert`), 'Y');
});

test('a key under the wrong OID, a mislabelled form and a seed/expandedKey mismatch are N', () => {
  const d = copyBase();
  // ML-DSA-44 seed key stored as the ML-DSA-65 seed key
  copyFileSync(file(d, 'ml-dsa-44-', '_seed_priv.der'), file(d, 'ml-dsa-65-', '_seed_priv.der'));
  // expandedkey file holding the seed form
  copyFileSync(file(d, 'ml-dsa-44-', '_seed_priv.der'), file(d, 'ml-dsa-44-', '_expandedkey_priv.der'));
  // both form whose seed and expandedKey disagree: ML-KEM-512 seed + another key's expandedKey
  const other = freshDir();
  generate(other, { algs: ['ml-dsa', 'ml-kem'], testSeed: SEED.replace(/^00/, 'ff') });
  const seed = readFileSync(file(d, 'ml-kem-512-', '_seed_priv.der'));
  const sk2 = readFileSync(file(other, 'ml-kem-512-', '_expandedkey_priv.der'));
  const seedBytes = seed.subarray(seed.length - 64); // the 64-byte seed ends the seed-form file
  const skBytes = sk2.subarray(sk2.length - 1632); // the 1632-byte expanded key ends the expandedkey file
  writeFileSync(file(d, 'ml-kem-512-', '_both_priv.der'),
    der.oneAsymmetricKey(OIDS.mlkem512, der.latticeBoth(seedBytes, skBytes)));
  const { rows } = verify(d);
  assert.equal(rows.get(`${OIDS.mldsa65},seed`), 'N');
  assert.equal(rows.get(`${OIDS.mldsa44},expandedkey`), 'N');
  assert.equal(rows.get(`${OIDS.mlkem512},both`), 'N');
  assert.equal(rows.get(`${OIDS.mlkem512},consistent`), 'N');
});

test('trailing bytes after a DER object are N', () => {
  const d = copyBase();
  const k = file(d, 'ml-dsa-65-', '_seed_priv.der');
  writeFileSync(k, Buffer.concat([readFileSync(k), Buffer.from([0x00])]));
  const { rows } = verify(d);
  assert.equal(rows.get(`${OIDS.mldsa65},seed`), 'N');
});

test('validity: Y with a warning when outside it, N only with VERIFY_TIME', () => {
  const late = verify(base, { VERIFY_TIME: '2050-01-01T00:00:00Z' });
  assert.equal(late.rows.get(`${OIDS.mldsa44},cert`), 'N');
  const now = verify(base, { VERIFY_TIME: '2030-01-01T00:00:00Z' });
  assert.equal(now.rows.get(`${OIDS.mldsa44},cert`), 'Y');
  const bad = spawnSync(process.execPath, [VERIFY, base], { encoding: 'utf8', env: { ...process.env, VERIFY_TIME: 'not-a-date' } });
  assert.equal(bad.status, 2);
});

test('two inputs for one OID and form skip that form; an EE without its TA has no cert row', () => {
  const d = copyBase();
  mkdirSync(join(d, 'sub'));
  copyFileSync(file(d, 'ml-dsa-87-', '_ta.der'), join(d, 'sub', readdirSync(d).find((f) => f.startsWith('ml-dsa-87-') && f.endsWith('_ta.der'))));
  rmSync(file(d, 'ml-dsa-44-', '_ta.der'));
  const { rows, stderr } = verify(d);
  assert.equal(rows.has('2.16.840.1.101.3.4.3.19,cert'), false);
  assert.match(stderr, /too many inputs match ta/);
  assert.equal(rows.has(`${OIDS.mlkem512},cert`), false);
  assert.match(stderr, /not performed: the artifact set has no 2\.16\.840\.1\.101\.3\.4\.3\.17 TA/);
});

test('files with a hybrid-format prefix are ignored, not counted as duplicates', () => {
  const d = copyBase();
  const ee = file(d, 'ml-kem-512-', '_ee.der');
  copyFileSync(ee, join(d, `external_${ee.split('/').pop()}`));
  const { rows, stderr } = verify(d);
  assert.equal(rows.get(`${OIDS.mlkem512},cert`), 'Y');
  assert.match(stderr, /1 file\(s\) with a hybrid-format prefix/);
});

test('check_certs.sh refuses a zip that holds a symbolic link', () => {
  const d = freshDir();
  const src = join(d, 'src');
  mkdirSync(src);
  copyFileSync(file(base, 'ml-dsa-44-', '_ta.der'), join(src, 'a_ta.der'));
  execFileSync('ln', ['-s', '.', join(src, 'loop')]);
  execFileSync('zip', ['-q', '-y', '-r', join(d, 'links.zip'), '.'], { cwd: src });
  const r = spawnSync(CHECK, [join(d, 'links.zip')], { encoding: 'utf8' });
  assert.equal(r.status, 3);
  assert.match(r.stderr, /symbolic links/);
});

// A certificate built here with the same TBS fields as the generator's TA, then changed in one way.
function signedTa(mutate) {
  const keys = ml_dsa44.keygen(new Uint8Array(32).fill(9));
  const oid = OIDS.mldsa44;
  const subject = der.name([[der.OID.commonName, 'test TA']]);
  const fields = {
    serial: Uint8Array.of(0x01, 0x02), sigAlg: oid, issuer: subject, subject, spkiAlg: oid,
    notBefore: new Date(Date.UTC(2026, 0, 1)), notAfter: new Date(Date.UTC(2046, 0, 1)), publicKey: keys.publicKey,
    extensions: [
      der.extension(der.OID.basicConstraints, true, der.basicConstraints(true)),
      der.extension(der.OID.keyUsage, true, der.keyUsage(der.KEY_USAGE.keyCertSign, der.KEY_USAGE.cRLSign)),
    ],
  };
  mutate(fields);
  const tbs = der.tbsCertificate(fields);
  return der.certificate(tbs, oid, ml_dsa44.sign(tbs, keys.secretKey));
}

test('certificate structure: a repeated extension is N; the unchanged certificate is Y', () => {
  const ok = freshDir();
  writeFileSync(join(ok, `ml-dsa-44-${OIDS.mldsa44}_ta.der`), signedTa(() => {}));
  assert.equal(verify(ok).rows.get(`${OIDS.mldsa44},cert`), 'Y');
  const dup = freshDir();
  writeFileSync(join(dup, `ml-dsa-44-${OIDS.mldsa44}_ta.der`),
    signedTa((f) => f.extensions.push(der.extension(der.OID.keyUsage, true, der.keyUsage(der.KEY_USAGE.keyCertSign)))));
  const r = verify(dup);
  assert.equal(r.rows.get(`${OIDS.mldsa44},cert`), 'N');
  assert.match(r.stderr, /appears more than once/);
});

test('an OID with a 0x80 padding octet is N (X.690 8.19.2)', () => {
  const d = freshDir();
  const keys = ml_dsa44.keygen(new Uint8Array(32).fill(9));
  const subject = der.name([[der.OID.commonName, 'test TA']]);
  // id-ml-dsa-44 with the last subidentifier written as 80 11 instead of 11
  const paddedAlg = der.seq(der.tlv(0x06, Uint8Array.of(0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x03, 0x80, 0x11)));
  const tbs = der.seq(
    der.explicit(0, der.integer(2n)), der.integer(258n), der.algorithmIdentifier(OIDS.mldsa44), subject,
    der.seq(der.time(new Date(Date.UTC(2026, 0, 1))), der.time(new Date(Date.UTC(2046, 0, 1)))), subject,
    der.seq(paddedAlg, der.bitStringBytes(keys.publicKey)),
    der.explicit(3, der.seq(der.extension(der.OID.basicConstraints, true, der.basicConstraints(true)))),
  );
  writeFileSync(join(d, `ml-dsa-44-${OIDS.mldsa44}_ta.der`),
    der.certificate(tbs, OIDS.mldsa44, ml_dsa44.sign(tbs, keys.secretKey)));
  const r = verify(d);
  assert.equal(r.rows.get(`${OIDS.mldsa44},cert`), 'N');
  assert.match(r.stderr, /OBJECT IDENTIFIER subidentifier not minimal/);
});

test('a private key CHOICE with a non-minimal length is N (RFC 9881 Sec. 6: DER)', () => {
  const d = copyBase();
  const seedFile = file(d, 'ml-dsa-44-', '_seed_priv.der');
  const seed = readFileSync(seedFile).subarray(-32);
  const choice = Buffer.concat([Buffer.from([0x80, 0x81, 0x20]), seed]); // [0] with a long-form length
  writeFileSync(seedFile, der.seq(der.integer(0n), der.algorithmIdentifier(OIDS.mldsa44), der.octetString(choice)));
  const r = verify(d);
  assert.equal(r.rows.get(`${OIDS.mldsa44},seed`), 'N');
  assert.match(r.stderr, /not DER: length not in minimal form/);
});

test('check_certs.sh refuses a zip with too many entries before unzipping it', () => {
  const d = freshDir();
  const src = join(d, 'many');
  mkdirSync(src);
  for (let i = 0; i < 4097; i++) writeFileSync(join(src, `f${i}`), '');
  execFileSync('zip', ['-q', '-j', '-r', join(d, 'many.zip'), src]);
  const r = spawnSync(CHECK, [join(d, 'many.zip')], { encoding: 'utf8' });
  assert.equal(r.status, 3);
  assert.match(r.stderr, /refused: .* entries/);
});
