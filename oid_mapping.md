The following are is the OID mapping to be used for the hackathon.

Taken from: 
* https://docs.google.com/document/d/1A2-D82du0qJjygvBuOlG8Xao3MzDYz1pRDzjT9eY6ls/edit#

Note: asterisk "*" means experimental; ie likely to change after the hackathon.


 # Single-algorithm OIDs


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


# Composite OIDs

| Algorithm Name | OID | Signature Algorithm |
| ----------- | ----------- | ----------- |
| COMPOSITE-Signature | 1.3.6.1.4.1.18227.2.1 | COMPOSITE-Signature |
| COMPOSITE-KEY | 2.16.840.1.114027.80.4.1 | COMPOSITE-KEY |

