# Object Identifiers for PQC and Composite

The following are is the OID mapping to be used for the hackathon.

Taken from: 
* https://docs.google.com/document/d/1A2-D82du0qJjygvBuOlG8Xao3MzDYz1pRDzjT9eY6ls/edit#

Note: asterisk "*" means experimental; ie likely to change after the hackathon.

# Single-algorithm OIDs

This section provides the individual OIDs used for the different algorithms. Notice
that the same OID is often used in the single algorithm non-hash signatures.

| Algorithm Name | OID | Signature Algorithm |
| ----------- | ----------- | ----------- |
| RSA | 1.2.840.113549.1.1.1 | SHA256withRSA, SHA384withRSA, SHA512withRSA |
| ECDSA |  1.2.840.10045.2.1 | SHA256withEC, SHA384withEC, SHA512withEC |
| Dilithium2 | 1.3.6.1.4.1.2.267.7.4.4* | Dilithium2 |
| Dilithium3 | 1.3.6.1.4.1.2.267.7.6.5* | Dilithium3 |
| Dilithium5 | 1.3.6.1.4.1.2.267.7.8.7* | Dilithium5 |
| DilithiumAES2 | 1.3.6.1.4.1.2.267.11.4.4* | Dilithium2-AES |
| DilithiumAES3 | 1.3.6.1.4.1.2.267.11.6.5* | Dilithium3-AES |
| DilithiumAES5 | 1.3.6.1.4.1.2.267.11.8.7* | Dilithium5-AES |
| Falcon-512 | 1.3.9999.3.1* | Falcon-512 |
| Falcon-1024 | 1.3.9999.3.4* | Falcon-1024 |
| SPHINCS+-SHA256-128f-robust | 1.3.9999.6.4.1* | SPHINCS+-SHA256-128f-robust |
| SPHINCS+-SHA256-128f-simple | 1.3.9999.6.4.4* | SPHINCS+-SHA256-128f-simple |
| SPHINCS+-SHA256-128s-robust | 1.3.9999.6.4.7* | SPHINCS+-SHA256-128s-robust |
| SPHINCS+-SHA256-128s-simple | 1.3.9999.6.4.10* | SPHINCS+-SHA256-128s-simple |
| SPHINCS+-SHA256-192f-robust | 1.3.9999.6.5.1* | SPHINCS+-SHA256-192f-robust |
| SPHINCS+-SHA256-192f-simple | 1.3.9999.6.5.3* | SPHINCS+-SHA256-192f-simple |
| SPHINCS+-SHA256-192s-robust | 1.3.9999.6.5.5 | SPHINCS+-SHA256-192s-robust |
| SPHINCS+-SHA256-192s-simple | 1.3.9999.6.5.7* | SPHINCS+-SHA256-192s-simple |
| SPHINCS+-SHA256-256f-robust | 1.3.9999.6.6.1* | SPHINCS+-SHA256-256f-robust |
| SPHINCS+-SHA256-256f-simple | 1.3.9999.6.6.3* | SPHINCS+-SHA256-256f-simple |
| SPHINCS+-SHA256-256s-robust | 1.3.9999.6.6.5* | SPHINCS+-SHA256-256s-robust |
| SPHINCS+-SHA256-256s-simple | 1.3.9999.6.6.7* | SPHINCS+-SHA256-256s-simple |


# Composite Keys OIDs

The Composite paradigm works with two different sets of OIDs. The first set is
the one related to the generic composite where the component keys are not
pre-determined by the OID (generic), and a second set where the component keys
are explicitly associated with the OID (explicit).

## Generic Composite Keys OIDs

This section provides the OIDs associated with Generic Composite Keys

| Algorithm Name | OID | Signature Algorithm |
| ----------- | ----------- | ----------- |
| COMPOSITE-KEY | 2.16.840.1.114027.80.4.1 | COMPOSITE-KEY |
| COMPOSITE | 1.3.6.1.4.1.18227.2.1.999.1 | COMPOSITE-NONE |
| MULTIKEY | 1.3.6.1.4.1.18227.2.1.999.1 | MULTIKEY-NONE |

## Explicit Composite Key OIDs 

This section provides the OIDs associated with Explicit algorithm combinations for
Composite Keys:

| Algorithm Name | OID | Signature Algorithm |
| ----------- | ----------- | ----------- |
| id-Dilithium3-ECDSA-P256 | 2.16.840.1.114027.80.5.1 | TBD |
| id-Dilithium3-RSA | 2.16.840.1.114027.80.5.2 | TBD |
| id-Falcon512-ECDSA-P256 | 2.16.840.1.114027.80.5.3 | TBD |
| id-Falcon512-Ed25519 | 2.16.840.1.114027.80.5.4 | TBD |
| id-Dilithium5-Falcon1024-ECDSA-P521 | 2.16.840.1.114027.80.5.5 | TBD |
| id-Dilithium5-Falcon1024-RSA | 2.16.840.1.114027.80.5.6 | TBD |
| id-SPHINCS256_256f_robust+-ECDSA-P256 | 2.16.840.1.114027.80.5.7 | TBD |
| id-SPHINCS256_256f+-RSA | 2.16.840.1.114027.80.5.8 | TBD |
| entrust-Algorithm-ExplicitCompositeKEMKEY | 2.16.840.1.114027.80.7 | TBD |

# Composite Signatures OIDs

This section provides two sets of algorithms. The first set is the set of
signatures related to generic composite (both native and hash-n-sign paradigms)
and explicit composite (only native at the moment).

## Generic Composite Signatures OIDs

This section provides the set of algorithms for native and hash-n-sign paradigm
when using the generic composite OIDs

### No Hash Signatures

| Algorithm Name | OID | Signature Algorithm |
| ----------- | ----------- | ----------- |
| CompositeWithNoHash | 1.3.6.1.4.1.18227.2.1 | COMPOSITE-NONE |

### Standard Hash-n-Sign Signatures

In this case, we use a base OID for composite (1.3.6.1.4.1.18227.2.1)
signatures and the sub-arcs for the combination of the supported
hash algorithms.

By updating/replacing the base composite OID, all supported algorithm
combinations can be easily updated to the new value.

| Algorithm Name | OID | Signature Algorithm |
| ----------- | ----------- | ----------- |
| CompositeWithSha256 | 1.3.6.1.4.1.18227.2.1.2 | COMPOSITE-SHA256 |
| CompositeWithSha384 | 1.3.6.1.4.1.18227.2.1.3 | COMPOSITE-SHA384 |
| CompositeWithSha512 | 1.3.6.1.4.1.18227.2.1.4 | COMPOSITE-SHA512 |
| CompositeWithSha3At256 | 1.3.6.1.4.1.18227.2.1.5 | COMPOSITE-SHA3_256 |
| CompositeWithSha3At384 | 1.3.6.1.4.1.18227.2.1.6 | COMPOSITE-SHA3_384 |
| CompositeWithSha3At512 | 1.3.6.1.4.1.18227.2.1.7 | COMPOSITE-SHA3_512 |
| CompositeWithShake128 | 1.3.6.1.4.1.18227.2.1.8 | COMPOSITE-SHAKE128 |
| CompositeWithShake256 | 1.3.6.1.4.1.18227.2.1.9 | COMPOSITE-SHAKE256 |


## Explicit Composite Signatures OIDs

### No Hash Explicit Composite Signatures OIDs

| Algorithm Name | OID | Signature Algorithm |
| ----------- | ----------- | ----------- |
| id-Dilithium3-ECDSA-P256 | 2.16.840.1.114027.80.5.1 | TBD |
| id-Dilithium3-RSA | 2.16.840.1.114027.80.5.2 | TBD |
| id-Falcon512-ECDSA-P256 | 2.16.840.1.114027.80.5.3 | TBD |
| id-Falcon512-Ed25519 | 2.16.840.1.114027.80.5.4 | TBD |
| id-Dilithium5-Falcon1024-ECDSA-P521 | 2.16.840.1.114027.80.5.5 | TBD |
| id-Dilithium5-Falcon1024-RSA | 2.16.840.1.114027.80.5.6 | TBD |
| id-SPHINCS256_256f_robust+-ECDSA-P256 | 2.16.840.1.114027.80.5.7 | TBD |
| id-SPHINCS256_256f+-RSA | 2.16.840.1.114027.80.5.8 | TBD |
| entrust-Algorithm-ExplicitCompositeKEMKEY | 2.16.840.1.114027.80.7 | TBD |

# PQC Signatures OIDs

Currently PQC signatures are defined for direct signing (i.e., no use of
intermediary hash function). In this section, we provide a definition for
both the direct and hash-n-sign paradigms.

## No Hash PQC Signatures OIDs

For PQC signatures, when no hash-n-sign is used, the OIDs match the OID for
the individual algorithms. Here's the same table from the first section of this
document:

| Algorithm Name | OID | Signature Algorithm |
| ----------- | ----------- | ----------- |
| Dilithium2 | 1.3.6.1.4.1.2.267.7.4.4* | Dilithium2 |
| Dilithium3 | 1.3.6.1.4.1.2.267.7.6.5* | Dilithium3 |
| Dilithium5 | 1.3.6.1.4.1.2.267.7.8.7* | Dilithium5 |
| Falcon-512 | 1.3.9999.3.1* | Falcon-512 |
| Falcon-1024 | 1.3.9999.3.4* | Falcon-1024 |
| SPHINCS+-SHA256-128f-simple | 1.3.9999.6.4.4* | SPHINCS+-SHA256-128f-simple |
| SPHINCS+-SHA256-128s-simple | 1.3.9999.6.4.10* | SPHINCS+-SHA256-128s-simple |
| SPHINCS+-SHA256-192f-simple | 1.3.9999.6.5.3* | SPHINCS+-SHA256-192f-simple |
| SPHINCS+-SHA256-192s-simple | 1.3.9999.6.5.7* | SPHINCS+-SHA256-192s-simple |
| SPHINCS+-SHA256-256f-simple | 1.3.9999.6.6.3* | SPHINCS+-SHA256-256f-simple |
| SPHINCS+-SHA256-256s-simple | 1.3.9999.6.6.7* | SPHINCS+-SHA256-256s-simple |

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

| Algorithm Name | OID | Signature Algorithm |
| ----------- | ----------- | ----------- |
| Dilithium3 | 1.3.6.1.4.1.2.267.7.6.5* | Dilithium3 |
| Dilithium3WithNoHash | 1.3.6.1.4.1.18227.999.1.1 | DILITHIUM3-NULL |
| Dilithium3WithSha256 | 1.3.6.1.4.1.18227.999.1.1.1 | DILITHIUM3-SHA256 |
| Dilithium3WithSha384 | 1.3.6.1.4.1.18227.999.1.1.2 | DILITHIUM3-SHA384 |
| Dilithium3WithSha512 | 1.3.6.1.4.1.18227.999.1.1.3 | DILITHIUM3-SHA512 |
| Dilithium3WithSha3At256 | 1.3.6.1.4.1.18227.999.1.1.4 | DILITHIUM3-SHA3_256 |
| Dilithium3WithSha3At384 | 1.3.6.1.4.1.18227.999.1.1.5 | DILITHIUM3-SHA3_384 |
| Dilithium3WithSha3At512 | 1.3.6.1.4.1.18227.999.1.1.6 | DILITHIUM3-SHA3_512 |
| Dilithium3WithShake128 | 1.3.6.1.4.1.18227.999.1.1.7 | DILITHIUM3-SHAKE128 |
| Dilithium3WithShake256 | 1.3.6.1.4.1.18227.999.1.1.8 | DILITHIUM3-SHAKE256 |
| Dilithium5 | 1.3.6.1.4.1.2.267.7.8.7* | Dilithium5 |
| Dilithium5WithNoHash | 1.3.6.1.4.1.18227.999.1.2 | DILITHIUM5-NULL |
| Dilithium5WithSha256 | 1.3.6.1.4.1.18227.999.1.2.1 | DILITHIUM5-SHA256 |
| Dilithium5WithSha384 | 1.3.6.1.4.1.18227.999.1.2.2 | DILITHIUM5-SHA384 |
| Dilithium5WithSha512 | 1.3.6.1.4.1.18227.999.1.2.3 | DILITHIUM5-SHA512 |
| Dilithium5WithSha3At256 | 1.3.6.1.4.1.18227.999.1.2.4 | DILITHIUM5-SHA3_256 |
| Dilithium5WithSha3At384 | 1.3.6.1.4.1.18227.999.1.2.5 | DILITHIUM5-SHA3_384 |
| Dilithium5WithSha3At512 | 1.3.6.1.4.1.18227.999.1.2.6 | DILITHIUM5-SHA3_512 |
| Dilithium5WithShake128 | 1.3.6.1.4.1.18227.999.1.2.7 | DILITHIUM5-SHAKE128 |
| Dilithium5WithShake256 | 1.3.6.1.4.1.18227.999.1.2.8 | DILITHIUM5-SHAKE256 |
| Falcon-512 | 1.3.9999.3.1* | Falcon-512 |
| Falcon512WithNoHash | 1.3.6.1.4.1.18227.999.2.1 | FALCON512-NULL |
| Falcon512WithSha256 | 1.3.6.1.4.1.18227.999.2.1.1 | FALCON512-SHA256 |
| Falcon512WithSha384 | 1.3.6.1.4.1.18227.999.2.1.2 | FALCON512-SHA384 |
| Falcon512WithSha512 | 1.3.6.1.4.1.18227.999.2.1.3 | FALCON512-SHA512 |
| Falcon512WithSha3At256 | 1.3.6.1.4.1.18227.999.2.1.4 | FALCON512-SHA3_256 |
| Falcon512WithSha3At384 | 1.3.6.1.4.1.18227.999.2.1.5 | FALCON512-SHA3_384 |
| Falcon512WithSha3At512 | 1.3.6.1.4.1.18227.999.2.1.6 | FALCON512-SHA3_512 |
| Falcon512WithShake128 | 1.3.6.1.4.1.18227.999.2.1.7 | FALCON512-SHAKE128 |
| Falcon512WithShake256 | 1.3.6.1.4.1.18227.999.2.1.8 | FALCON512-SHAKE256 |
| Falcon-1024 | 1.3.9999.3.4* | Falcon-1024 |
| Falcon1024WithNoHash | 1.3.6.1.4.1.18227.999.2.2 | FALCON51024-NULL |
| Falcon1024WithSha256 | 1.3.6.1.4.1.18227.999.2.2.1 | FALCON1024-SHA256 |
| Falcon1024WithSha384 | 1.3.6.1.4.1.18227.999.2.2.2 | FALCON1024-SHA384 |
| Falcon1024WithSha512 | 1.3.6.1.4.1.18227.999.2.2.3 | FALCON1024-SHA512 |
| Falcon1024WithSha3At256 | 1.3.6.1.4.1.18227.999.2.2.4 | FALCON1024-SHA3_256 |
| Falcon1024WithSha3At384 | 1.3.6.1.4.1.18227.999.2.2.5 | FALCON1024-SHA3_384 |
| Falcon1024WithSha3At512 | 1.3.6.1.4.1.18227.999.2.2.6 | FALCON1024-SHA3_512 |
| Falcon1024WithShake128 | 1.3.6.1.4.1.18227.999.2.2.7 | FALCON1024-SHAKE128 |
| Falcon1024WithShake256 | 1.3.6.1.4.1.18227.999.2.2.8 | FALCON1024-SHAKE256 |
| SPHINCS+-SHA256-128f-simple | 1.3.9999.6.4.4* | SPHINCS+-SHA256-128f-simple |
| SPHINCS+-SHA256-128s-simple | 1.3.9999.6.4.10* | SPHINCS+-SHA256-128s-simple |
| SPHINCS+-SHA256-192f-simple | 1.3.9999.6.5.3* | SPHINCS+-SHA256-192f-simple |
| SPHINCS+-SHA256-192s-simple | 1.3.9999.6.5.7* | SPHINCS+-SHA256-192s-simple |
| SPHINCS+-SHA256-256f-simple | 1.3.9999.6.6.3* | SPHINCS+-SHA256-256f-simple |
| SPHINCS+-SHA256-256s-simple | 1.3.9999.6.6.7* | SPHINCS+-SHA256-256s-simple |