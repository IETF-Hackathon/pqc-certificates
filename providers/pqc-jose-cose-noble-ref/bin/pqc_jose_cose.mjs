// JOSE/COSE artifacts for ML-DSA, SLH-DSA and Composite ML-DSA+(ECDSA|Ed25519|Ed448).
// Use @noble/post-quantum (ML-DSA, SLH-DSA) and @noble/curves (ECDSA P-256/P-384, Ed25519, Ed448).
// Implements RFC 9964, draft-ietf-cose-sphincs-plus and
// draft-ietf-jose-pq-composite-sigs.

import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import { execSync } from 'node:child_process';
import { ml_dsa44, ml_dsa65, ml_dsa87 } from '@noble/post-quantum/ml-dsa.js';
import { slh_dsa_sha2_128s, slh_dsa_shake_128s } from '@noble/post-quantum/slh-dsa.js';
import { ed25519 } from '@noble/curves/ed25519.js';
import { ed448 } from '@noble/curves/ed448.js';
import { p256, p384 } from '@noble/curves/nist.js';
import { encode as cborEncode, decode as cborDecode, Tag } from 'cbor2';

const ARTIFACT_DIR = 'artifacts_jose_cose_v1';
const PAYLOAD = Buffer.from('This is a test of signature data');

const MLDSA_IMPL = { 44: ml_dsa44, 65: ml_dsa65, 87: ml_dsa87 };

const SIMPLE_ALGS = {
  'ML-DSA-44': { kind: 'mldsa', level: 44, coseAlg: -48 },
  'ML-DSA-65': { kind: 'mldsa', level: 65, coseAlg: -49 },
  'ML-DSA-87': { kind: 'mldsa', level: 87, coseAlg: -50 },
  'SLH-DSA-SHA2-128s': { kind: 'slhdsa', impl: slh_dsa_sha2_128s, coseAlg: -51 },
  'SLH-DSA-SHAKE-128s': { kind: 'slhdsa', impl: slh_dsa_shake_128s, coseAlg: -52 },
};

const COMPOSITE_PREFIX = Buffer.from('CompositeAlgorithmSignatures2025', 'ascii');

const MLDSA_PUB_LEN = { 44: 1312, 65: 1952, 87: 2592 };
const MLDSA_SIG_LEN = { 44: 2420, 65: 3309, 87: 4627 };
const EC_CURVES = { P256: p256, P384: p384 };

const COMPOSITE_ALGS = {
  'ML-DSA-44-ES256': { mldsaLevel: 44, label: Buffer.from('COMPSIG-MLDSA44-ECDSA-P256-SHA256', 'ascii'), coseAlg: -51,
    trad: 'ecdsa', curve: 'P256', tradHash: 'sha256', prehash: 'sha256' },
  'ML-DSA-65-ES256': { mldsaLevel: 65, label: Buffer.from('COMPSIG-MLDSA65-ECDSA-P256-SHA512', 'ascii'), coseAlg: -52,
    trad: 'ecdsa', curve: 'P256', tradHash: 'sha256', prehash: 'sha512' },
  'ML-DSA-87-ES384': { mldsaLevel: 87, label: Buffer.from('COMPSIG-MLDSA87-ECDSA-P384-SHA512', 'ascii'), coseAlg: -53,
    trad: 'ecdsa', curve: 'P384', tradHash: 'sha384', prehash: 'sha512' },
  'ML-DSA-44-Ed25519': { mldsaLevel: 44, label: Buffer.from('COMPSIG-MLDSA44-Ed25519-SHA512', 'ascii'), coseAlg: -54,
    trad: 'ed25519', prehash: 'sha512' },
  'ML-DSA-65-Ed25519': { mldsaLevel: 65, label: Buffer.from('COMPSIG-MLDSA65-Ed25519-SHA512', 'ascii'), coseAlg: -55,
    trad: 'ed25519', prehash: 'sha512' },
  'ML-DSA-87-Ed448': { mldsaLevel: 87, label: Buffer.from('COMPSIG-MLDSA87-Ed448-SHAKE256', 'ascii'), coseAlg: -56,
    trad: 'ed448', prehash: 'shake256' },
};

const allAlgids = () => [...Object.keys(SIMPLE_ALGS), ...Object.keys(COMPOSITE_ALGS)];
const isComposite = (algid) => algid in COMPOSITE_ALGS;
const coseAlgOf = (algid) => (SIMPLE_ALGS[algid] ?? COMPOSITE_ALGS[algid]).coseAlg;

const u8 = (b) => Uint8Array.from(b);

function b64u(buf) {
  return Buffer.from(buf).toString('base64url');
}

function b64uDecode(s) {
  return Buffer.from(s, 'base64url');
}

function jwkThumbprint(algid, pub) {
  const canonical = JSON.stringify({ alg: algid, kty: 'AKP', pub: b64u(pub) });
  return b64u(crypto.createHash('sha256').update(canonical).digest());
}

function coseThumbprint(coseAlg, pub) {
  const canonical = cborEncode(new Map([[1, 7], [3, coseAlg], [-1, u8(pub)]]));
  return crypto.createHash('sha256').update(canonical).digest();
}

// --- pure algorithms ---

function keygenSimple(algid) {
  const info = SIMPLE_ALGS[algid];
  if (info.kind === 'mldsa') {
    const seed = crypto.randomBytes(32);
    const { publicKey } = MLDSA_IMPL[info.level].keygen(seed);
    return { pub: Buffer.from(publicKey), priv: seed };
  }
  const { publicKey, secretKey } = info.impl.keygen();
  return { pub: Buffer.from(publicKey), priv: Buffer.from(secretKey) };
}

function signSimple(algid, priv, message) {
  const info = SIMPLE_ALGS[algid];
  if (info.kind === 'mldsa') {
    const { secretKey } = MLDSA_IMPL[info.level].keygen(priv);
    return Buffer.from(MLDSA_IMPL[info.level].sign(message, secretKey, { context: new Uint8Array(0) }));
  }
  return Buffer.from(info.impl.sign(message, priv, { context: new Uint8Array(0) }));
}

function verifySimple(algid, pub, message, sig) {
  const info = SIMPLE_ALGS[algid];
  const impl = info.kind === 'mldsa' ? MLDSA_IMPL[info.level] : info.impl;
  try {
    return impl.verify(sig, message, pub, { context: new Uint8Array(0) });
  } catch {
    return false;
  }
}

// --- composite ML-DSA + (ECDSA | Ed25519 | Ed448) ---

function prehash(name, data) {
  if (name === 'shake256') return crypto.createHash('shake256', { outputLength: 64 }).update(data).digest();
  return crypto.createHash(name).update(data).digest();
}

function edCurve(kind) {
  return kind === 'ed25519' ? ed25519 : ed448;
}

function tradKeygen(info) {
  if (info.trad === 'ecdsa') {
    const curve = EC_CURVES[info.curve];
    const priv = curve.utils.randomSecretKey();
    const pub = curve.getPublicKey(priv, false);
    return { pub: Buffer.from(pub.subarray(1)), priv: Buffer.from(priv) };
  }
  const curve = edCurve(info.trad);
  const priv = curve.utils.randomSecretKey();
  const pub = curve.getPublicKey(priv);
  return { pub: Buffer.from(pub), priv: Buffer.from(priv) };
}

function tradSign(info, priv, data) {
  if (info.trad === 'ecdsa') {
    const curve = EC_CURVES[info.curve];
    return Buffer.from(curve.sign(data, priv, { lowS: true }));
  }
  return Buffer.from(edCurve(info.trad).sign(data, priv));
}

function tradVerify(info, pub, data, sig) {
  try {
    if (info.trad === 'ecdsa') {
      const curve = EC_CURVES[info.curve];
      const sec1Pub = Buffer.concat([Buffer.from([0x04]), pub]);
      return curve.verify(sig, data, sec1Pub);
    }
    return edCurve(info.trad).verify(sig, data, pub);
  } catch {
    return false;
  }
}

function keygenComposite(algid) {
  const info = COMPOSITE_ALGS[algid];
  const mldsaSeed = crypto.randomBytes(32);
  const { publicKey: mldsaPub } = MLDSA_IMPL[info.mldsaLevel].keygen(mldsaSeed);
  const { pub: tradPub, priv: tradPriv } = tradKeygen(info);
  return {
    pub: Buffer.concat([Buffer.from(mldsaPub), tradPub]),
    priv: Buffer.concat([mldsaSeed, tradPriv]),
  };
}

function compositeMessageRepresentative(algid, msgToSign) {
  const info = COMPOSITE_ALGS[algid];
  const ph = prehash(info.prehash, msgToSign);
  return Buffer.concat([COMPOSITE_PREFIX, info.label, Buffer.from([0x00]), ph]);
}

function signComposite(algid, priv, msgToSign) {
  const info = COMPOSITE_ALGS[algid];
  const mldsaSeed = priv.subarray(0, 32);
  const tradPriv = priv.subarray(32);
  const mPrime = compositeMessageRepresentative(algid, msgToSign);

  const { secretKey } = MLDSA_IMPL[info.mldsaLevel].keygen(mldsaSeed);
  const mldsaSig = MLDSA_IMPL[info.mldsaLevel].sign(mPrime, secretKey, { context: info.label });
  const tradSig = tradSign(info, tradPriv, mPrime);

  return Buffer.concat([Buffer.from(mldsaSig), tradSig]);
}

function verifyComposite(algid, pub, msgToSign, sig) {
  const info = COMPOSITE_ALGS[algid];
  const pubSplit = MLDSA_PUB_LEN[info.mldsaLevel];
  const sigSplit = MLDSA_SIG_LEN[info.mldsaLevel];
  const mldsaPub = pub.subarray(0, pubSplit);
  const tradPub = pub.subarray(pubSplit);
  const mldsaSig = sig.subarray(0, sigSplit);
  const tradSig = sig.subarray(sigSplit);

  const mPrime = compositeMessageRepresentative(algid, msgToSign);

  try {
    if (!MLDSA_IMPL[info.mldsaLevel].verify(mldsaSig, mPrime, mldsaPub, { context: info.label })) return false;
    return tradVerify(info, tradPub, mPrime, tradSig);
  } catch {
    return false;
  }
}

function keygen(algid) {
  return isComposite(algid) ? keygenComposite(algid) : keygenSimple(algid);
}

// --- JWS / JWK ---

function buildJwk(algid, pub, priv) {
  const kid = jwkThumbprint(algid, pub);
  const jwk = { kid, kty: 'AKP', alg: algid, pub: b64u(pub) };
  if (priv) jwk.priv = b64u(priv);
  return { jwk, kid };
}

function buildJws(algid, priv, kid, payload) {
  const header = { alg: algid, kid };
  const signingInput = `${b64u(Buffer.from(JSON.stringify(header)))}.${b64u(payload)}`;
  const msg = Buffer.from(signingInput, 'ascii');
  const sig = isComposite(algid)
    ? signComposite(algid, priv, msg)
    : signSimple(algid, priv, msg);
  return `${signingInput}.${b64u(sig)}`;
}

// --- COSE_Key / COSE_Sign1 ---

function buildCoseKey(algid, pub, priv) {
  const coseAlg = coseAlgOf(algid);
  const kid = coseThumbprint(coseAlg, pub);
  const entries = [[2, u8(kid)], [1, 7], [3, coseAlg], [-1, u8(pub)]];
  if (priv) entries.push([-2, u8(priv)]);
  return { bytes: Buffer.from(cborEncode(new Map(entries))), kid };
}

function buildCoseSign1(algid, priv, kid, payload) {
  const coseAlg = coseAlgOf(algid);
  const protectedBytes = Buffer.from(cborEncode(new Map([[1, coseAlg], [4, u8(kid)]])));
  const sigStructure = Buffer.from(cborEncode(['Signature1', u8(protectedBytes), new Uint8Array(0), u8(payload)]));
  const sig = isComposite(algid)
    ? signComposite(algid, priv, sigStructure)
    : signSimple(algid, priv, sigStructure);
  return Buffer.from(cborEncode(new Tag(18, [u8(protectedBytes), new Map(), u8(payload), u8(sig)])));
}

function parseCoseSign1(data) {
  const tag = cborDecode(data);
  const [protectedBytes, , payload, sig] = tag.contents ?? tag.value ?? tag;
  const protectedMap = cborDecode(protectedBytes);
  return { protectedMap, protectedBytes: Buffer.from(protectedBytes), payload: Buffer.from(payload), sig: Buffer.from(sig) };
}

// --- generate ---

function generate(outDir) {
  const artDir = path.join(outDir, ARTIFACT_DIR);
  fs.mkdirSync(artDir, { recursive: true });
  fs.writeFileSync(path.join(artDir, 'payload.txt'), PAYLOAD);

  for (const algid of allAlgids()) {
    const { pub, priv } = keygen(algid);

    const { jwk: jwkPub } = buildJwk(algid, pub);
    const { jwk: jwkPriv, kid } = buildJwk(algid, pub, priv);
    fs.writeFileSync(path.join(artDir, `${algid}_jwk_pub.json`), JSON.stringify(jwkPub, null, 2));
    fs.writeFileSync(path.join(artDir, `${algid}_jwk_priv.json`), JSON.stringify(jwkPriv, null, 2));

    const jws = buildJws(algid, priv, kid, PAYLOAD);
    fs.writeFileSync(path.join(artDir, `${algid}_jws.txt`), jws);

    const { bytes: cosePub, kid: coseKid } = buildCoseKey(algid, pub);
    const { bytes: cosePriv } = buildCoseKey(algid, pub, priv);
    fs.writeFileSync(path.join(artDir, `${algid}_cose_key_pub.cbor`), cosePub);
    fs.writeFileSync(path.join(artDir, `${algid}_cose_key_priv.cbor`), cosePriv);

    const sign1 = buildCoseSign1(algid, priv, coseKid, PAYLOAD);
    fs.writeFileSync(path.join(artDir, `${algid}_cose_sign1.cbor`), sign1);
  }

  const zipPath = path.join(outDir, `${ARTIFACT_DIR}.zip`);
  execSync(`cd ${JSON.stringify(outDir)} && zip -qr ${JSON.stringify(`${ARTIFACT_DIR}.zip`)} ${ARTIFACT_DIR}`);
  fs.rmSync(artDir, { recursive: true, force: true });
  console.log(`wrote ${zipPath}`);
}

// --- verify ---

function verifyDir(artDir, outCsv) {
  if (!fs.existsSync(artDir) || !fs.statSync(artDir).isDirectory()) {
    console.error(`ERROR: ${artDir} doesn't exist ` +
      `(need to run 'make generate' and 'make unzip' for that provider first)`);
    process.exit(1);
  }

  const payloadPath = path.join(artDir, 'payload.txt');
  const rows = [['key_algorithm_oid', 'type', 'test_result']];

  for (const algid of allAlgids()) {
    const jwsPath = path.join(artDir, `${algid}_jws.txt`);
    const pubPath = path.join(artDir, `${algid}_jwk_pub.json`);
    if (fs.existsSync(jwsPath) && fs.existsSync(pubPath)) {
      const pub = b64uDecode(JSON.parse(fs.readFileSync(pubPath)).pub);
      const jws = fs.readFileSync(jwsPath, 'utf8').trim();
      const [headerB64, payloadB64, sigB64] = jws.split('.');
      const signingInput = Buffer.from(`${headerB64}.${payloadB64}`, 'ascii');
      const sig = b64uDecode(sigB64);
      let ok;
      try {
        ok = isComposite(algid)
          ? verifyComposite(algid, pub, signingInput, sig)
          : verifySimple(algid, pub, signingInput, sig);
      } catch { ok = false; }
      rows.push([algid, 'jws', ok ? 'Y' : 'N']);
    }

    const sign1Path = path.join(artDir, `${algid}_cose_sign1.cbor`);
    const cosePubPath = path.join(artDir, `${algid}_cose_key_pub.cbor`);
    if (fs.existsSync(sign1Path) && fs.existsSync(cosePubPath)) {
      const pubMap = cborDecode(fs.readFileSync(cosePubPath));
      const pub = Buffer.from(pubMap.get(-1));
      const { protectedBytes, payload, sig } = parseCoseSign1(fs.readFileSync(sign1Path));
      const sigStructure = Buffer.from(cborEncode(['Signature1', u8(protectedBytes), new Uint8Array(0), u8(payload)]));
      let ok;
      try {
        ok = isComposite(algid)
          ? verifyComposite(algid, pub, sigStructure, sig)
          : verifySimple(algid, pub, sigStructure, sig);
      } catch { ok = false; }
      rows.push([algid, 'cose', ok ? 'Y' : 'N']);
    }
  }

  if (rows.length === 1) {
    console.error(`ERROR: no recognized artifacts found under ${artDir} ` +
      `(expected files like <algid>_jws.txt, <algid>_cose_sign1.cbor, ...)`);
    process.exit(1);
  }

  fs.writeFileSync(outCsv, rows.map((r) => r.join(',')).join('\n') + '\n');
  console.log(`wrote ${outCsv}`);
}

const [, , cmd, ...args] = process.argv;
if (cmd === 'generate') {
  generate(args[0] ?? '.');
} else if (cmd === 'verify') {
  verifyDir(args[0], args[1]);
} else {
  console.error(`unknown command: ${cmd}`);
  process.exit(1);
}
