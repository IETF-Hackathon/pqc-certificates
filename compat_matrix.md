# This document shows cross-compatibility testing results

Rows are producers (ie artifact zips in this repo).
Columns are parsers



| - | Red Hound | PQShield | Entrust | DigiCert Python | Openssl-OQS | BouncyCastle |
| - | --------- | -------- | ------- | --------------- | ----------- | ------------ |
| carl_redhound/artifacts.zip | Y | | | | | |
| entrust/artifacts.zip | | | Y | | Y | |
| oqs-openssl111/artifacts.zip | | | | | Y |
| oqs-oqsprovider/artifacts.zip | | | | | Y |
| kris/artifacts.zip | | | | | | |
| corey_snakefood/arifacts.zip | | | | | (Y) errors on dilithium3+5 | |
