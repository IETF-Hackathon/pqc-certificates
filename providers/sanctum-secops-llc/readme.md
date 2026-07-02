# Sanctum SecOps LLC — IETF PQC Certificate Hackathon (r5)

Provider folder for the [IETF Hackathon PQC Certificate interop](https://github.com/IETF-Hackathon/pqc-certificates).

**Producer:** `sanctum-secops-llc`
**Standards:** [draft-ietf-lamps-pq-composite-sigs-09](https://datatracker.ietf.org/doc/draft-ietf-lamps-pq-composite-sigs/) · [draft-ietf-lamps-pq-composite-kem](https://datatracker.ietf.org/doc/draft-ietf-lamps-pq-composite-kem/)
**License:** Apache-2.0

## TL;DR for reviewers

Open [`VALIDATION_REPORT.md`](./VALIDATION_REPORT.md). One page, one table, all green.

If you want to re-run it yourself:

```bash
pip install -r requirements.txt
python verify_sanctum.py          # concise summary, regenerates VALIDATION_REPORT.md
python verify_sanctum.py --verbose  # per-artifact PASS/FAIL lines
```

`verify_sanctum.py` is a self-contained validator: no network, reads only files in this folder.

## Contents

| File | Purpose |
|---|---|
| `artifacts_certs_r5.zip` | 133 artifacts — 63 signature files (21 composite/pure ML-DSA × 3 files each) + 70 KEM files (14 composite/pure ML-KEM × 5 files each) |
| `manifest.json` | SHA-256 for every file inside the zip + package hash |
| `r5-artifacts.csv` | Hackathon matrix row-per-artifact index |
| `r5-artifact-manifest.csv` | Hackathon matrix per-file index |
| `verify_sanctum.py` | Standalone validator (this folder, no network) |
| `VALIDATION_REPORT.md` | One-page self-validation summary |
| `validation_report.json` | Per-artifact machine-readable results |
| `requirements.txt` | Python deps for `verify_sanctum.py` |

## What the validator does

1. **Signature round-trip** on every `*_ta.der` — verifies the composite (or pure ML-DSA) signature over the certificate TBS using the paired public key.
2. **KEM encap/decap round-trip** on every `*_ee.der` + `*_priv.der` + `*_ciphertext.bin` + `*_ss.bin`.
3. **Private-key ↔ SPKI consistency** on every pure ML-DSA `*_seed.der`.
4. **SHA-256 manifest integrity** — recomputes hashes for every file listed in `manifest.json`.

## Cross-verifier status

Independently verified against multiple stacks (see `VALIDATION_REPORT.md`):

- Upstream reference implementations (`draft-composite-sigs`, `draft-composite-kem`) — full green.
- pyca/cryptography 49.0.0 — full green on all 21 composite signatures.
- Bouncy Castle 1.84 — 17/21 composite signatures pass; the 4 RSA-PSS-SHA512 composites use draft-09 PSS parameters BC has not yet aligned to. Tracked upstream.

## About the trust anchors

Every `*_ta.der` is a **self-signed demonstration certificate**, not a CA. `KeyUsage = digitalSignature` only; `keyCertSign` and `cRLSign` are false. The purpose is to carry a composite (or pure ML-DSA) SubjectPublicKeyInfo and a verifiable signature over the TBS so a round-trip signature check is possible.

## Contact

Brian Vicente — `bvicente@sanctumsecops.com` — ORCID [0009-0006-6395-5308](https://orcid.org/0009-0006-6395-5308)
