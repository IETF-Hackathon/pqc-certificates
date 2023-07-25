# Object Identifiers for PQC and Composite

The following are is the OID mapping to be used for the hackathon.

Taken from: 
* https://docs.google.com/document/d/1A2-D82du0qJjygvBuOlG8Xao3MzDYz1pRDzjT9eY6ls/edit#

Notes: 
1. Asterisk "*" means experimental; ie likely to change after the hackathon.
2. ~~Strikethrough~~ means that this is a deprecated OID as it refers to an older (non-compatible) version of the algorithm spec.

# MikeTest

| Name                 | OID                         |
| -------------------- | --------------------------- |
| MikeTest    | 1.2.840.10045.2.1 | huh |
| ecPublicKey | 1.2.840.10045.2.1 |
| prime256v1  | 1.2.840.10045.3.1.7 |

## Single-algorithm OIDs

This section provides the individual OIDs used for the different algorithms.

Currently PQC signatures are defined for direct signing (i.e., no use of intermediary hash
function) and, therefore, the OID used for signature generation is the same as the
algorithm OID. Although this choice makes the OID to identify both a public key and a
signature, this choice reduces the number of OIDs that is needed to be defined.

The strike thru indicates algorithms that have been used by this group in the past,
but are no longer recommended for testing because of anticipated changes in the algorithms.
For example, the AES variants used in Dilithium are not expected in the final standard,
and neither are the robust variant of SPHINCS+.

| Key Algorithm Name | Signature OID | Signature Name |
| ----------- | ----------- | ----------- |
| Dilithium2 | 1.3.6.1.4.1.2.267.7.4.4* | Dilithium2 |
| Dilithium3 | 1.3.6.1.4.1.2.267.7.6.5* | Dilithium3 |
| Dilithium5 | 1.3.6.1.4.1.2.267.7.8.7* | Dilithium5 |
| ~~DilithiumAES2~~ | ~~1.3.6.1.4.1.2.267.11.4.4*~~ | ~~Dilithium2-AES~~ |
| ~~DilithiumAES3~~ | ~~1.3.6.1.4.1.2.267.11.6.5*~~ | ~~Dilithium3-AES~~ |
| ~~DilithiumAES5~~ | ~~1.3.6.1.4.1.2.267.11.8.7*~~ | ~~Dilithium5-AES~~ |
| ~~Falcon-512~~ | ~~1.3.9999.3.1*~~ | ~~Falcon-512~~ |
| ~~Falcon-1024~~ | ~~1.3.9999.3.4*~~ | ~~Falcon-1024~~ |
| Falcon-512 | 1.3.9999.3.6* | Falcon-512 |
| Falcon-1024 | 1.3.9999.3.9* | Falcon-1024 |
| ~~SPHINCS+-SHA256-128f-robust~~ | ~~1.3.9999.6.4.1*~~ | ~~SPHINCS+-SHA256-128f-robust~~ |
| ~~SPHINCS+-SHA256-128f-simple~~ | ~~1.3.9999.6.4.4*~~ | ~~SPHINCS+-SHA256-128f-simple~~ |
| SPHINCS+-SHA2-128f-simple | 1.3.9999.6.4.13* | SPHINCS+-SHA2-128f-simple |
| ~~SPHINCS+-SHA256-128s-robust~~ | ~~1.3.9999.6.4.7*~~ | ~~SPHINCS+-SHA256-128s-robust~~ |
| ~~SPHINCS+-SHA256-128s-simple~~ | ~~1.3.9999.6.4.10*~~ | ~~SPHINCS+-SHA256-128s-simple~~ |
| SPHINCS+-SHA2-128s-simple | 1.3.9999.6.4.16* | SPHINCS+-SHA2-128s-simple |
| ~~SPHINCS+-SHA256-192f-robust~~ | ~~1.3.9999.6.5.1*~~ | ~~SPHINCS+-SHA256-192f-robust~~ |
| ~~SPHINCS+-SHA256-192f-simple~~ | ~~1.3.9999.6.5.3*~~ | ~~SPHINCS+-SHA256-192f-simple~~ |
| SPHINCS+-SHA2-192f-simple | 1.3.9999.6.5.10* | SPHINCS+-SHA2-192f-simple |
| ~~SPHINCS+-SHA256-192s-robust~~ | ~~1.3.9999.6.5.5~~ | ~~SPHINCS+-SHA256-192s-robust~~ |
| ~~SPHINCS+-SHA256-192s-simple~~ | ~~1.3.9999.6.5.7*~~ | ~~SPHINCS+-SHA256-192s-simple~~ |
| SPHINCS+-SHA2-192s-simple | 1.3.9999.6.5.12* | SPHINCS+-SHA2-192s-simple |
| ~~SPHINCS+-SHA256-256f-robust~~ | ~~1.3.9999.6.6.1*~~ | ~~SPHINCS+-SHA256-256f-robust~~ |
| ~~SPHINCS+-SHA256-256f-simple~~ | ~~1.3.9999.6.6.3*~~ | ~~SPHINCS+-SHA256-256f-simple~~ |
| SPHINCS+-SHA2-256f-simple | 1.3.9999.6.6.10* | SPHINCS+-SHA2-256f-simple |
| ~~SPHINCS+-SHA256-256s-robust~~ | ~~1.3.9999.6.6.5*~~ | ~~SPHINCS+-SHA256-256s-robust~~ |
| ~~SPHINCS+-SHA256-256s-simple~~ | ~~1.3.9999.6.6.7*~~ | ~~SPHINCS+-SHA256-256s-simple~~ |
| SPHINCS+-SHA2-256s-simple | 1.3.9999.6.6.12* | SPHINCS+-SHA2-256s-simple |
| sphincsshake128fsimple | 1.3.9999.6.7.4 | sphincsshake128fsimple |
| sphincsshake192fsimple | 1.3.9999.6.8.3 | sphincsshake192fsimple |
| sphincsshake256fsimple | 1.3.9999.6.9.3 | sphincsshake256fsimple |

Update: The AES version of Dilithium were removed due to their exclusion from the NIST
standardization process.

Update: The Falcon-512 and Falcon-1024 OIDs have been updated due to the updates to the
algorithm's parameters.

Update: The SPHINCS+ robust variants have been removed due to their drop from the NIST
standardization process.  SPHINCS+ OIDs were updated in LibOQS in May 2023 to reflect the 
algorithm changes in SPHINCS+.   Therefore, the OIDs were up-versioned in LibOQS to
prevent compatiblity issues and we have accomodated those changes here as well.

## KEM Algorithm OIDs

This section provides the list of OIDs for composite KEMs.

| KEM Algorithm Name | OID |
| ----------- | ----------- |
| kyber512 |   1.3.6.1.4.1.22554.5.6.1 |
| kyber768 |  1.3.6.1.4.1.22554.5.6.2 |
| kyber1024 | 1.3.6.1.4.1.22554.5.6.3 |
| ~~kyber512_aes~~ | ~~1.3.6.1.4.1.22554.5.6.4~~ |
| ~~kyber768_aes~~ | ~~1.3.6.1.4.1.22554.5.6.5~~ |
| ~~kyber1024_aes~~ | ~~1.3.6.1.4.1.22554.5.6.6~~ |
| bike128 | 1.3.6.1.4.1.22554.5.8.1|
| bike192 | 1.3.6.1.4.1.22554.5.8.2 |
| bike256 | 1.3.6.1.4.1.22554.5.8.3 |
| hqc128 | 1.3.6.1.4.1.22554.5.9.1 |
| hqc192 | 1.3.6.1.4.1.22554.5.9.2 |
| hqc256 | 1.3.6.1.4.1.22554.5.9.3 |
| mceliece348864 | TBD |
| mceliece460896 | TBD |
| mceliece6688128 | TBD |
| mceliece6960119 | TBD |
| mceliece8192128 | TBD |

Update: Support for the AES version of Kyber has been removed due to its
drop from NIST standardization process.

## Explicit Composite Key and Direct Signature OIDs

This section provides the OIDs associated with Explicit algorithm combinations for
Composite Keys and Composite Signatures.  

The Algorithm OID is the same for both the Explicit Composite Key and for the
Composite Signature Algorithm. For example, when using the explicit composite key
identified by the `id-Dilithium3-RSA-PKCS15-SHA256` OID, the same OID MUST be
used to identify the signatures generated with the said key, i.e. `id-Dilithium3-RSA-PKCS15-SHA256`.

| Key Algorithm | Key and Signature OID |
| ----------- | ----------- |
| ExplicitCompositeSignature | 2.16.840.1.114027.80.5.1 |
| id-Dilithium3-RSA-PKCS15-SHA256         | 2.16.840.1.114027.80.5.1.1 |
| id-Dilithium3-ECDSA-P256-SHA256            | 2.16.840.1.114027.80.5.1.2 |
| id-Dilithium3-ECDSA-brainpoolP256r1-SHA256 | 2.16.840.1.114027.80.5.1.3 |
| id-Dilithium3-Ed25519               | 2.16.840.1.114027.80.5.1.4 |
| id-Dilithium5-ECDSA-P384-SHA384            | 2.16.840.1.114027.80.5.1.5 |
| id-Dilithium5-ECDSA-brainpoolP384r1-SHA384 | 2.16.840.1.114027.80.5.1.6 |
| id-Dilithium5-Ed448                   | 2.16.840.1.114027.80.5.1.7 |
| ~~id-Falcon512-ECDSA-P256-SHA256~~        | ~~2.16.840.1.114027.80.5.1.8~~ |
| ~~id-Falcon512-ECDSA-brainpoolP256r1-SHA256~~  | ~~2.16.840.1.114027.80.5.1.9~~ |
| ~~id-Falcon512-Ed25519~~ | ~~2.16.840.1.114027.80.5.1.10~~ |
| id-Falcon512-ECDSA-P256-SHA256        | 2.16.840.1.114027.80.5.1.8.1 |
| id-Falcon512-ECDSA-brainpoolP256r1-SHA256  | 2.16.840.1.114027.80.5.1.9.1 |
| id-Falcon512-Ed25519                       | 2.16.840.1.114027.80.5.1.10.1 |
| ~~id-SPHINCSplusSHA256128sSimple-ECDSA-P256-SHA256~~ | ~~2.16.840.1.114027.80.5.1.11~~ |
| ~~id-SPHINCSplusSHA256128sSimple-ECDSA-brainpoolP256r1-SHA256~~ | ~~2.16.840.1.114027.80.5.1.12~~ |
| ~~id-SPHINCSplusSHA256128sSimple-Ed25519~~  |~~2.16.840.1.114027.80.5.1.13~~ |
| id-Dilithium3-RSA-PSS-SHA256                   | 2.16.840.1.114027.80.5.1.14 |

Update: The SPHINCS+ combinations have been removed because the need for
composite is very minimal given the conservative design of the algorithm.

Update: The Falcon512 combinations have been updated because of the changes
in the Falcon512 parameters (May 2023).

## Generic Composite Keys and Direct Signature OIDs

This section provides the OIDs associated with Generic Composite Keys and
Direct Signatures. Specifically, we define the OID for a Generic Composite
Key as follows:

| Public Key Alg Name | OID | Alias |
| ----------- | ----------- | ----------- |
| COMPOSITE-KEY | 2.16.840.1.114027.80.4.1 | id-Composite-Key |
| ~~COMPOSITE~~ | ~~1.3.6.1.4.1.18227.2.1.999.1~~ | ~~id-Composite-Key~~ |
| ~~MULTIKEY~~ | ~~1.3.6.1.4.1.18227.2.1.999.1~~ | ~~id-Multi-Key~~ |

Update: The MULTIKEY option has been integrated into the generic composite and does not
need a separate OID. When the optional parameter (K of N) is present, the
validation policy leverage the `K` parameter. When the key parameter is not
present, the validation is equivalent to the case where `K == N`.

Differently from the Explicit use-case, for Generic Composite Direct Signature, the
signature OID is not the same as the Key, but uses the following arc. The direct
signature OID for Composite is defined as follows:

| Algorithm Name | OID | Alias |
| ----------- | ----------- | ----------- |
| CompositeWithNoHash | 1.3.6.1.4.1.18227.2.1 | COMPOSITE |

## Generic Composite and Hash-n-Sign

Generic Composite supports both signing with or without pre-hashing.

When using pre-hashing (hash-n-sign), we map the differet OIDs from
the base OID for composite (1.3.6.1.4.1.18227.2.1). By updating/replacing
the base composite OID, all supported algorithm combinations can be easily
updated to the new value.

The list of suggested hash-n-sign combinations (also supported by NIST in
informal conversation with the standardization team) are:

| Algorithm Name | OID | Alias |
| ----------- | ----------- | ----------- |
| CompositeWithSha256 | 1.3.6.1.4.1.18227.2.1.2 | COMPOSITE-SHA256 |
| CompositeWithSha512 | 1.3.6.1.4.1.18227.2.1.4 | COMPOSITE-SHA512 |

Other supported hash-n-sign combinations are:

| Algorithm Name | OID | Alias |
| ----------- | ----------- | ----------- |
| CompositeWithSha256 | 1.3.6.1.4.1.18227.2.1.3 | COMPOSITE-SHA384 |
| CompositeWithSha3at256 | 1.3.6.1.4.1.18227.2.1.5 | COMPOSITE-SHA3_256 |
| CompositeWithSha3at384 | 1.3.6.1.4.1.18227.2.1.6 | COMPOSITE-SHA3_384 |
| CompositeWithSha3at512 | 1.3.6.1.4.1.18227.2.1.7 | COMPOSITE-SHA3_512 |
| CompositeWithShake128 | 1.3.6.1.4.1.18227.2.1.8 | COMPOSITE-SHAKE128 |
| CompositeWithShake256 | 1.3.6.1.4.1.18227.2.1.9 | COMPOSITE-SHAKE256 |

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


| Alg Name | OID |
| COMPOSITE_KEY_HASH_N_SIGN | 2.16.840.1.114027.80.4.1.2 |

### Dilithium2 Hash-n-Sign Algorithm Identifiers

The list of suggested hash-n-sign combinations is as follows:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm |
| ----------- | ----------- | ----------- |  ----------- |
| Dilithium2WithSha256 | 1.3.6.1.4.1.18227.999.1.1.1 | Dilithium2 | SHA256 |
| Dilithium2WithSha512 | 1.3.6.1.4.1.18227.999.1.1.3 | Dilithium2 | SHA512 |

The full list of supported hash-n-sign combinations also comprises the following:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm |
| ----------- | ----------- | ----------- |  ----------- |
| Dilithium2WithSha384 | 1.3.6.1.4.1.18227.999.1.1.2 | Dilithium2 | SHA384 |
| Dilithium2WithSha3At256 | 1.3.6.1.4.1.18227.999.1.1.4 | Dilithium2 | SHA3_256 |
| Dilithium2WithSha3At384 | 1.3.6.1.4.1.18227.999.1.1.5 | Dilithium2 | SHA3_384 |
| Dilithium2WithSha3At512 | 1.3.6.1.4.1.18227.999.1.1.6 | Dilithium2 | SHA3_512 |
| Dilithium2WithShake128 | 1.3.6.1.4.1.18227.999.1.1.7 | Dilithium2 | SHAKE128 |
| Dilithium2WithShake256 | 1.3.6.1.4.1.18227.999.1.1.8 | Dilithium2 | SHAKE256 |

### Dilithium3 Hash-n-Sign Algorithm Identifiers

The list of suggested hash-n-sign combinations is as follows:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm |
| ----------- | ----------- | ----------- |  ----------- |
| Dilithium3WithSha256 | 1.3.6.1.4.1.18227.999.1.2.1 | Dilithium3 | SHA256 |
| Dilithium3WithSha512 | 1.3.6.1.4.1.18227.999.1.2.3 | Dilithium3 | SHA512 |

The full list of supported hash-n-sign combinations also comprises the following:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm |
| ----------- | ----------- | ----------- |  ----------- |
| Dilithium3WithSha384 | 1.3.6.1.4.1.18227.999.1.2.2 | Dilithium3 | SHA384 |
| Dilithium3WithSha3At256 | 1.3.6.1.4.1.18227.999.1.2.4 | Dilithium3 | SHA3_256 |
| Dilithium3WithSha3At384 | 1.3.6.1.4.1.18227.999.1.2.5 | Dilithium3 | SHA3_384 |
| Dilithium3WithSha3At512 | 1.3.6.1.4.1.18227.999.1.2.6 | Dilithium3 | SHA3_512 |
| Dilithium3WithShake128 | 1.3.6.1.4.1.18227.999.1.2.7 | Dilithium3 | SHAKE128 |
| Dilithium3WithShake256 | 1.3.6.1.4.1.18227.999.1.2.8 | Dilithium3 | SHAKE256 |

### Dilithium5 Hash-n-Sign Algorithm Identifiers

The list of suggested hash-n-sign combinations is as follows:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm |
| ----------- | ----------- | ----------- |  ----------- |
| Dilithium5WithSha256 | 1.3.6.1.4.1.18227.999.1.2.1 | Dilithium5 | SHA256 |
| Dilithium5WithSha512 | 1.3.6.1.4.1.18227.999.1.2.3 | Dilithium5 | SHA512 |

The full list of supported hash-n-sign combinations also comprises the following:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm |
| ----------- | ----------- | ----------- |  ----------- |
| Dilithium5WithSha384 | 1.3.6.1.4.1.18227.999.1.2.2 | Dilithium5 | SHA384 |
| Dilithium5WithSha3At256 | 1.3.6.1.4.1.18227.999.1.2.4 | Dilithium5 | SHA3_256 |
| Dilithium5WithSha3At384 | 1.3.6.1.4.1.18227.999.1.2.5 | Dilithium5 | SHA3_384 |
| Dilithium5WithSha3At512 | 1.3.6.1.4.1.18227.999.1.2.6 | Dilithium5 | SHA3_512 |
| Dilithium5WithShake128 | 1.3.6.1.4.1.18227.999.1.2.7 | Dilithium5 | SHAKE128 |
| Dilithium5WithShake256 | 1.3.6.1.4.1.18227.999.1.2.8 | Dilithium5 | SHAKE256 |

### Falcon512 Hash-n-Sign Algorithm Identifiers

The list of suggested hash-n-sign combinations is as follows:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm |
| ----------- | ----------- | ----------- |  ----------- |
| ~~Falcon512WithSha256~~ | ~~1.3.6.1.4.1.18227.999.2.1.1~~ | ~~Falcon512~~ | ~~SHA256~~ |
| ~~Falcon512WithSha512~~ | ~~1.3.6.1.4.1.18227.999.2.3.3~~ | ~~Falcon512~~ | ~~SHA512~~ |
| Falcon512WithSha256 | 1.3.6.1.4.1.18227.999.2.3.1.1 | Falcon512 | SHA256 |
| Falcon512WithSha512 | 1.3.6.1.4.1.18227.999.2.3.3.1 | Falcon512 | SHA512 |

The full list of supported hash-n-sign combinations also comprises the following:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm |
| ----------- | ----------- | ----------- |  ----------- |
| ~~Falcon512WithSha384~~ | ~~1.3.6.1.4.1.18227.999.2.1.2~~ | ~~Falcon512~~ | ~~SHA384~~ |
| ~~Falcon512WithSha3At256~~ | ~~1.3.6.1.4.1.18227.999.2.1.4~~ | ~~Falcon512~~ | ~~SHA3_256~~ |
| ~~Falcon512WithSha3At384~~ | ~~1.3.6.1.4.1.18227.999.2.1.5~~ | ~~Falcon512~~ | ~~SHA3_384~~ |
| ~~Falcon512WithSha3At512~~ | ~~1.3.6.1.4.1.18227.999.2.1.6~~ | ~~Falcon512~~ | ~~SHA3_512~~ |
| ~~Falcon512WithShake128~~ | ~~1.3.6.1.4.1.18227.999.2.1.7~~ | ~~Falcon512~~ | ~~SHAKE128~~ |
| ~~Falcon512WithShake256~~ | ~~1.3.6.1.4.1.18227.999.2.1.8~~ | ~~Falcon512~~ | ~~SHAKE256~~ |
| Falcon512WithSha384 | 1.3.6.1.4.1.18227.999.2.3.2.1 | Falcon512 | SHA384 |
| Falcon512WithSha3At256 | 1.3.6.1.4.1.18227.999.2.3.4.1 | Falcon512 | SHA3_256 |
| Falcon512WithSha3At384 | 1.3.6.1.4.1.18227.999.2.3.5.1 | Falcon512 | SHA3_384 |
| Falcon512WithSha3At512 | 1.3.6.1.4.1.18227.999.2.3.6.1 | Falcon512 | SHA3_512 |
| Falcon512WithShake128 | 1.3.6.1.4.1.18227.999.2.3.7.1 | Falcon512 | SHAKE128 |
| Falcon512WithShake256 | 1.3.6.1.4.1.18227.999.2.3.8.1 | Falcon512 | SHAKE256 |

Update: The OIDs for Falcon combinations have been updated to reflect the changes
in the algorithm's parameters (May 2023)

### Falcon1024 Hash-n-Sign Algorithm Identifiers

The list of suggested hash-n-sign combinations is as follows:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm |
| ----------- | ----------- | ----------- |  ----------- |
| ~~Falcon1024WithSha256~~ | ~~1.3.6.1.4.1.18227.999.2.2.1~~ | ~~FALCON1024-SHA256~~ |
| ~~Falcon1024WithSha512~~ | ~~1.3.6.1.4.1.18227.999.2.2.3~~ | ~~FALCON1024-SHA512~~ |
| Falcon1024WithSha256 | 1.3.6.1.4.1.18227.999.2.2.1.1 | FALCON1024-SHA256 |
| Falcon1024WithSha512 | 1.3.6.1.4.1.18227.999.2.2.3.1 | FALCON1024-SHA512 |

The full list of supported hash-n-sign combinations also comprises the following:

| Sig Algorithm Name | OID | Key Algorithm | Hash Algorithm |
| ----------- | ----------- | ----------- |  ----------- |
| ~~Falcon1024WithSha384~~ | ~~1.3.6.1.4.1.18227.999.2.2.2~~ | ~~FALCON1024-SHA384~~ |
| ~~Falcon1024WithSha3At256~~ | ~~1.3.6.1.4.1.18227.999.2.2.4~~ | ~~FALCON1024-SHA3_256~~ |
| ~~Falcon1024WithSha3At384~~ | ~~1.3.6.1.4.1.18227.999.2.2.5~~ | ~~FALCON1024-SHA3_384~~ |
| ~~Falcon1024WithSha3At512~~ | ~~1.3.6.1.4.1.18227.999.2.2.6~~ | ~~FALCON1024-SHA3_512~~ |
| ~~Falcon1024WithShake128~~ | ~~1.3.6.1.4.1.18227.999.2.2.7~~ | ~~FALCON1024-SHAKE128~~ |
| ~~Falcon1024WithShake256~~ | ~~1.3.6.1.4.1.18227.999.2.2.8~~ | ~~FALCON1024-SHAKE256~~ |
| Falcon1024WithSha384 | 1.3.6.1.4.1.18227.999.2.2.2.1 | FALCON1024-SHA384 |
| Falcon1024WithSha3At256 | 1.3.6.1.4.1.18227.999.2.2.4.1 | FALCON1024-SHA3_256 |
| Falcon1024WithSha3At384 | 1.3.6.1.4.1.18227.999.2.2.5.1 | FALCON1024-SHA3_384 |
| Falcon1024WithSha3At512 | 1.3.6.1.4.1.18227.999.2.2.6.1 | FALCON1024-SHA3_512 |
| Falcon1024WithShake128 | 1.3.6.1.4.1.18227.999.2.2.7.1 | FALCON1024-SHAKE128 |
| Falcon1024WithShake256 | 1.3.6.1.4.1.18227.999.2.2.8.1 | FALCON1024-SHAKE256 |

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
| MikeTest     | 1.2.840.10045.2.1 | huh |
| ecPublicKey | 1.2.840.10045.2.1 |
| prime256v1  | 1.2.840.10045.3.1.7 |
| ecdsa-with-SHA256 | 1.2.840.10045.4.3.2 |
| rsaEncryption | 1.2.840.113549.1.1.1 |
