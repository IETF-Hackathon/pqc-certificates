# This document shows cross-compatibility testing results

Rows are producers (ie artifact zips in this repo).
Columns are parsers



| - | Red Hound | PQShield | Entrust | DigiCert Python | Openssl-OQS | BouncyCastle |
| - | --------- | -------- | ------- | --------------- | ----------- | ------------ |
| carl_redhound/artifacts.zip | Y | | | | "Could not read cert etc. of certificate file from ca/ca.pem" and dilithiumAES errors |
| entrust/artifacts.zip | | | Y | | Y | |
| oqs-openssl111/artifacts.zip | | | | | Y |
| oqs-oqsprovider/artifacts.zip | | | | | Y |
| kris/artifacts.zip | | | | | "error 20 at 0 depth lookup: unable to get local issuer certificate" | |
| corey_snakefood/artifacts.zip | | | | | (Y) errors on dilithium3+5 | |
