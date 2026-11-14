# Bouncy Castle Trial Artifacts and Validation Tool

## Building

The generators and validating parsers in `src/main/java` are built against the latest beta of Bouncy Castle, which can be found at https://downloads.bouncycastle.org/betas. The beta in use is recorded in `lib/beta.ver` (currently `jdk18on-1.88-SNAPSHOT`).

You need the bcprov-jdk18on, bcpkix-jdk18on and bcutil-jdk18on jars on the class path to compile and run the tools. `gen.sh` and `check.sh` download the current beta into `lib` and compile everything into `classes`, so the simplest way to build is to run one of them.

## Scripts

| Script | Purpose |
|---|---|
| `gen.sh` | Builds the tools and runs `R5ArtifactGenerator`, producing `artifacts_certs_r5.zip` (certificates, under a top-level `artifacts/` directory) and `artifacts_cms_v3.zip`. |
| `check.sh [artifacts]` | Builds the tools and runs `R5ArtifactParser` over the certificate artifacts and, if present, the CMS artifacts. |
| `gen_r3.sh` | Runs `R3ArtifactGenerator` (expects the tools to have been compiled into `classes` already). |
| `check_r3.sh [producer] [artifacts]` | Runs `R3ArtifactParser`, e.g. `./check_r3.sh bc ./artifacts_certs_r3`. |
| `verify_r3.sh <certfile>` | Runs `Verify self-signed` against a single self-signed certificate. |

The top-level `Makefile` uses `gen.sh` and `check.sh`.

## R5ArtifactGenerator / R5ArtifactParser (current)

`R5ArtifactGenerator` writes `artifacts_certs_r5` and `artifacts_cms_v3` into the current working directory. Covered algorithms:

- ML-DSA and hash-ML-DSA, SLH-DSA and hash-SLH-DSA, Falcon.
- Composite ML-DSA signatures and composite ML-KEM, using the IANA (`1.3.6.1.5.5.7.6.*`) OIDs.
- ML-KEM, FrodoKEM/eFrodoKEM and NTRU, with sample ciphertexts and shared secrets.
- Catalyst and chameleon hybrid trust anchors.
- CMS signed-data and KEMRecipientInfo enveloped-data artifacts.

`R5ArtifactParser <producer> <artifacts_dir|artifacts.zip>` validates certificate and key artifacts. Use the producer name `bc-cms` for a CMS artifact set. Results are printed as passed/failed/ignored lists and written to `<producer>_bc.csv`.

## R3 and R4 generators and parsers

`R3ArtifactGenerator` and `R4ArtifactGenerator` produce the earlier rounds' layouts (`artifacts_certs_r3`/`artifacts_cms_r3` as PEM and `artifacts_certs_r4`/`artifacts_cms_r4` as DER). `R3ArtifactParser` and `R4ArtifactParser` take the same arguments as `R5ArtifactParser`, but only check certificate artifacts and skip CMS files.

## ArtifactGenerator / ArtifactParser (original rounds)

`ArtifactGenerator` creates the original `artifacts` hierarchy (one directory per OID, with `ta`, `ca`, `ee` and `crl` subdirectories) in the current working directory. It also creates an ECDSA trust anchor and CA with an ML-DSA-65 alternative signature. `ArtifactParser <producer> <artifacts_dir|artifacts.zip>` parses such a hierarchy and confirms what signatures it can for certificates, certification requests and CRLs, as well as validating public keys. The artifacts from round 2 are kept in `historical_artifacts/artifacts_r2.zip`.

## Algorithms no longer supported (BC 1.88 and later)

From BC 1.88 the following can no longer be generated or verified, so they have been removed from the generators:

- **Round 3 Dilithium and SPHINCS+.** `ArtifactGenerator` now only covers Falcon, and its hybrid uses ML-DSA-65 instead of Dilithium3.
- **Composite signatures under the Entrust arc (`2.16.840.1.114027.80.8.1.*` and `2.16.840.1.114027.80.9.1.*`).** These were removed from R3 and R4. Composites now use the IANA OIDs, as in R5.
- **The generic "explicit" composite (`2.16.840.1.114027.80.4.1`, `COMPOSITE` with `CompositeAlgorithmSpec`).** The `composite_*_ta` trust anchors were removed from every round.

Artifacts using these algorithms that were generated with earlier betas will be reported as failed by the current parsers. Verify them with the BC release that produced them.
