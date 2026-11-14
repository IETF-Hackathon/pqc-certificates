#!/usr/bin/env node
// SPDX-License-Identifier: Apache-2.0
// Extracts the example certificates and private keys from the appendices of RFC 9881 (ML-DSA),
// RFC 9935 (ML-KEM) and RFC 9909 (SLH-DSA) and stores them as DER under R5 file names, so that
// bin/verify_r5.mjs can run on them as known-answer tests (test/kat.test.mjs).
//
// Usage: node bin/extract_rfc_vectors.mjs <out-dir> <rfc9881.txt> <rfc9935.txt> <rfc9909.txt>
//   The inputs are the plain-text RFCs from https://www.rfc-editor.org/rfc/rfcNNNN.txt (any order).
//   Writes, under <out-dir>:
//     rfc9881/   RFC 9881 C.1 keys (seed, expandedKey, both) and C.3 self-signed certificates
//     rfc9935/   RFC 9935 C.1 keys and C.3 certificates, plus copies of the RFC 9881 C.3
//                certificates (RFC 9935 C.3 says its certificates are signed with the RFC 9881 keys,
//                and the verifier pairs ML-KEM-512/768/1024 with the ML-DSA-44/65/87 TA of one set)
//     rfc9909/   RFC 9909 C.2 key and C.3 self-signed certificate
//     invalid/rfc<n>-<section>-ex<k>/   each deliberately bad key of RFC 9881 C.4 and RFC 9935 C.4.1
//                (e.g. invalid/rfc9881-c4-ex1/, invalid/rfc9935-c4.1-ex4/), one key per folder
//     manifest.json   source section and line range in the RFC text, size and SHA-256 of each file
//   Public keys (C.2 of RFC 9881 and RFC 9935, C.1 of RFC 9909) have no R5 file name: each must
//   equal the SubjectPublicKeyInfo of the example certificate for its OID, and is listed in the
//   manifest only.
// The PEM text is decoded strictly (base64 alphabet, padding, canonical form) and each object
// must be one DER TLV; the file name comes from the OID and the private key CHOICE tag, and is
// cross-checked against the section headings.

import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { createHash } from 'node:crypto';
import { join, basename } from 'node:path';

const NAMES = {
  '2.16.840.1.101.3.4.3.17': 'ml-dsa-44',
  '2.16.840.1.101.3.4.3.18': 'ml-dsa-65',
  '2.16.840.1.101.3.4.3.19': 'ml-dsa-87',
  '2.16.840.1.101.3.4.4.1': 'ml-kem-512',
  '2.16.840.1.101.3.4.4.2': 'ml-kem-768',
  '2.16.840.1.101.3.4.4.3': 'ml-kem-1024',
  '2.16.840.1.101.3.4.3.20': 'slh-dsa-sha2-128s',
  '2.16.840.1.101.3.4.3.21': 'slh-dsa-sha2-128f',
  '2.16.840.1.101.3.4.3.22': 'slh-dsa-sha2-192s',
  '2.16.840.1.101.3.4.3.23': 'slh-dsa-sha2-192f',
  '2.16.840.1.101.3.4.3.24': 'slh-dsa-sha2-256s',
  '2.16.840.1.101.3.4.3.25': 'slh-dsa-sha2-256f',
  '2.16.840.1.101.3.4.3.26': 'slh-dsa-shake-128s',
  '2.16.840.1.101.3.4.3.27': 'slh-dsa-shake-128f',
  '2.16.840.1.101.3.4.3.28': 'slh-dsa-shake-192s',
  '2.16.840.1.101.3.4.3.29': 'slh-dsa-shake-192f',
  '2.16.840.1.101.3.4.3.30': 'slh-dsa-shake-256s',
  '2.16.840.1.101.3.4.3.31': 'slh-dsa-shake-256f',
};
const isKem = (oid) => oid.startsWith('2.16.840.1.101.3.4.4.');
const isLattice = (oid) => isKem(oid) || /^2\.16\.840\.1\.101\.3\.4\.3\.1[789]$/.test(oid); // ML-KEM, ML-DSA

// Which appendix sections hold what, and how many PEM objects each RFC must yield.
const LAYOUT = {
  9881: { valid: ['C.1', 'C.3'], invalid: ['C.4'], pub: ['C.2'], counts: { valid: 12, invalid: 3, pub: 3 } },
  9935: { valid: ['C.1', 'C.3'], invalid: ['C.4.1'], pub: ['C.2'], counts: { valid: 12, invalid: 4, pub: 3 } },
  9909: { valid: ['C.2', 'C.3'], invalid: [], pub: ['C.1'], counts: { valid: 2, invalid: 0, pub: 1 } },
};
const within = (section, roots) => roots.find((r) => section === r || section.startsWith(`${r}.`));
const FORM_TITLES = { 'Seed Format': 'seed', 'Expanded Format': 'expandedkey', 'Both Format': 'both' };

// ---------- minimal DER reader ----------
function tlv(buf, off) {
  if (off + 2 > buf.length) throw new Error('DER: truncated header');
  const tag = buf[off];
  if ((tag & 0x1f) === 0x1f) throw new Error('DER: high tag numbers are not used here');
  let len = buf[off + 1];
  let hdr = 2;
  if (len === 0x80) throw new Error('DER: indefinite length');
  if (len & 0x80) {
    const n = len & 0x7f;
    if (n > 4) throw new Error('DER: length too long');
    len = 0;
    for (let i = 0; i < n; i++) len = len * 256 + buf[off + 2 + i];
    if (len < 0x80 || buf[off + 2] === 0) throw new Error('DER: non-minimal length');
    hdr = 2 + n;
  }
  const end = off + hdr + len;
  if (end > buf.length) throw new Error('DER: length beyond buffer');
  return { tag, start: off, valStart: off + hdr, end };
}
function kids(buf, node) {
  const out = [];
  for (let p = node.valStart; p < node.end;) {
    const c = tlv(buf, p);
    if (c.end > node.end) throw new Error('DER: child overruns its parent');
    out.push(c);
    p = c.end;
  }
  return out;
}
const val = (buf, n) => buf.subarray(n.valStart, n.end);
function oidStr(bytes) {
  const parts = [];
  let v = 0;
  for (const b of bytes) {
    v = v * 128 + (b & 0x7f);
    if (!(b & 0x80)) {
      if (parts.length === 0) {
        const top = v < 80 ? Math.floor(v / 40) : 2;
        parts.push(top, v - top * 40);
      } else parts.push(v);
      v = 0;
    }
  }
  return parts.join('.');
}
const algOid = (buf, seqNode) => oidStr(val(buf, kids(buf, seqNode)[0]));

function describe(label, der) {
  const top = tlv(der, 0);
  if (top.tag !== 0x30 || top.end !== der.length) throw new Error('not one DER SEQUENCE');
  const k = kids(der, top);
  if (label === 'CERTIFICATE') {
    const t = kids(der, k[0]);
    const i0 = t[0].tag === 0xa0 ? 1 : 0;
    const issuer = der.subarray(t[i0 + 2].start, t[i0 + 2].end);
    const subject = der.subarray(t[i0 + 4].start, t[i0 + 4].end);
    const spki = kids(der, t[i0 + 5]);
    return {
      kind: 'cert', oid: algOid(der, spki[0]), sigOid: algOid(der, k[1]),
      selfIssued: Buffer.compare(Buffer.from(issuer), Buffer.from(subject)) === 0,
      spki: der.subarray(t[i0 + 5].start, t[i0 + 5].end),
    };
  }
  if (label === 'PRIVATE KEY') {
    const oid = algOid(der, k[1]);
    let form = 'priv';
    if (isLattice(oid)) {
      const inner = val(der, k[2]);
      form = { 0x80: 'seed', 0x04: 'expandedkey', 0x30: 'both' }[inner[0]];
      if (!form) throw new Error(`unknown private key CHOICE tag 0x${inner[0].toString(16)}`);
    }
    return { kind: 'key', oid, form };
  }
  if (label === 'PUBLIC KEY') return { kind: 'pub', oid: algOid(der, k[0]), spki: der };
  throw new Error(`unexpected PEM label ${label}`);
}

// ---------- RFC text ----------
const HEADING_RE = /^(Appendix ([A-Z])|[A-Z](?:\.\d+)+|\d+(?:\.\d+)*)\.\s+(\S.*)$/;
const B64_LINE_RE = /^[A-Za-z0-9+/]+={0,2}$/;

function readRfc(path) {
  const text = readFileSync(path);
  const lines = text.toString('utf8').replace(/^\uFEFF/, '').replace(/\r/g, '').replace(/\f/g, '').split('\n');
  const m = /^Request for Comments: (\d+)/m.exec(lines.slice(0, 20).join('\n'));
  if (!m) throw new Error(`${path}: no "Request for Comments:" line`);
  const rfc = Number(m[1]);
  const objects = [];
  const headings = new Map(); // section number -> title
  let section = '';
  let sectionStart = 0;
  for (let i = 0; i < lines.length; i++) {
    const h = HEADING_RE.exec(lines[i]);
    if (h) {
      section = h[2] ?? h[1];
      headings.set(section, h[3].trim());
      sectionStart = i;
      continue;
    }
    const b = /^\s+-----BEGIN ([A-Z0-9 ]+)-----\s*$/.exec(lines[i]);
    if (!b) continue;
    const label = b[1];
    const body = [];
    let j = i + 1;
    for (; j < lines.length && !lines[j].includes('-----END'); j++) body.push(lines[j].trim());
    if (j === lines.length || lines[j].trim() !== `-----END ${label}-----`) throw new Error(`RFC ${rfc} line ${i + 1}: unterminated PEM`);
    for (const l of body) if (!B64_LINE_RE.test(l)) throw new Error(`RFC ${rfc} line ${i + 1}: not base64: ${l}`);
    const b64 = body.join('');
    if (b64.length % 4 !== 0) throw new Error(`RFC ${rfc} line ${i + 1}: base64 length`);
    const der = Buffer.from(b64, 'base64');
    if (der.toString('base64') !== b64) throw new Error(`RFC ${rfc} line ${i + 1}: base64 not canonical`);
    objects.push({
      rfc, section, label, der, lines: [i + 1, j + 1],
      context: lines.slice(sectionStart, i).join(' '),
    });
    i = j;
  }
  return { rfc, path, sha256: createHash('sha256').update(text).digest('hex'), objects, headings };
}

// ---------- main ----------
const [outDir, ...inputs] = process.argv.slice(2);
if (!outDir || inputs.length !== 3) {
  console.error('Usage: node bin/extract_rfc_vectors.mjs <out-dir> <rfc9881.txt> <rfc9935.txt> <rfc9909.txt>');
  process.exit(2);
}
const rfcs = new Map(inputs.map((p) => readRfc(p)).map((r) => [r.rfc, r]));
for (const n of Object.keys(LAYOUT)) if (!rfcs.has(Number(n))) throw new Error(`RFC ${n} missing from the inputs`);

const manifest = { sources: [], files: [], not_written: [] };
const written = new Map(); // relative path -> Buffer; nothing is written until every check passed
const publicKeys = []; // the example public keys, compared below with the certificates' SPKI
const certSpki = new Map(); // "<rfc> <oid>" -> { rel, spki }
function put(rel, der, entry) {
  if (written.has(rel)) throw new Error(`two objects map to ${rel}`);
  written.set(rel, der);
  manifest.files.push({ file: rel, bytes: der.length, sha256: createHash('sha256').update(der).digest('hex'), ...entry });
}

for (const [n, layout] of Object.entries(LAYOUT)) {
  const r = rfcs.get(Number(n));
  manifest.sources.push({ rfc: r.rfc, url: `https://www.rfc-editor.org/rfc/rfc${r.rfc}.txt`, file: basename(r.path), sha256: r.sha256 });
  const counts = { valid: 0, invalid: 0, pub: 0 };
  const ordinal = new Map(); // invalid section -> running example number
  for (const o of r.objects) {
    const d = describe(o.label, o.der);
    const name = NAMES[d.oid];
    if (!name) throw new Error(`RFC ${r.rfc} ${o.section}: unknown OID ${d.oid}`);
    const prefix = `${name}-${d.oid}`;
    const src = { rfc: r.rfc, section: o.section, section_title: r.headings.get(o.section), pem_label: o.label, rfc_lines: o.lines };
    // The parameter set must be named in the section heading or the text before the object.
    const setName = name.toUpperCase().replace(/^SLH-DSA-/, '');
    const parentTitles = [...r.headings].filter(([s]) => o.section.startsWith(s)).map(([, t]) => t).join(' ');
    if (!`${parentTitles} ${o.context}`.toUpperCase().includes(setName)) {
      throw new Error(`RFC ${r.rfc} ${o.section} line ${o.lines[0]}: ${setName} not named near the object`);
    }
    if (within(o.section, layout.pub)) {
      if (d.kind !== 'pub') throw new Error(`RFC ${r.rfc} ${o.section}: expected a public key`);
      counts.pub++;
      const entry = { ...src, reason: 'public key: no R5 file name', oid: d.oid };
      manifest.not_written.push(entry);
      publicKeys.push({ rfc: r.rfc, oid: d.oid, spki: d.spki, entry });
      continue;
    }
    if (within(o.section, layout.valid)) {
      let rel;
      if (d.kind === 'cert') {
        if (isKem(d.oid)) {
          if (d.sigOid === d.oid) throw new Error('ML-KEM certificate cannot be self-signed');
          rel = `rfc${r.rfc}/${prefix}_ee.der`;
        } else {
          if (!d.selfIssued || d.sigOid !== d.oid) throw new Error(`RFC ${r.rfc} ${o.section}: TA not self-signed`);
          rel = `rfc${r.rfc}/${prefix}_ta.der`;
        }
      } else if (d.kind === 'key') {
        const expected = FORM_TITLES[r.headings.get(o.section)];
        if (isLattice(d.oid) && expected !== d.form) {
          throw new Error(`RFC ${r.rfc} ${o.section}: heading says ${expected}, key is ${d.form}`);
        }
        rel = `rfc${r.rfc}/${prefix}_${d.form === 'priv' ? 'priv' : `${d.form}_priv`}.der`;
      } else throw new Error(`RFC ${r.rfc} ${o.section}: unexpected ${o.label}`);
      counts.valid++;
      put(rel, o.der, { ...src, oid: d.oid, expect: 'valid' });
      if (d.kind === 'cert') certSpki.set(`${r.rfc} ${d.oid}`, { rel, spki: d.spki });
      continue;
    }
    const inv = within(o.section, layout.invalid);
    if (inv) {
      if (d.kind !== 'key') throw new Error(`RFC ${r.rfc} ${o.section}: expected a private key`);
      const k = (ordinal.get(inv) ?? 0) + 1;
      ordinal.set(inv, k);
      counts.invalid++;
      const folder = `invalid/rfc${r.rfc}-${inv.toLowerCase().replace(/^([a-z])\./, '$1')}-ex${k}`;
      put(`${folder}/${prefix}_${d.form}_priv.der`, o.der, { ...src, oid: d.oid, expect: 'invalid', example: k });
      continue;
    }
    throw new Error(`RFC ${r.rfc} line ${o.lines[0]}: PEM object outside the known sections (${o.section})`);
  }
  for (const [k, v] of Object.entries(layout.counts)) {
    if (counts[k] !== v) throw new Error(`RFC ${r.rfc}: ${counts[k]} ${k} objects, expected ${v}`);
  }
}

// Each example public key must be the SubjectPublicKeyInfo of the example certificate for its OID.
for (const p of publicKeys) {
  const c = certSpki.get(`${p.rfc} ${p.oid}`);
  if (!c) throw new Error(`RFC ${p.rfc}: no example certificate for the public key of ${p.oid}`);
  if (Buffer.compare(Buffer.from(c.spki), Buffer.from(p.spki)) !== 0) {
    throw new Error(`RFC ${p.rfc}: the example public key of ${p.oid} differs from the SPKI in ${c.rel}`);
  }
  p.entry.same_as_spki_of = c.rel;
}

// The RFC 9935 certificates are signed with the RFC 9881 keys: put those TAs next to them.
for (const rel of [...written.keys()].filter((f) => /^rfc9881\/ml-dsa-.*_ta\.der$/.test(f))) {
  const src = manifest.files.find((f) => f.file === rel);
  put(rel.replace(/^rfc9881\//, 'rfc9935/'), written.get(rel), {
    rfc: src.rfc, section: src.section, section_title: src.section_title, pem_label: src.pem_label,
    rfc_lines: src.rfc_lines, oid: src.oid, expect: 'valid', copy_of: rel,
  });
}

for (const [rel, der] of written) {
  mkdirSync(join(outDir, rel, '..'), { recursive: true });
  writeFileSync(join(outDir, rel), der);
}
manifest.files.sort((a, b) => (a.file < b.file ? -1 : 1));
writeFileSync(join(outDir, 'manifest.json'), `${JSON.stringify(manifest, null, 2)}\n`);
console.error(`wrote ${manifest.files.length} files and manifest.json to ${outDir}`);
