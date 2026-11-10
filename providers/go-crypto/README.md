# go-crypto

Artifacts and checks built only from the Go 1.27.3 standard library
(`crypto/mldsa`, `crypto/x509`, `crypto/rand`, `archive/zip`, ...). The Go
module is `pqccerts/gocrypto` in `src/` and has no dependencies.

## What it produces

`artifacts_certs_r5.zip` holds, for ML-DSA-44, ML-DSA-65 and ML-DSA-87 only:

- `<friendly>-<oid>_ta.der`: a self-signed trust anchor;
- `<friendly>-<oid>_seed_priv.der`: the seed-form PKCS#8 private key.

It does not produce expanded-key or both-form private keys, ML-KEM keys,
ML-KEM end-entity certificates, ciphertexts or shared secrets. Why:

- `x509.MarshalPKCS8PrivateKey` writes ML-DSA keys in seed form only, and
  `x509.ParsePKCS8PrivateKey` rejects the expanded and the both forms
  ("semi-expanded ML-DSA private keys without seed are not supported",
  "ML-DSA private keys with both seed and expanded key are not supported").
- `crypto/x509` has no ML-KEM key support in 1.27.3. `ParsePKCS8PrivateKey`
  fails with "unknown algorithm" on an ML-KEM key, `MarshalPKCS8PrivateKey`
  and `MarshalPKIXPublicKey` reject `crypto/mlkem` keys, and
  `ParseCertificate` accepts a certificate with an ML-KEM public key but leaves
  `PublicKeyAlgorithm` unknown and `PublicKey` nil. `crypto/mlkem` itself
  offers ML-KEM-768 and ML-KEM-1024 only.
- `crypto/mlkem` has no ML-KEM-512.

## How to run

From `providers/go-crypto` (needs Go 1.27.3; `unzip` for the `unzip` target):

    make test          # go test ./... in src/
    make generate      # rewrites artifacts_certs_r5.zip (new random keys)
    make verify        # checks our zip, writes
                       #   compatMatrices/artifacts_certs_r5/go-crypto_go-crypto.csv
    make cross_verify  # checks every other providers/*/artifacts_certs_r5.zip,
                       #   writes compatMatrices/artifacts_certs_r5/<provider>_go-crypto.csv
                       #   here; findings go to logs/cross_verify_findings.jsonl
    make unzip         # extracts the zip into artifacts_certs_r5/ (git-ignored)

`./gen.sh` and `./check.sh [<provider-dir>|<zip>]` are what `generate` and
`verify` call.

## What the checker does

For the three ML-DSA OIDs only, in any zip, whatever folder the files are in:

- `seed`, `expandedkey`, `both`: the key parses, signs a test message, and the
  signature verifies under the public key of the TA.
- `cert`: the TA's self-signature verifies.
- `consistent`: a key that parsed has the same public key as the TA.

A row is written only for a check that ran. Go cannot parse the expanded and
both forms, so those produce no row; each such file is noted in the findings
instead. A file that is present but malformed is `N`. A generator with no rows
gets no CSV.
