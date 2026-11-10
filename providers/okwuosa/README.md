# okwuosa

CIRCL v1.6.5 for ML-DSA and ML-KEM; X.509 and PKCS#8 built by hand with Go encoding/asn1

The Go module is `pqccerts/okwuosa` in `src/` (Go 1.27). Its only
dependency is `github.com/cloudflare/circl` v1.6.5 (plus `golang.org/x/sys`,
which CIRCL needs). The certificates and the private key files are written
and read byte by byte in `src/internal/der`; there is no `crypto/x509`,
`crypto/mldsa` or `crypto/mlkem` in the non-test code.

## What it produces

`artifacts_certs_r5.zip` is flat and holds 30 files, one set per algorithm
(ML-DSA-44, ML-DSA-65, ML-DSA-87, ML-KEM-512, ML-KEM-768, ML-KEM-1024):

- ML-DSA, 3 each:
  - `<friendly>-<oid>_ta.der`: a self-signed trust anchor (CA:TRUE,
    keyUsage keyCertSign and cRLSign, subjectKeyIdentifier);
  - `<friendly>-<oid>_seed_priv.der`, `_expandedkey_priv.der`,
    `_both_priv.der`: the same key in the three PKCS#8 forms of RFC 9881.
- ML-KEM, 3 each:
  - `<friendly>-<oid>_ee.der`: an end-entity certificate, signed by the
    ML-DSA trust anchor of the matching level (ML-KEM-512 by ML-DSA-44,
    ML-KEM-768 by ML-DSA-65, ML-KEM-1024 by ML-DSA-87);
  - `_seed_priv.der`, `_expandedkey_priv.der`, `_both_priv.der`: the key in
    the three PKCS#8 forms of RFC 9935;
  - `_ciphertext.bin` and `_ss.bin`: a ciphertext encapsulated to that key and
    the shared secret.

The signature algorithm identifier has its parameters absent. Subject and
issuer are `CN=<friendly> TA` or `CN=<friendly> EE` with `O=okwuosa`. Each
signature is a pure ML-DSA signature with an empty context. Every run uses new
random keys and serial numbers.

## How to run

From `providers/okwuosa` (needs Go 1.27 and `which`; `unzip` for the `unzip`
target):

    make test          # go test ./... in src/
    make generate      # rewrites artifacts_certs_r5.zip (new random keys)
    make verify        # checks our zip, writes
                       #   compatMatrices/artifacts_certs_r5/okwuosa_okwuosa.csv
    make cross_verify  # checks every other providers/*/artifacts_certs_r5.zip,
                       #   writes compatMatrices/artifacts_certs_r5/<provider>_okwuosa.csv
                       #   here; findings go to logs/cross_verify_findings.jsonl
    make unzip         # extracts the zip into artifacts_certs_r5/ (git-ignored)

`./gen.sh` and `./check.sh [<provider-dir>|<zip>]` are what `generate` and
`verify` call.

## What the checker does

In any zip, whatever folder the files are in. Files are found by name suffix;
files that are not for one of the six OIDs are ignored, and so are
`external_`, `catalyst_` and `chameleon_` files. The CI skips those for trust
anchors but its skip for KEM end-entity files does not take effect, so our
result can differ from the CI's where a provider ships both a plain and a
hybrid-prefixed EE for the same OID.

The private key forms follow what the CI forces with
`-provparam ...input_formats=`: `seed` must be exactly the seed-only form,
`expandedkey` exactly the expanded-only form, `both` exactly the both form
with a seed that regenerates the expanded key.

ML-DSA-44/65/87:

- `seed`, `expandedkey`, `both`: the key loads, signs the CI's test message,
  and the signature verifies under the public key of the TA.
- `cert`: the TA is self-issued and its self-signature verifies. The CA flag
  and keyUsage are not looked at, because `openssl verify -check_ss_sig`
  accepts a TA without them.
- `consistent`: the public key derived from each key file equals the TA's.
  There is one row per OID: `N` if any key file fails, `Y` if at least one
  passes and none fails.

ML-KEM-512/768/1024:

- `seed`, `expandedkey`, `both`: the key loads and decapsulates
  `_ciphertext.bin` to a secret equal to `_ss.bin`. An expanded key must also
  pass an encapsulate/decapsulate round trip with the key it contains.
- `cert`: the end-entity certificate parses and its SubjectPublicKeyInfo is a
  well-formed encapsulation key of the right parameter set to which an
  encapsulation succeeds. The EE signature is not part of this row.
- `consistent`: the public key derived from each key file equals the EE's
  public key (one row per OID, folded as for ML-DSA).
- Separately, the EE signature is checked against the same generator's TA at
  the same level. That never makes a row; a failure, or a missing TA, is a
  `strict` finding.

A row is written only for a check that ran. What it cannot run is recorded as
a `cannot-run` finding, with no row:

- an ML-DSA key with no TA in the zip;
- a TA whose public key is not an ML-DSA key (no `cert` row);
- a KEM key with no `_ciphertext.bin` or `_ss.bin`, and a KEM `consistent`
  check with no EE.

A present file that is malformed for a check that can run is `N`. A TA that
does not parse gives `N` for `cert`, for each ML-DSA key and for `consistent`;
an EE that does not parse gives `N` for `cert` and `consistent`. Private keys
may be PKCS#8 version 0 or version 1 (with the optional attributes and public
key), as OpenSSL accepts them. An expanded ML-DSA key is checked by signing with it, so a wrong `t0`
is caught only if it breaks that signature. A generator with no rows gets no
CSV. Findings other than `strict` and `cannot-run` (`failed`) say why a row
is `N`.
