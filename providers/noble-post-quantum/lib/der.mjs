// SPDX-License-Identifier: Apache-2.0
// Minimal DER encoder for the structures in R5 artifacts: X.509 v3 certificates (RFC 5280) and
// OneAsymmetricKey private keys (RFC 5958) for ML-DSA (RFC 9881), ML-KEM (RFC 9935) and
// SLH-DSA (RFC 9909). It writes only what those structures need, in DER (X.690):
// definite minimal lengths, minimal INTEGERs, BOOLEAN TRUE as 0xFF, DEFAULT values omitted,
// named bit lists without trailing zero bits, UTCTime before 2050 and GeneralizedTime after.

export function concat(...parts) {
  const bufs = parts.map((p) => (p instanceof Uint8Array ? p : Uint8Array.from(p)));
  const out = new Uint8Array(bufs.reduce((n, b) => n + b.length, 0));
  let off = 0;
  for (const b of bufs) { out.set(b, off); off += b.length; }
  return out;
}

function encodeLength(n) {
  if (!Number.isSafeInteger(n) || n < 0) throw new Error('DER: bad length');
  if (n < 0x80) return Uint8Array.of(n);
  const bytes = [];
  for (let v = n; v > 0; v = Math.floor(v / 256)) bytes.unshift(v & 0xff);
  return Uint8Array.of(0x80 | bytes.length, ...bytes);
}

export const tlv = (tag, content) => concat(Uint8Array.of(tag), encodeLength(content.length), content);
export const seq = (...items) => tlv(0x30, concat(...items));
// SET OF with the elements sorted by their encodings (X.690 11.6); a single element is the usual case.
export const setOf = (...items) => {
  const sorted = [...items].sort((a, b) => Buffer.compare(Buffer.from(a), Buffer.from(b)));
  return tlv(0x31, concat(...sorted));
};
export const octetString = (bytes) => tlv(0x04, bytes);
export const nullValue = () => Uint8Array.of(0x05, 0x00);
export const bool = (value) => tlv(0x01, Uint8Array.of(value ? 0xff : 0x00));
export const utf8String = (s) => tlv(0x0c, new TextEncoder().encode(s));
// [n] EXPLICIT (constructed) or [n] IMPLICIT primitive
export const explicit = (n, content) => tlv(0xa0 | n, content);
export const implicitPrimitive = (n, bytes) => tlv(0x80 | n, bytes);

// INTEGER from a non-negative bigint or an unsigned big-endian byte string: minimal two's complement.
export function integer(value) {
  let bytes;
  if (typeof value === 'bigint' || typeof value === 'number') {
    let v = BigInt(value);
    if (v < 0n) throw new Error('DER: negative INTEGER not supported');
    const out = [];
    do { out.unshift(Number(v & 0xffn)); v >>= 8n; } while (v > 0n);
    bytes = Uint8Array.from(out);
  } else {
    let i = 0;
    while (i < value.length - 1 && value[i] === 0) i++;
    bytes = value.subarray(i);
    if (bytes.length === 0) bytes = Uint8Array.of(0);
  }
  if (bytes[0] & 0x80) bytes = concat([0], bytes);
  return tlv(0x02, bytes);
}

export function oid(dotted) {
  const arcs = dotted.split('.').map((a) => BigInt(a));
  if (arcs.length < 2 || arcs[0] > 2n || (arcs[0] < 2n && arcs[1] > 39n)) throw new Error(`DER: bad OID ${dotted}`);
  const values = [arcs[0] * 40n + arcs[1], ...arcs.slice(2)];
  const out = [];
  for (const v of values) {
    const chunk = [];
    let x = v;
    do { chunk.unshift(Number(x & 0x7fn)); x >>= 7n; } while (x > 0n);
    for (let i = 0; i < chunk.length - 1; i++) chunk[i] |= 0x80;
    out.push(...chunk);
  }
  return tlv(0x06, Uint8Array.from(out));
}

// BIT STRING carrying whole octets (public keys, signatures): unused bits = 0.
export const bitStringBytes = (bytes) => tlv(0x03, concat([0], bytes));

// BIT STRING for a named bit list such as KeyUsage: trailing zero bits are removed (X.690 11.2.2),
// so e.g. keyCertSign+cRLSign = 03 02 01 06 and keyEncipherment = 03 02 05 20.
export function namedBits(bitNumbers) {
  if (bitNumbers.length === 0) return Uint8Array.of(0x03, 0x01, 0x00);
  const highest = Math.max(...bitNumbers);
  const bytes = new Uint8Array(Math.floor(highest / 8) + 1);
  for (const b of bitNumbers) bytes[Math.floor(b / 8)] |= 0x80 >> (b % 8);
  const unused = 7 - (highest % 8);
  return tlv(0x03, concat([unused], bytes));
}

const pad = (n, w) => String(n).padStart(w, '0');
// Time (RFC 5280 4.1.2.5): UTCTime for years through 2049, GeneralizedTime from 2050; whole
// seconds in Zulu time.
export function time(date) {
  const d = new Date(Math.floor(date.getTime() / 1000) * 1000);
  const y = d.getUTCFullYear();
  const rest = pad(d.getUTCMonth() + 1, 2) + pad(d.getUTCDate(), 2) + pad(d.getUTCHours(), 2)
    + pad(d.getUTCMinutes(), 2) + pad(d.getUTCSeconds(), 2) + 'Z';
  if (y >= 1950 && y < 2050) return tlv(0x17, new TextEncoder().encode(pad(y % 100, 2) + rest));
  return tlv(0x18, new TextEncoder().encode(pad(y, 4) + rest));
}

// ---------- X.509 helpers ----------
export const OID = {
  commonName: '2.5.4.3',
  organizationName: '2.5.4.10',
  subjectKeyIdentifier: '2.5.29.14',
  keyUsage: '2.5.29.15',
  basicConstraints: '2.5.29.19',
  authorityKeyIdentifier: '2.5.29.35',
};
export const KEY_USAGE = {
  digitalSignature: 0, nonRepudiation: 1, keyEncipherment: 2, dataEncipherment: 3,
  keyAgreement: 4, keyCertSign: 5, cRLSign: 6, encipherOnly: 7, decipherOnly: 8,
};

// AlgorithmIdentifier with parameters absent (RFC 9881, 9935, 9909: MUST be absent).
export const algorithmIdentifier = (dotted) => seq(oid(dotted));

// Name as an RDNSequence of single-valued RDNs, e.g. [['2.5.4.10', 'Org'], ['2.5.4.3', 'CN']].
export const name = (attrs) => seq(...attrs.map(([type, value]) => setOf(seq(oid(type), utf8String(value)))));

// Extension: critical is omitted when FALSE (DEFAULT FALSE).
export const extension = (dotted, critical, valueDer) =>
  seq(oid(dotted), ...(critical ? [bool(true)] : []), octetString(valueDer));

export const basicConstraints = (isCA) => seq(...(isCA ? [bool(true)] : [])); // CA:FALSE = 30 00
export const keyUsage = (...bits) => namedBits(bits);
export const subjectKeyIdentifier = (keyId) => octetString(keyId);
export const authorityKeyIdentifier = (keyId) => seq(implicitPrimitive(0, keyId));

export function tbsCertificate({ serial, sigAlg, issuer, notBefore, notAfter, subject, spkiAlg, publicKey, extensions }) {
  return seq(
    explicit(0, integer(2n)), // version v3
    integer(serial),
    algorithmIdentifier(sigAlg),
    issuer,
    seq(time(notBefore), time(notAfter)),
    subject,
    seq(algorithmIdentifier(spkiAlg), bitStringBytes(publicKey)),
    explicit(3, seq(...extensions)),
  );
}

export const certificate = (tbs, sigAlg, signature) => seq(tbs, algorithmIdentifier(sigAlg), bitStringBytes(signature));

// OneAsymmetricKey v1 (version 0, no attributes, no publicKey) wrapping the given privateKey contents.
export const oneAsymmetricKey = (alg, privateKeyContents) =>
  seq(integer(0n), algorithmIdentifier(alg), octetString(privateKeyContents));

// ML-DSA / ML-KEM private key CHOICE contents (RFC 9881 / RFC 9935)
export const latticeSeed = (seed) => implicitPrimitive(0, seed); // seed [0] IMPLICIT OCTET STRING
export const latticeExpanded = (sk) => octetString(sk);
export const latticeBoth = (seed, sk) => seq(octetString(seed), octetString(sk));
