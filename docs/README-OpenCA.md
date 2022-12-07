# OpenCA - LibPKI

The OpenCA's LibPKI provides its own implementations for few algorithms
via a dynamic ASN1 / PKEY method that is added at startup time.

The LibPKI uses the following set of OIDs for Composite and MultiKey:

  * 

The LibPKI uses the following set of OIDs for OQS implementations:

The LibPKI also supports the OQS OIDs.


# LibPKI CC Compatibility Matrices (Composite Crypto)

For the compatibility matrix for composite cryptography, we generate
both classic and post-quantum combinations as well as generic classic
with classic combinations (e.g., RSA + EC) to provide CC (Composite
Crypto) specific tests that do not require the use of post-quantum
algorithms.

## Generic Composite Crypto Keys (Not Explicit)

### Entrust (Dec 5, 2022)

| Product   | Key        | Sig             | Key Load/Use   | Sigs Load/Verify |
| --------- | ---------- | --------------- | -------------- | ---------------- |
| Entrust   | COMPOSITE  | COMPOSITE-NULL  | Yes (20221206) | n/a              |
| Entrust   | MULTIKEY   | MULTIKEY-NULL   | n/a            | n/a              |

## Explicit Composite Crypto Keys (Not Generic)

| Product   | Key                           | Sig             | Key Load/Use   | Sigs Load/Verify |
| --------- | ----------------------------- | --------------- | -------------- | ---------------- |
| Entrust   | id-Dilithium3-ECDSA-P256      | TBD             | Y (20221206)   | n/a              | 
| Entrust   | id-Dilithium3-RSA             | TBD             | n/a            | n/a              |
| Entrust   | id-Falcon512-ECDSA-P256       | TBD             | n/a            | n/a              |
| Entrust   | id-Falcon512-Ed25519          | TBD             | n/a            | n/a              |
| Entrust   | id-Dilithium5-Falcon1024-ECDSA-P521 | TBD       | n/a            | n/a              |
| Entrust   | id-Dilithium5-Falcon1024-RSA  | TBD             | n/a            | n/a              |
| Entrust   | id-SPHINCS256_256f-RSA        | TBD             | n/a            | n/a              |
| Entrust   | entrust-Algorithm-ExplicitCompositeKEMKEY | TBD | n/a            | n/a              |

## Generic Composite Crypto Hash-n-Sign

### Entrust (Dec 5, 2022)

| Product   | Key        | Sig                | Key Load/Use | Sigs Load/Verify |
| --------- | ---------- | ------------------ | ------------ | ---------------- |
| Entrust   | COMPOSITE  | COMPOSITE-SHA256   | n/a          | n/a              |
| Entrust   | COMPOSITE  | COMPOSITE-SHA384   | n/a          | n/a              |
| Entrust   | COMPOSITE  | COMPOSITE-SHA512   | n/a          | n/a              |
| Entrust   | COMPOSITE  | COMPOSITE-SHA3_256 | n/a          | n/a              |
| Entrust   | COMPOSITE  | COMPOSITE-SHA3_384 | n/a          | n/a              |
| Entrust   | COMPOSITE  | COMPOSITE-SHA3_512 | n/a          | n/a              |
| Entrust   | COMPOSITE  | COMPOSITE-SHAKE128 | n/a          | n/a              |
| Entrust   | COMPOSITE  | COMPOSITE-SHAKE256 | n/a          | n/a              |

## Explicit Composite Crypto Direct signing

### Entrust (Dec 5, 2022)

| Product   | Key        | Sig             | Key Load/Use | Sigs Load/Verify |
| --------- | ---------- | --------------- | ------------ | ---------------- |
| Entrust   | COMPOSITE  | COMPOSITE-NULL  | Yes          | n/a              |
| Entrust   | MULTIKEY   | MULTIKEY-NULL   | n/a          | n/a              |
| Entrust   | id-Dilithium3-ECDSA-P256 | id-Dilithium3-ECDSA-P256 | n/a | n/a |
| Entrust   | id-Dilithium3-RSA | id-Dilithium3-RSA | n/a | n/a |
| Entrust   | id-Falcon512-ECDSA-P256 | id-Falcon512-ECDSA-P256 | n/a | n/a |
| Entrust   | id-Falcon512-Ed25519 | id-Falcon512-Ed25519 | n/a | n/a |
| Entrust   | id-Dilithium5-Falcon1024-ECDSA-P521 | id-Dilithium5-Falcon1024-ECDSA-P521 | n/a | n/a |
| Entrust   | id-Dilithium5-Falcon1024-RSA | id-Dilithium5-Falcon1024-RSA | n/a | n/a |
| Entrust   | id-SPHINCS256_256f_robust+-ECDSA-P256 | id-SPHINCS256_256f_robust+-ECDSA-P256 | n/a | n/a |
| Entrust   | id-SPHINCS256_256f+-RSA | id-SPHINCS256_256f+-RSA | n/a | n/a |
| Entrust   | entrust-Algorithm-ExplicitCompositeKEMKEY | entrust-Algorithm-ExplicitCompositeKEMKEY | n/a | n/a |

## Explicit Composite Crypto Hash-n-Sign paradigm

TBD.

# LibPKI PQC Compatibility Matrices (Post Quantum)

## PQC Direct signing paradigm

### Entrust

| Product   | Key        | Sig          | Key Load/Use | Sigs Load/Verify |
| --------- | ---------- | ------------ | ------------ | ---------------- |
| Entrust   | Dilithium3 | Dilithium3   | Yes          | n/a              |
| Entrust   | Dilithium5 | Dilithium5   | Yes          | n/a              |
| Entrust   | Falcon512  | Falcon512    | Yes          | n/a              |
| Entrust   | Falcon1024 | Falcon1024   | Yes          | n/a              |

### Open Quantum Safe - OpenSSL 1.1.1x

| Product   | Key        | Sig          | Key Load/Use | Sigs Load/Verify |
| --------- | ---------- | ------------ | ------------ | ---------------- |
| OQS (v1)  | Dilithium3 | Dilithium3   | Yes          | n/a              |
| OQS (v1)  | Dilithium5 | Dilithium5   | Yes          | n/a              |
| OQS (v1)  | Falcon512  | Falcon512    | Yes          | n/a              |
| OQS (v1)  | Falcon1024 | Falcon1024   | Yes          | n/a              |

### Open Quantum Safe - OpenSSL 3.x.x

| Product   | Key        | Sig          | Key Load/Use | Sigs Load/Verify |
| --------- | ---------- | ------------ | ------------ | ---------------- |
| OQS (v3)  | dilithium3 | dilithium3   | Yes          | n/a              |
| OQS (v3)  | dilithium5 | dilithium5   | Yes          | n/a              |
| OQS (v3)  | Falcon512  | Falcon512    | Yes          | n/a              |
| OQS (v3)  | Falcon1024 | Falcon1024   | Yes          | n/a              |

### DigiCert - Java Artifacts

| Product   | Key        | Sig          | Key Load/Use   | Sigs Load/Verify |
| --------- | ---------- | ------------ | -------------- | ---------------- |
| bc/java   | dilithium3 | dilithium3   | No (20221206)  | n/a              |
| bc/java   | dilithium5 | dilithium5   | No (20221206)  | n/a              |
| bc/java   | falcon512  | falcon512    | No (20221206)  | n/a              |
| bc/java   | falcon1024 | falcon1024   | No (20221206)  | n/a              |

## Hash-n-Sign Paradigm

| Product   | Key        | Sig          | Key Load/Use | Sigs Load/Verify |
| --------- | ---------- | ------------ | ------------ | ---------------- |
| OQS (v1)  | Dilithium3 | Dilithium3   | Yes          | Yes              |
| OQS (v1)  | Dilithium5 | Dilithium5   | Yes          | Yes              |
| OQS (v1)  | Falcon512  | Falcon512    | Yes          | Yes              |
| OQS (v1)  | Falcon1024 | Falcon1024   | Yes          | Yes              |