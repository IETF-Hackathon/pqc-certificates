
IETF PQC Hackathon Certificate Interoperability Results
=======================================================


<style> table { border-collapse: collapse; } th, td { border: solid black 1px; padding: 0 1ex; } col { width: auto !important; } </style>

Generated: 2024-11-05 11:18 UTC


# Algorithms Submitted


✅ = passing all verifiers<br>◒ = passing some verifiers<br>⚪︎ = not passing any verifiers<br>Columns represent producers who submitted artifacts. Verifiers are not listed in this table, but are listed in the broken-out tables below.<br>


|-|bc|carl-redhound|cht|cnsprovider|corey-digicert|cryptonext|cryptonext-cnsprovider|kris|seventhsense.ai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|ML-DSA-44|✅|✅|✅|✅|✅|✅|✅|✅|✅|
|ML-DSA-65|✅|✅|✅|✅|✅|✅|✅|✅|✅|
|ML-DSA-87|✅|✅|✅|✅|✅|✅|✅|✅|✅|
|SLH-DSA-SHA2-128s|✅|✅|✅|✅||✅|✅||✅|
|SLH-DSA-SHA2-128f|✅|✅|✅|✅||✅|✅||✅|
|SLH-DSA-SHA2-192s|✅|✅|✅|✅||✅|✅||✅|
|SLH-DSA-SHA2-192f|✅|✅|✅|✅||✅|✅||✅|
|SLH-DSA-SHA2-256s|✅|✅|✅|✅||✅|✅||✅|
|SLH-DSA-SHA2-256f|✅|✅|✅|✅||✅|✅||✅|
|SLH-DSA-SHAKE-128s|✅|✅|✅|✅||✅|✅||✅|
|SLH-DSA-SHAKE-128f|✅|✅|✅|✅||✅|✅||✅|
|SLH-DSA-SHAKE-192s|✅|✅|✅|✅||✅|✅||✅|
|SLH-DSA-SHAKE-192f|✅|✅|✅|✅||✅|✅||✅|
|SLH-DSA-SHAKE-256s|✅|✅|✅|✅||✅|✅||✅|
|SLH-DSA-SHAKE-256f|✅|✅|✅|✅||✅|✅||✅|
|HASH-ML-DSA-44|◒|✅|||✅|◒|||✅|
|HASH-ML-DSA-65|◒|✅|||✅|◒|||✅|
|HASH-ML-DSA-87|◒|✅|||✅|◒|||✅|
|HASH-SLH-DSA-SHA2-128s|◒|||||◒|||✅|
|HASH-SLH-DSA-SHA2-128f|◒|||||◒|||✅|
|HASH-SLH-DSA-SHA2-192s|◒|||||◒|||✅|
|HASH-SLH-DSA-SHA2-192f|◒|||||◒|||✅|
|HASH-SLH-DSA-SHA2-256s|◒|||||◒|||✅|
|HASH-SLH-DSA-SHA2-256f|◒|||||◒|||✅|
|HASH-SLH-DSA-SHAKE-128s|◒|||||◒|||✅|
|HASH-SLH-DSA-SHAKE-128f|◒|||||◒|||✅|
|HASH-SLH-DSA-SHAKE-192s|◒|||||◒|||✅|
|HASH-SLH-DSA-SHAKE-192f|◒|||||◒|||✅|
|HASH-SLH-DSA-SHAKE-256s|◒|||||◒|||✅|
|HASH-SLH-DSA-SHAKE-256f|◒|||||◒|||✅|
|ML-KEM-512|✅||✅|||✅|✅|||
|ML-KEM-768|✅||✅|||✅|✅|||
|ML-KEM-1024|✅||✅|||✅|✅|||
|id-MLDSA44-RSA2048-PSS|✅||||||||✅|
|id-MLDSA44-RSA2048-PKCS15|✅||||||||✅|
|id-MLDSA44-Ed25519|✅||||||||✅|
|id-MLDSA44-ECDSA-P256|✅||||||||✅|
|id-MLDSA65-RSA3072-PSS|✅||||||||✅|
|id-MLDSA65-RSA3072-PKCS15|✅||||||||✅|
|id-MLDSA65-ECDSA-P384|✅||||||||✅|
|id-MLDSA65-ECDSA-brainpoolP256r1|✅||||||||✅|
|id-MLDSA65-Ed25519|✅||||||||✅|
|id-MLDSA87-ECDSA-P384|✅||||||||✅|
|id-MLDSA87-ECDSA-brainpoolP384r1|✅||||||||✅|
|id-MLDSA87-Ed448|✅||||||||✅|
|id-MLDSA65-RSA4096-PSS|✅||||||||✅|
|id-MLDSA65-RSA4096-PKCS15|✅||||||||✅|
|id-HashMLDSA44-RSA2048-PSS-SHA256|✅||||||||✅|
|id-HashMLDSA44-RSA2048-PKCS15-SHA256|✅||||||||✅|
|id-HashMLDSA44-Ed25519-SHA512|✅||||||||✅|
|id-HashMLDSA44-ECDSA-P256-SHA256|✅||||||||✅|
|id-HashMLDSA65-RSA3072-PSS-SHA512|✅||||||||✅|
|id-HashMLDSA65-RSA3072-PKCS15-SHA512|✅||||||||✅|
|id-HashMLDSA65-RSA4096-PSS-SHA512|✅||||||||✅|
|id-HashMLDSA65-RSA4096-PKCS15-SHA512|✅||||||||◒|
|id-HashMLDSA65-ECDSA-P384-SHA512|✅||||||||✅|
|id-HashMLDSA65-ECDSA-brainpoolP256r1-SHA512|✅||||||||✅|
|id-HashMLDSA65-Ed25519-SHA512|✅||||||||✅|
|id-HashMLDSA87-ECDSA-P384-SHA512|✅||||||||✅|
|id-HashMLDSA87-ECDSA-brainpoolP384r1-SHA51|✅||||||||✅|
|id-HashMLDSA87-Ed448-SHA512|✅||||||||✅|

# ML-DSA-44 (2.16.840.1.101.3.4.3.17)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅|✅|
|carl-redhound|✅|||||✅|
|cht|✅|✅|✅|✅|✅|✅|
|cnsprovider||||✅|||
|corey-digicert|✅|✅|✅|||✅|
|cryptonext|✅|✅|✅|✅||✅|
|cryptonext-cnsprovider|✅|✅|✅||✅|✅|
|kris|✅||✅|||✅|
|seventhsense.ai|✅|||||✅|

# ML-DSA-65 (2.16.840.1.101.3.4.3.18)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅|✅|
|carl-redhound|✅|||||✅|
|cht|✅|✅|✅|✅|✅|✅|
|cnsprovider||||✅|||
|corey-digicert|✅|✅|✅|||✅|
|cryptonext|✅|✅|✅|✅||✅|
|cryptonext-cnsprovider|✅|✅|✅||✅|✅|
|kris|✅||✅|||✅|
|seventhsense.ai|✅|||||✅|

# ML-DSA-87 (2.16.840.1.101.3.4.3.19)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅|✅|
|carl-redhound|✅|||||✅|
|cht|✅|✅|✅|✅|✅|✅|
|cnsprovider||||✅|||
|corey-digicert|✅|✅|✅|||✅|
|cryptonext|✅|✅|✅|✅||✅|
|cryptonext-cnsprovider|✅|✅|✅||✅|✅|
|kris|✅||✅|||✅|
|seventhsense.ai|✅|||||✅|

# SLH-DSA-SHA2-128s (2.16.840.1.101.3.4.3.20)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅|✅|
|carl-redhound|✅|||||✅|
|cht|✅|✅||✅|✅|✅|
|cnsprovider||||✅|||
|corey-digicert|||||||
|cryptonext|✅|✅||✅||✅|
|cryptonext-cnsprovider|✅|✅|||✅|✅|
|kris|||||||
|seventhsense.ai|✅|||||✅|

# SLH-DSA-SHA2-128f (2.16.840.1.101.3.4.3.21)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅|✅|
|carl-redhound|✅|||||✅|
|cht|✅|✅||✅|✅|✅|
|cnsprovider||||✅|||
|corey-digicert|||||||
|cryptonext|✅|✅||✅||✅|
|cryptonext-cnsprovider|✅|✅|||✅|✅|
|kris|||||||
|seventhsense.ai|✅|||||✅|

# SLH-DSA-SHA2-192s (2.16.840.1.101.3.4.3.22)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅|✅|
|carl-redhound|✅|||||✅|
|cht|✅|✅||✅|✅|✅|
|cnsprovider||||✅|||
|corey-digicert|||||||
|cryptonext|✅|✅||✅||✅|
|cryptonext-cnsprovider|✅|✅|||✅|✅|
|kris|||||||
|seventhsense.ai|✅|||||✅|

# SLH-DSA-SHA2-192f (2.16.840.1.101.3.4.3.23)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅|✅|
|carl-redhound|✅|||||✅|
|cht|✅|✅||✅|✅|✅|
|cnsprovider||||✅|||
|corey-digicert|||||||
|cryptonext|✅|✅||✅||✅|
|cryptonext-cnsprovider|✅|✅|||✅|✅|
|kris|||||||
|seventhsense.ai|✅|||||✅|

# SLH-DSA-SHA2-256s (2.16.840.1.101.3.4.3.24)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅|✅|
|carl-redhound|✅|||||✅|
|cht|✅|✅||✅|✅|✅|
|cnsprovider||||✅|||
|corey-digicert|||||||
|cryptonext|✅|✅||✅||✅|
|cryptonext-cnsprovider|✅|✅|||✅|✅|
|kris|||||||
|seventhsense.ai|✅|||||✅|

# SLH-DSA-SHA2-256f (2.16.840.1.101.3.4.3.25)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅|✅|
|carl-redhound|✅|||||✅|
|cht|✅|✅||✅|✅|✅|
|cnsprovider||||✅|||
|corey-digicert|||||||
|cryptonext|✅|✅||✅||✅|
|cryptonext-cnsprovider|✅|✅|||✅|✅|
|kris|||||||
|seventhsense.ai|✅|||||✅|

# SLH-DSA-SHAKE-128s (2.16.840.1.101.3.4.3.26)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅|✅|
|carl-redhound|✅|||||✅|
|cht|✅|✅||✅|✅|✅|
|cnsprovider||||✅|||
|corey-digicert|||||||
|cryptonext|✅|✅||✅||✅|
|cryptonext-cnsprovider|✅|✅|||✅|✅|
|kris|||||||
|seventhsense.ai|✅|||||✅|

# SLH-DSA-SHAKE-128f (2.16.840.1.101.3.4.3.27)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅|✅|
|carl-redhound|✅|||||✅|
|cht|✅|✅||✅|✅|✅|
|cnsprovider||||✅|||
|corey-digicert|||||||
|cryptonext|✅|✅||✅||✅|
|cryptonext-cnsprovider|✅|✅|||✅|✅|
|kris|||||||
|seventhsense.ai|✅|||||✅|

# SLH-DSA-SHAKE-192s (2.16.840.1.101.3.4.3.28)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅|✅|
|carl-redhound|✅|||||✅|
|cht|✅|✅||✅|✅|✅|
|cnsprovider||||✅|||
|corey-digicert|||||||
|cryptonext|✅|✅||✅||✅|
|cryptonext-cnsprovider|✅|✅|||✅|✅|
|kris|||||||
|seventhsense.ai|✅|||||✅|

# SLH-DSA-SHAKE-192f (2.16.840.1.101.3.4.3.29)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅|✅|
|carl-redhound|✅|||||✅|
|cht|✅|✅||✅|✅|✅|
|cnsprovider||||✅|||
|corey-digicert|||||||
|cryptonext|✅|✅||✅||✅|
|cryptonext-cnsprovider|✅|✅|||✅|✅|
|kris|||||||
|seventhsense.ai|✅|||||✅|

# SLH-DSA-SHAKE-256s (2.16.840.1.101.3.4.3.30)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅|✅|
|carl-redhound|✅|||||✅|
|cht|✅|✅||✅|✅|✅|
|cnsprovider||||✅|||
|corey-digicert|||||||
|cryptonext|✅|✅||✅||✅|
|cryptonext-cnsprovider|✅|✅|||✅|✅|
|kris|||||||
|seventhsense.ai|✅|||||✅|

# SLH-DSA-SHAKE-256f (2.16.840.1.101.3.4.3.31)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||✅|✅|✅|
|carl-redhound|✅|||||✅|
|cht|✅|✅||✅|✅|✅|
|cnsprovider||||✅|||
|corey-digicert|||||||
|cryptonext|✅|✅||✅||✅|
|cryptonext-cnsprovider|✅|✅|||✅|✅|
|kris|||||||
|seventhsense.ai|✅|||||✅|

# HASH-ML-DSA-44 (2.16.840.1.101.3.4.3.32)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|❌||✅|
|carl-redhound|✅|||||✅|
|cht|||||||
|cnsprovider|||||||
|corey-digicert|✅||✅|||✅|
|cryptonext|✅||❌|✅||❌|
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# HASH-ML-DSA-65 (2.16.840.1.101.3.4.3.33)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|❌||✅|
|carl-redhound|✅|||||✅|
|cht|||||||
|cnsprovider|||||||
|corey-digicert|✅||✅|||✅|
|cryptonext|✅||❌|✅||❌|
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# HASH-ML-DSA-87 (2.16.840.1.101.3.4.3.34)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|❌||✅|
|carl-redhound|✅|||||✅|
|cht|||||||
|cnsprovider|||||||
|corey-digicert|✅||✅|||✅|
|cryptonext|✅||❌|✅||❌|
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# HASH-SLH-DSA-SHA2-128s (2.16.840.1.101.3.4.3.35)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||❌||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|✅|||✅||❌|
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# HASH-SLH-DSA-SHA2-128f (2.16.840.1.101.3.4.3.36)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||❌||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|✅|||✅||❌|
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# HASH-SLH-DSA-SHA2-192s (2.16.840.1.101.3.4.3.37)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||❌||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|✅|||✅||❌|
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# HASH-SLH-DSA-SHA2-192f (2.16.840.1.101.3.4.3.38)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||❌||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|✅|||✅||❌|
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# HASH-SLH-DSA-SHA2-256s (2.16.840.1.101.3.4.3.39)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||❌||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|✅|||✅||❌|
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# HASH-SLH-DSA-SHA2-256f (2.16.840.1.101.3.4.3.40)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||❌||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|✅|||✅||❌|
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# HASH-SLH-DSA-SHAKE-128s (2.16.840.1.101.3.4.3.41)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||❌||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|✅|||✅||❌|
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# HASH-SLH-DSA-SHAKE-128f (2.16.840.1.101.3.4.3.42)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||❌||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|✅|||✅||❌|
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# HASH-SLH-DSA-SHAKE-192s (2.16.840.1.101.3.4.3.43)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||❌||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|✅|||✅||❌|
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# HASH-SLH-DSA-SHAKE-192f (2.16.840.1.101.3.4.3.44)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||❌||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|✅|||✅||❌|
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# HASH-SLH-DSA-SHAKE-256s (2.16.840.1.101.3.4.3.45)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||❌||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|✅|||✅||❌|
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# HASH-SLH-DSA-SHAKE-256f (2.16.840.1.101.3.4.3.46)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||❌||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|✅|||✅||❌|
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# ML-KEM-512 (2.16.840.1.101.3.4.4.1)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||✅||
|carl-redhound|||||||
|cht||✅|||✅||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext||✅|||||
|cryptonext-cnsprovider||✅|||✅||
|kris|||||||
|seventhsense.ai|||||||

# ML-KEM-768 (2.16.840.1.101.3.4.4.2)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||✅||
|carl-redhound|||||||
|cht||✅|||✅||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext||✅|||||
|cryptonext-cnsprovider||✅|||✅||
|kris|||||||
|seventhsense.ai|||||||

# ML-KEM-1024 (2.16.840.1.101.3.4.4.3)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅|||✅||
|carl-redhound|||||||
|cht||✅|||✅||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext||✅|||||
|cryptonext-cnsprovider||✅|||✅||
|kris|||||||
|seventhsense.ai|||||||

# id-MLDSA44-RSA2048-PSS (2.16.840.1.114027.80.8.1.21)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-MLDSA44-RSA2048-PKCS15 (2.16.840.1.114027.80.8.1.22)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-MLDSA44-Ed25519 (2.16.840.1.114027.80.8.1.23)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-MLDSA44-ECDSA-P256 (2.16.840.1.114027.80.8.1.24)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-MLDSA65-RSA3072-PSS (2.16.840.1.114027.80.8.1.26)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-MLDSA65-RSA3072-PKCS15 (2.16.840.1.114027.80.8.1.27)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-MLDSA65-ECDSA-P384 (2.16.840.1.114027.80.8.1.28)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-MLDSA65-ECDSA-brainpoolP256r1 (2.16.840.1.114027.80.8.1.29)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai||||||✅|

# id-MLDSA65-Ed25519 (2.16.840.1.114027.80.8.1.30)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-MLDSA87-ECDSA-P384 (2.16.840.1.114027.80.8.1.31)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-MLDSA87-ECDSA-brainpoolP384r1 (2.16.840.1.114027.80.8.1.32)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai||||||✅|

# id-MLDSA87-Ed448 (2.16.840.1.114027.80.8.1.33)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai||||||✅|

# id-MLDSA65-RSA4096-PSS (2.16.840.1.114027.80.8.1.34)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-MLDSA65-RSA4096-PKCS15 (2.16.840.1.114027.80.8.1.35)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-HashMLDSA44-RSA2048-PSS-SHA256 (2.16.840.1.114027.80.8.1.40)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-HashMLDSA44-RSA2048-PKCS15-SHA256 (2.16.840.1.114027.80.8.1.41)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-HashMLDSA44-Ed25519-SHA512 (2.16.840.1.114027.80.8.1.42)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-HashMLDSA44-ECDSA-P256-SHA256 (2.16.840.1.114027.80.8.1.43)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-HashMLDSA65-RSA3072-PSS-SHA512 (2.16.840.1.114027.80.8.1.44)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-HashMLDSA65-RSA3072-PKCS15-SHA512 (2.16.840.1.114027.80.8.1.45)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-HashMLDSA65-RSA4096-PSS-SHA512 (2.16.840.1.114027.80.8.1.46)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-HashMLDSA65-RSA4096-PKCS15-SHA512 (2.16.840.1.114027.80.8.1.47)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||❌|

# id-HashMLDSA65-ECDSA-P384-SHA512 (2.16.840.1.114027.80.8.1.48)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-HashMLDSA65-ECDSA-brainpoolP256r1-SHA512 (2.16.840.1.114027.80.8.1.49)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai||||||✅|

# id-HashMLDSA65-Ed25519-SHA512 (2.16.840.1.114027.80.8.1.50)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-HashMLDSA87-ECDSA-P384-SHA512 (2.16.840.1.114027.80.8.1.51)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai|✅|||||✅|

# id-HashMLDSA87-ECDSA-brainpoolP384r1-SHA51 (2.16.840.1.114027.80.8.1.52)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai||||||✅|

# id-HashMLDSA87-Ed448-SHA512 (2.16.840.1.114027.80.8.1.53)


Rows are producers. Columns are parsers.

|-|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|ssai|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||✅|
|carl-redhound|||||||
|cht|||||||
|cnsprovider|||||||
|corey-digicert|||||||
|cryptonext|||||||
|cryptonext-cnsprovider|||||||
|kris|||||||
|seventhsense.ai||||||✅|
