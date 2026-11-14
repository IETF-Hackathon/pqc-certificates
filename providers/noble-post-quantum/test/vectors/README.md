# RFC example vectors

Known-answer vectors for `bin/verify_r5.mjs`: the example certificates and private keys from the
appendices of RFC 9881 (ML-DSA), RFC 9935 (ML-KEM) and RFC 9909 (SLH-DSA), stored as DER under the
R5 file names of the IETF Hackathon project <https://github.com/IETF-Hackathon/pqc-certificates>.
`test/kat.test.mjs` runs the verifier on each folder; `test/openssl_kat_check.sh` checks the same
files with OpenSSL. The keys are public test keys: do not use them for anything else.

## Sources

| RFC | Published | Appendix sections used | Errata (checked 2026-11-14) |
|---|---|---|---|
| [RFC 9881](https://www.rfc-editor.org/rfc/rfc9881) — Algorithm Identifiers for the Module-Lattice-Based Digital Signature Algorithm (ML-DSA) | October 2025 | C.1 private keys, C.3 certificates, C.4 inconsistent private keys; C.2 public keys compared only | 8699 (Appendix A, ML-DSA-87 public key size 2592) and 8700 (Appendix A, OID arc name), both verified; neither touches Appendix C |
| [RFC 9935](https://www.rfc-editor.org/rfc/rfc9935) — Algorithm Identifiers for the Module-Lattice-Based Key-Encapsulation Mechanism (ML-KEM) | March 2026 | C.1 private keys, C.3 certificates, C.4.1 bad private keys; C.2 public keys compared only | 9020 and 9021 (Section 9), rejected |
| [RFC 9909](https://www.rfc-editor.org/rfc/rfc9909) — Algorithm Identifiers for the Stateless Hash-Based Digital Signature Algorithm (SLH-DSA) | December 2025 | C.2 private key, C.3 certificate; C.1 public key compared only | 8891 and 8892 (OID arc name in Section 3 and Appendix A), held for document update |

The text files used were downloaded from `https://www.rfc-editor.org/rfc/rfcNNNN.txt` on
2026-11-14:

| File | SHA-256 |
|---|---|
| rfc9881.txt | `20ae3b519bc69e32989fa6e625ab8746453eddf457e20ddbfd79d841a44237a2` |
| rfc9935.txt | `9a369bca93a613d0b89b8f4ed119ba9ded91c00acd97ae5b9a2f9b3f02e49b4f` |
| rfc9909.txt | `2c77519a6eeff691a2931a86643b0c9346ce7018303316d864cad1e585a5a50b` |

`manifest.json` lists every file with its RFC, section, line range in that text file, size and
SHA-256, and the public keys that were not written.

## Layout

The OIDs are those of the NIST CSOR: ML-DSA-44/65/87 `2.16.840.1.101.3.4.3.17`–`.19`, SLH-DSA-SHA2-128s
`2.16.840.1.101.3.4.3.20`, ML-KEM-512/768/1024 `2.16.840.1.101.3.4.4.1`–`.3`.

| Folder | Files | Source |
|---|---|---|
| `rfc9881/` | `ml-dsa-{44,65,87}-<oid>_seed_priv.der`, `_expandedkey_priv.der`, `_both_priv.der`, `_ta.der` (12) | RFC 9881 C.1.1.1–C.1.3.3 (all from the seed `000102…1e1f`), C.3 (self-signed, O=IETF, CN=LAMPS WG) |
| `rfc9935/` | `ml-kem-{512,768,1024}-<oid>_seed_priv.der`, `_expandedkey_priv.der`, `_both_priv.der`, `_ee.der` (12) and `ml-dsa-{44,65,87}-<oid>_ta.der` (3) | RFC 9935 C.1.1.1–C.1.3.3 (seed `000102…3e3f`), C.3. The three TAs are byte-identical copies of the RFC 9881 C.3 certificates: RFC 9935 C.3 says its certificates are signed with the RFC 9881 ML-DSA-44/65/87 keys, and the verifier looks for the ML-DSA TA of the same level in the same set |
| `rfc9909/` | `slh-dsa-sha2-128s-<oid>_priv.der`, `_ta.der` (2) | RFC 9909 C.2 (without the public key), C.3 (self-signed) |
| `invalid/rfc9881-c4-ex1/` … `-ex3/` | one ML-DSA-44 key each | RFC 9881 C.4, examples 1–3 |
| `invalid/rfc9935-c4.1-ex1/` … `-ex4/` | one ML-KEM-512 key each | RFC 9935 C.4.1, examples 1–4 |

Each example public key (RFC 9881 C.2, RFC 9935 C.2, RFC 9909 C.1) equals the
SubjectPublicKeyInfo of the example certificate for its OID; the extraction script checks this.

Run the verifier on one folder at a time. It walks sub-folders, so on `test/vectors/` itself the TA
copies and the invalid keys would count as second inputs for the same OID and form, and those
forms would be skipped.

```sh
node bin/verify_r5.mjs test/vectors/rfc9881
node --test test/kat.test.mjs
test/openssl_kat_check.sh <out-dir>
```

## Expected results

`bin/verify_r5.mjs` (with @noble/post-quantum 0.7.1) and OpenSSL 3.5.8, on 2026-11-14. All the
certificates are within their validity periods until 2034 (RFC 9909) and 2040 (RFC 9881, RFC 9935).

| Folder | Rows | Verifier stderr | OpenSSL 3.5.8 |
|---|---|---|---|
| `rfc9881/` | `seed`, `expandedkey`, `both`, `cert`, `consistent` Y for each level (15) | — | TAs verify (`verify -x509_strict -check_ss_sig`); each key imports (`pkey -check`), has the TA's public key and signs a message that verifies under the TA |
| `rfc9935/` | `cert` Y for the three TAs and the three EEs, `consistent` Y for each ML-KEM level (9); no `seed`, `expandedkey`, `both` rows | `key decapsulation not performed: need exactly one _ciphertext.bin and one _ss.bin (found 0 and 0)` for each ML-KEM OID | the TA copies verify as in `rfc9881/`; EEs verify under the TA of the same level (`verify -x509_strict`); each key imports, has the EE's public key and decapsulates an OpenSSL ciphertext for that key |
| `rfc9909/` | `priv`, `cert`, `consistent` Y (3) | — | TA verifies; the key imports, has the TA's public key, signs and verifies |

pkilint 0.13.4 (`lint_pkix_cert lint -s NOTICE`) reports no error or warning on the seven
certificates, only notices: the RFC 9881 TAs have no authorityKeyIdentifier (allowed for a
self-signed certificate by RFC 5280 Section 4.2.1.1), and the subjectKeyIdentifier of the RFC 9881
and RFC 9935 certificates is SHAKE256 of the subjectPublicKey truncated to 20 octets, a method that
pkilint does not know (RFC 9909 uses SHA-1, method 1 of RFC 5280 Section 4.2.1.2).

RFC 9935 has no ciphertext and shared secret, so the R5 key test of the ML-KEM keys (decapsulation)
is not performed on the folder as published. With one ciphertext and shared secret per level added
under R5 names, the `seed`, `expandedkey` and `both` rows are Y for all three levels: in
`test/kat.test.mjs` the pair is made with @noble/post-quantum for the certificate's public key and a
fixed message; in `test/openssl_kat_check.sh` it is made with `openssl pkeyutl -encap`. Those pairs
are not RFC data and are not stored here.

The bad keys, as measured here against the valid C.1.1.2 key of the same seed:

| Folder | What is wrong | Rows (stderr) | With a ciphertext | OpenSSL 3.5.8 on import |
|---|---|---|---|---|
| `invalid/rfc9881-c4-ex1/` | `both`: the seed is the C.1 seed, the expandedKey belongs to another key | `both` N, `consistent` N (`seed and expandedKey disagree`) | — | refused: explicit ML-DSA-44 private key does not match seed |
| `invalid/rfc9881-c4-ex2/` | `expandedKey`: one byte of `tr` changed (offset 64, 0x32 → 0x33), so `tr` ≠ H(pk) | `expandedkey` N (`sign/verify failed`) | — | refused: ML-DSA-44 private key does not match its pubkey part |
| `invalid/rfc9881-c4-ex3/` | `expandedKey`: one byte of `t0` changed (offset 896, 0x1e → 0x1f), coefficient 0 of t0[0] is −1823 instead of −1822 | **`expandedkey` Y: not detected** (see below) | — | refused: ML-DSA-44 private key does not match its pubkey part |
| `invalid/rfc9935-c4.1-ex1/` | `both`: the expandedKey is not the expansion of the seed (its public key differs) | `both` N, `consistent` N (`seed and expandedKey disagree`) | same | refused: explicit ML-KEM-512 private key does not match seed |
| `invalid/rfc9935-c4.1-ex2/` | `expandedKey`: coefficient 0 of ŝ[0] is 1393 instead of 1392; H(ek) is still valid | no row (not performed) | `expandedkey` N (`decapsulation mismatch`) | refused: public part of ML-KEM-512 private key fails to match private (pairwise test) |
| `invalid/rfc9935-c4.1-ex3/` | `expandedKey`: one byte of H(ek) changed (offset 1568, 0x82 → 0x83) | no row (not performed) | `expandedkey` N (`invalid secretKey: hash check failed`) | refused: ML-KEM-512 public key hash mismatch |
| `invalid/rfc9935-c4.1-ex4/` | `both`: only z differs (last byte 0x3f → 0x3e) | `both` N (`seed and expandedKey disagree`); `consistent` Y, since the public keys agree | same | refused: private ML-KEM-512 key implicit rejection secret does not match seed |

RFC 9881 C.4 example 3 is the only bad key that gets a Y. The verifier derives the public key from ρ, s1 and
s2, and its key test is the R5 one: sign a message with the key and verify. The changed t0 enters
signing only through c·t0 (its norm check and the hint), and in a run here 2000 hedged and 2000
deterministic signatures made with this key all verified, so the R5 test as defined passes. OpenSSL
3.5.8 rejects the key on import because it recomputes t0 and `tr` from ρ, s1 and s2 and compares
them with the key (`ossl_ml_dsa_key_public_from_private` in `crypto/ml_dsa/ml_dsa_key.c`, called
from `ossl_ml_dsa_sk_decode`). `test/kat.test.mjs` keeps the expected N as a `todo` test.

## Re-extracting

```sh
for n in 9881 9935 9909; do curl -sSfO "https://www.rfc-editor.org/rfc/rfc$n.txt"; done
node bin/extract_rfc_vectors.mjs test/vectors rfc9881.txt rfc9935.txt rfc9909.txt
```

The script decodes the PEM text strictly (base64 alphabet, padding, canonical form, one DER object),
names each file from its OID and private-key CHOICE tag, checks the name against the section
headings, requires the expected number of objects per section, checks the public keys against the
certificates and rewrites `manifest.json`. Run on the text files above, it reproduces these files
byte for byte.

## Licence

The DER files in this folder are taken unchanged (PEM decoded to DER) from RFC 9881, RFC 9935 and
RFC 9909, whose authors are named on each RFC. Each of these RFCs carries this notice, with the year
2025 for RFC 9881 and RFC 9909 and 2026 for RFC 9935:

> Copyright (c) 2025 IETF Trust and the persons identified as the document authors. All rights
> reserved.
>
> This document is subject to BCP 78 and the IETF Trust's Legal Provisions Relating to IETF
> Documents (https://trustee.ietf.org/license-info) in effect on the date of publication of this
> document. Please review these documents carefully, as they describe your rights and restrictions
> with respect to this document. Code Components extracted from this document must include Revised
> BSD License text as described in Section 4.e of the Trust Legal Provisions and are provided
> without warranty as described in the Revised BSD License.

The IETF Trust's list of Code Components
(<https://trustee.ietf.org/documents/trust-legal-provisions/code-components-list-3/>) includes
ASN.1 structures. These DER files are used here as Code Components under the Revised BSD License
of Section 4.c of the Trust Legal Provisions (TLP 5.0, effective 2015-03-25, corrected 2021-09-21),
reproduced in full as Section 4.e allows:

> Copyright (c) 2025 IETF Trust and the persons identified as authors of the code. All rights
> reserved. (RFC 9881, RFC 9909)
>
> Copyright (c) 2026 IETF Trust and the persons identified as authors of the code. All rights
> reserved. (RFC 9935)
>
> Redistribution and use in source and binary forms, with or without modification, are permitted
> provided that the following conditions are met:
>
> - Redistributions of source code must retain the above copyright notice, this list of conditions
>   and the following disclaimer.
> - Redistributions in binary form must reproduce the above copyright notice, this list of
>   conditions and the following disclaimer in the documentation and/or other materials provided
>   with the distribution.
> - Neither the name of Internet Society, IETF or IETF Trust, nor the names of specific
>   contributors, may be used to endorse or promote products derived from this software without
>   specific prior written permission.
>
> THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
> IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
> FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
> CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
> IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
> OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

This README, `manifest.json` and the scripts that use these files (`bin/extract_rfc_vectors.mjs`,
`test/kat.test.mjs`, `test/openssl_kat_check.sh`) are under the Apache License 2.0, like the rest of
this provider.
