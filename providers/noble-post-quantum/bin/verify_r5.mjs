#!/usr/bin/env node
// SPDX-License-Identifier: Apache-2.0
// Verifier for R5 certificate artifacts of the IETF Hackathon PQC certificates project
// (https://github.com/IETF-Hackathon/pqc-certificates), written against @noble/post-quantum.
//
// Usage: node bin/verify_r5.mjs <dir-with-unzipped-artifacts> [out.csv]
// Output CSV columns: key_algorithm_oid,type,test_result  (see docs/compat_matrix_instructions.md)
//
// Covered: ML-DSA-44/65/87 (FIPS 204, RFC 9881), ML-KEM-512/768/1024 (FIPS 203, RFC 9935),
// SLH-DSA SHA2/SHAKE 128/192/256 s/f (FIPS 205, RFC 9909). Other OIDs are skipped, and so are
// files whose name starts with a hybrid-format prefix (external_, catalyst_, chameleon_), as in
// the project's CI scripts.
// The checks follow the R5 definitions in docs/compat_matrix_instructions.md:
//   cert        TA: a valid self-signature. ML-KEM EE: a valid signature by the ML-DSA TA of the
//               same security level (the readme's rule for producers). Validity dates are only
//               checked when VERIFY_TIME is set.
//   seed, expandedkey, both, priv
//               the private-key form is well formed, and a signature made with it verifies
//               (ML-DSA, SLH-DSA) or it decapsulates the provided ciphertext to the provided
//               shared secret (ML-KEM). Without exactly one ciphertext and one shared secret the
//               ML-KEM key rows are not performed.
//   consistent  every private-key form that parses yields the same public key, which is also
//               the certificate's public key; reported when there are two keys, or a key and a
//               certificate.

import { readdirSync, readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { expandedKeyMismatch } from '../lib/mldsa_sk_check.mjs';
import { ml_dsa44, ml_dsa65, ml_dsa87 } from '@noble/post-quantum/ml-dsa.js';
import { ml_kem512, ml_kem768, ml_kem1024 } from '@noble/post-quantum/ml-kem.js';
import * as slh from '@noble/post-quantum/slh-dsa.js';

const MLDSA = {
  '2.16.840.1.101.3.4.3.17': ml_dsa44,
  '2.16.840.1.101.3.4.3.18': ml_dsa65,
  '2.16.840.1.101.3.4.3.19': ml_dsa87,
};
const MLKEM = {
  '2.16.840.1.101.3.4.4.1': ml_kem512,
  '2.16.840.1.101.3.4.4.2': ml_kem768,
  '2.16.840.1.101.3.4.4.3': ml_kem1024,
};
// The readme: "For ML-KEM, use the ML-DSA TA of the equivalent security level to sign".
const KEM_TA = {
  '2.16.840.1.101.3.4.4.1': '2.16.840.1.101.3.4.3.17',
  '2.16.840.1.101.3.4.4.2': '2.16.840.1.101.3.4.3.18',
  '2.16.840.1.101.3.4.4.3': '2.16.840.1.101.3.4.3.19',
};
const SLHDSA = {
  '2.16.840.1.101.3.4.3.20': slh.slh_dsa_sha2_128s,
  '2.16.840.1.101.3.4.3.21': slh.slh_dsa_sha2_128f,
  '2.16.840.1.101.3.4.3.22': slh.slh_dsa_sha2_192s,
  '2.16.840.1.101.3.4.3.23': slh.slh_dsa_sha2_192f,
  '2.16.840.1.101.3.4.3.24': slh.slh_dsa_sha2_256s,
  '2.16.840.1.101.3.4.3.25': slh.slh_dsa_sha2_256f,
  '2.16.840.1.101.3.4.3.26': slh.slh_dsa_shake_128s,
  '2.16.840.1.101.3.4.3.27': slh.slh_dsa_shake_128f,
  '2.16.840.1.101.3.4.3.28': slh.slh_dsa_shake_192s,
  '2.16.840.1.101.3.4.3.29': slh.slh_dsa_shake_192f,
  '2.16.840.1.101.3.4.3.30': slh.slh_dsa_shake_256s,
  '2.16.840.1.101.3.4.3.31': slh.slh_dsa_shake_256f,
};
const SIGNERS = { ...MLDSA, ...SLHDSA };
const MESSAGE = new TextEncoder().encode('Attack at dawn\n'); // same plaintext as ossl35

// ---------- minimal DER reader (enough for X.509 and PKCS#8) ----------
// Count of length fields not in minimal definite form (X.690 10.1). RFC 5958 receivers MUST
// accept BER for OneAsymmetricKey, and OpenSSL accepts it in certificates, so only the ML-DSA /
// ML-KEM private key CHOICE (RFC 9881 / RFC 9935 Sec. 6: "DER-encoded") rejects it; a
// certificate only gets a warning.
let nonMinimalLengths = 0;
function tlv(buf, off) {
  if (off + 2 > buf.length) throw new Error('DER: truncated header');
  const tag = buf[off];
  if ((tag & 0x1f) === 0x1f) throw new Error('DER: high tag numbers are not used here');
  let len = buf[off + 1];
  let hdr = 2;
  if (len & 0x80) {
    const n = len & 0x7f;
    if (n === 0 || n > 4) throw new Error('DER: unsupported length');
    if (off + 2 + n > buf.length) throw new Error('DER: truncated length');
    len = 0;
    for (let i = 0; i < n; i++) len = len * 256 + buf[off + 2 + i];
    hdr = 2 + n;
    if (len < 0x80 || buf[off + 2] === 0) nonMinimalLengths++;
  }
  const end = off + hdr + len;
  if (end > buf.length) throw new Error('DER: length beyond buffer');
  return { tag, start: off, valStart: off + hdr, end };
}
function kids(buf, node) {
  const out = [];
  let p = node.valStart;
  while (p < node.end) {
    const c = tlv(buf, p);
    out.push(c);
    p = c.end;
  }
  if (p !== node.end) throw new Error('DER: children overrun');
  return out;
}
const val = (buf, n) => buf.subarray(n.valStart, n.end);
function oidStr(bytes) {
  if (bytes.length === 0 || bytes[bytes.length - 1] & 0x80) throw new Error('DER: malformed OBJECT IDENTIFIER');
  const parts = [];
  let v = 0;
  for (let i = 0; i < bytes.length; i++) {
    if (v === 0 && bytes[i] === 0x80) throw new Error('DER: OBJECT IDENTIFIER subidentifier not minimal');
    if (v > 2 ** 45) throw new Error('DER: OBJECT IDENTIFIER arc too large');
    v = v * 128 + (bytes[i] & 0x7f);
    if (!(bytes[i] & 0x80)) {
      if (parts.length === 0) {
        const first = v < 80 ? Math.floor(v / 40) : 2;
        parts.push(first, v - first * 40);
      } else parts.push(v);
      v = 0;
    }
  }
  return parts.join('.');
}
function algOid(buf, algSeq) {
  const k = kids(buf, algSeq);
  if (k[0].tag !== 0x06) throw new Error('AlgorithmIdentifier without OID');
  if (k.length > 1) throw new Error('AlgorithmIdentifier with parameters'); // PQC OIDs: absent
  return oidStr(val(buf, k[0]));
}
function bitString(buf, node) {
  if (node.tag !== 0x03) throw new Error('expected BIT STRING');
  const v = val(buf, node);
  if (v[0] !== 0) throw new Error('BIT STRING with unused bits');
  return v.subarray(1);
}
function parseTime(buf, node) {
  const s = Buffer.from(val(buf, node)).toString('latin1');
  let y, rest;
  if (node.tag === 0x17) { // UTCTime YYMMDDHHMMSSZ
    const yy = Number(s.slice(0, 2));
    y = yy >= 50 ? 1900 + yy : 2000 + yy;
    rest = s.slice(2);
  } else if (node.tag === 0x18) { // GeneralizedTime YYYYMMDDHHMMSSZ
    y = Number(s.slice(0, 4));
    rest = s.slice(4);
  } else throw new Error('unexpected time tag');
  if (!rest.endsWith('Z') || rest.length !== 11) throw new Error('time must be ...SSZ');
  return Date.UTC(y, Number(rest.slice(0, 2)) - 1, Number(rest.slice(2, 4)),
    Number(rest.slice(4, 6)), Number(rest.slice(6, 8)), Number(rest.slice(8, 10)));
}

function parseCert(der) {
  nonMinimalLengths = 0;
  const c = parseCertInner(der);
  c.nonMinimalLengths = nonMinimalLengths;
  return c;
}
function checkTbsShape(der, t) {
  const want = [0x02, 0x30, 0x30, 0x30, 0x30, 0x30];
  let i = t[0].tag === 0xa0 ? 1 : 0;
  if (i === 1) {
    const v = kids(der, t[0]);
    if (v.length !== 1 || v[0].tag !== 0x02 || val(der, v[0]).length !== 1 || val(der, v[0])[0] > 2) throw new Error('bad TBSCertificate version');
  }
  for (const tag of want) {
    if (!t[i] || t[i].tag !== tag) throw new Error('TBSCertificate field has the wrong type or is missing');
    i++;
  }
  const optional = [0x81, 0x82, 0xa3];
  for (let last = -1; i < t.length; i++) {
    const k = optional.indexOf(t[i].tag);
    if (k <= last) throw new Error('unexpected element in TBSCertificate');
    last = k;
    if (t[i].tag === 0xa3) {
      const [exts, ...more] = kids(der, t[i]);
      if (!exts || more.length || exts.tag !== 0x30) throw new Error('bad extensions');
      const seen = new Set();
      for (const e of kids(der, exts)) {
        const id = oidStr(val(der, kids(der, e)[0]));
        if (seen.has(id)) throw new Error(`extension ${id} appears more than once`);
        seen.add(id);
      }
    }
  }
}
function parseCertInner(der) {
  const cert = tlv(der, 0);
  if (cert.tag !== 0x30 || cert.end !== der.length) throw new Error('not a single DER SEQUENCE');
  const top = kids(der, cert);
  if (top.length !== 3 || top[0].tag !== 0x30 || top[1].tag !== 0x30) throw new Error('Certificate is not SEQUENCE { tbs, alg, sig }');
  const [tbs, sigAlg, sigVal] = top;
  const t = kids(der, tbs);
  checkTbsShape(der, t);
  const i0 = t[0].tag === 0xa0 ? 1 : 0; // explicit version present
  const tbsSigAlg = algOid(der, t[i0 + 1]);
  const issuer = Buffer.from(der.subarray(t[i0 + 2].start, t[i0 + 2].end));
  const validity = kids(der, t[i0 + 3]);
  const subject = Buffer.from(der.subarray(t[i0 + 4].start, t[i0 + 4].end));
  const spki = kids(der, t[i0 + 5]);
  const outerSigAlg = algOid(der, sigAlg);
  if (outerSigAlg !== tbsSigAlg) throw new Error('signatureAlgorithm differs from tbs.signature');
  return {
    tbsBytes: der.subarray(tbs.start, tbs.end),
    sigAlg: outerSigAlg,
    signature: bitString(der, sigVal),
    issuer, subject,
    notBefore: parseTime(der, validity[0]),
    notAfter: parseTime(der, validity[1]),
    spkiAlg: algOid(der, spki[0]),
    publicKey: bitString(der, spki[1]),
  };
}

// OneAsymmetricKey (RFC 5958): returns { alg, privateKey (contents of the privateKey OCTET STRING), publicKey? }
function parsePkcs8(der) {
  const top = tlv(der, 0);
  if (top.tag !== 0x30 || top.end !== der.length) throw new Error('not a single DER SEQUENCE');
  const k = kids(der, top);
  if (k[0].tag !== 0x02) throw new Error('missing version');
  const version = val(der, k[0]);
  if (!(version.length === 1 && (version[0] === 0 || version[0] === 1))) throw new Error('bad version');
  const alg = algOid(der, k[1]);
  if (k[2].tag !== 0x04) throw new Error('privateKey is not an OCTET STRING');
  let publicKey;
  for (const extra of k.slice(3)) {
    if (extra.tag === 0x81) { // [1] IMPLICIT BIT STRING publicKey: first octet = unused bits
      const v = val(der, extra);
      if (v[0] !== 0) throw new Error('publicKey BIT STRING with unused bits');
      publicKey = v.subarray(1);
    }
  }
  return { alg, privateKey: val(der, k[2]), publicKey };
}

// ML-DSA / ML-KEM private key CHOICE (RFC 9881 / RFC 9935):
//   seed [0] IMPLICIT OCTET STRING | expandedKey OCTET STRING | both SEQUENCE { seed, expandedKey }
function parseLatticePriv(inner, seedLen, skLen) {
  nonMinimalLengths = 0;
  const n = tlv(inner, 0);
  if (n.tag === 0x30) kids(inner, n);
  if (nonMinimalLengths) throw new Error('private key CHOICE is not DER: length not in minimal form (RFC 9881 / RFC 9935 Sec. 6)');
  if (n.end !== inner.length) throw new Error('trailing bytes after private key CHOICE');
  if (n.tag === 0x80) {
    const seed = val(inner, n);
    if (seed.length !== seedLen) throw new Error('bad seed length');
    return { form: 'seed', seed };
  }
  if (n.tag === 0x04) {
    const sk = val(inner, n);
    if (sk.length !== skLen) throw new Error('bad expandedKey length');
    return { form: 'expandedkey', sk };
  }
  if (n.tag === 0x30) {
    const [a, b] = kids(inner, n);
    if (a.tag !== 0x04 || b.tag !== 0x04) throw new Error('bad both form');
    const seed = val(inner, a);
    const sk = val(inner, b);
    if (seed.length !== seedLen || sk.length !== skLen) throw new Error('bad both lengths');
    return { form: 'both', seed, sk };
  }
  throw new Error('unknown private key CHOICE tag');
}

// SLH-DSA private key: RFC 9909 Sec. 7 puts the raw SK.seed||SK.prf||PK.seed||PK.root in the
// privateKey OCTET STRING. A second OCTET STRING inside it is reported as a failure.
function parseSlhPriv(inner, skLen) {
  if (inner.length === skLen) return inner;
  let wrapped = false;
  try {
    const n = tlv(inner, 0);
    wrapped = n.tag === 0x04 && n.end === inner.length && n.end - n.valStart === skLen;
  } catch { /* not DER at all */ }
  if (wrapped) throw new Error('private key wrapped in a second OCTET STRING (RFC 9909 Sec. 7 carries the raw key)');
  throw new Error('bad SLH-DSA private key length');
}

const eq = (a, b) => a && b && a.length === b.length && Buffer.compare(Buffer.from(a), Buffer.from(b)) === 0;

function verifyCert(cert, issuerAlg, issuerPub, checkTime) {
  const signer = SIGNERS[cert.sigAlg];
  if (!signer || cert.sigAlg !== issuerAlg) throw new Error('signature algorithm mismatch');
  if (!signer.verify(cert.signature, cert.tbsBytes, issuerPub)) throw new Error('bad signature');
  if (checkTime !== undefined && !(cert.notBefore <= checkTime && checkTime <= cert.notAfter)) {
    throw new Error('certificate not valid at VERIFY_TIME');
  }
}
function noteValidity(cert, label, warnings) {
  const t = Date.now();
  if (!(cert.notBefore <= t && t <= cert.notAfter)) {
    warnings.push(`${label}: outside its validity period now (not part of the R5 test; set VERIFY_TIME to require it)`);
  }
}

// ---------- collect files ----------
const NAME_RE = /^(.*)-(\d+(?:\.\d+)+)_(ta|ee|priv|seed_priv|expandedkey_priv|both_priv|ciphertext|ss)\.(der|bin)$/;
// Hybrid certificate formats (readme: <hybrid_format>_<oid1>_with_<oid2>_ta.der, and e.g. bc's
// external_<friendly>-<oid>_ee.der) are not the plain artifact of that OID.
const HYBRID_PREFIX_RE = /^(external|catalyst|chameleon)_/i;
// Walks sub-folders too: some zips are not flat, and a name that occurs in two folders then
// counts as two inputs (skipped with a warning) instead of one silently replacing the other.
function collect(dir, warnings) {
  const byOid = new Map();
  let hybrid = 0;
  const entries = [];
  const walk = (folder, depth) => {
    for (const d of readdirSync(folder, { withFileTypes: true })) {
      if (d.isDirectory()) {
        if (d.name === '__MACOSX') { warnings.push(`${join(folder, d.name)}: macOS metadata folder ignored`); continue; }
        if (depth >= 8) { warnings.push(`${join(folder, d.name)}: folder nesting too deep, ignored`); continue; }
        walk(join(folder, d.name), depth + 1);
      } else if (d.isFile()) entries.push({ name: d.name, parentPath: folder });
      else warnings.push(`${join(folder, d.name)}: not a regular file (symlink or special file), ignored`);
    }
  };
  walk(dir, 0);
  for (const d of entries) {
    if (d.name.startsWith('._')) { warnings.push(`${d.name}: AppleDouble companion ignored`); continue; }
    if (HYBRID_PREFIX_RE.test(d.name)) { hybrid++; continue; }
    const m = NAME_RE.exec(d.name);
    if (!m) continue;
    const oid = m[2];
    const form = m[3];
    if (!byOid.has(oid)) byOid.set(oid, new Map());
    const forms = byOid.get(oid);
    if (!forms.has(form)) forms.set(form, []);
    forms.get(form).push(join(d.parentPath ?? d.path, d.name));
  }
  if (hybrid) warnings.push(`${hybrid} file(s) with a hybrid-format prefix (external_, catalyst_, chameleon_) ignored`);
  return byOid;
}
// Private-key files under a name the R5 convention does not use for this algorithm.
function noteUnusedForms(forms, oid, expected, warnings) {
  for (const f of ['priv', 'seed_priv', 'expandedkey_priv', 'both_priv']) {
    if (!expected.includes(f) && forms.has(f)) {
      warnings.push(`${oid}: ${count(forms, f)} file(s) named _${f}.der ignored (this algorithm uses ${expected.map((e) => `_${e}.der`).join(', ')})`);
    }
  }
}
function one(forms, form, oid, warnings) {
  const list = forms.get(form);
  if (!list) return undefined;
  if (list.length !== 1) { warnings.push(`too many inputs match ${form} for ${oid}; skipped`); return undefined; }
  return readFileSync(list[0]);
}

const count = (forms, form) => (forms.get(form) || []).length;

// Every key form that parses contributes its public key, and so does a certificate that parses.
function pushConsistent(push, oid, keyPubs, certPub) {
  const all = certPub ? [...keyPubs, certPub] : keyPubs;
  if (keyPubs.length >= 2 || (keyPubs.length >= 1 && certPub)) {
    push(oid, 'consistent', all.every((p) => eq(p, all[0])));
  }
}

// ---------- checks ----------
function run(dir, checkTime) {
  const rows = [];
  const warnings = [];
  const files = collect(dir, warnings);
  const push = (oid, type, ok) => rows.push([oid, type, ok ? 'Y' : 'N']);
  const taState = new Map(); // ML-DSA OID -> { ok, pk, subject }, only when a TA file was read
  const try_ = (fn) => { try { return fn(); } catch (e) { return { error: e.message }; } };

  // 1) SLH-DSA and ML-DSA (TAs first so that ML-KEM EEs can find their issuer)
  for (const [oid, forms] of files) {
    const signer = SIGNERS[oid];
    if (!signer) continue;
    const isMl = oid in MLDSA;
    const keyPubs = [];
    let certPub;
    const privForms = isMl ? ['seed', 'expandedkey', 'both'] : ['priv'];
    noteUnusedForms(forms, oid, privForms.map((f) => (f === 'priv' ? 'priv' : `${f}_priv`)), warnings);
    for (const form of privForms) {
      const der = one(forms, form === 'priv' ? 'priv' : `${form}_priv`, oid, warnings);
      if (!der) continue;
      let pk;
      let pkOther; // set when a both form disagrees: the expanded key's own public key, or null
      const r = try_(() => {
        const p8 = parsePkcs8(der);
        if (p8.alg !== oid) throw new Error('privateKeyAlgorithm OID mismatch');
        let sk;
        if (isMl) {
          const k = parseLatticePriv(p8.privateKey, signer.lengths.seed, signer.lengths.secretKey);
          if (k.form !== form) throw new Error(`file says ${form} but key is ${k.form}`);
          if (k.seed) {
            const kp = signer.keygen(k.seed);
            pk = kp.publicKey;
            if (k.sk && !eq(kp.secretKey, k.sk)) {
              pkOther = null;
              try { pkOther = signer.getPublicKey(k.sk); } catch { /* malformed expanded key */ }
              throw new Error('seed and expandedKey disagree');
            }
            sk = kp.secretKey;
          } else {
            sk = k.sk;
            pk = signer.getPublicKey(sk);
            const bad = expandedKeyMismatch(sk, pk);
            if (bad) throw new Error(`expandedKey is inconsistent: ${bad}`);
          }
        } else {
          sk = parseSlhPriv(p8.privateKey, signer.lengths.secretKey);
          pk = sk.subarray(sk.length / 2); // PK.seed || PK.root
        }
        if (p8.publicKey && !eq(p8.publicKey, pk)) throw new Error('embedded publicKey differs');
        const sig = signer.sign(MESSAGE, sk);
        if (!signer.verify(sig, MESSAGE, pk)) throw new Error('sign/verify failed');
        return {};
      });
      push(oid, form, !r.error);
      if (pk) keyPubs.push(pk);
      if (pkOther !== undefined) keyPubs.push(pkOther); // a disagreeing both form makes consistent N
      if (r.error) warnings.push(`${oid} ${form}: ${r.error}`);
    }
    const ta = one(forms, 'ta', oid, warnings);
    if (ta) {
      let c;
      const r = try_(() => {
        c = parseCert(ta);
        if (c.spkiAlg !== oid) throw new Error('SPKI algorithm OID mismatch');
        if (!eq(c.issuer, c.subject)) throw new Error('TA issuer != subject');
        verifyCert(c, oid, c.publicKey, checkTime);
        return {};
      });
      push(oid, 'cert', !r.error);
      if (c) { certPub = c.publicKey; noteValidity(c, `${oid} cert`, warnings); }
      if (c?.nonMinimalLengths) warnings.push(`${oid} cert: ${c.nonMinimalLengths} length(s) not in minimal DER form`);
      if (isMl) taState.set(oid, r.error ? { ok: false } : { ok: true, pk: c.publicKey, subject: c.subject });
      if (r.error) warnings.push(`${oid} cert: ${r.error}`);
    }
    pushConsistent(push, oid, keyPubs, certPub);
  }

  // 2) ML-KEM
  for (const [oid, forms] of files) {
    const kem = MLKEM[oid];
    if (!kem) continue;
    const keyPubs = [];
    let certPub;
    const nCt = count(forms, 'ciphertext');
    const nSs = count(forms, 'ss');
    const vector = nCt === 1 && nSs === 1;
    const ct = vector ? readFileSync(forms.get('ciphertext')[0]) : undefined;
    const ss = vector ? readFileSync(forms.get('ss')[0]) : undefined;
    let keysSeen = 0;
    noteUnusedForms(forms, oid, ['seed_priv', 'expandedkey_priv', 'both_priv'], warnings);
    for (const form of ['seed', 'expandedkey', 'both']) {
      const der = one(forms, `${form}_priv`, oid, warnings);
      if (!der) continue;
      keysSeen++;
      let pk;
      let pkOther; // set when a both form disagrees: the expanded key's own public key, or null
      let sk;
      const parsed = try_(() => {
        const p8 = parsePkcs8(der);
        if (p8.alg !== oid) throw new Error('privateKeyAlgorithm OID mismatch');
        const k = parseLatticePriv(p8.privateKey, kem.lengths.seed, kem.lengths.secretKey);
        if (k.form !== form) throw new Error(`file says ${form} but key is ${k.form}`);
        if (k.seed) {
          const kp = kem.keygen(k.seed);
          pk = kp.publicKey;
          if (k.sk && !eq(kp.secretKey, k.sk)) {
            pkOther = null;
            try { pkOther = kem.getPublicKey(k.sk); } catch { /* malformed expanded key */ }
            throw new Error('seed and expandedKey disagree');
          }
          sk = kp.secretKey;
        } else { sk = k.sk; pk = kem.getPublicKey(sk); }
        if (p8.publicKey && !eq(p8.publicKey, pk)) throw new Error('embedded publicKey differs');
        return {};
      });
      if (pk) keyPubs.push(pk);
      if (pkOther !== undefined) keyPubs.push(pkOther); // a disagreeing both form makes consistent N
      if (parsed.error) { // a malformed key fails whether or not a test vector exists
        push(oid, form, false);
        warnings.push(`${oid} ${form}: ${parsed.error}`);
        continue;
      }
      if (!vector) continue; // not performed; reported once below
      const r = try_(() => {
        if (!eq(kem.decapsulate(ct, sk), ss)) throw new Error('decapsulation mismatch');
        return {};
      });
      push(oid, form, !r.error);
      if (r.error) warnings.push(`${oid} ${form}: ${r.error}`);
    }
    if (keysSeen && !vector) {
      warnings.push(`${oid}: key decapsulation not performed: need exactly one _ciphertext.bin and one _ss.bin (found ${nCt} and ${nSs}); well-formed keys get no row`);
    }
    const ee = one(forms, 'ee', oid, warnings);
    if (ee) {
      const taOid = KEM_TA[oid];
      const ta = taState.get(taOid);
      let c;
      const parsed = try_(() => {
        c = parseCert(ee);
        if (c.spkiAlg !== oid) throw new Error('SPKI algorithm OID mismatch');
        return {};
      });
      if (c) { certPub = c.publicKey; noteValidity(c, `${oid} cert`, warnings); }
      if (c?.nonMinimalLengths) warnings.push(`${oid} cert: ${c.nonMinimalLengths} length(s) not in minimal DER form`);
      if (parsed.error) {
        push(oid, 'cert', false);
        warnings.push(`${oid} cert: ${parsed.error}`);
      } else if (!ta) {
        warnings.push(`${oid} cert: not performed: the artifact set has no ${taOid} TA (the readme pairs ML-KEM with the ML-DSA TA of the same level)`);
      } else if (!ta.ok) {
        push(oid, 'cert', false);
        warnings.push(`${oid} cert: the associated ${taOid} TA is present but did not verify`);
      } else {
        const r = try_(() => {
          if (c.sigAlg !== taOid) throw new Error(`EE is signed with ${c.sigAlg}, not with the associated ${taOid}`);
          verifyCert(c, taOid, ta.pk, checkTime);
          return {};
        });
        push(oid, 'cert', !r.error);
        if (r.error) warnings.push(`${oid} cert: ${r.error}`);
        // The R5 test is the signature by the associated TA; a differing issuer name is only reported.
        else if (!eq(c.issuer, ta.subject)) warnings.push(`${oid} cert: signature verifies, but the EE issuer name differs from the TA subject`);
      }
    }
    pushConsistent(push, oid, keyPubs, certPub);
  }
  const typeOrder = ['seed', 'expandedkey', 'both', 'priv', 'cert', 'consistent'];
  const oidKey = (o) => o.split('.').map((x) => x.padStart(6, '0')).join('.');
  rows.sort((a, b) => (oidKey(a[0]) < oidKey(b[0]) ? -1 : oidKey(a[0]) > oidKey(b[0]) ? 1
    : typeOrder.indexOf(a[1]) - typeOrder.indexOf(b[1])));
  return { rows, warnings };
}

// ---------- main ----------
const [dir, out] = process.argv.slice(2);
if (!dir) {
  console.error('Usage: node bin/verify_r5.mjs <artifact-dir> [out.csv]   (VERIFY_TIME=<ISO 8601> also checks validity dates)');
  process.exit(2);
}
let checkTime;
if (process.env.VERIFY_TIME) {
  checkTime = Date.parse(process.env.VERIFY_TIME);
  if (Number.isNaN(checkTime)) {
    console.error(`VERIFY_TIME is not a date: ${process.env.VERIFY_TIME}`);
    process.exit(2);
  }
}
const { rows, warnings } = run(dir, checkTime);
const csv = ['key_algorithm_oid,type,test_result', ...rows.map((r) => r.join(','))].join('\n') + '\n';
if (out && out !== '-') writeFileSync(out, csv); else process.stdout.write(csv);
for (const w of warnings) console.error(`warning: ${w}`);
