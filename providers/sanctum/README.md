# Provider: sanctum

**Org:** Sanctum SecOps LLC
**PEN:** 1.3.6.1.4.1.65953
**Related I-D:** draft-vicente-lamps-pqchc-01
**Contact:** Brian Vicente

## Scope

Composite/hybrid PQC issuance profiles over FIPS 203/204/205, plus two
X.509 evidence extensions under the Sanctum PEN:

- `SanctumAttestation`  (1.3.6.1.4.1.65953.1.1.1)
- `SanctumPQCProfile`   (1.3.6.1.4.1.65953.1.1.2)

## Mechanisms contributed

| Mechanism | OID | Standards basis |
|---|---|---|
| ML-DSA-65 + ECDSA-P256 (composite) | 2.16.840.1.114027.80.8.1.22 | draft-ietf-lamps-pq-composite-sigs |
| ML-KEM-768 + X25519 (hybrid KEM)   | 2.16.840.1.114027.80.5.2.6  | composite KEM draft |
| **ML-DSA-65 + SLH-DSA-128s (hedge, EXPERIMENTAL)** | 1.3.6.1.4.1.65953.1.2.3 | Sanctum PEN — NOT NIST-registered |

The hedge mechanism is an experimental lattice‖hash-based dual-family signature
recited under the Sanctum PEN arc. It is clearly marked non-standard and is
offered as a feedback signal to the LAMPS WG, not as an interop target.

## Files
- `compatMatrices/artifacts_certs_r5/sanctum_sanctum.csv` — results matrix
- `tools/sanctum_pqc_ext.py` — DER encoders for both extensions
- `tools/gen_profile.sh` — composite/hybrid/hedge cert generation (oqs-provider)
