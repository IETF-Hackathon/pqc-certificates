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
  offers ML-KEM-768 and ML-KEM-1024 only (no ML-KEM-512).

Generating ML-KEM artifacts is therefore out of scope, but ML-KEM-768 and
ML-KEM-1024 artifacts from other providers can be checked (see below).

## How to run

From `providers/go-crypto` (needs Go 1.27.3, and `which`; `unzip` for the
`unzip` target):

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

In any zip, whatever folder the files are in. Files are found by name suffix;
files that are not for one of the OIDs below are ignored, and so are
`external_`, `catalyst_` and `chameleon_` files. The CI's skip for KEM EE files
does not take effect, so our result can differ from the CI's where a provider
ships both a plain and a hybrid-prefixed EE for the same OID.

ML-DSA-44/65/87:

- `seed`, `expandedkey`, `both`: the key parses, signs a test message, and the
  signature verifies under the public key of the TA.
- `cert`: the TA's self-signature verifies. This row is the self-signature
  only: the CA flag and keyUsage are not checked (a missing CA flag or
  keyCertSign is a `strict` finding, with no row). In our test with OpenSSL
  3.5.9, `openssl verify -check_ss_sig` rejected a self-signed CA certificate
  whose keyUsage was digitalSignature only (error 32, key usage does not
  include certificate signing); this checker would still say Y for it. No
  trust anchor in the repository at the time of writing is a CA certificate
  with a keyUsage that lacks keyCertSign.
- `consistent`: a key that parsed has the same public key as the TA. When no
  private key parsed there is no `consistent` row at all. The CI script
  writes a `consistent` row whenever any of the three key files is present
  (`N` if OpenSSL fails on any of them), so it has rows here that this
  checker does not, including `N` rows for malformed key files.

ML-KEM-768 and ML-KEM-1024:

- `seed`: the private key is exactly the seed-only PKCS#8 form (version 0,
  the algorithm OID with no parameters, a 64-byte seed). Go decapsulates
  `_ciphertext.bin` with it and the result must equal `_ss.bin`.
- `cert`: the end-entity certificate parses, its SubjectPublicKeyInfo has the
  right OID without parameters, and `crypto/mlkem` accepts the key and
  encapsulates to it. The EE signature is not part of this row.
- `consistent`: the seed key's encapsulation key equals the EE's public key.
- Separately, the EE signature is checked against the same generator's TA at
  the same level (768 with ML-DSA-65, 1024 with ML-DSA-87). That never makes a
  row; a failure, or a missing TA, is a `strict` finding.

A row is written only for a check that ran; what Go cannot check is recorded
as a `cannot-run` finding, with no row:

- ML-DSA expanded and both keys: `x509.ParsePKCS8PrivateKey` answers "not
  supported" for these forms. A file that fails to parse for any other reason
  (truncated, not PKCS#8, wrong algorithm) is `N`.
- An ML-DSA key that parsed when the zip has no trust anchor for that OID.
- ML-KEM expanded and both keys, and everything for ML-KEM-512 (keys and EE).
- A KEM seed key with no `_ciphertext.bin` or `_ss.bin`, and `consistent`
  when there is no EE.

A present file that is malformed for a check Go can run is `N`. A generator
with no rows gets no CSV.
