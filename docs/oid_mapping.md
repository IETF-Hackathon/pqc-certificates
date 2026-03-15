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
| Falcon-512 | 1.3.9999* | NIST Round 3 -- [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| Falcon-1024 | 1.3.9999.3.9* | NIST Round 3 -- [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |

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
| id-MLDSA44-RSA2048-PSS-SHA256 | 1.3.6.1.5.5.7.6.37 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA44-RSA2048-PKCS15-SHA256 | 1.3.6.1.5.5.7.6.38 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA44-Ed25519-SHA512 | 1.3.6.1.5.5.7.6.39 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA44-ECDSA-P256-SHA256 | 1.3.6.1.5.5.7.6.40 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA65-RSA3072-PSS-SHA512 | 1.3.6.1.5.5.7.6.41 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA65-RSA3072-PKCS15-SHA512 | 1.3.6.1.5.5.7.6.42 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA65-RSA4096-PSS-SHA512 | 1.3.6.1.5.5.7.6.43 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA65-RSA4096-PKCS15-SHA512 | 1.3.6.1.5.5.7.6.44 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA65-ECDSA-P256-SHA512 | 1.3.6.1.5.5.7.6.45 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA65-ECDSA-P384-SHA512 | 1.3.6.1.5.5.7.6.46 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA65-ECDSA-brainpoolP256r1-SHA512 | 1.3.6.1.5.5.7.6.47 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA65-Ed25519-SHA512 | 1.3.6.1.5.5.7.6.48 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA87-ECDSA-P384-SHA512 | 1.3.6.1.5.5.7.6.49 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA87-ECDSA-brainpoolP384r1-SHA512 | 1.3.6.1.5.5.7.6.50 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA87-Ed448-SHAKE256 | 1.3.6.1.5.5.7.6.51 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA87-RSA3072-PSS-SHA512 | 1.3.6.1.5.5.7.6.52 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA87-RSA4096-PSS-SHA512 | 1.3.6.1.5.5.7.6.53 | draft-ietf-lamps-pq-composite-sigs-12 |
| id-MLDSA87-ECDSA-P521-SHA512 | 1.3.6.1.5.5.7.6.54 | draft-ietf-lamps-pq-composite-sigs-12 |

# Production OIDs for Composite KEM
The following OIDs currently serve as placeholders in draft-ietf-lamps-pq-composite-kem. Final OID assignment will be handled by IANA.

| Composite Algorithm Name | OID | Specification |
| ----------- | ----------- | ----------- |
| id-MLKEM768-RSA2048-SHA3-256 | 1.3.6.1.5.5.7.6.55 |  draft-ietf-lamps-pq-composite-kem-12 |
| id-MLKEM768-RSA3072-SHA3-256 | 1.3.6.1.5.5.7.6.56 | draft-ietf-lamps-pq-composite-kem-12 |
| id-MLKEM768-RSA4096-SHA3-256 | 1.3.6.1.5.5.7.6.57 | draft-ietf-lamps-pq-composite-kem-12 |
| id-MLKEM768-X25519-SHA3-256 | 1.3.6.1.5.5.7.6.58 | draft-ietf-lamps-pq-composite-kem-12 |
| id-MLKEM768-ECDH-P256-SHA3-256 | 1.3.6.1.5.5.7.6.59 | draft-ietf-lamps-pq-composite-kem-12 |
| id-MLKEM768-ECDH-P384-SHA3-256 | 1.3.6.1.5.5.7.6.60 | draft-ietf-lamps-pq-composite-kem-12 |
| id-MLKEM768-ECDH-brainpoolP256r1-SHA3-256 | 1.3.6.1.5.5.7.6.61 | draft-ietf-lamps-pq-composite-kem-12 |
| id-MLKEM1024-RSA3072-SHA3-256 | 1.3.6.1.5.5.7.6.62 | draft-ietf-lamps-pq-composite-kem-12 |
| id-MLKEM1024-ECDH-P384-SHA3-256 | 1.3.6.1.5.5.7.6.63 | draft-ietf-lamps-pq-composite-kem-12 |
| id-MLKEM1024-ECDH-brainpoolP384r1-SHA3-256 | 1.3.6.1.5.5.7.6.64 | draft-ietf-lamps-pq-composite-kem-12 |
| id-MLKEM1024-X448-SHA3-256 | 1.3.6.1.5.5.7.6.65 | draft-ietf-lamps-pq-composite-kem-12 |
| id-MLKEM1024-ECDH-P521-SHA3-256 | 1.3.6.1.5.5.7.6.66 | draft-ietf-lamps-pq-composite-kem-12 |
