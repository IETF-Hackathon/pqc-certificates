# This document shows cross-compatibility testing results

Rows are producers (ie artifact zips in this repo).
Columns are parsers



| - | Red Hound | Kris | Entrust | DigiCert Python | Openssl-OQS | BouncyCastle |
| - | --------- | -------- | ------- | --------------- | ----------- | ------------ |
| carl_redhound/artifacts.zip | Y | | Y | | "Could not read cert etc. of certificate file from ca/ca.pem" and dilithiumAES errors |
| entrust/artifacts.zip | self-signed TAs verify, paths did not due to negative serial numbers | | Y | | Y | |
| oqs-openssl111/artifacts.zip | self-signed TAs verify, paths did not due to missing basicConstraints | | | | Y |
| oqs-oqsprovider/artifacts.zip | self-signed TAs verify, paths did not due to missing basicConstraints | | Y | | Y |
| kris/artifacts.zip | self-signed Dilithium TAs verify (Falcon did not), paths did not due to missing basicConstraints | | | (Y) errors on Falcon 512 + 1024 | | "error 20 at 0 depth lookup: unable to get local issuer certificate" | |
| corey_snakefood/artifacts.zip | Y - self-signed TAs verify, paths verify (including revocation checking with CRLs) | | | Y | (Y) errors on dilithium3+5 | |
