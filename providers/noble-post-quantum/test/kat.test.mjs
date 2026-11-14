// SPDX-License-Identifier: Apache-2.0
// Known-answer tests: bin/verify_r5.mjs on the example certificates and private keys of
// RFC 9881 (ML-DSA), RFC 9935 (ML-KEM) and RFC 9909 (SLH-DSA), stored as DER under R5 names in
// test/vectors/ (sources, extraction and licence: test/vectors/README.md).
// Run with: node --test test/kat.test.mjs
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { copyFileSync, mkdtempSync, readFileSync, readdirSync, rmSync, writeFileSync } from 'node:fs';
import { dirname, join, relative } from 'node:path';
import { tmpdir } from 'node:os';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { ml_kem512, ml_kem768, ml_kem1024 } from '@noble/post-quantum/ml-kem.js';

const here = dirname(fileURLToPath(import.meta.url));
const VECTORS = join(here, 'vectors');
const VERIFY = join(here, '..', 'bin', 'verify_r5.mjs');

const OID = {
  mldsa44: '2.16.840.1.101.3.4.3.17', mldsa65: '2.16.840.1.101.3.4.3.18', mldsa87: '2.16.840.1.101.3.4.3.19',
  mlkem512: '2.16.840.1.101.3.4.4.1', mlkem768: '2.16.840.1.101.3.4.4.2', mlkem1024: '2.16.840.1.101.3.4.4.3',
  slh128s: '2.16.840.1.101.3.4.3.20',
};
const MLDSA = [OID.mldsa44, OID.mldsa65, OID.mldsa87];
const KEMS = [['ml-kem-512', OID.mlkem512, ml_kem512], ['ml-kem-768', OID.mlkem768, ml_kem768], ['ml-kem-1024', OID.mlkem1024, ml_kem1024]];
const BAD_KEM = (n, form) => join(VECTORS, 'invalid', `rfc9935-c4.1-ex${n}`, `ml-kem-512-${OID.mlkem512}_${form}_priv.der`);

// Runs the verifier on one folder: { rows: Map("<oid>,<type>" -> Y|N), warnings: [text] }.
// Warnings about validity at the current time are left out: they depend on the clock (the RFC
// certificates expire in 2034 and 2040) and do not change any row.
function verify(dir, env = {}) {
  const r = spawnSync(process.execPath, [VERIFY, dir], { encoding: 'utf8', env: { ...process.env, ...env } });
  if (r.status !== 0) throw new Error(`verifier exited ${r.status}: ${r.stderr}`);
  const lines = r.stdout.trim().split('\n');
  assert.equal(lines[0], 'key_algorithm_oid,type,test_result');
  const rows = new Map();
  for (const line of lines.slice(1)) {
    const [oid, type, result] = line.split(',');
    assert.equal(rows.has(`${oid},${type}`), false, `duplicate row ${oid},${type}`);
    rows.set(`${oid},${type}`, result);
  }
  const warnings = r.stderr.split('\n').filter(Boolean).map((l) => l.replace(/^warning: /, ''))
    .filter((w) => !/outside its validity period now/.test(w));
  return { rows, warnings };
}
// The verifier's rows must be exactly these (no row missing, no extra row).
const assertRows = (rows, expected) =>
  assert.deepEqual(Object.fromEntries([...rows].sort()), Object.fromEntries(Object.entries(expected).sort()));
const rowsFor = (oid, types, result) => Object.fromEntries(types.map((t) => [`${oid},${t}`, result]));
const NOT_PERFORMED = (oid) => `${oid}: key decapsulation not performed: need exactly one _ciphertext.bin and one _ss.bin (found 0 and 0); well-formed keys get no row`;

function tempDir(t, ...sources) {
  const d = mkdtempSync(join(tmpdir(), 'r5kat-'));
  t.after(() => rmSync(d, { recursive: true, force: true }));
  for (const s of sources) {
    for (const f of readdirSync(s)) copyFileSync(join(s, f), join(d, f));
  }
  return d;
}

// The BIT STRING contents of the certificate's SubjectPublicKeyInfo (minimal DER walk).
function certPublicKey(der) {
  const read = (off) => {
    let len = der[off + 1];
    let hdr = 2;
    if (len & 0x80) {
      const n = len & 0x7f;
      len = 0;
      for (let i = 0; i < n; i++) len = len * 256 + der[off + 2 + i];
      hdr += n;
    }
    return { tag: der[off], val: off + hdr, end: off + hdr + len };
  };
  const children = (node) => {
    const out = [];
    for (let p = node.val; p < node.end; p = out[out.length - 1].end) out.push(read(p));
    return out;
  };
  const tbs = children(read(0))[0];
  const fields = children(tbs);
  const spki = children(fields[fields[0].tag === 0xa0 ? 6 : 5]);
  return der.subarray(spki[1].val + 1, spki[1].end); // skip the unused-bits octet
}

// RFC 9935 has no ciphertext and shared secret. Here one is made with @noble/post-quantum for the
// public key of the RFC certificate, with a fixed encapsulation message m, so that the R5
// decapsulation test can run on the RFC keys. These two files are not RFC data.
const M = new Uint8Array(createHash('sha256').update('r5 kat encapsulation message').digest());
function addCiphertext(dir, name, oid, kem, certFile) {
  const { cipherText, sharedSecret } = kem.encapsulate(certPublicKey(readFileSync(certFile)), M);
  writeFileSync(join(dir, `${name}-${oid}_ciphertext.bin`), cipherText);
  writeFileSync(join(dir, `${name}-${oid}_ss.bin`), sharedSecret);
}

// ---------- the vector files ----------
test('vectors: each DER file is listed in manifest.json with its size and SHA-256, and no other is present', () => {
  const manifest = JSON.parse(readFileSync(join(VECTORS, 'manifest.json'), 'utf8'));
  const onDisk = readdirSync(VECTORS, { recursive: true, withFileTypes: true })
    .filter((d) => d.isFile() && d.name.endsWith('.der'))
    .map((d) => relative(VECTORS, join(d.parentPath ?? d.path, d.name)))
    .sort();
  assert.deepEqual(onDisk, manifest.files.map((f) => f.file).sort());
  assert.equal(manifest.files.length, 36);
  for (const f of manifest.files) {
    const b = readFileSync(join(VECTORS, f.file));
    assert.equal(b.length, f.bytes, f.file);
    assert.equal(createHash('sha256').update(b).digest('hex'), f.sha256, f.file);
    if (f.copy_of) assert.deepEqual(b, readFileSync(join(VECTORS, f.copy_of)), f.file);
  }
});

// ---------- valid examples ----------
test('RFC 9881 C.1 and C.3: ML-DSA-44/65/87 seed, expandedkey, both, cert and consistent are Y', () => {
  const { rows, warnings } = verify(join(VECTORS, 'rfc9881'));
  assertRows(rows, Object.assign({}, ...MLDSA.map((o) => rowsFor(o, ['seed', 'expandedkey', 'both', 'cert', 'consistent'], 'Y'))));
  assert.deepEqual(warnings, []);
});

test('RFC 9935 C.3: ML-KEM EEs verify under the RFC 9881 TAs, consistent Y; key rows not performed (no ciphertext in the RFC)', () => {
  const { rows, warnings } = verify(join(VECTORS, 'rfc9935'));
  assertRows(rows, Object.assign(
    {},
    ...MLDSA.map((o) => rowsFor(o, ['cert'], 'Y')),
    ...KEMS.map(([, o]) => rowsFor(o, ['cert', 'consistent'], 'Y')),
  ));
  assert.deepEqual(warnings.sort(), KEMS.map(([, o]) => NOT_PERFORMED(o)).sort());
});

test('RFC 9909 C.2 and C.3: SLH-DSA-SHA2-128s priv, cert and consistent are Y', () => {
  const { rows, warnings } = verify(join(VECTORS, 'rfc9909'));
  assertRows(rows, rowsFor(OID.slh128s, ['priv', 'cert', 'consistent'], 'Y'));
  assert.deepEqual(warnings, []);
});

test('RFC validity periods are read as published, notBefore and notAfter inclusive (VERIFY_TIME)', (t) => {
  // RFC 9881 and RFC 9935: 2020-02-03T04:32:10Z .. 2040-01-29T04:32:10Z; RFC 9909: 2024-10-16T13:42:12Z .. 2034-10-14T13:42:12Z
  const certsOnly = tempDir(t);
  for (const dir of ['rfc9935', 'rfc9909']) {
    for (const f of readdirSync(join(VECTORS, dir)).filter((n) => /_(ta|ee)\.der$/.test(n))) {
      copyFileSync(join(VECTORS, dir, f), join(certsOnly, f));
    }
  }
  const at = (time) => verify(certsOnly, { VERIFY_TIME: time }).rows;
  const lattice = [...MLDSA, ...KEMS.map(([, o]) => o)];
  const expect = (time, latticeResult, slhResult) => assertRows(at(time), Object.assign(
    {}, ...lattice.map((o) => rowsFor(o, ['cert'], latticeResult)), rowsFor(OID.slh128s, ['cert'], slhResult),
  ));
  expect('2020-02-03T04:32:09Z', 'N', 'N');
  expect('2020-02-03T04:32:10Z', 'Y', 'N');
  expect('2024-10-16T13:42:12Z', 'Y', 'Y');
  expect('2034-10-14T13:42:12Z', 'Y', 'Y');
  expect('2034-10-14T13:42:13Z', 'Y', 'N');
  expect('2040-01-29T04:32:10Z', 'Y', 'N');
  expect('2040-01-29T04:32:11Z', 'N', 'N');
});

test('RFC 9935 C.1 keys with a ciphertext made here for each RFC public key: seed, expandedkey, both Y', (t) => {
  const d = tempDir(t, join(VECTORS, 'rfc9935'));
  for (const [name, oid, kem] of KEMS) addCiphertext(d, name, oid, kem, join(d, `${name}-${oid}_ee.der`));
  const { rows, warnings } = verify(d);
  assertRows(rows, Object.assign(
    {},
    ...MLDSA.map((o) => rowsFor(o, ['cert'], 'Y')),
    ...KEMS.map(([, o]) => rowsFor(o, ['seed', 'expandedkey', 'both', 'cert', 'consistent'], 'Y')),
  ));
  assert.deepEqual(warnings, []);
});

// ---------- invalid examples: RFC 9881 C.4 (ML-DSA-44) ----------
test('RFC 9881 C.4 example 1 (both: seed and expandedKey disagree): both N, consistent N', () => {
  const { rows, warnings } = verify(join(VECTORS, 'invalid', 'rfc9881-c4-ex1'));
  assertRows(rows, rowsFor(OID.mldsa44, ['both', 'consistent'], 'N'));
  assert.deepEqual(warnings, [`${OID.mldsa44} both: seed and expandedKey disagree`]);
});

test('RFC 9881 C.4 example 2 (expandedKey: tr does not match the public key): expandedkey N', () => {
  const { rows, warnings } = verify(join(VECTORS, 'invalid', 'rfc9881-c4-ex2'));
  assertRows(rows, rowsFor(OID.mldsa44, ['expandedkey'], 'N'));
  assert.deepEqual(warnings, [`${OID.mldsa44} expandedkey: expandedKey is inconsistent: tr does not match the public key`]);
});

// The key differs from RFC 9881 C.1.1.2 by one unit in one t0 coefficient, and signatures made
// with it still verify; lib/mldsa_sk_check.mjs recomputes t0 and tr from rho, s1 and s2 (as
// OpenSSL 3.5 does on import), so the row is N.
test('RFC 9881 C.4 example 3 (expandedKey: t0 does not match s1 and s2): expandedkey N', () => {
  const { rows, warnings } = verify(join(VECTORS, 'invalid', 'rfc9881-c4-ex3'));
  assertRows(rows, rowsFor(OID.mldsa44, ['expandedkey'], 'N'));
  assert.deepEqual(warnings, [`${OID.mldsa44} expandedkey: expandedKey is inconsistent: t0 does not match s1 and s2`]);
});

// ---------- invalid examples: RFC 9935 C.4.1 (ML-KEM-512), as published (no ciphertext) ----------
test('RFC 9935 C.4.1 example 1 (both: seed and expandedKey disagree): both N, consistent N', () => {
  const { rows, warnings } = verify(join(VECTORS, 'invalid', 'rfc9935-c4.1-ex1'));
  assertRows(rows, rowsFor(OID.mlkem512, ['both', 'consistent'], 'N'));
  assert.deepEqual(warnings, [`${OID.mlkem512} both: seed and expandedKey disagree`, NOT_PERFORMED(OID.mlkem512)]);
});

test('RFC 9935 C.4.1 examples 2 and 3 (expandedKey: changed s, changed H(ek)): no row without a ciphertext', () => {
  for (const n of [2, 3]) {
    const { rows, warnings } = verify(join(VECTORS, 'invalid', `rfc9935-c4.1-ex${n}`));
    assertRows(rows, {});
    assert.deepEqual(warnings, [NOT_PERFORMED(OID.mlkem512)], `example ${n}`);
  }
});

test('RFC 9935 C.4.1 example 4 (both: only z differs): both N; consistent Y, since the public keys agree', () => {
  const { rows, warnings } = verify(join(VECTORS, 'invalid', 'rfc9935-c4.1-ex4'));
  assertRows(rows, { ...rowsFor(OID.mlkem512, ['both'], 'N'), ...rowsFor(OID.mlkem512, ['consistent'], 'Y') });
  assert.deepEqual(warnings, [`${OID.mlkem512} both: seed and expandedKey disagree`, NOT_PERFORMED(OID.mlkem512)]);
});

test('RFC 9935 C.4.1 examples 1-4 with a ciphertext made here for the RFC ML-KEM-512 public key: every key row N', (t) => {
  const cases = [
    [1, 'both', { ...rowsFor(OID.mlkem512, ['both', 'consistent'], 'N') }, 'both: seed and expandedKey disagree'],
    [2, 'expandedkey', rowsFor(OID.mlkem512, ['expandedkey'], 'N'), 'expandedkey: decapsulation mismatch'],
    [3, 'expandedkey', rowsFor(OID.mlkem512, ['expandedkey'], 'N'), 'expandedkey: invalid secretKey: hash check failed'],
    [4, 'both', { ...rowsFor(OID.mlkem512, ['both'], 'N'), ...rowsFor(OID.mlkem512, ['consistent'], 'Y') }, 'both: seed and expandedKey disagree'],
  ];
  const cert = join(VECTORS, 'rfc9935', `ml-kem-512-${OID.mlkem512}_ee.der`);
  for (const [n, form, expected, warning] of cases) {
    const d = tempDir(t);
    copyFileSync(BAD_KEM(n, form), join(d, `ml-kem-512-${OID.mlkem512}_${form}_priv.der`));
    addCiphertext(d, 'ml-kem-512', OID.mlkem512, ml_kem512, cert);
    const { rows, warnings } = verify(d);
    assertRows(rows, expected);
    assert.deepEqual(warnings, [`${OID.mlkem512} ${warning}`], `example ${n}`);
  }
});
