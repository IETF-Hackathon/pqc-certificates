# IETF Hackathon - PQC Certificates

This project provides a set of data repositories for X.509 data
structures that make use of post-quantum and composite algorithms
(classic with PQC).

This repo represents work done between IETF 115 - 123.

The various output compatibility tables produced by this project can be viewed here:

https://ietf-hackathon.github.io/pqc-certificates/

## Goals
- Adding PQ algorithm support into existing X.509 structures (keys, signatures, certificates and protocols)
- Test and interoperate with newer draft updated to support the migration to PQ 
- provide an artifact repository for interoperability testing
- Provide a comprehensive compatibility matrix to show results
- Provide feedback to the standards groups about practical usage

## Contributing and testing your artifacts
Simply upload your artifacts zip files into your own directory under `providers/`, and uploads test results CSV files into the `compatMatrices/` directory of your provider, and the github automation will:
* Validate your artifacts against the OpenQuantumSafe docker image.
* Re-build and update the results HTML pages using both the automated results, and any results CSV files that you included.
* Output artifacts, including, importantly a log file to help with debugging failures, can be found under the ACtions tab; click on the most recent run, and download the output zip. You may not be able to download this unless you are logged in to github and have permissions to this repo.

NOTE: expired certificates within the artifacts zips will show as failed against the OQS automated testing because there is no flag to `openssl verify` to ignore expiry. We recommend uploading certs with very long expiry times -- like 10 years or more -- so that they do not start failing one year from now.

Also note that for legibility, the main table is filtered to only show the "modern" set of algorithm OIDs as represented it [docs/oids.json]. Providers which do not provide any of these OIDs will not be shown.

## Folder structure of this repo

The project's directory structure is as follows:

~~~
    - main_project_dir
    - Makefile
    - docs/
    - providers/
        - provider_name_1/
            - artifacts_certs_r5.zip
            - artifacts_cms_v3.zip
            - compatMatrices
              - artifacts_certs_r5
                - prov2_prov1.csv
                - prov3_prov1.csv
                - ...
              - artifacts_cms_v3
                - prov2_prov1.csv
                - prov3_prov1.csv
                - ...
            - gen.sh
            - check.sh
            - Makefile
                - unzip, generate, verify, and cross_verify targets
        - provider_name_2
            - ...
~~~
Note that some vendors have multiple providers with artifacts. Due to automation for generating the results HTML page which takes the provider name from the directory name; please create a new top-level provider directory for each of your providers.

Where:

  * The `Makefile` provides few useful targets for generating data
    (for open-source packages) and/or validating the distributed
    artifacts. 
    
    Required targets to be supported are:
    * **unzip** - decompresses the `artifacts.zip`, if any

    * **generate** - generates the directory structure (might require
      local tools) (requires `gen.sh`)
    
    * **verify** - verifies the provided artifacts material for
      the entire provider (requires `check.sh`). The material can
      be either generated (`gen.sh`) and/or directly provided in
      the package (`artifacts.zip`)
    
    * **cross_verify** - verifiers the decompressed artifacts material
        from a different directory that is passed as the argument
        to the `check.sh` script

  * The `docs` directory contains the extended documentation related
    to this project.

  * The `providers` directory is where the core of the data is kept.
    Each provider must come with a `bin` directory where the `gen.sh`
    and `check.sh` scripts must be stored (more on this later).
    Each provider sub directory also contains one directory for each
    different implementation from the provider (if more than one),
    inside each directory, the artifacts.zip file must be present
    carrying the X.509 structures (e.g., keys, requests, certs, etc.)
    generated via the implementation. See the `Zip format` section
    for more information about its structure.

## Zip Format (R5)

### Certificates - artifacts_certs_r5.zip

Starting with artifacts for the Hackathon in March 15th, 2025

* NEW:  Private key testing for ML-DSA, SLH-DSA and ML-KEM
  * Support the seed, expanded or both ML-DSA and ML-KEM private key format
  * Support the single SLH-DSA private key format
  * To test private key formats, use this naming convention with prefix `<friendlyname>-<oid>` to match public and private keys and other related artifacts:
    * `<friendlyname>-<oid>_seed_priv.der` #private key in seed format
    * `<friendlyname>-<oid>_expandedkey_priv.der`  #private key in expanded format
    * `<friendlyname>-<oid>_both_priv.der`  #both the seed and expanded format
    * `<friendlyname>-<oid>_priv.der` #For private keys which don't have multiple formats (e.g. SLH-DSA)
  * To support testing of KEM private keys artifacts
    * `<friendlyname>-<oid>_ee.der` #certificate for a KEM public key
    * `<friendlyname>-<oid>_ciphertext.bin` #encapsulation of a shared secret
    * `<friendlyname>-<oid>_ss.bin` #decapsulation of the shared secret
    * To test, the verifier MUST decapsulate the`<friendlyname>-<oid>_ciphertext.bin` file with the private key files and the output for each decapsulation MUST match the `<friendlyname>-<oid>_ss.bin` file
  * To support testing of the Signature private keys
    * A signature MUST be produced with the private keys, and the public key from the matching certificate files `<friendlyname>-<oid>_ta.der` should be used to verify the signature.  The signature can be produced over any data.  For example, a file with the string "This is a test of signature data" could be used. 
* Only produce a self-signed certificate (TAs). 
* Only Use DER Encoding format (so that PEM encoding doesn't cause issues).
* Use a flat folder structure with filenames <friendlyname>-<oid>_ta.der
* For ML-KEM, use the the ML-DSA TA of the equivalent security level to sign a <ML-KEM_oid>_ee.der
* For hybrid certificate formats, name the file `<hybrid_format>_<oid1>_with_<oid2>_ta.der`

Within `providers/<provider_name>/[implementation_name/]`
- artifacts_certs_r5.zip
  - `<friendlyname>-<oid>_ta.der`  # self-signed cert for signature alg oids
  - `<friendlyname>-<oid>_ee.der`  # ex.: ML-KEM-512  - signed with ML-DSA-44
  - `<hybrid_format>_<oid1>_with_<oid2>_ta.der`  # ex.: catalyst_1.2.840.10045.4.3.2_with_1.3.6.1.4.1.2.267.12.4.4_ta.der

The KEM end entity certificate can be used to validate encrypted artifacts in either the CMS or CMP artifacts zips.

## Zip Format (R4)

### Certificates - artifacts_certs_r4.zip

Starting with artifacts for the NIST standards released 2024-08-13, we will use a much simpler artifact format:

* Only produce a self-signed certificate (TAs). 
* Only Use DER Encoding format (so that PEM encoding doesn't cause issues).
* Use a flat folder structure with filenames <friendlyname>-<oid>_ta.der
* For ML-KEM, use the the ML-DSA TA of the equivalent security level to sign a <ML-KEM_oid>_ee.der
* For hybrid certificate formats, name the file `<hybrid_format>_<oid1>_with_<oid2>_ta.der`

Within `providers/<provider_name>/[implementation_name/]`
- artifacts_certs_r4.zip
  - `<friendlyname>-<oid>_ta.der`  # self-signed cert for signature alg oids
  - `<friendlyname>-<oid>_ee.der`  # ex.: ML-KEM-512  - signed with ML-DSA-44
  - `<hybrid_format>_<oid1>_with_<oid2>_ta.der`  # ex.: catalyst_1.2.840.10045.4.3.2_with_1.3.6.1.4.1.2.267.12.4.4_ta.der

The KEM end entity certificate can be used to validate encrypted artifacts in either the CMS or CMP artifacts zips.

## CMS -- artifacts_cms_v3.zip

This is version 3 of the CMS artifacts format.  It may change if needs change.

Within `providers/<provider_name>/[implementation_name/]`
- artifacts_cms_v3.zip
  - `artifacts_cms_v3/` subfolder which will contain the artifacts
  - `artifacts_cms_v3/expected_plaintext.txt` # The message which was encrypted and can be compared against the decrypted artifacts.
  - `artifacts_cms_v3/ukm.txt` # The User Keying Material (UKM) included in some of the enveloped messages.
  - `artifacts_cms_v3/ta.der` # ML-DSA-44 trust anchor used to sign the end-entity certificates.
  - `artifacts_cms_v3/<friendly>-<oid>_ee.der` # The KEM certificate that the message is enveloped to.
  - `artifacts_cms_v3/<friendly>-<oid>_both_priv.der` # The private KEM key to decrypt the enveloped messages.
  - `artifacts_cms_v3/<friendly>-<oid>_kemri_ukm.der` # An Enveloped artifact using KEMRI’s UKM field and one of the MTI KDFs for the KEM algorithm.
  - `artifacts_cms_v3/<friendly>-<oid>_kemri_auth.der` # An AuthEnveloped artifact using KEMRI without UKM and one of the MTI KDFs for the KEM algorithm.
  - `artifacts_cms_v3/<friendly>-<oid>_kemri_<kdf>.der` # Enveloped artifacts using KEMRI without UKM, and the specified KDF. Implementations must provide artifacts for each of the MTI KDFs for the OID, and may provide artifacts for other KDFs.
  - `artifacts_cms_v3/<friendly>-<oid>_signed_attrs.der` # Signed artifact, with attached content and signed attributes.

#### Friendly

Per https://github.com/IETF-Hackathon/pqc-certificates/issues/96 we would like a text description of the algorithm in the artifact names to make artifacts directory listings easier to read. Stick something same in there, for example the appropriate name from [oid_mapping.md](docs/oid_mapping.md).

#### Trust Anchor

A trust anchor isn't necessary to verify the KEMRecipientInfo artifacts, but some implementations may find it useful. We're using dilithium2 at the moment since some might not have implemented ML-DSA.ipd.

#### DER vs PEM

We picked DER encoding so there's not an extra layer to mess up. You probably have a DER<->PEM re-encoding tool.

#### Encryption Algorithms

Use `id-aes<size>wrap` for KEK algorithm where `<size>` is appropriate for your `<oid>`.  Each I-D/RFC should specify this.

Use `aes-<size>-gcm` for the CEK algorithm in the `<oid>_kemri_auth.der` artifact.  Use `aes-<size>-cbc` for all others.

#### MTI KDFs

Each RFC will specify mandatory KDFs, and probably allow for others as well. You should have a `<oid>_kemri_<kdf>.der` artifact for all MTI KDFs for each KEM OID that you support.

| I-D/RFC | Algorithm | MTI KDF | `<kdf> string` |
| - | - | - | - |
| rfc5990bis | RSA-KEM | KDF3 w/ SHA-256 | id-kdf-kdf3 |
| cms-kyber | ML-KEM-512 | KMAC128-KDF\* | id-kmac128\* |
| cms-kyber | ML-KEM-768 | KMAC256-KDF\* | id-kmac256\* |
| cms-kyber | ML-KEM-1024 | KMAC256-KDF\* | id-kmac256\* |
| - | kyber512 | KMAC256-KDF\* | id-kmac128\* |
| - | kyber768 | KMAC256-KDF\* | id-kmac256\* |
| - | kyber1024 | KMAC256-KDF\* | id-kmac256\* |

\* The MTI artifacts were updated to KMAC-based KDFs in draft-ietf-lamps-cms-kyber-03.

### CMP -- artifacts_cmp.zip

CMP artifacts should be placed into a `artifacts_cmp.zip` within `providers/<provider_name>/[implementation_name/]`. We will specify the exact file format when we start to see more robust artifacts submitted.

## Old Zip Format (R2) - Deprecated and will be removed at Hackathon in November 2024

OLD -- IF YOU ARE SUBMITTING ARTIFACTS AGAINST THE NIST DRAFT SPECS AS OF 2023-08-24, THEN PLEASE USE THE R3 FORMAT ABOVE.

At the hackathon, we are all going to script our PKI toolkit to produce and read zip bundles of certs in the following format. Scripts should place data into files with the following names so that parsing scripts 

(parentheses denotes optional files)

- artifacts_r2.zip
  - artifacts/
    - alg_oid_dir/
        - ta/     # trust anchor, aka root CA, aka self-signed
            - ta.der
            - ta_priv.der
            - (*.pem)
        - ca/     # certificate authority, aka intermediate CA
            - ca.der
            - ca_priv.der
            - (*.pem)
        - ee/     # end entity
            - cert.der
            - cert_priv.der    # corresponding private key
            - cert.csr
            - (*.pem)
        - (crl/)
            - crl_ta.crl
            - crl_ca.crl
        - (ocsp/)
            - ocsp.der           /* R1 */
            - (ocsp_ca.der)      /* R2 */
            - (ocsp_cert.der)    /* R2 */

NOTE: The OCSP filename has changed from R1 (ocsp.der) to R2 (ocsp_ca.der)
      amd ocsp_cert.der for the OCSP responses for the Intermediate CA and
      the EE certificate.

## OIDs

The OID mappings to be used for this hackathon are documented in [oid_mapping.md](docs/oid_mapping.md).

## Unzipping Artifacts

The repository comes with a Makefile that is meant to ease and automate
the operations for unzipping, generating, and validating the artifacts
provided.

To accommodate for different options from different providers, there
are three primary targets for the Makefile:

  * `unzip` - Uncompresses all the artifacts archives from all the
    providers, if present;

  * `gen` - Generates new artifacts in all providers who support this
    option. In order to generate the artifacts you need to have all
    the requirements for the provider satisfied. Please refer to the
    provider directory's readme.md or the docs directory for further
    details; Providers that wish to provide the generation option are
    required to provide the `gen.sh` script in their directory.

  * `verify` - Verifies the presence and validity of the artifacts
    for the individual providers. Providers that wish to provide the
    functionality they are required to provide the `check.sh` script.

  * `cross_verify` - Runs the verify scripts from each provider by
    using the material from a different provider. Providers that wish
    to provide this functionality must provide the `check.sh` script
    for 

Specifically, to unzip all the artifacts from all the providers, simply
use the following:
```
$ make unzip
```

To run the verify for all the providers:
```
$ make verify
```

To run the verify from a single provider, simply change the directory
to the specific provider and run the same command:

```
$ cd providers/<provider_name>
$ make verify
```

# Interoperability Results

Instructions for documenting each provider's compatibility test results can be found in [compat_matrix_intructions.md](docs/compat_matrix_instructions.md).

