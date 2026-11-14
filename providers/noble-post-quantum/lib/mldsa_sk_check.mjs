// SPDX-License-Identifier: Apache-2.0
// Consistency check for an ML-DSA expanded private key (FIPS 204 skEncode layout
// rho || K || tr || s1 || s2 || t0): recompute t = A*s1 + s2, split it with Power2Round into
// (t1, t0), and require that the stored t0 and tr = H(rho || t1, 64) match. This is the check
// RFC 9881 Appendix C.4 describes for its second and third inconsistent examples; the public
// key from @noble/post-quantum's getPublicKey() ignores both fields.
import { genCrystals, XOF128 } from '@noble/post-quantum/_crystals.js';
import { shake256 } from '@noble/hashes/sha3.js';

const N = 256;
const Q = 8380417;
const D = 13;
const crystals = genCrystals({ N, Q, F: 8347681, ROOT_OF_UNITY: 1753, newPoly: (n) => new Int32Array(n), isKyber: false, brvBits: 8 });
// expanded key length -> parameter set (FIPS 204 Table 1 / Table 2)
const PARAMS = { 2560: { K: 4, L: 4, ETA: 2 }, 4032: { K: 6, L: 5, ETA: 4 }, 4896: { K: 8, L: 7, ETA: 2 } };

function rejNttPoly(next) { // FIPS 204 Algorithm 30 RejNTTPoly
  const r = new Int32Array(N);
  for (let j = 0; j < N;) {
    const b = next();
    for (let i = 0; j < N && i + 3 <= b.length; i += 3) {
      const t = (b[i] | (b[i + 1] << 8) | (b[i + 2] << 16)) & 0x7fffff;
      if (t < Q) r[j++] = t;
    }
  }
  return r;
}

export function expandedKeyMismatch(sk, publicKey) {
  const p = PARAMS[sk.length];
  if (!p) return 'unknown expanded key length';
  const { K, L, ETA } = p;
  const eta = crystals.bitsCoder(ETA === 2 ? 3 : 4, { encode: (i) => ETA - i, decode: (i) => ETA - i });
  const t0c = crystals.bitsCoder(13, { encode: (i) => (1 << (D - 1)) - i, decode: (i) => (1 << (D - 1)) - i });
  const rho = sk.subarray(0, 32);
  const tr = sk.subarray(64, 128);
  let off = 128;
  const take = (n) => { const v = sk.subarray(off, off + n); off += n; return v; };
  const s1 = Array.from({ length: L }, () => eta.decode(take(eta.bytesLen)));
  const s2 = Array.from({ length: K }, () => eta.decode(take(eta.bytesLen)));
  const t0Stored = sk.subarray(off);
  const xof = XOF128(rho);
  const s1Hat = s1.map((poly) => crystals.NTT.encode(poly.slice()));
  const t0 = [];
  for (let i = 0; i < K; i++) {
    const acc = new Int32Array(N);
    for (let j = 0; j < L; j++) {
      const a = rejNttPoly(xof.get(j, i)); // A[i][j] from rho || j || i
      for (let n = 0; n < N; n++) acc[n] = crystals.mod(acc[n] + crystals.mod(a[n] * s1Hat[j][n]));
    }
    crystals.NTT.decode(acc);
    const low = new Int32Array(N);
    for (let n = 0; n < N; n++) low[n] = crystals.smod(crystals.mod(acc[n] + s2[i][n]), 1 << D); // Power2Round low part
    t0.push(t0c.encode(low));
  }
  xof.clean();
  const t0Bytes = Buffer.concat(t0.map((x) => Buffer.from(x)));
  if (!t0Bytes.equals(Buffer.from(t0Stored))) return 't0 does not match s1 and s2';
  if (!Buffer.from(shake256(publicKey, { dkLen: 64 })).equals(Buffer.from(tr))) return 'tr does not match the public key';
  return null;
}
