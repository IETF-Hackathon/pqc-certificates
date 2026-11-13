# okwuosa

CIRCL v1.6.5 for ML-DSA and ML-KEM; X.509 and PKCS#8 built by hand with Go encoding/asn1.
The checker also verifies eFrodoKEM artifacts of other providers (go-frodokem v1.0.2).

The Go module is `pqccerts/okwuosa` in `src/` (`go 1.27` in `go.mod`; built
and tested with Go 1.27.3). It depends on
`github.com/cloudflare/circl` v1.6.5 (plus `golang.org/x/sys`, which CIRCL
needs) for ML-DSA and ML-KEM, and on `github.com/kuking/go-frodokem` v1.0.2
(plus `golang.org/x/crypto`, for SHAKE) for the eFrodoKEM checks only. See
"eFrodoKEM" below for what is known about that library. The certificates and the private key files are written
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

From `providers/okwuosa` (needs Go 1.27 or newer and `which`; `unzip` for the
`unzip` and `all` targets):

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
files that are not for one of the six OIDs or the eight FrodoKEM OIDs are
ignored, and so are
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
- `cert`: the TA is self-issued and its self-signature verifies. This row is
  the self-signature only: the CA flag and keyUsage are not checked. In our
  test with OpenSSL 3.5.9, `openssl verify -check_ss_sig` rejected a
  self-signed CA certificate whose keyUsage was digitalSignature only
  (error 32, key usage does not include certificate signing); this checker
  would still say Y for it. No trust anchor in the repository at the time of
  writing is a CA certificate with a keyUsage that lacks keyCertSign.
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
key), as OpenSSL accepts them. An expanded ML-DSA key is checked by signing
with it, so a wrong `t0` is caught only if it breaks that signature.
Certificate extensions are not parsed: nothing after the SubjectPublicKeyInfo
inside the TBSCertificate is interpreted, so malformed or unknown critical
extensions are not detected. Bytes after signatureValue inside the
Certificate SEQUENCE make the certificate unparseable, so `N`; bytes after
the SEQUENCE are a `strict` finding only. A generator with no rows
gets no CSV. Findings other than `strict` and `cannot-run` (`failed`) say why
a row is `N`.

## eFrodoKEM

The checker verifies the four eFrodoKEM parameter sets with ISO OIDs
(`docs/oid_mapping.md`): eFrodoKEM-976-SHAKE (`1.0.18033.2.2.7.3`),
eFrodoKEM-1344-SHAKE (`.7.4`), eFrodoKEM-976-AES (`.7.7`) and
eFrodoKEM-1344-AES (`.7.8`). This provider generates no FrodoKEM artifacts, so
our own zip and CSV are unchanged.

Rows, from the files `<name>-<oid>_priv.der`, `_ee.der`, `_ciphertext.bin` and
`_ss.bin`:

- `priv`: the file is a PKCS#8 structure for that OID whose privateKey holds
  one OCTET STRING of the secret key length (31296 bytes for 976, 43088 for
  1344), and decapsulating `_ciphertext.bin` with it gives `_ss.bin`.
- `cert`: the end-entity certificate parses, its SubjectPublicKeyInfo names
  the OID and holds a public key of the right length (15632 or 21520 bytes),
  and an encapsulation to it succeeds. The EE signature is not part of this
  row.
- `consistent`: the public key stored inside the secret key equals the
  certificate's.
- Separately, if the EE is signed with ML-DSA-44, -65 or -87, its signature is
  checked against that TA in the same zip; a failure or a missing TA is a
  `strict` finding and never a row.

The key and certificate layout is the one found in the artifacts of the two
providers that ship FrodoKEM at the time of writing (bc and cryptonext). It
was not checked against draft-smyslov-lamps-frodokem-certificates.

The four salted FrodoKEM OIDs (`.7.1`, `.7.2`, `.7.5`, `.7.6`) are not
checked: the library has no salted FrodoKEM. Where a zip holds such a key or
certificate there is a `cannot-run` finding and no row.

About the library: `github.com/kuking/go-frodokem` is pure Go, MIT licensed,
and implements FrodoKEM as submitted to round 3 of the NIST process, which is
what the ISO OIDs call eFrodoKEM. Its last release, v1.0.2, is from 2021. Its
README says it passes the reference known-answer tests; we did not run those.
What we ran: it decapsulates the eight eFrodoKEM ciphertexts of bc and
cryptonext to their shared secrets (`go test ./...` in `src/`). It makes no
constant-time claim that we rely on; the checker only handles test keys.
