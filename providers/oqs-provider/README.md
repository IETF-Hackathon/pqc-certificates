# oqs-provider

Artifacts generated with [oqs-provider](https://github.com/open-quantum-safe/oqs-provider) loaded into OpenSSL, using the pinned Docker image `openquantumsafe/oqs-ossl3`.
The image digest is set in [`gen_r5.sh`](gen_r5.sh) and in the `oqs_cert_validation` job of [`artifact_validation.yaml`](../../.github/workflows/artifact_validation.yaml).
These two images should be kept in sync.

## Contents

| File | Description |
| --- | --- |
| `artifacts_certs_r5.zip` | r5 artifacts: a self-signed TA (`<name>-<oid>_ta.der`) and a private key (`<name>-<oid>_priv.der`) per algorithm |
| `gen_r5.sh` | Generates `artifacts_certs_r5.zip` |
| `historical_artifacts/` | Artifacts from earlier rounds |

## Algorithms Used

`gen_r5.sh` generates artifacts for the algorithms in its `ALGS` list:
Falcon-512, Falcon-1024 and their padded variants, under the OQS OIDs listed in [docs/oid_mapping.md](../../docs/oid_mapping.md).

Not included:

- **MAYO, SNOVA, UOV.** liboqs 0.15 implements the NIST additional-signatures round 2 versions, which round 3 (May 2026) supersedes. Planned for a follow-up once round 3 implementations are available.
- **SPHINCS+.** oqs-provider still serves the FIPS 205 draft versions. Final SLH-DSA is covered by `providers/ossl35`.
- **CROSS.** Did not advance to round 3 ([source](https://csrc.nist.gov/News/2026/nist-advances-9-candidates-to-the-3rd-round-of-pqc)).
- **ML-DSA, ML-KEM, SLH-DSA.** oqs-provider leaves these to OpenSSL's default provider. So covered by `providers/ossl35` for those.
- **OQS classical+PQ hybrids.** These aren't standard composites.
- **KEMs** (BIKE, FrodoKEM). This build has no key encoders for them, so they cannot be put in certificates.

## Usage

Requires `docker` and `zip` on the host.
To regenerate `artifacts_certs_r5.zip`, run:
```sh
./gen_r5.sh
# or
make generate
```
The script runs itself inside the pinned image (which has no bash or zip) and zips the result on the host.

To verify the artifact, run:
```sh
make verify
```
This runs `./gen_r5.sh --verify`, which runs `src/test_certs_r5.sh oqs` in the same image, which verifies every provider's `artifacts_certs_r5.zip`, this one included.
Results go to `output/certs/` at the repository root.
This is the same check CI runs.

## Updating oqs-provider

`IMAGE` and `ALGS` are at the top of `gen_r5.sh`. To move to a newer image:

1. Update the digest in `IMAGE` and in the `oqs_cert_validation` CI job.
2. Check the OIDs in `ALGS` against oqs-provider's
   [`oqs-template/generate.yml`](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml)
   at the new release's tag, and update any that changed. Then rerun `./gen_r5.sh`.
