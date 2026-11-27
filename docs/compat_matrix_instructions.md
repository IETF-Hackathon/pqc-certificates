# PQC Interoperability Matrix Generation

This tool parses interoperability results files and creates Markdown-based
tables.

For the R5 certificate and CMS v3 formats, CI builds the result pages from the committed CSVs and
publishes them on https://ietf-hackathon.github.io/pqc-certificates/; the pages are not committed. Just
commit your CSVs.

Results count only while they are current: the last column of a result file, `zip_sha256`, gives the SHA-256 of
the producer's zip that was verified (`sha256sum artifacts_certs_r5.zip`: 64 hex digits, in either case, the same in
every row), and the results are current while it is the SHA-256 of the producer's zip as it is now, your own zip
included. When a producer updates its zip, earlier results for it are stale and are left out of the Results by
Algorithm section until the verifier submits new ones. To fix a result file, verify the producer's current zip
again and submit the new results; do not edit the file in place (to correct its header or its name, say) unless
it still has the results of the zip its `zip_sha256` names.

Result files submitted before the `zip_sha256` column was added are judged by git instead, until they are
replaced: such a file is current if it, or any other result file in the same directory, was committed with or
after the current version of the zip it verifies. The directory counts because results that come out the same
when a verifier re-runs its tests leave the file unchanged, with nothing to commit. New and changed result files
must have the `zip_sha256` column.

The verifier scoreboard at the top of each page ranks each verifier by the share of current tests of its *implemented
algorithms* (those in its own zip and any others it has reported results for), counting every test of those
algorithms from every producer, and shows how many algorithms that is and its share of all tests on the page.
A test is a row any verifier has reported whose artifact is in the producer's current zip: a `seed` test needs a
`_seed_priv.der`, a `cert` test a `_ta.der` or `_ee.der`, and a `consistent` test a private key and either a
certificate or another private key, so results for a file the zip does not have (or no longer has) are not counted.
Only the key forms an algorithm takes count: `_seed_priv.der`, `_expandedkey_priv.der` and `_both_priv.der` for the
algorithms in `docs/choice_oids.txt`, `_priv.der` for the others; a key named for the other kind is not a test.
It also lists the stale result files. The producer table below it shows, for each producer, how many other
verifiers have current results for its zip and how many of those results pass. It is not a ranking: how many
verifiers test a zip is not up to its producer.

Each name in the verifier scoreboard or the producer table links to that implementation's summary at the bottom
of the page. As a verifier:
its results by producer, the tests it has not run yet (by algorithm), its failures and where it disagrees with
the other verifiers, and problems with its result files. As a producer: which of its tests fail and for which
verifiers, the tests no other verifier has a current result for, the algorithms in its zip that no one has
reported on, and problems with its zip. Where the conformance checker (`src/test_artifacts_conformance.py`)
has run, as it does in CI, the producer table and summaries also show which of a producer's artifacts fail
its checks, and mark the failing tests whose artifact does. In CI, each producer's summary also links to its
summary on the automated results page, where the CI verifiers test every producer's current zip: that page has
the same producer table and summaries, but no verifier scoreboard, since the same verifiers run on every zip and
their results are never stale.

A result file is named `<producer>_<verifier>.csv`, with a lower-case `.csv`, where the producer is the name of
its directory under `providers/`; names may use only letters, digits, `.` and `-` (and `_` in the verifier). It
must be UTF-8 text. Spaces around the column names and values are ignored, results may be in either case, and if
a test is reported more than once, the worst result is used (a failure over a warning over a pass). A file that is
not UTF-8, or whose header does not have the columns of its format, or with a row that has a different number of
values than the header has columns, is not read.

A result file goes in its verifier's directory, `providers/<verifier>/compatMatrices/<format>/`. A file in another
verifier's directory, or that is not read, is left out of the page, and the verifier's summary says why; a zip
that cannot be read is listed at the top of the page, and its producer's summary says so.

CI checks the result files and zips a pull request adds or changes for these problems: errors (a file that is not
read, including one whose `zip_sha256` is not 64 hex digits or is not the same in every row, a header that is not
the full header of its format ending with `zip_sha256`, a producer with no zip by that name, even in a file with no
results, a file name that is not `<producer>_<verifier>.csv`, a zip that cannot be read or is in a directory whose
name is not a valid producer name) fail the check, and warnings (rows with characters not allowed in their algorithm
or type, rows reported twice, algorithms that are not in the producer's zip or not in `docs/oid_mapping.md`, tests
whose artifact is not in the producer's zip, a `zip_sha256` that is not that of the producer's current zip) are
shown on the files.

A changed zip is also checked for the names and layout of its artifacts, but not their contents (the conformance
checker, `src/test_artifacts_conformance.py`, checks those in CI): a file that looks like a misnamed artifact
(`_seed.der` for `_seed_priv.der`, say), a private key named for the other kind of algorithm (`_priv.der` for an
algorithm in `docs/choice_oids.txt`, which takes `_seed_priv.der`, `_expandedkey_priv.der` or `_both_priv.der`,
or one of those for any other algorithm; in `artifacts_cms_v3.zip`, private keys without a `_priv.der`), an
artifact that is not `.der` (`.bin` for `_ciphertext` and `_ss`), two files for the same artifact, or a CMS
artifact outside `artifacts_cms_v3/` is an error; other files (`.DS_Store`, say), artifacts in more than one
folder, missing files that keep an artifact from being tested, and OIDs that are not in `docs/oid_mapping.md`
are warnings. To check your files before you submit them, run
`src/check_result_files.py <files>` from the repository root (with your zips too, if you changed them), or
`src/check_result_files.py --all` for every result file and zip (which does not hold the files submitted before
`zip_sha256` was added to it).

To preview the pages locally, run `src/rebuild_results_certs_r5.sh --local` or
`src/rebuild_results_cms_v3.sh --local` from the repository root, in a clone with the full git history.
They write to `docs/`, where git ignores them. A result file without `zip_sha256` counts as current there if its
directory has uncommitted changes.

The `rebuild_results.sh` script compiles the results of the earlier formats.

## The interoperability results format R5

Results for the R5 *certs* tests should be placed in
`providers/<provider_name>/compatMatrices/artifacts_certs_r5/<producer>_<consumer>.csv`.
Because there in this format there can be multiple files for each OID (up to
three private key formats, a certificate, and for ML-KEM possible ciphertext
and shared secret), there is a `type` column, and the last column, `zip_sha256`,
gives the SHA-256 of the producer's `artifacts_certs_r5.zip` that was verified
(see above). For example, the results for ML-DSA-44 and SLH-DSA-SHA2-128s might be:

```
key_algorithm_oid,type,test_result,zip_sha256
2.16.840.1.101.3.4.3.17,cert,Y,9f2c...e41a
2.16.840.1.101.3.4.3.17,seed,Y,9f2c...e41a
2.16.840.1.101.3.4.3.17,expandedkey,Y,9f2c...e41a
2.16.840.1.101.3.4.3.17,both,Y,9f2c...e41a
2.16.840.1.101.3.4.3.17,consistent,Y,9f2c...e41a
2.16.840.1.101.3.4.3.20,priv,Y,9f2c...e41a
2.16.840.1.101.3.4.3.20,cert,Y,9f2c...e41a
```

(`9f2c...e41a` stands for the 64 hex digits of the SHA-256.)

The `type` column takes the following values (a type may use only letters, digits, `_` and `-`; rows with
other characters are left out of the results):

- cert
    - The TA certificate (ML-DSA or SLH-DSA) had a valid self-signature, or
    - The ML-KEM EE certificate had a valid signature, by the associated ML-DSA TA.
- priv
    - The single SLH-DSA private key form was well formed.
    - A signature made with the private key can be verified with the
      corresponding public key.
- seed
    - The seed form of an ML-DSA or ML-KEM private key form was well formed.
    - A signature made with that ML-DSA private key can be verified with the
      corresponding public key.
    - The encapsulation ciphertext provided for that ML-KEM OID decapsulates
      via the seed-only key to a shared secret identical with the provided
      shared secret.
- expandedkey
    - The expanded key form of an ML-DSA or ML-KEM private key form was well
      formed.
    - A signature made with that ML-DSA private key can be verified with the
      corresponding public key.
    - The encapsulation ciphertext provided for that ML-KEM OID decapsulates
      via the expanded key to a shared secret identical with the provided
      shared secret.
- both
    - The seed plus expanded key (both) form of an ML-DSA or ML-KEM private key
      form was well formed.
    - A signature made with that ML-DSA private key can be verified with the
      corresponding public key.
    - The encapsulation ciphertext provided for that ML-KEM OID decapsulates
      via the seed plus expanded key form to a shared secret identical with the
      provided shared secret.
- consistent
    - All the private key forms yield the same public key form, that is also
      the public key in the certificate.
    - This test is not applicable if only a certificate and no keys, or only
      one key and no certificate is provided.

## The interoperability results format CMS v3

Results for the CMS v3 tests should be placed in
`providers/<provider_name>/compatMatrices/artifacts_cms_v3/<producer>_<consumer>.csv`, with a row per OID and
no `type` column: `key_algorithm_oid`, `test_result` (as in R3, below), then `zip_sha256`, the SHA-256 of the
producer's `artifacts_cms_v3.zip` that was verified (see above). For example:

```
key_algorithm_oid,test_result,zip_sha256
2.16.840.1.101.3.4.4.1,Y,0b7d...93c2
2.16.840.1.101.3.4.4.2,N,0b7d...93c2
```

## The interoperability results format R3

This is simplified relative to the R2 format.

Results should be placed in `providers/<provider_name>/compatMatrices/<zip_name>/<producer>_<consumer>.csv`.

The header line for the result file has the following columns:

`key_algorithm_oid`, `test_result`

The `key_algorithm_oid` contains the OID contained in the SPKI for the given algorithm. The `test_result` column
contains whether verification of the the specific artifact was successful, failed, or wasn't performed. Successful
verifications are denoted with `Y`. Failures are denoted with `N`, and verifications that weren't performed are
denoted by the empty string(``).

For example, a result file `X_Y.csv` for implementation Y verifying X's Dilithium2 artifacts will have the following
content:

```
key_algorithm_oid,test_result
1.3.6.1.4.1.2.267.7.4.4,Y
```

## The interoperability results format R2

Interoperability result files are CSV-formatted. JSON support is planned. The result files should be placed in your
provider's dir in a compatMatrices/ subdir. The file names have the following format: `PRODUCER_CONSUMER.csv`, where
`PRODUCER` is the name of the implementation that generated the artifacts, and `CONSUMER` is the name of the
implementation that verified the artifacts.

The header line for the result file has the following columns:

`key_algorithm_oid`, `ta`, `ca`, `ee`, `crl_ta`, `crl_ca`

The `key_algorithm_oid` contains the OID contained in the SPKI for the given algorithm.

The other columns contain whether verification of the the specific artifact was successful, failed, or wasn't
performed. Successful verifications are denoted with `Y`. Failures are denoted with `N`, and verifications that
weren't performed are denoted by the empty string(``).

For example, a result file `X_Y.csv` for implementation Y verifying X's Dilithium2 artifacts will have the following
content:

```
key_algorithm_oid,ta,ca,ee,crl_ta,crl_ca
1.3.6.1.4.1.2.267.7.4.4,Y,Y,,,
```

In this example, the root and ICA signatures validated, but the end-entity certificate, root CRL, and intermediate
CRL were not evaluated.

## Setup

1. Install Python 3
2. Install [mdutils](https://github.com/didix21/mdutils): `pip3 install -r requirements.txt`
3. `apt install pandoc` (for `rebuild_results.sh`).

## Execution

Run `python3 pqc_report_writer.py OID_MAPPING_FILE FILES`, where:

* `OID_MAPPING_FILE` is the file that contains the mapping of OIDs to their long names
* `FILES` is the list of result files

The resulting Markdown file will be output to `pqc_hackathon_results.md`.

The script `rebuild_results.sh` includes calling pqc_report_writer.py, so you can just use that.
