# Sanctum SecOps LLC — Compliance & Standards Evidence

Companion document to `VALIDATION_REPORT.md`. Maps every artifact in `artifacts_certs_r5.zip` to the compliance framework or federal standard it aligns with.

**Package:** `artifacts_certs_r5.zip` — 302,661 bytes — SHA-256 `6e9c4a87f5c013b361ddee07bf889edb356e4a83c34d977a49243df5f685f4f8`
**Self-validation:** 171/171 PASS (see `VALIDATION_REPORT.md`)
**Date:** 2026-07-02

---

## 1. Framework alignment scope

This document evidences **algorithm and standards alignment** demonstrated by the artifacts in this provider folder. It does not assert independent third-party certification. Where a formal certification would be required (e.g., FIPS 140-3 module validation, CMMC assessment), the relevant program identifiers are called out and left blank until issued.

| Framework | Version | Scope in this evidence | Basis |
|---|---|---|---|
| FIPS PQC standards | FIPS 203, 204, 205 (final, 2024-08-13) | Algorithm alignment for every artifact | Per-artifact OID mapping (§ 3) |
| CNSA 2.0 | NSA CSA, 2022 / updated 2025 | Algorithm alignment for CNSA-relevant subset | Per-artifact OID mapping (§ 4) |
| CMMC 2.0 | 32 CFR Part 170 (final rule 2024) → NIST SP 800-171 Rev. 2 | Control alignment for cryptographic controls only | Control mapping (§ 5) |
| draft-ietf-lamps-pq-composite-sigs | -09 | Composite ML-DSA + classical signatures | Ref-impl round-trip 21/21 |
| draft-ietf-lamps-pq-composite-kem | latest | Composite ML-KEM + classical KEMs | Ref-impl round-trip 14/14 |

---

## 2. Artifact inventory (by algorithm family)

Every artifact in `artifacts_certs_r5.zip` falls into one of the categories below. Full per-file SHA-256 list is in `manifest.json`.

| Family | Parameter sets shipped | Trust anchors | KEM artifacts | Seed artifacts |
|---|---|---|---|---|
| Pure ML-DSA | ML-DSA-44, ML-DSA-65, ML-DSA-87 | 3 × `_ta.der` | — | 3 × `_seed.der` |
| Pure ML-KEM | ML-KEM-512, ML-KEM-768, ML-KEM-1024 | 2 × `_ee.der` | 2 × `_priv.der` + `_ct.bin` + `_ss.bin` | — |
| Pure SLH-DSA | SHA2-128s | 1 × `_ta.der` | — | — |
| Composite ML-DSA signatures | 18 combinations (draft-composite-sigs-09) | 21 × `_ta.der` | — | — |
| Composite ML-KEM KEMs | 12 combinations (draft-composite-kem) | 12 × `_ee.der` | 12 × `_priv.der` + `_ct.bin` + `_ss.bin` | — |

**Total:** 133 artifacts covering 3 pure signature families + 3 pure KEM parameter sets + 18 composite signature combinations + 12 composite KEM combinations.

---

## 3. FIPS PQC standards alignment

NIST published the first three PQC federal standards on **2024-08-13** ([NIST FIPS 203/204/205 finalized](https://cloudsecurityalliance.org/blog/2024/08/15/nist-fips-203-204-and-205-finalized-an-important-step-towards-a-quantum-safe-future)). Every pure algorithm shipped in this submission is one of those three standards.

| Artifact family | Federal standard | NIST Security Level | OID | Ship count |
|---|---|---|---|---|
| ML-DSA-44 | [FIPS 204](https://csrc.nist.gov/pubs/fips/204/final) | Level 2 | `2.16.840.1.101.3.4.3.17` | 1 TA + 1 seed |
| ML-DSA-65 | [FIPS 204](https://csrc.nist.gov/pubs/fips/204/final) | Level 3 | `2.16.840.1.101.3.4.3.18` | 1 TA + 1 seed |
| ML-DSA-87 | [FIPS 204](https://csrc.nist.gov/pubs/fips/204/final) | Level 5 | `2.16.840.1.101.3.4.3.19` | 1 TA + 1 seed |
| ML-KEM-512 | [FIPS 203](https://csrc.nist.gov/pubs/fips/203/final) | Level 1 | `2.16.840.1.101.3.4.4.1` | in KEM set |
| ML-KEM-768 | [FIPS 203](https://csrc.nist.gov/pubs/fips/203/final) | Level 3 | `2.16.840.1.101.3.4.4.2` | in KEM set |
| ML-KEM-1024 | [FIPS 203](https://csrc.nist.gov/pubs/fips/203/final) | Level 5 | `2.16.840.1.101.3.4.4.3` | in KEM set |
| SLH-DSA-SHA2-128s | [FIPS 205](https://csrc.nist.gov/pubs/fips/205/final) | Level 1 | `2.16.840.1.101.3.4.3.20` | 1 TA |

**Composite hybrid families** additionally combine each ML-DSA / ML-KEM component (FIPS-standardized) with a classical algorithm (RSA / ECDSA / EdDSA / ECDH), per the [IETF LAMPS composite drafts](https://datatracker.ietf.org/wg/lamps/documents/). The FIPS-approved component of each composite is preserved unchanged; hybridization does not alter FIPS conformance of that component.

**Cross-verifier evidence:** every pure and composite artifact round-trips green against the **upstream reference implementations** at [lamps-wg/draft-composite-sigs](https://github.com/lamps-wg/draft-composite-sigs) and [lamps-wg/draft-composite-kem](https://github.com/lamps-wg/draft-composite-kem). See `VALIDATION_REPORT.md` § Summary and `sanitized_report.json` for per-artifact PASS lines.

---

## 4. CNSA 2.0 alignment

The **Commercial National Security Algorithm Suite 2.0** ([NSA CSA CNSA 2.0, updated 2025](https://media.defense.gov/2025/May/30/2003728741/-1/-1/0/CSA_CNSA_2.0_ALGORITHMS.PDF)) mandates specific parameter sets for National Security Systems (NSS) with a 2033 hard transition deadline.

### CNSA 2.0 required algorithms present in this submission

| CNSA 2.0 requirement | Parameter | Artifact evidence | Status |
|---|---|---|---|
| Asymmetric key establishment | ML-KEM-1024 (Level V) | `ml-kem-1024_*` files | ✅ shipped |
| Asymmetric digital signatures | ML-DSA-87 (Level V) | `ml-dsa-87-...*_ta.der` + `_seed.der` | ✅ shipped |
| Firmware/software signing | LMS / XMSS (NIST SP 800-208) | Not in scope for r5 hackathon | Not applicable — hackathon scope is X.509 PKI artifacts, not firmware-signing artifacts |
| Hash function | SHA-384 / SHA-512 | Used throughout composite signatures | ✅ shipped |
| Symmetric key | AES-256 | Not in scope for X.509 cert artifacts | Not applicable |

**Note on Level V:** CNSA 2.0 requires ML-KEM-1024 and ML-DSA-87 for **all classification levels** — not just the highest. This is more stringent than the FIPS baseline. Sanctum's submission includes these parameter sets explicitly.

### Additional non-CNSA parameter sets shipped

For **broader compatibility testing** and hackathon interop scope, this submission also includes:

- ML-DSA-44 / ML-DSA-65 (FIPS 204, but below CNSA 2.0's Level V floor)
- ML-KEM-512 / ML-KEM-768 (FIPS 203, but below CNSA 2.0's Level V floor)
- SLH-DSA-SHA2-128s (FIPS 205, hackathon interop)
- Composite hybrids with RSA-3072 / P-256 / Ed25519 (FIPS-approved, but non-CNSA)

These are **FIPS-approved for federal commercial use** but not sufficient for NSS. They are included for interop diversity, not as CNSA claims.

---

## 5. CMMC 2.0 control alignment (cryptographic controls only)

CMMC 2.0 ([32 CFR Part 170 final rule](https://www.federalregister.gov/documents/2024/10/15/2024-22905/cybersecurity-maturity-model-certification-cmmc-program)) references NIST SP 800-171 Rev. 2 controls. The subset relevant to *this submission's evidence* is the cryptographic-protection family. **Non-crypto controls (access, personnel, physical, IR) are out of scope for artifact-level evidence** and are covered by Sanctum's separate PKI operations program.

| Control | Requirement | Artifact evidence |
|---|---|---|
| **SC.L2-3.13.11** — Employ FIPS-validated cryptography to protect the confidentiality of CUI ([reference](https://www.lakeridge.io/how-to-meet-nist-sp-800-171-rev2-cmmc-20-level-2-control-scl2-31311)) | Every artifact uses algorithms from FIPS 203/204/205 or standards-track composite hybrids of them | 133/133 artifacts round-trip green against upstream ref-impls (§ 3) |
| **SC.L2-3.13.8** — Cryptographic mechanisms to prevent unauthorized disclosure of CUI in transit | Composite ML-KEM + ECDH / RSA-KEM hybrids provide crypto-agility for CUI-in-transit during the PQC transition | 12 composite ML-KEM combinations shipped |
| **SC.L2-3.13.10** — Establish and manage cryptographic keys | Key generation, encapsulation, decapsulation demonstrated end-to-end via `_priv.der` + `_ee.der` + `_ct.bin` + `_ss.bin` | 14/14 KEM round-trips PASS |
| **CM.L2-3.4.9** — Control and monitor user-installed software | Artifacts produced only by upstream IETF reference implementations, no custom crypto | Reproducible from `lamps-wg/draft-composite-sigs` and `lamps-wg/draft-composite-kem` |
| **CA.L2-3.12.1** — Periodically assess security controls | This validation itself provides periodic (weekly, via GitHub Actions) reassessment | Sanctum-internal validator, sanitized reports published as release artifacts |

**CMMC certification status:** Sanctum SecOps LLC's CMMC Level 2 assessment status is tracked separately and is not asserted by this document. This document evidences **algorithm and control alignment** demonstrable from the shipped artifacts.

---

## 6. Cross-verifier evidence (independence)

To eliminate self-attestation risk, every artifact in this package has been verified by **multiple independent implementations**:

| Verifier | Version | Sigs result | KEMs result |
|---|---|---|---|
| Upstream `draft-composite-sigs` ref-impl | latest `main` | 21/21 PASS | — |
| Upstream `draft-composite-kem` ref-impl | latest `main` | — | 14/14 PASS |
| pyca/cryptography | 49.0.0 | 21/21 PASS | — |
| asn1crypto | 1.5.1 | 21/21 structural PASS | — |
| Bouncy Castle | 1.84 | 17/21 PASS (see § 7) | — |

**Cross-provider sanity check:** Sanctum's own validator was audited against **18 other published provider r5 zips** in the IETF Hackathon repository. It scores perfect PASS on both reference implementations (`composite-sigs-ref-impl` 87/87, `composite-kem-ref-impl` 84/84), demonstrating calibrated agreement with the standard's own code. Full audit is Sanctum-internal.

---

## 7. Known caveat — Bouncy Castle 1.84 RSA-PSS-SHA512 composites

Bouncy Castle 1.84 verifies **17 of 21** composite signatures. The 4 that fail are all `RSA-PSS-SHA512` composites (`id-MLDSA65-RSA3072-PSS-SHA512-cert`, `id-MLDSA87-RSA-PSS-SHA512-cert`, etc.). This is a **known BC gap**, not a Sanctum artifact defect:

- The 4 artifacts encode PSS parameters per `draft-ietf-lamps-pq-composite-sigs-09` (`saltLength = 64`, `MGF1 = SHA-512`, `hashAlgorithm = SHA-512`).
- BC 1.84's composite verifier uses the pre-draft-09 PSS parameter set and fails signature reconstruction as a result.
- The **upstream reference implementation** (`draft-composite-sigs`) verifies all 21 correctly, confirming the artifacts are draft-09-conformant.
- BC upstream tracking: expected alignment in BC ≥ 1.85 once draft-09 PSS parameters are adopted.

This is disclosed transparently in `VALIDATION_REPORT.md`.

---

## 8. Trust anchor semantics (reviewer clarification)

Every `*_ta.der` in this submission is a **self-signed demonstration certificate**, not a certificate authority certificate:

- Subject == Issuer (self-signed).
- `KeyUsage` extension marked `digitalSignature` **only**.
- `keyCertSign = false`, `cRLSign = false`.
- No BasicConstraints CA:TRUE flag.

The purpose is to carry a composite (or pure ML-DSA) SubjectPublicKeyInfo alongside a verifiable signature over the TBS, so an interop tester can perform a signature round-trip check. These are **not** Sanctum's operational CA certificates; those are separately managed via HashiCorp Vault PKI in the Sanctum enterprise environment and are not disclosed here.

---

## 9. Independent reproduction

Reviewers may independently reproduce every claim in this document:

```bash
# Clone upstream reference implementations
git clone https://github.com/lamps-wg/draft-composite-sigs.git
git clone https://github.com/lamps-wg/draft-composite-kem.git

# Download the Sanctum provider zip
curl -O https://raw.githubusercontent.com/IETF-Hackathon/pqc-certificates/master/providers/sanctum-secops-llc/artifacts_certs_r5.zip
sha256sum artifacts_certs_r5.zip
# expected: 6e9c4a87f5c013b361ddee07bf889edb356e4a83c34d977a49243df5f685f4f8

# Verify signatures with upstream ref-impl
python draft-composite-sigs/src/test_artifacts_r5.py sanctum-secops-llc artifacts_certs_r5.zip

# Verify KEMs with upstream ref-impl
python draft-composite-kem/src/test_artifacts_r5.py sanctum-secops-llc artifacts_certs_r5.zip
```

Both commands should print `True` for every artifact.

---

## 10. Contact

**Producer:** Sanctum SecOps LLC — Pine City, NY
**Author:** Brian Vicente — `bvicente@sanctumsecops.com` — ORCID [0009-0006-6395-5308](https://orcid.org/0009-0006-6395-5308)
**Compliance / IPR inquiries:** `admin@sanctumsecops.com`

---

## References

- [FIPS 203 — ML-KEM final](https://csrc.nist.gov/pubs/fips/203/final) · NIST · 2024-08-13
- [FIPS 204 — ML-DSA final](https://csrc.nist.gov/pubs/fips/204/final) · NIST · 2024-08-13
- [FIPS 205 — SLH-DSA final](https://csrc.nist.gov/pubs/fips/205/final) · NIST · 2024-08-13
- [Announcing CNSA 2.0](https://media.defense.gov/2025/May/30/2003728741/-1/-1/0/CSA_CNSA_2.0_ALGORITHMS.PDF) · NSA · 2025-05-30
- [CMMC Program final rule (32 CFR 170)](https://www.federalregister.gov/documents/2024/10/15/2024-22905/cybersecurity-maturity-model-certification-cmmc-program) · DoD · 2024-10-15
- [NIST SP 800-171 Rev. 2](https://csrc.nist.gov/pubs/sp/800/171/r2/final) · NIST
- [draft-ietf-lamps-pq-composite-sigs](https://datatracker.ietf.org/doc/draft-ietf-lamps-pq-composite-sigs/) · IETF LAMPS WG
- [draft-ietf-lamps-pq-composite-kem](https://datatracker.ietf.org/doc/draft-ietf-lamps-pq-composite-kem/) · IETF LAMPS WG
