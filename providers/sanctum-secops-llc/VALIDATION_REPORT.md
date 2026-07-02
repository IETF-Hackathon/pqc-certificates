# Sanctum SecOps LLC — Provider Folder Self-Validation

**Result:** ✅ **171/171 PASS**  ·  2026-07-02T17:42:20Z  ·  Apache-2.0

- Package: `artifacts_certs_r5.zip` (302,661 bytes)
- SHA-256: `6e9c4a87f5c013b361ddee07bf889edb356e4a83c34d977a49243df5f685f4f8`
- Standards: draft-ietf-lamps-pq-composite-sigs-09, draft-ietf-lamps-pq-composite-kem

## Summary

| Validation | Result |
|---|---|
| Signature round-trip | ✅ **21/21** |
| KEM round-trip | ✅ **14/14** |
| Seed consistency | ✅ **3/3** |
| manifest | ✅ **133/133** |
| **TOTAL** | ✅ **171/171** |

## What was validated

1. **Signature round-trip** — for every `*_ta.der`, verify the composite (or pure ML-DSA) signature over the certificate TBS using the paired public key.
2. **KEM round-trip** — for every `*_ee.der` + `*_priv.der` + `*_ciphertext.bin` + `*_ss.bin`, decapsulate and match the expected shared secret.
3. **Seed consistency** — for every pure ML-DSA `*_seed.der`, expand the seed and confirm the derived public key matches the SPKI in the paired `*_ta.der`.
4. **Manifest integrity** — recompute SHA-256 for every file listed in `manifest.json`.

## Reproduce

```bash
pip install -r requirements.txt
python verify_sanctum.py            # concise summary (this report)
python verify_sanctum.py --verbose  # per-artifact PASS/FAIL lines
```

Full per-artifact detail is in `validation_report.json`.

## Notes for reviewers

- Trust anchors (`*_ta.der`) are self-signed demonstration certificates with `KeyUsage = digitalSignature` only. They are **not** CA certificates; `keyCertSign` and `cRLSign` are false. Their purpose is to carry a composite (or pure ML-DSA) SubjectPublicKeyInfo and a valid signature over the TBS for round-trip verification.
- All 21 composite signatures also verify green against the upstream `draft-ietf-lamps-pq-composite-sigs` reference implementation and pyca/cryptography 49.0.0. Bouncy Castle 1.84 verifies 17/21; the 4 RSA-PSS-SHA512 composites use draft-09 PSS parameters that BC has not yet aligned to.
- All 14 composite/pure KEMs also verify green against the upstream `draft-ietf-lamps-pq-composite-kem` reference implementation.
