# Object Identifiers for PQC and Composite

The following are is the OID mapping to be used for the PQ in X.509 Project

Notes: 
1. Asterisk "*" means experimental; ie likely to change after the hackathon.

# FIPS 203, 204, and 205

This section provides the official OIDs assigned by NIST for FIPS 203, 204, and 205 as per:
https://csrc.nist.gov/projects/computer-security-objects-register/algorithm-registration

| Signature Algorithm Name | OID | Specification |
| ------------------------ | --- | ------------- |
| ML-DSA-44 | 2.16.840.1.101.3.4.3.17 | FIPS 204 |
| ML-DSA-65 | 2.16.840.1.101.3.4.3.18 | FIPS 204 |
| ML-DSA-87 | 2.16.840.1.101.3.4.3.19 | FIPS 204 |
| SLH-DSA-SHA2-128s  | 2.16.840.1.101.3.4.3.20 | FIPS 205 |
| SLH-DSA-SHA2-128f  | 2.16.840.1.101.3.4.3.21 | FIPS 205 |
| SLH-DSA-SHA2-192s  | 2.16.840.1.101.3.4.3.22 | FIPS 205 |
| SLH-DSA-SHA2-192f  | 2.16.840.1.101.3.4.3.23 | FIPS 205 |
| SLH-DSA-SHA2-256s  | 2.16.840.1.101.3.4.3.24 | FIPS 205 |
| SLH-DSA-SHA2-256f  | 2.16.840.1.101.3.4.3.25 | FIPS 205 |
| SLH-DSA-SHAKE-128s | 2.16.840.1.101.3.4.3.26 | FIPS 205 |
| SLH-DSA-SHAKE-128f | 2.16.840.1.101.3.4.3.27 | FIPS 205 |
| SLH-DSA-SHAKE-192s | 2.16.840.1.101.3.4.3.28 | FIPS 205 |
| SLH-DSA-SHAKE-192f | 2.16.840.1.101.3.4.3.29 | FIPS 205 |
| SLH-DSA-SHAKE-256s | 2.16.840.1.101.3.4.3.30 | FIPS 205 |
| SLH-DSA-SHAKE-256f | 2.16.840.1.101.3.4.3.31 | FIPS 205 |

This section provides the official OIDs assigned by NIST for the PRE-HASH FIPS 203 and 204 as per:
https://csrc.nist.gov/projects/computer-security-objects-register/algorithm-registration

| Signature Algorithm Name | OID | Specification | Pre - Hash |
| ------------------------ | --- | ------------- | --- |
| HASH-ML-DSA-44 | 2.16.840.1.101.3.4.3.32 | FIPS 204 | SHA-512 |
| HASH-ML-DSA-65 | 2.16.840.1.101.3.4.3.33 | FIPS 204 | SHA-512 |
| HASH-ML-DSA-87 | 2.16.840.1.101.3.4.3.34 | FIPS 204 | SHA-512 |
| HASH-SLH-DSA-SHA2-128s  | 2.16.840.1.101.3.4.3.35 | FIPS 205 | SHA-256 |
| HASH-SLH-DSA-SHA2-128f  | 2.16.840.1.101.3.4.3.36 | FIPS 205 | SHA-256 |
| HASH-SLH-DSA-SHA2-192s  | 2.16.840.1.101.3.4.3.37 | FIPS 205 | SHA-512 |
| HASH-SLH-DSA-SHA2-192f  | 2.16.840.1.101.3.4.3.38 | FIPS 205 | SHA-512 |
| HASH-SLH-DSA-SHA2-256s  | 2.16.840.1.101.3.4.3.39 | FIPS 205 | SHA-512 |
| HASH-SLH-DSA-SHA2-256f  | 2.16.840.1.101.3.4.3.40 | FIPS 205 | SHA-512 |
| HASH-SLH-DSA-SHAKE-128s | 2.16.840.1.101.3.4.3.41 | FIPS 205 | SHAKE-128 |
| HASH-SLH-DSA-SHAKE-128f | 2.16.840.1.101.3.4.3.42 | FIPS 205 | SHAKE-128 |
| HASH-SLH-DSA-SHAKE-192s | 2.16.840.1.101.3.4.3.43 | FIPS 205 | SHAKE-256 |
| HASH-SLH-DSA-SHAKE-192f | 2.16.840.1.101.3.4.3.44 | FIPS 205 | SHAKE-256 |
| HASH-SLH-DSA-SHAKE-256s | 2.16.840.1.101.3.4.3.45 | FIPS 205 | SHAKE-256 |
| HASH-SLH-DSA-SHAKE-256f | 2.16.840.1.101.3.4.3.46 | FIPS 205 | SHAKE-256 |

| KEM Algorithm Name | OID | Specification |
| -----------------  | --- | ------------- |
| ML-KEM-512  | 2.16.840.1.101.3.4.4.1 | FIPS 203 |
| ML-KEM-768  | 2.16.840.1.101.3.4.4.2 | FIPS 203 |
| ML-KEM-1024 | 2.16.840.1.101.3.4.4.3 | FIPS 203 |

## Falcon (Prototype - NIST Round 3 Finalist to be standardized)

| Signature Algorithm Name | Signature OID | Specification |
| ----------- | ----------- | ----------- |
| Falcon-512 | 1.3.9999.3.11* | NIST Round 3 -- [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| Falcon-1024 | 1.3.9999.3.14* | NIST Round 3 -- [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| Falcon-padded-512 | 1.3.9999.3.16* | NIST Round 3 -- [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| Falcon-padded-1024 | 1.3.9999.3.19* | NIST Round 3 -- [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |

Note: earlier rounds used the older OQS OIDs 1.3.9999.3.6 (Falcon-512) and 1.3.9999.3.9 (Falcon-1024).

## NTRU (Prototype - NIST Round 3)

| KEM Algorithm Name | OID |  Specification |
| ----------- | ----------- | ----------- |
| NTRUHPS2048509 | 1.3.6.1.4.1.22554.5.5.1 | NIST Round 3 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| NTRUHPS2048677 | 1.3.6.1.4.1.22554.5.5.2 | NIST Round 3 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| NTRUHPS4096821 | 1.3.6.1.4.1.22554.5.5.3 | NIST Round 3 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| NTRUHPS40961229 | 1.3.6.1.4.1.22554.5.5.5 | NIST Round 3 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| NTRUHRSS701 | 1.3.6.1.4.1.22554.5.5.4 | NIST Round 3 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| NTRUHRSS1373 | 1.3.6.1.4.1.22554.5.5.6 | NIST Round 3 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |

# Production OIDs for Composite Signatures

| Composite Algorithm Name | OID | Specification |
| ----------- | ----------- | ----------- |
| id-MLDSA44-RSA2048-PSS-SHA256 | 1.3.6.1.5.5.7.6.37 | RFC 10073 |
| id-MLDSA44-RSA2048-PKCS15-SHA256 | 1.3.6.1.5.5.7.6.38 | RFC 10073 |
| id-MLDSA44-Ed25519-SHA512 | 1.3.6.1.5.5.7.6.39 | RFC 10073 |
| id-MLDSA44-ECDSA-P256-SHA256 | 1.3.6.1.5.5.7.6.40 | RFC 10073 |
| id-MLDSA65-RSA3072-PSS-SHA512 | 1.3.6.1.5.5.7.6.41 | RFC 10073 |
| id-MLDSA65-RSA3072-PKCS15-SHA512 | 1.3.6.1.5.5.7.6.42 | RFC 10073 |
| id-MLDSA65-RSA4096-PSS-SHA512 | 1.3.6.1.5.5.7.6.43 | RFC 10073 |
| id-MLDSA65-RSA4096-PKCS15-SHA512 | 1.3.6.1.5.5.7.6.44 | RFC 10073 |
| id-MLDSA65-ECDSA-P256-SHA512 | 1.3.6.1.5.5.7.6.45 | RFC 10073 |
| id-MLDSA65-ECDSA-P384-SHA512 | 1.3.6.1.5.5.7.6.46 | RFC 10073 |
| id-MLDSA65-ECDSA-brainpoolP256r1-SHA512 | 1.3.6.1.5.5.7.6.47 | RFC 10073 |
| id-MLDSA65-Ed25519-SHA512 | 1.3.6.1.5.5.7.6.48 | RFC 10073 |
| id-MLDSA87-ECDSA-P384-SHA512 | 1.3.6.1.5.5.7.6.49 | RFC 10073 |
| id-MLDSA87-ECDSA-brainpoolP384r1-SHA512 | 1.3.6.1.5.5.7.6.50 | RFC 10073 |
| id-MLDSA87-Ed448-SHAKE256 | 1.3.6.1.5.5.7.6.51 | RFC 10073 |
| id-MLDSA87-RSA3072-PSS-SHA512 | 1.3.6.1.5.5.7.6.52 | RFC 10073 |
| id-MLDSA87-RSA4096-PSS-SHA512 | 1.3.6.1.5.5.7.6.53 | RFC 10073 |
| id-MLDSA87-ECDSA-P521-SHA512 | 1.3.6.1.5.5.7.6.54 | RFC 10073 |

# Production OIDs for Composite KEM
The following OIDs currently serve as placeholders in draft-ietf-lamps-pq-composite-kem. Final OID assignment will be handled by IANA.

| Composite Algorithm Name | OID | Specification |
| ----------- | ----------- | ----------- |
| id-MLKEM768-RSA2048-SHA3-256 | 1.3.6.1.5.5.7.6.55 |  draft-ietf-lamps-pq-composite-kem-15 |
| id-MLKEM768-RSA3072-SHA3-256 | 1.3.6.1.5.5.7.6.56 | draft-ietf-lamps-pq-composite-kem-15 |
| id-MLKEM768-RSA4096-SHA3-256 | 1.3.6.1.5.5.7.6.57 | draft-ietf-lamps-pq-composite-kem-15 |
| id-MLKEM768-X25519-SHA3-256 | 1.3.6.1.5.5.7.6.58 | draft-ietf-lamps-pq-composite-kem-15 |
| id-MLKEM768-ECDH-P256-SHA3-256 | 1.3.6.1.5.5.7.6.59 | draft-ietf-lamps-pq-composite-kem-15 |
| id-MLKEM768-ECDH-P384-SHA3-256 | 1.3.6.1.5.5.7.6.60 | draft-ietf-lamps-pq-composite-kem-15 |
| id-MLKEM768-ECDH-brainpoolP256r1-SHA3-256 | 1.3.6.1.5.5.7.6.61 | draft-ietf-lamps-pq-composite-kem-15 |
| id-MLKEM1024-RSA3072-SHA3-256 | 1.3.6.1.5.5.7.6.62 | draft-ietf-lamps-pq-composite-kem-15 |
| id-MLKEM1024-ECDH-P384-SHA3-256 | 1.3.6.1.5.5.7.6.63 | draft-ietf-lamps-pq-composite-kem-15 |
| id-MLKEM1024-ECDH-brainpoolP384r1-SHA3-256 | 1.3.6.1.5.5.7.6.64 | draft-ietf-lamps-pq-composite-kem-15 |
| id-MLKEM1024-X448-SHA3-256 | 1.3.6.1.5.5.7.6.65 | draft-ietf-lamps-pq-composite-kem-15 |
| id-MLKEM1024-ECDH-P521-SHA3-256 | 1.3.6.1.5.5.7.6.66 | draft-ietf-lamps-pq-composite-kem-15 |

# FrodoKEM Object Identifiers   
The draft-smyslov-lamps-frodokem-certificates contains the following ISO registered object Identifiers

| FrodoKEM Algorithm Name | OID | Specification |
| ----------- | ----------- | ----------- |
| id-kem-frodokem976-shake | 1.0.18033.2.2.7.1 |  draft-smyslov-lamps-frodokem-certificates |
| id-kem-frodokem1344-shake | 1.0.18033.2.2.7.2 | draft-smyslov-lamps-frodokem-certificates |
| id-kem-efrodokem976-shake | 1.0.18033.2.2.7.3 | draft-smyslov-lamps-frodokem-certificates |
| id-kem-efrodokem1344-shake | 1.0.18033.2.2.7.4 | draft-smyslov-lamps-frodokem-certificates |
| id-kem-frodokem976-aes | 1.0.18033.2.2.7.5 | draft-smyslov-lamps-frodokem-certificates |
| id-kem-frodokem1344-aes | 1.0.18033.2.2.7.6 | draft-smyslov-lamps-frodokem-certificates |
| id-kem-efrodokem976-aes | 1.0.18033.2.2.7.7 | draft-smyslov-lamps-frodokem-certificates |
| id-kem-efrodokem1344-aes | 1.0.18033.2.2.7.8 | draft-smyslov-lamps-frodokem-certificates |

# FrodoKEM Composite KEM (Prototype)
The draft-song-lamps-cms-composite-frodokem is proposing the following composite combinations, which
are not yet standardized.  The OIDs are prototype for now.

| FrodoKEM Composite Algorithm Name | OID | Specification |
| ----------- | ----------- | ----------- |
| id-FrodoKEM976-SHAKE-RSA3072-SHA3-256  | 1.3.6.1.4.1.22554.5.12.1 | draft-song-lamps-cms-composite-frodokem |
| id-FrodoKEM976-SHAKE-X25519-SHA3-256   | 1.3.6.1.4.1.22554.5.12.2 | draft-song-lamps-cms-composite-frodokem |
| id-FrodoKEM1344-SHAKE-RSA4096-SHA3-256 | 1.3.6.1.4.1.22554.5.12.3 | draft-song-lamps-cms-composite-frodokem |
| id-FrodoKEM1344-SHAKE-X448-SHA3-256    | 1.3.6.1.4.1.22554.5.12.4 | draft-song-lamps-cms-composite-frodokem |
| id-FrodoKEM976-AES-RSA3072-SHA3-256    | 1.3.6.1.4.1.22554.5.12.5 | draft-song-lamps-cms-composite-frodokem |
| id-FrodoKEM976-AES-X25519-SHA3-256     | 1.3.6.1.4.1.22554.5.12.6 | draft-song-lamps-cms-composite-frodokem |
| id-FrodoKEM1344-AES-RSA4096-SHA3-256   | 1.3.6.1.4.1.22554.5.12.7 | draft-song-lamps-cms-composite-frodokem |
| id-FrodoKEM1344-AES-X448-SHA3-256      | 1.3.6.1.4.1.22554.5.12.8 | draft-song-lamps-cms-composite-frodokem |

# Classic McEliece Object Identifiers   
The Classic McEliece Object identifers have been specified by ISO

| McEliece Algorithm Name | OID | Specification |
| ----------- | ----------- | ----------- |
| id-kem-mceliece460896 | 1.0.18033.2.2.6.1 | https://www.iso.org/standard/86890.html |
| id-kem-mceliece460896f | 1.0.18033.2.2.6.2 | https://www.iso.org/standard/86890.html |
| id-kem-mceliece460896pc | 1.0.18033.2.2.6.3 | https://www.iso.org/standard/86890.html |
| id-kem-mceliece460896pcf | 1.0.18033.2.2.6.4 | https://www.iso.org/standard/86890.html |
| id-kem-mceliece6688128 | 1.0.18033.2.2.6.5 | https://www.iso.org/standard/86890.html |
| id-kem-mceliece6688128f | 1.0.18033.2.2.6.6 | https://www.iso.org/standard/86890.html |
| id-kem-mceliece6688128pc | 1.0.18033.2.2.6.7 | https://www.iso.org/standard/86890.html |
| id-kem-mceliece6688128pcf | 1.0.18033.2.2.6.8 | https://www.iso.org/standard/86890.html |
| id-kem-mceliece6960119 | 1.0.18033.2.2.6.9 | https://www.iso.org/standard/86890.html |
| id-kem-mceliece6960119f | 1.0.18033.2.2.6.10 | https://www.iso.org/standard/86890.html |
| id-kem-mceliece6960119pc | 1.0.18033.2.2.6.11 | https://www.iso.org/standard/86890.html |
| id-kem-mceliece6960119pcf | 1.0.18033.2.2.6.12 | https://www.iso.org/standard/86890.html |
| id-kem-mceliece8192128 | 1.0.18033.2.2.6.13 | https://www.iso.org/standard/86890.html |
| id-kem-mceliece8192128f | 1.0.18033.2.2.6.14 | https://www.iso.org/standard/86890.html |
| id-kem-mceliece8192128pc | 1.0.18033.2.2.6.15 | https://www.iso.org/standard/86890.html |
| id-kem-mceliece8192128pcf | 1.0.18033.2.2.6.16 | https://www.iso.org/standard/86890.html |

# Bouncy Castle Prototype OIDs

The following algorithms do not yet have officially assigned OIDs. These are the OIDs used by [Bouncy Castle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) (BC arc `1.3.6.1.4.1.22554`; where Open Quantum Safe assigns an OID, as for MAYO and the Round 3 versions of SNOVA and MQOM, Bouncy Castle uses the OQS OID under `1.3.9999`). They are prototype OIDs and are likely to change once official OIDs are assigned. The BC identifier is the constant name in `BCObjectIdentifiers`.

The NIST additional signature OIDs end in the NIST round of the version they identify: `.2` for the Round 2 versions that bc-java main implements, `.1` for SDitH, which bc-java implements as version 1.1 (Round 1), and `.3` for the Round 3 versions. NIST announced the Round 3 candidates in May 2026 (NIST IR 8610). The Round 3 OIDs are declared in `BCObjectIdentifiers` but bc-java does not use them yet: each Round 3 implementation will use its OIDs when it replaces the earlier one. Bouncy Castle releases up to 1.87 used these OIDs without the round suffix (for example `1.3.6.1.4.1.22554.2.11.1` for SNOVA_24_5_4-SSK); bc-java still reads those but no longer writes them.

## MAYO (Prototype - NIST PQC Additional Signatures Round 2, OQS arc)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| MAYO-1 | 1.3.9999.8.1.3* | `mayo_1` |
| MAYO-2 | 1.3.9999.8.2.3* | `mayo_2` |
| MAYO-3 | 1.3.9999.8.3.3* | `mayo_3` |
| MAYO-5 | 1.3.9999.8.5.3* | `mayo_5` |

## MAYO (Prototype - NIST PQC Additional Signatures Round 3, OQS arc)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| MAYO-1 (Round 3) | 1.3.9999.8.1.5* | `mayo_1_r3` |
| MAYO-2 (Round 3) | 1.3.9999.8.2.5* | `mayo_2_r3` |
| MAYO-3 (Round 3) | 1.3.9999.8.3.5* | `mayo_3_r3` |
| MAYO-5 (Round 3) | 1.3.9999.8.5.5* | `mayo_5_r3` |

## SNOVA (Prototype - NIST PQC Additional Signatures Round 2)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| SNOVA_24_5_4-SSK | 1.3.6.1.4.1.22554.2.11.1.2* | `snova_24_5_4_ssk` |
| SNOVA_24_5_4-ESK | 1.3.6.1.4.1.22554.2.11.2.2* | `snova_24_5_4_esk` |
| SNOVA_24_5_4_SHAKE-SSK | 1.3.6.1.4.1.22554.2.11.3.2* | `snova_24_5_4_shake_ssk` |
| SNOVA_24_5_4_SHAKE-ESK | 1.3.6.1.4.1.22554.2.11.4.2* | `snova_24_5_4_shake_esk` |
| SNOVA_24_5_5-SSK | 1.3.6.1.4.1.22554.2.11.5.2* | `snova_24_5_5_ssk` |
| SNOVA_24_5_5-ESK | 1.3.6.1.4.1.22554.2.11.6.2* | `snova_24_5_5_esk` |
| SNOVA_24_5_5_SHAKE-SSK | 1.3.6.1.4.1.22554.2.11.7.2* | `snova_24_5_5_shake_ssk` |
| SNOVA_24_5_5_SHAKE-ESK | 1.3.6.1.4.1.22554.2.11.8.2* | `snova_24_5_5_shake_esk` |
| SNOVA_25_8_3-SSK | 1.3.6.1.4.1.22554.2.11.9.2* | `snova_25_8_3_ssk` |
| SNOVA_25_8_3-ESK | 1.3.6.1.4.1.22554.2.11.10.2* | `snova_25_8_3_esk` |
| SNOVA_25_8_3_SHAKE-SSK | 1.3.6.1.4.1.22554.2.11.11.2* | `snova_25_8_3_shake_ssk` |
| SNOVA_25_8_3_SHAKE-ESK | 1.3.6.1.4.1.22554.2.11.12.2* | `snova_25_8_3_shake_esk` |
| SNOVA_29_6_5-SSK | 1.3.6.1.4.1.22554.2.11.13.2* | `snova_29_6_5_ssk` |
| SNOVA_29_6_5-ESK | 1.3.6.1.4.1.22554.2.11.14.2* | `snova_29_6_5_esk` |
| SNOVA_29_6_5_SHAKE-SSK | 1.3.6.1.4.1.22554.2.11.15.2* | `snova_29_6_5_shake_ssk` |
| SNOVA_29_6_5_SHAKE-ESK | 1.3.6.1.4.1.22554.2.11.16.2* | `snova_29_6_5_shake_esk` |
| SNOVA_37_8_4-SSK | 1.3.6.1.4.1.22554.2.11.17.2* | `snova_37_8_4_ssk` |
| SNOVA_37_8_4-ESK | 1.3.6.1.4.1.22554.2.11.18.2* | `snova_37_8_4_esk` |
| SNOVA_37_8_4_SHAKE-SSK | 1.3.6.1.4.1.22554.2.11.19.2* | `snova_37_8_4_shake_ssk` |
| SNOVA_37_8_4_SHAKE-ESK | 1.3.6.1.4.1.22554.2.11.20.2* | `snova_37_8_4_shake_esk` |
| SNOVA_37_17_2-SSK | 1.3.6.1.4.1.22554.2.11.21.2* | `snova_37_17_2_ssk` |
| SNOVA_37_17_2-ESK | 1.3.6.1.4.1.22554.2.11.22.2* | `snova_37_17_2_esk` |
| SNOVA_37_17_2_SHAKE-SSK | 1.3.6.1.4.1.22554.2.11.23.2* | `snova_37_17_2_shake_ssk` |
| SNOVA_37_17_2_SHAKE-ESK | 1.3.6.1.4.1.22554.2.11.24.2* | `snova_37_17_2_shake_esk` |
| SNOVA_49_11_3-SSK | 1.3.6.1.4.1.22554.2.11.25.2* | `snova_49_11_3_ssk` |
| SNOVA_49_11_3-ESK | 1.3.6.1.4.1.22554.2.11.26.2* | `snova_49_11_3_esk` |
| SNOVA_49_11_3_SHAKE-SSK | 1.3.6.1.4.1.22554.2.11.27.2* | `snova_49_11_3_shake_ssk` |
| SNOVA_49_11_3_SHAKE-ESK | 1.3.6.1.4.1.22554.2.11.28.2* | `snova_49_11_3_shake_esk` |
| SNOVA_56_25_2-SSK | 1.3.6.1.4.1.22554.2.11.29.2* | `snova_56_25_2_ssk` |
| SNOVA_56_25_2-ESK | 1.3.6.1.4.1.22554.2.11.30.2* | `snova_56_25_2_esk` |
| SNOVA_56_25_2_SHAKE-SSK | 1.3.6.1.4.1.22554.2.11.31.2* | `snova_56_25_2_shake_ssk` |
| SNOVA_56_25_2_SHAKE-ESK | 1.3.6.1.4.1.22554.2.11.32.2* | `snova_56_25_2_shake_esk` |
| SNOVA_60_10_4-SSK | 1.3.6.1.4.1.22554.2.11.33.2* | `snova_60_10_4_ssk` |
| SNOVA_60_10_4-ESK | 1.3.6.1.4.1.22554.2.11.34.2* | `snova_60_10_4_esk` |
| SNOVA_60_10_4_SHAKE-SSK | 1.3.6.1.4.1.22554.2.11.35.2* | `snova_60_10_4_shake_ssk` |
| SNOVA_60_10_4_SHAKE-ESK | 1.3.6.1.4.1.22554.2.11.36.2* | `snova_60_10_4_shake_esk` |
| SNOVA_66_15_3-SSK | 1.3.6.1.4.1.22554.2.11.37.2* | `snova_66_15_3_ssk` |
| SNOVA_66_15_3-ESK | 1.3.6.1.4.1.22554.2.11.38.2* | `snova_66_15_3_esk` |
| SNOVA_66_15_3_SHAKE-SSK | 1.3.6.1.4.1.22554.2.11.39.2* | `snova_66_15_3_shake_ssk` |
| SNOVA_66_15_3_SHAKE-ESK | 1.3.6.1.4.1.22554.2.11.40.2* | `snova_66_15_3_shake_esk` |
| SNOVA_75_33_2-SSK | 1.3.6.1.4.1.22554.2.11.41.2* | `snova_75_33_2_ssk` |
| SNOVA_75_33_2-ESK | 1.3.6.1.4.1.22554.2.11.42.2* | `snova_75_33_2_esk` |
| SNOVA_75_33_2_SHAKE-SSK | 1.3.6.1.4.1.22554.2.11.43.2* | `snova_75_33_2_shake_ssk` |
| SNOVA_75_33_2_SHAKE-ESK | 1.3.6.1.4.1.22554.2.11.44.2* | `snova_75_33_2_shake_esk` |

## SNOVA (Prototype - NIST PQC Additional Signatures Round 3, SNOVA v3.0)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| SNOVA_I_K | 1.3.9999.10.1.3* | `snova_I_K` |
| SNOVA_I_B | 1.3.9999.10.2.3* | `snova_I_B` |
| SNOVA_I_S | 1.3.9999.10.3.3* | `snova_I_S` |
| SNOVA_III_K | 1.3.9999.10.4.3* | `snova_III_K` |
| SNOVA_III_B | 1.3.9999.10.5.3* | `snova_III_B` |
| SNOVA_III_S | 1.3.9999.10.6.3* | `snova_III_S` |
| SNOVA_V_K | 1.3.9999.10.7.3* | `snova_V_K` |
| SNOVA_V_B | 1.3.9999.10.8.3* | `snova_V_B` |
| SNOVA_V_S | 1.3.9999.10.9.3* | `snova_V_S` |
| SNOVA_I_K_AES | 1.3.6.1.4.1.22554.2.11.45.3* | `snova_I_K_aes` |
| SNOVA_I_B_AES | 1.3.6.1.4.1.22554.2.11.46.3* | `snova_I_B_aes` |
| SNOVA_I_S_AES | 1.3.6.1.4.1.22554.2.11.47.3* | `snova_I_S_aes` |
| SNOVA_III_K_AES | 1.3.6.1.4.1.22554.2.11.48.3* | `snova_III_K_aes` |
| SNOVA_III_B_AES | 1.3.6.1.4.1.22554.2.11.49.3* | `snova_III_B_aes` |
| SNOVA_III_S_AES | 1.3.6.1.4.1.22554.2.11.50.3* | `snova_III_S_aes` |
| SNOVA_V_K_AES | 1.3.6.1.4.1.22554.2.11.51.3* | `snova_V_K_aes` |
| SNOVA_V_B_AES | 1.3.6.1.4.1.22554.2.11.52.3* | `snova_V_B_aes` |
| SNOVA_V_S_AES | 1.3.6.1.4.1.22554.2.11.53.3* | `snova_V_S_aes` |

## FAEST (Prototype - NIST PQC Additional Signatures Round 2, FAEST v2.0)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| FAEST-128s | 1.3.6.1.4.1.22554.2.12.1.2* | `faest_128s` |
| FAEST-128f | 1.3.6.1.4.1.22554.2.12.2.2* | `faest_128f` |
| FAEST-192s | 1.3.6.1.4.1.22554.2.12.3.2* | `faest_192s` |
| FAEST-192f | 1.3.6.1.4.1.22554.2.12.4.2* | `faest_192f` |
| FAEST-256s | 1.3.6.1.4.1.22554.2.12.5.2* | `faest_256s` |
| FAEST-256f | 1.3.6.1.4.1.22554.2.12.6.2* | `faest_256f` |
| FAEST-EM-128s | 1.3.6.1.4.1.22554.2.12.7.2* | `faest_em_128s` |
| FAEST-EM-128f | 1.3.6.1.4.1.22554.2.12.8.2* | `faest_em_128f` |
| FAEST-EM-192s | 1.3.6.1.4.1.22554.2.12.9.2* | `faest_em_192s` |
| FAEST-EM-192f | 1.3.6.1.4.1.22554.2.12.10.2* | `faest_em_192f` |
| FAEST-EM-256s | 1.3.6.1.4.1.22554.2.12.11.2* | `faest_em_256s` |
| FAEST-EM-256f | 1.3.6.1.4.1.22554.2.12.12.2* | `faest_em_256f` |

## FAEST (Prototype - NIST PQC Additional Signatures Round 3, FAEST v3)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| FAEST-128s (Round 3) | 1.3.6.1.4.1.22554.2.12.1.3* | `faest_128s_r3` |
| FAEST-128f (Round 3) | 1.3.6.1.4.1.22554.2.12.2.3* | `faest_128f_r3` |
| FAEST-192s (Round 3) | 1.3.6.1.4.1.22554.2.12.3.3* | `faest_192s_r3` |
| FAEST-192f (Round 3) | 1.3.6.1.4.1.22554.2.12.4.3* | `faest_192f_r3` |
| FAEST-256s (Round 3) | 1.3.6.1.4.1.22554.2.12.5.3* | `faest_256s_r3` |
| FAEST-256f (Round 3) | 1.3.6.1.4.1.22554.2.12.6.3* | `faest_256f_r3` |
| FAEST-EM-128s (Round 3) | 1.3.6.1.4.1.22554.2.12.7.3* | `faest_em_128s_r3` |
| FAEST-EM-128f (Round 3) | 1.3.6.1.4.1.22554.2.12.8.3* | `faest_em_128f_r3` |
| FAEST-EM-192s (Round 3) | 1.3.6.1.4.1.22554.2.12.9.3* | `faest_em_192s_r3` |
| FAEST-EM-192f (Round 3) | 1.3.6.1.4.1.22554.2.12.10.3* | `faest_em_192f_r3` |
| FAEST-EM-256s (Round 3) | 1.3.6.1.4.1.22554.2.12.11.3* | `faest_em_256s_r3` |
| FAEST-EM-256f (Round 3) | 1.3.6.1.4.1.22554.2.12.12.3* | `faest_em_256f_r3` |

## MQOM (Prototype - NIST PQC Additional Signatures Round 2, MQOM v2.1)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| MQOM2-L1-gf2-fast-r3 | 1.3.6.1.4.1.22554.2.13.1.2* | `mqom2_cat1_gf2_fast_r3` |
| MQOM2-L1-gf2-fast-r5 | 1.3.6.1.4.1.22554.2.13.2.2* | `mqom2_cat1_gf2_fast_r5` |
| MQOM2-L1-gf2-short-r3 | 1.3.6.1.4.1.22554.2.13.3.2* | `mqom2_cat1_gf2_short_r3` |
| MQOM2-L1-gf2-short-r5 | 1.3.6.1.4.1.22554.2.13.4.2* | `mqom2_cat1_gf2_short_r5` |
| MQOM2-L1-gf16-fast-r3 | 1.3.6.1.4.1.22554.2.13.5.2* | `mqom2_cat1_gf16_fast_r3` |
| MQOM2-L1-gf16-fast-r5 | 1.3.6.1.4.1.22554.2.13.6.2* | `mqom2_cat1_gf16_fast_r5` |
| MQOM2-L1-gf16-short-r3 | 1.3.6.1.4.1.22554.2.13.7.2* | `mqom2_cat1_gf16_short_r3` |
| MQOM2-L1-gf16-short-r5 | 1.3.6.1.4.1.22554.2.13.8.2* | `mqom2_cat1_gf16_short_r5` |
| MQOM2-L1-gf256-fast-r3 | 1.3.6.1.4.1.22554.2.13.9.2* | `mqom2_cat1_gf256_fast_r3` |
| MQOM2-L1-gf256-fast-r5 | 1.3.6.1.4.1.22554.2.13.10.2* | `mqom2_cat1_gf256_fast_r5` |
| MQOM2-L1-gf256-short-r3 | 1.3.6.1.4.1.22554.2.13.11.2* | `mqom2_cat1_gf256_short_r3` |
| MQOM2-L1-gf256-short-r5 | 1.3.6.1.4.1.22554.2.13.12.2* | `mqom2_cat1_gf256_short_r5` |
| MQOM2-L3-gf2-fast-r3 | 1.3.6.1.4.1.22554.2.13.13.2* | `mqom2_cat3_gf2_fast_r3` |
| MQOM2-L3-gf2-fast-r5 | 1.3.6.1.4.1.22554.2.13.14.2* | `mqom2_cat3_gf2_fast_r5` |
| MQOM2-L3-gf2-short-r3 | 1.3.6.1.4.1.22554.2.13.15.2* | `mqom2_cat3_gf2_short_r3` |
| MQOM2-L3-gf2-short-r5 | 1.3.6.1.4.1.22554.2.13.16.2* | `mqom2_cat3_gf2_short_r5` |
| MQOM2-L3-gf16-fast-r3 | 1.3.6.1.4.1.22554.2.13.17.2* | `mqom2_cat3_gf16_fast_r3` |
| MQOM2-L3-gf16-fast-r5 | 1.3.6.1.4.1.22554.2.13.18.2* | `mqom2_cat3_gf16_fast_r5` |
| MQOM2-L3-gf16-short-r3 | 1.3.6.1.4.1.22554.2.13.19.2* | `mqom2_cat3_gf16_short_r3` |
| MQOM2-L3-gf16-short-r5 | 1.3.6.1.4.1.22554.2.13.20.2* | `mqom2_cat3_gf16_short_r5` |
| MQOM2-L3-gf256-fast-r3 | 1.3.6.1.4.1.22554.2.13.21.2* | `mqom2_cat3_gf256_fast_r3` |
| MQOM2-L3-gf256-fast-r5 | 1.3.6.1.4.1.22554.2.13.22.2* | `mqom2_cat3_gf256_fast_r5` |
| MQOM2-L3-gf256-short-r3 | 1.3.6.1.4.1.22554.2.13.23.2* | `mqom2_cat3_gf256_short_r3` |
| MQOM2-L3-gf256-short-r5 | 1.3.6.1.4.1.22554.2.13.24.2* | `mqom2_cat3_gf256_short_r5` |
| MQOM2-L5-gf2-fast-r3 | 1.3.6.1.4.1.22554.2.13.25.2* | `mqom2_cat5_gf2_fast_r3` |
| MQOM2-L5-gf2-fast-r5 | 1.3.6.1.4.1.22554.2.13.26.2* | `mqom2_cat5_gf2_fast_r5` |
| MQOM2-L5-gf2-short-r3 | 1.3.6.1.4.1.22554.2.13.27.2* | `mqom2_cat5_gf2_short_r3` |
| MQOM2-L5-gf2-short-r5 | 1.3.6.1.4.1.22554.2.13.28.2* | `mqom2_cat5_gf2_short_r5` |
| MQOM2-L5-gf16-fast-r3 | 1.3.6.1.4.1.22554.2.13.29.2* | `mqom2_cat5_gf16_fast_r3` |
| MQOM2-L5-gf16-fast-r5 | 1.3.6.1.4.1.22554.2.13.30.2* | `mqom2_cat5_gf16_fast_r5` |
| MQOM2-L5-gf16-short-r3 | 1.3.6.1.4.1.22554.2.13.31.2* | `mqom2_cat5_gf16_short_r3` |
| MQOM2-L5-gf16-short-r5 | 1.3.6.1.4.1.22554.2.13.32.2* | `mqom2_cat5_gf16_short_r5` |
| MQOM2-L5-gf256-fast-r3 | 1.3.6.1.4.1.22554.2.13.33.2* | `mqom2_cat5_gf256_fast_r3` |
| MQOM2-L5-gf256-fast-r5 | 1.3.6.1.4.1.22554.2.13.34.2* | `mqom2_cat5_gf256_fast_r5` |
| MQOM2-L5-gf256-short-r3 | 1.3.6.1.4.1.22554.2.13.35.2* | `mqom2_cat5_gf256_short_r3` |
| MQOM2-L5-gf256-short-r5 | 1.3.6.1.4.1.22554.2.13.36.2* | `mqom2_cat5_gf256_short_r5` |

## MQOM (Prototype - NIST PQC Additional Signatures Round 3, MQOM v3.0, OQS arc)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| MQOM3-L1-gf16-fast-ct | 1.3.9999.11.1.9* | `mqom3_cat1_gf16_fast_ct` |
| MQOM3-L1-gf16-fast-ot | 1.3.9999.11.1.11* | `mqom3_cat1_gf16_fast_ot` |
| MQOM3-L1-gf16-short-ct | 1.3.9999.11.1.13* | `mqom3_cat1_gf16_short_ct` |
| MQOM3-L1-gf16-short-ot | 1.3.9999.11.1.15* | `mqom3_cat1_gf16_short_ot` |
| MQOM3-L1-gf2-shorter-ct | 1.3.9999.11.1.17* | `mqom3_cat1_gf2_shorter_ct` |
| MQOM3-L1-gf2-shorter-ot | 1.3.9999.11.1.19* | `mqom3_cat1_gf2_shorter_ot` |
| MQOM3-L3-gf16-fast-ct | 1.3.9999.11.3.9* | `mqom3_cat3_gf16_fast_ct` |
| MQOM3-L3-gf16-fast-ot | 1.3.9999.11.3.11* | `mqom3_cat3_gf16_fast_ot` |
| MQOM3-L3-gf16-short-ct | 1.3.9999.11.3.13* | `mqom3_cat3_gf16_short_ct` |
| MQOM3-L3-gf16-short-ot | 1.3.9999.11.3.15* | `mqom3_cat3_gf16_short_ot` |
| MQOM3-L3-gf2-shorter-ct | 1.3.9999.11.3.17* | `mqom3_cat3_gf2_shorter_ct` |
| MQOM3-L3-gf2-shorter-ot | 1.3.9999.11.3.19* | `mqom3_cat3_gf2_shorter_ot` |
| MQOM3-L5-gf16-fast-ct | 1.3.9999.11.5.9* | `mqom3_cat5_gf16_fast_ct` |
| MQOM3-L5-gf16-fast-ot | 1.3.9999.11.5.11* | `mqom3_cat5_gf16_fast_ot` |
| MQOM3-L5-gf16-short-ct | 1.3.9999.11.5.13* | `mqom3_cat5_gf16_short_ct` |
| MQOM3-L5-gf16-short-ot | 1.3.9999.11.5.15* | `mqom3_cat5_gf16_short_ot` |
| MQOM3-L5-gf2-shorter-ct | 1.3.9999.11.5.17* | `mqom3_cat5_gf2_shorter_ct` |
| MQOM3-L5-gf2-shorter-ot | 1.3.9999.11.5.19* | `mqom3_cat5_gf2_shorter_ot` |

## UOV (Prototype - NIST PQC Additional Signatures Round 2)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| OV-Is | 1.3.6.1.4.1.22554.2.14.1.2* | `uov_Is_classic` |
| OV-Is-pkc | 1.3.6.1.4.1.22554.2.14.2.2* | `uov_Is_pkc` |
| OV-Is-pkc-skc | 1.3.6.1.4.1.22554.2.14.3.2* | `uov_Is_pkc_skc` |
| OV-Ip | 1.3.6.1.4.1.22554.2.14.4.2* | `uov_Ip_classic` |
| OV-Ip-pkc | 1.3.6.1.4.1.22554.2.14.5.2* | `uov_Ip_pkc` |
| OV-Ip-pkc-skc | 1.3.6.1.4.1.22554.2.14.6.2* | `uov_Ip_pkc_skc` |
| OV-III | 1.3.6.1.4.1.22554.2.14.7.2* | `uov_III_classic` |
| OV-III-pkc | 1.3.6.1.4.1.22554.2.14.8.2* | `uov_III_pkc` |
| OV-III-pkc-skc | 1.3.6.1.4.1.22554.2.14.9.2* | `uov_III_pkc_skc` |
| OV-V | 1.3.6.1.4.1.22554.2.14.10.2* | `uov_V_classic` |
| OV-V-pkc | 1.3.6.1.4.1.22554.2.14.11.2* | `uov_V_pkc` |
| OV-V-pkc-skc | 1.3.6.1.4.1.22554.2.14.12.2* | `uov_V_pkc_skc` |

## UOV (Prototype - NIST PQC Additional Signatures Round 3)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| OV-Is (Round 3) | 1.3.6.1.4.1.22554.2.14.1.3* | `uov_Is_classic_r3` |
| OV-Is-pkc (Round 3) | 1.3.6.1.4.1.22554.2.14.2.3* | `uov_Is_pkc_r3` |
| OV-Is-pkc-skc (Round 3) | 1.3.6.1.4.1.22554.2.14.3.3* | `uov_Is_pkc_skc_r3` |
| OV-Ip (Round 3) | 1.3.6.1.4.1.22554.2.14.4.3* | `uov_Ip_classic_r3` |
| OV-Ip-pkc (Round 3) | 1.3.6.1.4.1.22554.2.14.5.3* | `uov_Ip_pkc_r3` |
| OV-Ip-pkc-skc (Round 3) | 1.3.6.1.4.1.22554.2.14.6.3* | `uov_Ip_pkc_skc_r3` |
| OV-III (Round 3) | 1.3.6.1.4.1.22554.2.14.7.3* | `uov_III_classic_r3` |
| OV-III-pkc (Round 3) | 1.3.6.1.4.1.22554.2.14.8.3* | `uov_III_pkc_r3` |
| OV-III-pkc-skc (Round 3) | 1.3.6.1.4.1.22554.2.14.9.3* | `uov_III_pkc_skc_r3` |
| OV-V (Round 3) | 1.3.6.1.4.1.22554.2.14.10.3* | `uov_V_classic_r3` |
| OV-V-pkc (Round 3) | 1.3.6.1.4.1.22554.2.14.11.3* | `uov_V_pkc_r3` |
| OV-V-pkc-skc (Round 3) | 1.3.6.1.4.1.22554.2.14.12.3* | `uov_V_pkc_skc_r3` |

## QR-UOV (Prototype - NIST PQC Additional Signatures Round 2)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| QR-UOV-1q127L3v156m54 | 1.3.6.1.4.1.22554.2.17.1.2* | `qruov1q127L3v156m54` |
| QR-UOV-1q31L3v165m60 | 1.3.6.1.4.1.22554.2.17.2.2* | `qruov1q31L3v165m60` |
| QR-UOV-1q31L10v600m70 | 1.3.6.1.4.1.22554.2.17.3.2* | `qruov1q31L10v600m70` |
| QR-UOV-1q7L10v740m100 | 1.3.6.1.4.1.22554.2.17.4.2* | `qruov1q7L10v740m100` |
| QR-UOV-3q127L3v228m78 | 1.3.6.1.4.1.22554.2.17.5.2* | `qruov3q127L3v228m78` |
| QR-UOV-3q31L3v246m87 | 1.3.6.1.4.1.22554.2.17.6.2* | `qruov3q31L3v246m87` |
| QR-UOV-3q31L10v890m100 | 1.3.6.1.4.1.22554.2.17.7.2* | `qruov3q31L10v890m100` |
| QR-UOV-3q7L10v1100m140 | 1.3.6.1.4.1.22554.2.17.8.2* | `qruov3q7L10v1100m140` |
| QR-UOV-5q127L3v306m105 | 1.3.6.1.4.1.22554.2.17.9.2* | `qruov5q127L3v306m105` |
| QR-UOV-5q31L3v324m114 | 1.3.6.1.4.1.22554.2.17.10.2* | `qruov5q31L3v324m114` |
| QR-UOV-5q31L10v1120m120 | 1.3.6.1.4.1.22554.2.17.11.2* | `qruov5q31L10v1120m120` |
| QR-UOV-5q7L10v1490m190 | 1.3.6.1.4.1.22554.2.17.12.2* | `qruov5q7L10v1490m190` |

## QR-UOV (Prototype - NIST PQC Additional Signatures Round 3)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| QR-UOV-1q127L3v156m54 (Round 3) | 1.3.6.1.4.1.22554.2.17.1.3* | `qruov1q127L3v156m54_r3` |
| QR-UOV-1q31L3v165m60 (Round 3) | 1.3.6.1.4.1.22554.2.17.2.3* | `qruov1q31L3v165m60_r3` |
| QR-UOV-1q31L10v600m70 (Round 3) | 1.3.6.1.4.1.22554.2.17.3.3* | `qruov1q31L10v600m70_r3` |
| QR-UOV-1q7L10v740m100 (Round 3) | 1.3.6.1.4.1.22554.2.17.4.3* | `qruov1q7L10v740m100_r3` |
| QR-UOV-3q127L3v228m78 (Round 3) | 1.3.6.1.4.1.22554.2.17.5.3* | `qruov3q127L3v228m78_r3` |
| QR-UOV-3q31L3v246m87 (Round 3) | 1.3.6.1.4.1.22554.2.17.6.3* | `qruov3q31L3v246m87_r3` |
| QR-UOV-3q31L10v890m100 (Round 3) | 1.3.6.1.4.1.22554.2.17.7.3* | `qruov3q31L10v890m100_r3` |
| QR-UOV-3q7L10v1100m140 (Round 3) | 1.3.6.1.4.1.22554.2.17.8.3* | `qruov3q7L10v1100m140_r3` |
| QR-UOV-5q127L3v306m105 (Round 3) | 1.3.6.1.4.1.22554.2.17.9.3* | `qruov5q127L3v306m105_r3` |
| QR-UOV-5q31L3v324m114 (Round 3) | 1.3.6.1.4.1.22554.2.17.10.3* | `qruov5q31L3v324m114_r3` |
| QR-UOV-5q31L10v1120m120 (Round 3) | 1.3.6.1.4.1.22554.2.17.11.3* | `qruov5q31L10v1120m120_r3` |
| QR-UOV-5q7L10v1490m190 (Round 3) | 1.3.6.1.4.1.22554.2.17.12.3* | `qruov5q7L10v1490m190_r3` |
| QR-UOV-1q127L10v540m60 | 1.3.6.1.4.1.22554.2.17.13.3* | `qruov1q127L10v540m60` |
| QR-UOV-3q127L10v820m90 | 1.3.6.1.4.1.22554.2.17.14.3* | `qruov3q127L10v820m90` |
| QR-UOV-5q127L10v1040m110 | 1.3.6.1.4.1.22554.2.17.15.3* | `qruov5q127L10v1040m110` |

## SDitH (Prototype - NIST PQC Additional Signatures Round 1, SDitH v1.1)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| SDitH-hypercube-cat1-gf256 | 1.3.6.1.4.1.22554.2.16.1.1* | `sdith_hypercube_cat1_gf256` |
| SDitH-hypercube-cat3-gf256 | 1.3.6.1.4.1.22554.2.16.2.1* | `sdith_hypercube_cat3_gf256` |
| SDitH-hypercube-cat5-gf256 | 1.3.6.1.4.1.22554.2.16.3.1* | `sdith_hypercube_cat5_gf256` |
| SDitH-hypercube-cat1-p251 | 1.3.6.1.4.1.22554.2.16.4.1* | `sdith_hypercube_cat1_p251` |
| SDitH-hypercube-cat3-p251 | 1.3.6.1.4.1.22554.2.16.5.1* | `sdith_hypercube_cat3_p251` |
| SDitH-hypercube-cat5-p251 | 1.3.6.1.4.1.22554.2.16.6.1* | `sdith_hypercube_cat5_p251` |
| SDitH-threshold-cat1-gf256 | 1.3.6.1.4.1.22554.2.16.7.1* | `sdith_threshold_cat1_gf256` |
| SDitH-threshold-cat3-gf256 | 1.3.6.1.4.1.22554.2.16.8.1* | `sdith_threshold_cat3_gf256` |
| SDitH-threshold-cat5-gf256 | 1.3.6.1.4.1.22554.2.16.9.1* | `sdith_threshold_cat5_gf256` |
| SDitH-threshold-cat1-p251 | 1.3.6.1.4.1.22554.2.16.10.1* | `sdith_threshold_cat1_p251` |
| SDitH-threshold-cat3-p251 | 1.3.6.1.4.1.22554.2.16.11.1* | `sdith_threshold_cat3_p251` |
| SDitH-threshold-cat5-p251 | 1.3.6.1.4.1.22554.2.16.12.1* | `sdith_threshold_cat5_p251` |

## SDitH (Prototype - NIST PQC Additional Signatures Round 3, SDitH v3.0)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| SDitH3-L1-gf2-short | 1.3.6.1.4.1.22554.2.16.13.3* | `sdith3_L1_gf2_short` |
| SDitH3-L1-gf2-fast | 1.3.6.1.4.1.22554.2.16.14.3* | `sdith3_L1_gf2_fast` |
| SDitH3-L3-gf2-short | 1.3.6.1.4.1.22554.2.16.15.3* | `sdith3_L3_gf2_short` |
| SDitH3-L3-gf2-fast | 1.3.6.1.4.1.22554.2.16.16.3* | `sdith3_L3_gf2_fast` |
| SDitH3-L5-gf2-short | 1.3.6.1.4.1.22554.2.16.17.3* | `sdith3_L5_gf2_short` |
| SDitH3-L5-gf2-fast | 1.3.6.1.4.1.22554.2.16.18.3* | `sdith3_L5_gf2_fast` |
| SDitH3-L1-gf2-short-cipherpow | 1.3.6.1.4.1.22554.2.16.19.3* | `sdith3_L1_gf2_short_cipherpow` |
| SDitH3-L1-gf2-fast-cipherpow | 1.3.6.1.4.1.22554.2.16.20.3* | `sdith3_L1_gf2_fast_cipherpow` |
| SDitH3-L3-gf2-short-cipherpow | 1.3.6.1.4.1.22554.2.16.21.3* | `sdith3_L3_gf2_short_cipherpow` |
| SDitH3-L3-gf2-fast-cipherpow | 1.3.6.1.4.1.22554.2.16.22.3* | `sdith3_L3_gf2_fast_cipherpow` |
| SDitH3-L5-gf2-short-cipherpow | 1.3.6.1.4.1.22554.2.16.23.3* | `sdith3_L5_gf2_short_cipherpow` |
| SDitH3-L5-gf2-fast-cipherpow | 1.3.6.1.4.1.22554.2.16.24.3* | `sdith3_L5_gf2_fast_cipherpow` |

## SQIsign (Prototype - NIST PQC Additional Signatures Round 2, SQIsign v2)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| SQIsign-lvl1 | 1.3.6.1.4.1.22554.2.19.1.2* | `sqisign_lvl1` |
| SQIsign-lvl3 | 1.3.6.1.4.1.22554.2.19.2.2* | `sqisign_lvl3` |
| SQIsign-lvl5 | 1.3.6.1.4.1.22554.2.19.3.2* | `sqisign_lvl5` |

## SQIsign (Prototype - NIST PQC Additional Signatures Round 3, SQIsign v3)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| SQIsign-lvl1 (Round 3) | 1.3.6.1.4.1.22554.2.19.1.3* | `sqisign_lvl1_r3` |
| SQIsign-lvl3 (Round 3) | 1.3.6.1.4.1.22554.2.19.2.3* | `sqisign_lvl3_r3` |
| SQIsign-lvl5 (Round 3) | 1.3.6.1.4.1.22554.2.19.3.3* | `sqisign_lvl5_r3` |

## AIMer (Prototype - KpqC)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| AIMer-128f | 1.3.6.1.4.1.22554.2.20.1* | `aimer_128f` |
| AIMer-128s | 1.3.6.1.4.1.22554.2.20.2* | `aimer_128s` |
| AIMer-192f | 1.3.6.1.4.1.22554.2.20.3* | `aimer_192f` |
| AIMer-192s | 1.3.6.1.4.1.22554.2.20.4* | `aimer_192s` |
| AIMer-256f | 1.3.6.1.4.1.22554.2.20.5* | `aimer_256f` |
| AIMer-256s | 1.3.6.1.4.1.22554.2.20.6* | `aimer_256s` |

## HAETAE (Prototype - KpqC)

| Signature Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| HAETAE-2 | 1.3.6.1.4.1.22554.2.18.1* | `haetae2` |
| HAETAE-3 | 1.3.6.1.4.1.22554.2.18.2* | `haetae3` |
| HAETAE-5 | 1.3.6.1.4.1.22554.2.18.3* | `haetae5` |

## NTRU LPRime (Prototype - NIST PQC Round 3 Alternate)

| KEM Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| ntrulpr653 | 1.3.6.1.4.1.22554.5.7.1.1* | `ntrulpr653` |
| ntrulpr761 | 1.3.6.1.4.1.22554.5.7.1.2* | `ntrulpr761` |
| ntrulpr857 | 1.3.6.1.4.1.22554.5.7.1.3* | `ntrulpr857` |
| ntrulpr953 | 1.3.6.1.4.1.22554.5.7.1.4* | `ntrulpr953` |
| ntrulpr1013 | 1.3.6.1.4.1.22554.5.7.1.5* | `ntrulpr1013` |
| ntrulpr1277 | 1.3.6.1.4.1.22554.5.7.1.6* | `ntrulpr1277` |

## Streamlined NTRU Prime (Prototype - NIST PQC Round 3 Alternate)

| KEM Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| sntrup653 | 1.3.6.1.4.1.22554.5.7.2.1* | `sntrup653` |
| sntrup761 | 1.3.6.1.4.1.22554.5.7.2.2* | `sntrup761` |
| sntrup857 | 1.3.6.1.4.1.22554.5.7.2.3* | `sntrup857` |
| sntrup953 | 1.3.6.1.4.1.22554.5.7.2.4* | `sntrup953` |
| sntrup1013 | 1.3.6.1.4.1.22554.5.7.2.5* | `sntrup1013` |
| sntrup1277 | 1.3.6.1.4.1.22554.5.7.2.6* | `sntrup1277` |

## NTRU+ (Prototype - KpqC)

| KEM Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| NTRU+KEM768 | 1.3.6.1.4.1.22554.5.10.1* | `ntruplus768` |
| NTRU+KEM864 | 1.3.6.1.4.1.22554.5.10.2* | `ntruplus864` |
| NTRU+KEM1152 | 1.3.6.1.4.1.22554.5.10.3* | `ntruplus1152` |

## SMAUG-T (Prototype - KpqC)

| KEM Algorithm Name | OID | BC Identifier |
| ----------- | ----------- | ----------- |
| SMAUG-T-1 | 1.3.6.1.4.1.22554.5.11.1* | `smaugt_mode1` |
| SMAUG-T-3 | 1.3.6.1.4.1.22554.5.11.2* | `smaugt_mode3` |
| SMAUG-T-5 | 1.3.6.1.4.1.22554.5.11.3* | `smaugt_mode5` |
| SMAUG-T-TiMER | 1.3.6.1.4.1.22554.5.11.4* | `smaugt_modet` |

# Other object Identifiers needed for interoperability Testing

## Certificate Discovery prototype OIDS 
Required for testing https://datatracker.ietf.org/doc/draft-ietf-lamps-certdiscovery/06/ 

| Object ID Type | OID | Reference
| ----------- | ----------- | ----------- |
| certDiscovery | 1.3.6.1.5.5.7.48.99 | draft-ietf-lamps-certdiscovery |
| certDiscoverySelfLocation | 1.3.6.1.5.5.7.48.98 | draft-ietf-lamps-certdiscovery |
| relatedCertificateDescriptor | 1.3.6.1.5.5.7.8.99 | draft-ietf-lamps-certdiscovery |
