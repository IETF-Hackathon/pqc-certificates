# IETF 115 Hackathon - PQC Certificates

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
            - bin/
                - gen.sh
                - check.sh
        - provider_name_2
            - implementation_name_1
            - ...
~~~

Where:

  * The `Makefile` provides few useful targets for generating data
    (for open-source packages) and/or validating the distributed
    artifacts.

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
    - \<alg oid\>
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

The OID mappings to be used for this hackathon are documented in `docs/oid_mapping.md`.