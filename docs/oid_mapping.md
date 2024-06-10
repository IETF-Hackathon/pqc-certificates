# Object Identifiers for PQC and Composite

The following are is the OID mapping to be used for the PQ in X.509 Project

Notes: 
1. Asterisk "*" means experimental; ie likely to change after the hackathon.

## NIST Draft Standard Algorithm OIDs

This section provides the individual OIDs for the NIST draft standard OIDs

Until we have final standard OIDs, this list will be used for interoperability 
testing of the NIST Draft standard OIDs

| Signature Algorithm Name | Signature OID | Specification |
| ----------- | ----------- | ----------- |
| ML-DSA-44-ipd | 1.3.6.1.4.1.2.267.12.4.4 | FIPS 204 (Initial Public Draft) |
| ML-DSA-65-ipd | 1.3.6.1.4.1.2.267.12.6.5 | FIPS 204 (Initial Public Draft) |
| ML-DSA-87-ipd | 1.3.6.1.4.1.2.267.12.8.7 | FIPS 204 (Initial Public Draft) |
| Falcon-512 | 1.3.9999.3.6* | NIST Round 3 -- [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| Falcon-1024 | 1.3.9999.3.9* | NIST Round 3 -- [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| SLH-DSA-SHA2-128s-ipd | 1.3.9999.6.4.16 | FIPS 205 (Initial Public Draft) |
| SLH-DSA-SHAKE-128s-ipd | 1.3.9999.6.7.16 | FIPS 205 (Initial Public Draft) |
| SLH-DSA-SHA2-128f-ipd | 1.3.9999.6.4.13 | FIPS 205 (Initial Public Draft) |
| SLH-DSA-SHAKE-128f-ipd | 1.3.9999.6.7.13 | FIPS 205 (Initial Public Draft) |
| SLH-DSA-SHA2-192s-ipd | 1.3.9999.6.5.12 | FIPS 205 (Initial Public Draft) |
| SLH-DSA-SHAKE-192s-ipd | 1.3.9999.6.8.12 | FIPS 205 (Initial Public Draft) |
| SLH-DSA-SHA2-192f-ipd | 1.3.9999.6.5.10 | FIPS 205 (Initial Public Draft) |
| SLH-DSA-SHAKE-192f-ipd | 1.3.9999.6.8.10 | FIPS 205 (Initial Public Draft) |
| SLH-DSA-SHA2-256s-ipd | 1.3.9999.6.6.12 | FIPS 205 (Initial Public Draft) |
| SLH-DSA-SHAKE-256s-ipd | 1.3.9999.6.9.12 | FIPS 205 (Initial Public Draft) |
| SLH-DSA-SHA2-256f-ipd | 1.3.9999.6.6.10 | FIPS 205 (Initial Public Draft) |
| SLH-DSA-SHAKE-256f-ipd | 1.3.9999.6.9.10 | FIPS 205 (Initial Public Draft) |

KEM Algoirthm OIDs

| KEM Algorithm Name | OID | Specification |
| ----------- | ----------- | ----------- |
| ML-KEM-512-ipd |  1.3.6.1.4.1.22554.5.6.1 | FIPS 203 (Initial Public Draft) |
| ML-KEM-768-ipd |  1.3.6.1.4.1.22554.5.6.2 | FIPS 203 (Initial Public Draft) |
| ML-KEM-1024-ipd | 1.3.6.1.4.1.22554.5.6.3 | FIPS 203 (Initial Public Draft) |

## NIST Round 4 KEM Algorithm OIDs 

This section provides the list of OIDs for composite KEMs.

| KEM Algorithm Name | OID |  Specification |
| ----------- | ----------- | ----------- |
| bike128 | 1.3.6.1.4.1.22554.5.8.1 | NIST Round 4 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| bike192 | 1.3.6.1.4.1.22554.5.8.2 | NIST Round 4 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java)  |
| bike256 | 1.3.6.1.4.1.22554.5.8.3 | NIST Round 4 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| hqc128 | 1.3.6.1.4.1.22554.5.9.1 | NIST Round 4 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| hqc192 | 1.3.6.1.4.1.22554.5.9.2 | NIST Round 4 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| hqc256 | 1.3.6.1.4.1.22554.5.9.3 | NIST Round 4 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| mceliece348864 | 1.3.6.1.4.1.22554.5.1.1 | NIST Round 4 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| mceliece460896 | 1.3.6.1.4.1.22554.5.1.3 | NIST Round 4 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| mceliece6688128 | 1.3.6.1.4.1.22554.5.1.5 | NIST Round 4 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| mceliece6960119 | 1.3.6.1.4.1.22554.5.1.7 | NIST Round 4 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| mceliece8192128 | 1.3.6.1.4.1.22554.5.1.9 | NIST Round 4 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |

# Prototype OIDs for Composite Signatures
The following OIDs currently serve as placeholders in draft-ietf-lamps-pq-composite-sigs. Final OID assignment will be handled by IANA.

| Composite Algorithm Name | OID | Specification |
| ----------- | ----------- | ----------- |
| MLDSA44-RSA2048-PSS-SHA256 | 2.16.840.1.114027.80.8.1.1 | draft-ietf-lamps-pq-composite-sigs-01 |
| MLDSA44-RSA2048-PKCS15-SHA256 | 2.16.840.1.114027.80.8.1.2 | draft-ietf-lamps-pq-composite-sigs-01 |
| MLDSA44-Ed25519-SHA512 | 2.16.840.1.114027.80.8.1.3 | draft-ietf-lamps-pq-composite-sigs-01 |
| MLDSA44-ECDSA-P256-SHA256 | 2.16.840.1.114027.80.8.1.4 | draft-ietf-lamps-pq-composite-sigs-01 |
| MLDSA44-ECDSA-brainpoolP256r1-SHA256 | 2.16.840.1.114027.80.8.1.5 | draft-ietf-lamps-pq-composite-sigs-01 |
| MLDSA65-RSA3072-PSS-SHA512 | 2.16.840.1.114027.80.8.1.6 | draft-ietf-lamps-pq-composite-sigs-01 |
| MLDSA65-RSA3072-PKCS15-SHA512 | 2.16.840.1.114027.80.8.1.7 | draft-ietf-lamps-pq-composite-sigs-01 |
| MLDSA65-ECDSA-P256-SHA512 | 2.16.840.1.114027.80.8.1.8 | draft-ietf-lamps-pq-composite-sigs-01 |
| MLDSA65-ECDSA-brainpoolP256r1-SHA512 | 2.16.840.1.114027.80.8.1.9 | draft-ietf-lamps-pq-composite-sigs-01 |
| MLDSA65-Ed25519-SHA512 | 2.16.840.1.114027.80.8.1.10 | draft-ietf-lamps-pq-composite-sigs-01 |
| MLDSA87-ECDSA-P384-SHA512 | 2.16.840.1.114027.80.8.1.11 | draft-ietf-lamps-pq-composite-sigs-01 |
| MLDSA87-ECDSA-brainpoolP384r1-SHA512 | 2.16.840.1.114027.80.8.1.12 | draft-ietf-lamps-pq-composite-sigs-01 |
| MLDSA87-Ed448-SHA512 | 2.16.840.1.114027.80.8.1.13 | draft-ietf-lamps-pq-composite-sigs-01 |

# Prototype OIDs for Composite KEM
The following OIDs currently serve as placeholders in draft-ietf-lamps-pq-composite-kem. Final OID assignment will be handled by IANA.

| Composite Algorithm Name | OID | Specification |
| ----------- | ----------- | ----------- |
| MLKEM512-ECDH-P256-KMAC128  | 2.16.840.1.114027.80.5.2.1 |  draft-ietf-lamps-pq-composite-kem-03 |
| MLKEM512-ECDH-brainpoolP256r1-KMAC128 | 2.16.840.1.114027.80.5.2.2 | draft-ietf-lamps-pq-composite-kem-03 |
| MLKEM512-X25519-KMAC128 | 2.16.840.1.114027.80.5.2.3 | draft-ietf-lamps-pq-composite-kem-03 |
| MLKEM512-RSA2048-KMAC128 | 2.16.840.1.114027.80.5.2.13 | draft-ietf-lamps-pq-composite-kem-03 |
| MLKEM512-RSA3072-KMAC128 | 2.16.840.1.114027.80.5.2.4 | draft-ietf-lamps-pq-composite-kem-03 |
| MLKEM768-ECDH-P256-KMAC256 | 2.16.840.1.114027.80.5.2.5 | draft-ietf-lamps-pq-composite-kem-03 |
| MLKEM768-ECDH-brainpoolP256r1-KMAC256 | 2.16.840.1.114027.80.5.2.6 | draft-ietf-lamps-pq-composite-kem-03 |
| MLKEM768-X25519-KMAC256 | 2.16.840.1.114027.80.5.2.7 | draft-ietf-lamps-pq-composite-kem-03 |
| MLKEM1024-ECDH-P384-KMAC256 | 2.16.840.1.114027.80.5.2.8 | draft-ietf-lamps-pq-composite-kem-03 |
| MLKEM1024-ECDH-brainpoolP384r1-KMAC256 | 2.16.840.1.114027.80.5.2.9 | draft-ietf-lamps-pq-composite-kem-03 |
| MLKEM1024-X448-KMAC256 | 2.16.840.1.114027.80.5.2.10 | draft-ounsworth-pq-composite-sigs-13 |

# Experimental and Historical OIDs
The following are historical or experimental OIDs used in this project.     

Historical document: 
* https://docs.google.com/document/d/1A2-D82du0qJjygvBuOlG8Xao3MzDYz1pRDzjT9eY6ls/edit#

Notes: 
2. ~~Strikethrough~~ means that this is a deprecated OID as it refers to an older (non-compatible) version of the algorithm spec.

## Note on naming

As of the draft NIST standards released August 24, 2023, we have the names "ML-DSA", "SLH-DSA", and "ML-KEM" to replace the names "Dilithium", "SPHINCS+", and "Kyber".  

In order to avoid confusion between prototype versions and the eventual final standard versions, this hackathon project will continue using the names "Dilithium", "SPHINCS+", and "Kyber".


## Deprecated Single-algorithm OIDs used previously

This section provides the individual OIDs used for the different algorithms.  They should no longer be used.  

Currently PQC signatures are defined for direct signing (i.e., no use of intermediary hash
function) and, therefore, the OID used for signature generation is the same as the
algorithm OID. Although this choice makes the OID to identify both a public key and a
signature, this choice reduces the number of OIDs that is needed to be defined.

The strike thru indicates algorithms that have been used by this group in the past,
but are no longer recommended for testing because of anticipated changes in the algorithms.
For example, the AES variants used in Dilithium are not expected in the final standard,
and neither are the robust variant of SPHINCS+.

| Key Algorithm Name | Signature OID | Specification |
| ----------- | ----------- | ----------- |
| ~~Dilithium2~~ | 1.3.6.1.4.1.2.267.7.4.4 | NIST Round 3 -- [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~Dilithium3~~ | 1.3.6.1.4.1.2.267.7.6.5 | NIST Round 3 -- [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~Dilithium5~~ | 1.3.6.1.4.1.2.267.7.8.7 | NIST Round 3 -- [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~DilithiumAES2~~ | ~~1.3.6.1.4.1.2.267.11.4.4~~ | [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~DilithiumAES3~~ | ~~1.3.6.1.4.1.2.267.11.6.5~~ | [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~DilithiumAES5~~ | ~~1.3.6.1.4.1.2.267.11.8.7~~ | [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~Falcon-512~~ | ~~1.3.9999.3.1~~ | NIST Round 3. [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~Falcon-1024~~ | ~~1.3.9999.3.4~~ | NIST Round 3. [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~SPHINCS+-SHA256-128f-robust~~ | ~~1.3.9999.6.4.1~~ | NIST Round 3. [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~SPHINCS+-SHA256-128f-simple~~ | ~~1.3.9999.6.4.4~~ | NIST Round 3. [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) | 
| ~~SPHINCS+-SHA256-128s-robust~~ | ~~1.3.9999.6.4.7~~ | NIST Round 3. [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~SPHINCS+-SHA256-128s-simple~~ | ~~1.3.9999.6.4.10~~ | NIST Round 3. [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~SPHINCS+-SHA256-192f-robust~~ | ~~1.3.9999.6.5.1~~ | NIST Round 3. [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~SPHINCS+-SHA256-192f-simple~~ | ~~1.3.9999.6.5.3~~ | NIST Round 3. [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~SPHINCS+-SHA256-192s-robust~~ | ~~1.3.9999.6.5.5~~ | NIST Round 3. [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~SPHINCS+-SHA256-192s-simple~~ | ~~1.3.9999.6.5.7~~ | NIST Round 3. [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~SPHINCS+-SHA256-256f-robust~~ | ~~1.3.9999.6.6.1~~ | NIST Round 3. [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~SPHINCS+-SHA256-256f-simple~~ | ~~1.3.9999.6.6.3~~ | NIST Round 3. [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~SPHINCS+-SHA256-256s-robust~~ | ~~1.3.9999.6.6.5~~ | NIST Round 3. [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |
| ~~SPHINCS+-SHA256-256s-simple~~ | ~~1.3.9999.6.6.7~~ | NIST Round 3. [OQS](https://github.com/open-quantum-safe/oqs-provider/blob/main/oqs-template/generate.yml) |

Update: The AES version of Dilithium were removed due to their exclusion from the NIST
standardization process. They replaced the SHAKE with AES and were intended only for benchmarking purposes to simulate the performance characteristics that we will see once CPU chipsets have hardware support for SHA3 the same way that they currently do for AES.

Update: The Falcon-512 and Falcon-1024 OIDs have been updated due to the updates to the
algorithm's parameters.  See draft standards OIDS at the top for the latest OIDs.

Update: The SPHINCS+ robust variants have been removed due to their drop from the NIST
standardization process.  SPHINCS+ OIDs were updated in LibOQS in May 2023 to reflect the 
algorithm changes in SPHINCS+.   Therefore, the OIDs were up-versioned in LibOQS to
prevent compatiblity issues and we have accomodated those changes here as well.

## NIST deprecated KEM OIDS

This section provides the list of OIDs for composite KEMs.

| KEM Algorithm Name | OID |  Specification |
| ----------- | ----------- | ----------- |
| ~~kyber512_aes~~ | ~~1.3.6.1.4.1.22554.5.6.4~~ |  |
| ~~kyber768_aes~~ | ~~1.3.6.1.4.1.22554.5.6.5~~ |  |
| ~~kyber1024_aes~~ | ~~1.3.6.1.4.1.22554.5.6.6~~ |  |
| ~~kyber512_shake~~ | ~~1.3.6.1.4.1.22554.5.6.7~~ |  |
| ~~kyber768_shake~~ | ~~1.3.6.1.4.1.22554.5.6.8~~ |  |
| ~~kyber1024_shake~~ | ~~1.3.6.1.4.1.22554.5.6.9~~ |  |

Update: Support for the AES version of Kyber has been removed due to its
drop from NIST standardization process. They replaced the SHAKE with AES and were intended only for benchmarking purposes to simulate the performance characteristics that we will see once CPU chipsets have hardware support for SHA3 the same way that they currently do for AES.

## NIST Round 3 KEM Algorithm OIDs

| KEM Algorithm Name | OID |  Specification |
| ----------- | ----------- | ----------- |
| NTRUHPS2048509 | 1.3.6.1.4.1.22554.5.5.1 | NIST Round 3 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| NTRUHPS2048677 | 1.3.6.1.4.1.22554.5.5.2 | NIST Round 3 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| NTRUHPS4096821 | 1.3.6.1.4.1.22554.5.5.3 | NIST Round 3 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| NTRUHPS40961229 | 1.3.6.1.4.1.22554.5.5.5 | NIST Round 3 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| NTRUHRSS701 | 1.3.6.1.4.1.22554.5.5.4 | NIST Round 3 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |
| NTRUHRSS1373 | 1.3.6.1.4.1.22554.5.5.6 | NIST Round 3 -- [BouncyCastle](https://github.com/bcgit/bc-java/blob/main/core/src/main/java/org/bouncycastle/asn1/bc/BCObjectIdentifiers.java) |


## Experimental Explicit Composite Key and Direct Signature OIDs

This section provides the OIDs associated with Explicit algorithm combinations for
Composite Keys and Composite Signatures.   
See https://datatracker.ietf.org/doc/draft-ounsworth-pq-composite-sigs/

The Algorithm OID is the same for both the Explicit Composite Key and for the
Composite Signature Algorithm. For example, when using the explicit composite key
identified by the `id-Dilithium3-RSA-PKCS15-SHA256` OID, the same OID MUST be
used to identify the signatures generated with the said key, i.e. `id-Dilithium3-RSA-PKCS15-SHA256`.

| Key Algorithm | Key and Signature OID | Specification |
| ----------- | ----------- | ----------- |
| ExplicitCompositeSignature              | 2.16.840.1.114027.80.5.1 | draft-ounsworth-pq-composite-sigs-09 |
| id-Dilithium3-RSA-PKCS15-SHA256         | 2.16.840.1.114027.80.5.1.1 | draft-ounsworth-pq-composite-sigs-09 |
| id-Dilithium3-ECDSA-P256-SHA256            | 2.16.840.1.114027.80.5.1.2 | draft-ounsworth-pq-composite-sigs-09 |
| id-Dilithium3-ECDSA-brainpoolP256r1-SHA256 | 2.16.840.1.114027.80.5.1.3 | draft-ounsworth-pq-composite-sigs-09 |
| id-Dilithium3-Ed25519                      | 2.16.840.1.114027.80.5.1.4 | draft-ounsworth-pq-composite-sigs-09 |
| id-Dilithium5-ECDSA-P384-SHA384            | 2.16.840.1.114027.80.5.1.5 | draft-ounsworth-pq-composite-sigs-09 |
| id-Dilithium5-ECDSA-brainpoolP384r1-SHA384 | 2.16.840.1.114027.80.5.1.6 | draft-ounsworth-pq-composite-sigs-09 |
| id-Dilithium5-Ed448                        | 2.16.840.1.114027.80.5.1.7 | draft-ounsworth-pq-composite-sigs-09 |
| ~~id-Falcon512-ECDSA-P256-SHA256~~         | ~~2.16.840.1.114027.80.5.1.8~~ | draft-ounsworth-pq-composite-sigs-09 |
| ~~id-Falcon512-ECDSA-brainpoolP256r1-SHA256~~  | ~~2.16.840.1.114027.80.5.1.9~~ | draft-ounsworth-pq-composite-sigs-09 |
| ~~id-Falcon512-Ed25519~~ | ~~2.16.840.1.114027.80.5.1.10~~ | draft-ounsworth-pq-composite-sigs-09 |
| id-Falcon512-ECDSA-P256-SHA256        | 2.16.840.1.114027.80.5.1.8.1 | |
| id-Falcon512-ECDSA-brainpoolP256r1-SHA256  | 2.16.840.1.114027.80.5.1.9.1 | |
| id-Falcon512-Ed25519                       | 2.16.840.1.114027.80.5.1.10.1 | |
| ~~id-SPHINCSplusSHA256128sSimple-ECDSA-P256-SHA256~~ | ~~2.16.840.1.114027.80.5.1.11~~ | draft-ounsworth-pq-composite-sigs-08 |
| ~~id-SPHINCSplusSHA256128sSimple-ECDSA-brainpoolP256r1-SHA256~~ | ~~2.16.840.1.114027.80.5.1.12~~ | draft-ounsworth-pq-composite-sigs-08 |
| ~~id-SPHINCSplusSHA256128sSimple-Ed25519~~  |~~2.16.840.1.114027.80.5.1.13~~ | draft-ounsworth-pq-composite-sigs-08 |
| id-Dilithium3-RSA-PSS-SHA256                | 2.16.840.1.114027.80.5.1.14 | draft-ounsworth-pq-composite-sigs-09 |

Update: The SPHINCS+ combinations have been removed because the need for
composite is very minimal given the conservative design of the algorithm.

Update: The Falcon512 combinations have been updated because of the changes
in the Falcon512 parameters (May 2023).

## Generic Composite Keys and Direct Signature OIDs

This section provides the OIDs associated with Generic Composite Keys and
Direct Signatures. Specifically, we define the OID for a Generic Composite
Key as follows:

| Public Key Alg Name | OID | Alias | Specification |
| ----------- | ----------- | ----------- | ----------- |
| COMPOSITE-KEY | 2.16.840.1.114027.80.4.1 | id-Composite-Key |  |
| ~~COMPOSITE~~ | ~~1.3.6.1.4.1.18227.2.1.999.1~~ | ~~id-Composite-Key~~ |  |
| ~~MULTIKEY~~ | ~~1.3.6.1.4.1.18227.2.1.999.1~~ | ~~id-Multi-Key~~ | draft-pala-klaussner-composite-kofn-00 |

Update: The MULTIKEY option has been integrated into the generic composite and does not
need a separate OID. When the optional parameter (K of N) is present, the
validation policy leverage the `K` parameter. When the key parameter is not
present, the validation is equivalent to the case where `K == N`.

Differently from the Explicit use-case, for Generic Composite Direct Signature, the
signature OID is not the same as the Key, but uses the following arc. The direct
signature OID for Composite is defined as follows:

| Algorithm Name | OID | Alias | Specification |
| ----------- | ----------- | ----------- | ----------- |
| CompositeWithNoHash | 1.3.6.1.4.1.18227.2.1 | COMPOSITE |  |

## Generic Composite and Hash-n-Sign

Generic Composite supports both signing with or without pre-hashing.

When using pre-hashing (hash-n-sign), we map the differet OIDs from
the base OID for composite (1.3.6.1.4.1.18227.2.1). By updating/replacing
the base composite OID, all supported algorithm combinations can be easily
updated to the new value.

The list of suggested hash-n-sign combinations (also supported by NIST in
informal conversation with the standardization team) are:

| Algorithm Name | OID | Alias | Specification |
| ----------- | ----------- | ----------- | ----------- |
| CompositeWithSha256 | 1.3.6.1.4.1.18227.2.1.2 | COMPOSITE-SHA256 |  |
| CompositeWithSha512 | 1.3.6.1.4.1.18227.2.1.4 | COMPOSITE-SHA512 |  |

Other supported hash-n-sign combinations are:

| Algorithm Name | OID | Alias | Specification |
| ----------- | ----------- | ----------- | ----------- |
| CompositeWithSha256 | 1.3.6.1.4.1.18227.2.1.3 | COMPOSITE-SHA384 |  |
| CompositeWithSha3at256 | 1.3.6.1.4.1.18227.2.1.5 | COMPOSITE-SHA3_256 |  |
| CompositeWithSha3at384 | 1.3.6.1.4.1.18227.2.1.6 | COMPOSITE-SHA3_384 |  |
| CompositeWithSha3at512 | 1.3.6.1.4.1.18227.2.1.7 | COMPOSITE-SHA3_512 |  |
| CompositeWithShake128 | 1.3.6.1.4.1.18227.2.1.8 | COMPOSITE-SHAKE128 |  |
| CompositeWithShake256 | 1.3.6.1.4.1.18227.2.1.9 | COMPOSITE-SHAKE256 |  |

## Hash-n-Sign PQC Signatures OIDs

Currently there is no standardize set of OIDs identified for the for hash-n-sign
paradigm. In this section we provide a tentative proposal that uses a hierarchical
structure where the base OID for DILITHIUM signatures is 1.3.6.1.4.1.18227.999.1.1
and the sub-arcs provide the OIDs with the supported hash functions. A similar
structure is used for all supported algorithms.

By changing/updating the base OID, all other OIDs can inherit the updated prefix.

An additional 'version' sub-arc can be used for each algorithm to provide versioning
of the algorithms as needed (i.e., the base OID for the DILITHIUM would be updated
to 1.3.6.1.4.1.18227.999.1.1 and the DILITHIUM-SHA256 would be changed to
1.3.6.1.4.1.18227.999.1.1.1.1).


| Alg Name | OID | Specification |
| ----------- | ----------- | ----------- |
| COMPOSITE_KEY_HASH_N_SIGN | 2.16.840.1.114027.80.4.1.2 |  |

### Dilithium2 Hash-n-Sign Algorithm Identifiers

The list of suggested hash-n-sign combinations is as follows:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm | Specification |
| ----------- | ----------- | ----------- |  ----------- | ----------- |
| Dilithium2WithSha256 | 1.3.6.1.4.1.18227.999.1.1.1 | Dilithium2 | SHA256 |  |
| Dilithium2WithSha512 | 1.3.6.1.4.1.18227.999.1.1.3 | Dilithium2 | SHA512 |  |

The full list of supported hash-n-sign combinations also comprises the following:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm | Specification |
| ----------- | ----------- | ----------- |  ----------- | ----------- |
| Dilithium2WithSha384 | 1.3.6.1.4.1.18227.999.1.1.2 | Dilithium2 | SHA384 |  |
| Dilithium2WithSha3At256 | 1.3.6.1.4.1.18227.999.1.1.4 | Dilithium2 | SHA3_256 |  |
| Dilithium2WithSha3At384 | 1.3.6.1.4.1.18227.999.1.1.5 | Dilithium2 | SHA3_384 |  |
| Dilithium2WithSha3At512 | 1.3.6.1.4.1.18227.999.1.1.6 | Dilithium2 | SHA3_512 |  |
| Dilithium2WithShake128 | 1.3.6.1.4.1.18227.999.1.1.7 | Dilithium2 | SHAKE128 |  |
| Dilithium2WithShake256 | 1.3.6.1.4.1.18227.999.1.1.8 | Dilithium2 | SHAKE256 |  |

### Dilithium3 Hash-n-Sign Algorithm Identifiers

The list of suggested hash-n-sign combinations is as follows:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm | Specification |
| ----------- | ----------- | ----------- |  ----------- | ----------- |
| Dilithium3WithSha256 | 1.3.6.1.4.1.18227.999.1.2.1 | Dilithium3 | SHA256 |  |
| Dilithium3WithSha512 | 1.3.6.1.4.1.18227.999.1.2.3 | Dilithium3 | SHA512 |  |

The full list of supported hash-n-sign combinations also comprises the following:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm | Specification |
| ----------- | ----------- | ----------- |  ----------- | ----------- |
| Dilithium3WithSha384 | 1.3.6.1.4.1.18227.999.1.2.2 | Dilithium3 | SHA384 |  |
| Dilithium3WithSha3At256 | 1.3.6.1.4.1.18227.999.1.2.4 | Dilithium3 | SHA3_256 |  |
| Dilithium3WithSha3At384 | 1.3.6.1.4.1.18227.999.1.2.5 | Dilithium3 | SHA3_384 |  |
| Dilithium3WithSha3At512 | 1.3.6.1.4.1.18227.999.1.2.6 | Dilithium3 | SHA3_512 |  |
| Dilithium3WithShake128 | 1.3.6.1.4.1.18227.999.1.2.7 | Dilithium3 | SHAKE128 |  |
| Dilithium3WithShake256 | 1.3.6.1.4.1.18227.999.1.2.8 | Dilithium3 | SHAKE256 |  |

### Dilithium5 Hash-n-Sign Algorithm Identifiers

The list of suggested hash-n-sign combinations is as follows:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm | Specification |
| ----------- | ----------- | ----------- |  ----------- | ----------- |
| Dilithium5WithSha256 | 1.3.6.1.4.1.18227.999.1.2.1 | Dilithium5 | SHA256 |  |
| Dilithium5WithSha512 | 1.3.6.1.4.1.18227.999.1.2.3 | Dilithium5 | SHA512 |  |

The full list of supported hash-n-sign combinations also comprises the following:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm | Specification |
| ----------- | ----------- | ----------- |  ----------- | ----------- |
| Dilithium5WithSha384 | 1.3.6.1.4.1.18227.999.1.2.2 | Dilithium5 | SHA384 |  |
| Dilithium5WithSha3At256 | 1.3.6.1.4.1.18227.999.1.2.4 | Dilithium5 | SHA3_256 |  |
| Dilithium5WithSha3At384 | 1.3.6.1.4.1.18227.999.1.2.5 | Dilithium5 | SHA3_384 |  |
| Dilithium5WithSha3At512 | 1.3.6.1.4.1.18227.999.1.2.6 | Dilithium5 | SHA3_512 |  |
| Dilithium5WithShake128 | 1.3.6.1.4.1.18227.999.1.2.7 | Dilithium5 | SHAKE128 |  |
| Dilithium5WithShake256 | 1.3.6.1.4.1.18227.999.1.2.8 | Dilithium5 | SHAKE256 |  |

### Falcon512 Hash-n-Sign Algorithm Identifiers

The list of suggested hash-n-sign combinations is as follows:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm | Specification |
| ----------- | ----------- | ----------- |  ----------- | ----------- |
| ~~Falcon512WithSha256~~ | ~~1.3.6.1.4.1.18227.999.2.1.1~~ | ~~Falcon512~~ | ~~SHA256~~ |  |
| ~~Falcon512WithSha512~~ | ~~1.3.6.1.4.1.18227.999.2.3.3~~ | ~~Falcon512~~ | ~~SHA512~~ |  |
| Falcon512WithSha256 | 1.3.6.1.4.1.18227.999.2.3.1.1 | Falcon512 | SHA256 |  |
| Falcon512WithSha512 | 1.3.6.1.4.1.18227.999.2.3.3.1 | Falcon512 | SHA512 |  |

The full list of supported hash-n-sign combinations also comprises the following:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm | Specification |
| ----------- | ----------- | ----------- |  ----------- | ----------- |
| ~~Falcon512WithSha384~~ | ~~1.3.6.1.4.1.18227.999.2.1.2~~ | ~~Falcon512~~ | ~~SHA384~~ |  |
| ~~Falcon512WithSha3At256~~ | ~~1.3.6.1.4.1.18227.999.2.1.4~~ | ~~Falcon512~~ | ~~SHA3_256~~ |  |
| ~~Falcon512WithSha3At384~~ | ~~1.3.6.1.4.1.18227.999.2.1.5~~ | ~~Falcon512~~ | ~~SHA3_384~~ |  |
| ~~Falcon512WithSha3At512~~ | ~~1.3.6.1.4.1.18227.999.2.1.6~~ | ~~Falcon512~~ | ~~SHA3_512~~ |  |
| ~~Falcon512WithShake128~~ | ~~1.3.6.1.4.1.18227.999.2.1.7~~ | ~~Falcon512~~ | ~~SHAKE128~~ |  |
| ~~Falcon512WithShake256~~ | ~~1.3.6.1.4.1.18227.999.2.1.8~~ | ~~Falcon512~~ | ~~SHAKE256~~ |  |
| Falcon512WithSha384 | 1.3.6.1.4.1.18227.999.2.3.2.1 | Falcon512 | SHA384 |  |
| Falcon512WithSha3At256 | 1.3.6.1.4.1.18227.999.2.3.4.1 | Falcon512 | SHA3_256 |  |
| Falcon512WithSha3At384 | 1.3.6.1.4.1.18227.999.2.3.5.1 | Falcon512 | SHA3_384 |  |
| Falcon512WithSha3At512 | 1.3.6.1.4.1.18227.999.2.3.6.1 | Falcon512 | SHA3_512 |  |
| Falcon512WithShake128 | 1.3.6.1.4.1.18227.999.2.3.7.1 | Falcon512 | SHAKE128 |  |
| Falcon512WithShake256 | 1.3.6.1.4.1.18227.999.2.3.8.1 | Falcon512 | SHAKE256 |  |

Update: The OIDs for Falcon combinations have been updated to reflect the changes
in the algorithm's parameters (May 2023)

### Falcon1024 Hash-n-Sign Algorithm Identifiers

The list of suggested hash-n-sign combinations is as follows:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm | Specification |
| ----------- | ----------- | ----------- |  ----------- | ----------- |
| ~~Falcon1024WithSha256~~ | ~~1.3.6.1.4.1.18227.999.2.2.1~~ | ~~FALCON1024-SHA256~~ |  |
| ~~Falcon1024WithSha512~~ | ~~1.3.6.1.4.1.18227.999.2.2.3~~ | ~~FALCON1024-SHA512~~ |  |
| Falcon1024WithSha256 | 1.3.6.1.4.1.18227.999.2.2.1.1 | FALCON1024-SHA256 |  |
| Falcon1024WithSha512 | 1.3.6.1.4.1.18227.999.2.2.3.1 | FALCON1024-SHA512 |  |

The full list of supported hash-n-sign combinations also comprises the following:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm | Specification |
| ----------- | ----------- | ----------- |  ----------- | ----------- |
| ~~Falcon1024WithSha384~~ | ~~1.3.6.1.4.1.18227.999.2.2.2~~ | ~~FALCON1024-SHA384~~ |  |
| ~~Falcon1024WithSha3At256~~ | ~~1.3.6.1.4.1.18227.999.2.2.4~~ | ~~FALCON1024-SHA3_256~~ |  |
| ~~Falcon1024WithSha3At384~~ | ~~1.3.6.1.4.1.18227.999.2.2.5~~ | ~~FALCON1024-SHA3_384~~ |  |
| ~~Falcon1024WithSha3At512~~ | ~~1.3.6.1.4.1.18227.999.2.2.6~~ | ~~FALCON1024-SHA3_512~~ |  |
| ~~Falcon1024WithShake128~~ | ~~1.3.6.1.4.1.18227.999.2.2.7~~ | ~~FALCON1024-SHAKE128~~ |  |
| ~~Falcon1024WithShake256~~ | ~~1.3.6.1.4.1.18227.999.2.2.8~~ | ~~FALCON1024-SHAKE256~~ |  |
| Falcon1024WithSha384 | 1.3.6.1.4.1.18227.999.2.2.2.1 | FALCON1024-SHA384 |  |
| Falcon1024WithSha3At256 | 1.3.6.1.4.1.18227.999.2.2.4.1 | FALCON1024-SHA3_256 |  |
| Falcon1024WithSha3At384 | 1.3.6.1.4.1.18227.999.2.2.5.1 | FALCON1024-SHA3_384 |  |
| Falcon1024WithSha3At512 | 1.3.6.1.4.1.18227.999.2.2.6.1 | FALCON1024-SHA3_512 |  |
| Falcon1024WithShake128 | 1.3.6.1.4.1.18227.999.2.2.7.1 | FALCON1024-SHAKE128 |  |
| Falcon1024WithShake256 | 1.3.6.1.4.1.18227.999.2.2.8.1 | FALCON1024-SHAKE256 |  |

Update: The OIDs for Falcon combinations have been updated to reflect the changes
in the algorithm's parameters (May 2023)

### SPHINCS+ Hash-n-Sign Algorithm Identifiers

Because of the characteristics of SPHINCS+, the risk associated with the algorithm,
when compared to classic ones, is low enough that the use of hybrid is not felt
as compelling as other use-cases.

Update: We removed the support for hash-n-sign for SPHINCS+.

# Other algorithm types

This is non-PQC OIDs that are used in the artifacts of included providers.
(included here to make the results table easier to read)

| Name                 | OID                         |
| -------------------- | --------------------------- |
| ecPublicKey | 1.2.840.10045.2.1 |
| prime256v1  | 1.2.840.10045.3.1.7 |
| ecdsa-with-SHA256 | 1.2.840.10045.4.3.2 |
| rsaEncryption | 1.2.840.113549.1.1.1 |
| ED448 | 1.3.101.113 |
