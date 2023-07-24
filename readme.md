# IETF 115/116 Hackathon - PQC Certificates

This project provides a set of data repositories for X.509 data
structures that make use of post-quantum and composite algorithms
(classic with PQC).

## Folder structure of this repo

The project's directory structure is as follows:

~~~
    - main_project_dir
    - Makefile
    - docs/
    - providers/
        - provider_name_1/
            - implementation_name_1/
                - artifacts.zip
            - implementation_name_2/
                - artifacts.zip
            - compatMatrices
                - prov2_prov1.csv
                - prov3_prov1.csv
                - ...
            - gen.sh
            - check.sh
            - Makefile
                - unzip, generate, verify, and cross_verify targets
        - provider_name_2
            - implementation_name_1
            - ...
~~~

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

## Zip format (R2)

At the hackathon, we are all going to script our PKI toolkit to produce and read zip bundles of certs in the following format. Scripts should place data into files with the following names so that parsing scripts 

(parentheses denotes optional files)

- artifacts.zip
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

Interop results are documented in [compat_matrix.md](docs/compat_matrix.md).
