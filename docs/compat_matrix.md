# This document shows cross-compatibility testing results

Rows are producers (ie artifact zips in this repo).
Columns are parsers

<<<<<<< HEAD
| -               | Red Hound                                                                                        | Kris (PQShield)                                                                           | Entrust | [DigiCert Python](https://github.com/cbonnell/snakefoot)                             | Openssl-OQS                                                                           | BouncyCastle | LibPKI |
| --------------- | ------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------- | ------- | ------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------- | ------------ | ------ |
| carl_redhound   | Y                                                                                                |                                                                                           |         | All artifacts successfully verify including generic and explicit composite           | "Could not read cert etc. of certificate file from ca/ca.pem" and dilithiumAES errors |              |        |
| entrust         | self-signed TAs verify, paths did not due to negative serial numbers                             |                                                                                           | Y       | Cannot verify due to use of PEM files                                                | Y                                                                                     |              |        |
| oqs-openssl111  | self-signed TAs verify, paths did not due to missing basicConstraints                            | self-signed TAs verify. for EE I get "error 24 at 1 depth lookup: invalid CA certificate" |         | Y                                                                                    | Y                                                                                     | TBD          |
| oqs-oqsprovider | self-signed TAs verify, paths did not due to missing basicConstraints                            | self-signed TAs verify. for EE I get "error 24 at 1 depth lookup: invalid CA certificate" | Y       | Y                                                                                    | Y                                                                                     | TBD          |
| kris            | self-signed Dilithium TAs verify (Falcon did not), paths did not due to missing basicConstraints | Y                                                                                         |         | (Y) errors on Falcon 512 + 1024                                                      | "error 20 at 0 depth lookup: unable to get local issuer certificate"                  |              |        |
| corey_snakefoot | Y - self-signed TAs verify, paths verify (including revocation checking with CRLs)               | Y                                                                                         |         | Y                                                                                    | (Y) errors on dilithium3+5                                                            |              |        |
| bc              | Fail on composites                                                                               | Fail on Falcon                                                                            | Y       | Cannot verify due to use of PEM files                                                | Y                                                                                     |              |        |
=======


| - | Red Hound | Kris (PQShield) | Entrust | DigiCert Python | Openssl-OQS | BouncyCastle | LibPKI | AWS-LC |
| - | --------- | -------- | ------- | --------------- | ----------- | ------------ | ------------ | ------------ |
| carl_redhound/artifacts.zip | Y | | Y | | "Could not read cert etc. of certificate file from ca/ca.pem" and dilithiumAES errors |  |  |
| entrust/artifacts.zip | self-signed TAs verify, paths did not due to negative serial numbers | | Y | | Y | |  |
| oqs-openssl111/artifacts.zip | self-signed TAs verify, paths did not due to missing basicConstraints | self-signed TAs verify. for EE I get "error 24 at 1 depth lookup: invalid CA certificate" | | | Y | TBD |  |
| oqs-oqsprovider/artifacts.zip | self-signed TAs verify, paths did not due to missing basicConstraints | self-signed TAs verify. for EE I get "error 24 at 1 depth lookup: invalid CA certificate" | Y | | Y | TBD |  |
| kris/artifacts.zip | self-signed Dilithium TAs verify (Falcon did not), paths did not due to missing basicConstraints | Y | | (Y) errors on Falcon 512 + 1024 | "error 20 at 0 depth lookup: unable to get local issuer certificate" | |  |  |
| corey_snakefood/artifacts.zip | Y - self-signed TAs verify, paths verify (including revocation checking with CRLs) | Y | | Y | (Y) errors on dilithium3+5 | |  |  |
| bc/artifacts.zip | Fail on composites | Fail on Falcon | Y |  | Y | | |  |
>>>>>>> 66f21694a263be314fe08dbb0ceda88f6b9de1ae
