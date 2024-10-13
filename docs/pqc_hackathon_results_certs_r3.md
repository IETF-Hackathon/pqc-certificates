
IETF PQC Hackathon Certificate Interoperability Results
=======================================================


<style> table { border-collapse: collapse; } th, td { border: solid black 1px; padding: 0 1ex; } col { width: auto !important; } </style>

Generated: 2024-07-24 15:56 UTC


# Algorithms Submitted


✅ = passing all verifiers<br>◒ = passing some verifiers<br>⚪︎ = not passing any verifiers<br>


|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|ML-DSA-44-ipd|✅||✅|✅|✅|✅|✅|✅||◒||||✅|
|ML-DSA-65-ipd|✅||✅|✅|✅|✅|✅|✅||◒||||✅|
|ML-DSA-87-ipd|✅||✅|✅|✅|✅|✅|✅||◒||||✅|
|ML-KEM-512-ipd|✅||||✅|✅|✅||||||||
|ML-KEM-768-ipd|✅||||✅|✅|✅||||||||
|ML-KEM-1024-ipd|✅||||✅|✅|✅||||||||
|Falcon-512|◒||◒||◒|||◒||◒||||✅|
|Falcon-1024|◒||◒||◒|||◒||◒||||✅|
|SLH-DSA-SHA2-128f-ipd|✅||✅|✅|✅||✅|◒||||||✅|
|SLH-DSA-SHA2-128s-ipd|✅||✅|✅|✅||✅|◒||||||✅|
|SLH-DSA-SHA2-192f-ipd|✅||✅|✅|✅||✅|◒||||||✅|
|SLH-DSA-SHA2-192s-ipd|✅||✅|✅|✅||✅|◒||||||✅|
|SLH-DSA-SHA2-256f-ipd|✅||✅|✅|✅||✅|◒||||||✅|
|SLH-DSA-SHA2-256s-ipd|✅||✅|✅|✅||✅|◒||||||✅|
|SLH-DSA-SHAKE-128f-ipd|◒||◒|✅|◒|◒|✅|◒||||||◒|
|SLH-DSA-SHAKE-128s-ipd|✅||✅|✅|✅||✅|◒||||||✅|
|SLH-DSA-SHAKE-192f-ipd|✅||✅|✅|✅|✅|✅|◒||||||✅|
|SLH-DSA-SHAKE-192s-ipd|✅||✅|✅|✅||✅|◒||||||✅|
|SLH-DSA-SHAKE-256f-ipd|◒||◒|✅|◒|◒|✅|◒||||||◒|
|SLH-DSA-SHAKE-256s-ipd|✅||✅|✅|✅||✅|◒||||||✅|
|MLDSA44-RSA2048-PSS-SHA256||||||||||||||✅|
|MLDSA65-Ed25519-SHA512||||||||||||||✅|
|MLDSA87-ECDSA-P384-SHA512|✅||||||✅|✅||||||✅|
|MLDSA87-ECDSA-brainpoolP384r1-SHA512||||||||||||||✅|
|MLDSA87-Ed448-SHA512||||||||||||||✅|
|MLDSA44-RSA2048-PKCS15-SHA256|✅||||||✅|✅||||||✅|
|MLDSA44-Ed25519-SHA512||||||||||||||✅|
|MLDSA44-ECDSA-P256-SHA256|✅||||||✅|✅||||||✅|
|MLDSA44-ECDSA-brainpoolP256r1-SHA256||||||||||||||✅|
|MLDSA65-RSA3072-PSS-SHA512||||||||||||||⚪︎|
|MLDSA65-RSA3072-PKCS15-SHA512|✅||||||✅|✅||||||✅|
|MLDSA65-ECDSA-P256-SHA512|✅||||||✅|✅||||||✅|
|MLDSA65-ECDSA-brainpoolP256r1-SHA512||||||||||||||✅|

# ML-DSA-44-ipd (1.3.6.1.4.1.2.267.12.4.4)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅|✅|||✅|✅|
|botan|||||||||||
|carl-redhound||✅|✅|✅|✅|✅|||✅|✅|
|cht|||✅|||✅|||||
|corey-digicert||✅|✅|✅|✅|✅|||✅|✅|
|cryptonext||✅|✅|✅|✅|✅|||✅||
|cryptonext-cnsprovider||||||✅|||||
|entrust|||✅|||✅|||||
|isi-wolfssl|||||||||||
|kris||✅|✅|✅|✅|✅|||✅|❌|
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider||||||✅|||||

# ML-DSA-65-ipd (1.3.6.1.4.1.2.267.12.6.5)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅|✅|||✅|✅|
|botan|||||||||||
|carl-redhound||✅|✅|✅|✅|✅|||✅|✅|
|cht|||✅|||✅|||||
|corey-digicert||✅|✅|✅|✅|✅|||✅|✅|
|cryptonext||✅|✅|✅|✅|✅|||✅||
|cryptonext-cnsprovider||||||✅|||||
|entrust|||✅|||✅|||||
|isi-wolfssl|||||||||||
|kris||✅|✅|✅|✅|✅|||✅|❌|
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider||||||✅|||||

# ML-DSA-87-ipd (1.3.6.1.4.1.2.267.12.8.7)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅|✅|||✅|✅|
|botan|||||||||||
|carl-redhound||✅|✅|✅|✅|✅|||✅|✅|
|cht|||✅|||✅|||||
|corey-digicert||✅|✅|✅|✅|✅|||✅|✅|
|cryptonext||✅|✅|✅|✅|✅|||✅||
|cryptonext-cnsprovider||||||✅|||||
|entrust|||✅|||✅|||||
|isi-wolfssl|||||||||||
|kris||✅|✅|✅|✅|✅|||✅|❌|
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider||||||✅|||||

# ML-KEM-512-ipd (1.3.6.1.4.1.22554.5.6.1)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅|✅|||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert||||✅|✅|✅|||||
|cryptonext||||✅|✅|✅||✅|||
|cryptonext-cnsprovider||||||✅|||||
|entrust|||||||||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||||||||||

# ML-KEM-768-ipd (1.3.6.1.4.1.22554.5.6.2)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅|✅|||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert||||✅|✅|✅|||||
|cryptonext||||✅|✅|✅||✅|||
|cryptonext-cnsprovider||||||✅|||||
|entrust|||||||||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||||||||||

# ML-KEM-1024-ipd (1.3.6.1.4.1.22554.5.6.3)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||✅|✅|✅|||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert||||✅|✅|✅|||||
|cryptonext||||✅|✅|✅||✅|||
|cryptonext-cnsprovider||||||✅|||||
|entrust|||||||||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||||||||||

# Falcon-512 (1.3.9999.3.6)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||❌|
|botan|||||||||||
|carl-redhound||||✅|||||✅|❌|
|cht|||||||||||
|corey-digicert||✅||✅||||❌|✅|❌|
|cryptonext|||||||||||
|cryptonext-cnsprovider|||||||||||
|entrust|||||||✅||✅|❌|
|isi-wolfssl|||||||||||
|kris||||❌|||||✅|❌|
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||||||||✅|✅|

# Falcon-1024 (1.3.9999.3.9)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||❌|
|botan|||||||||||
|carl-redhound||||✅|||||✅|❌|
|cht|||||||||||
|corey-digicert||✅||✅||||❌|✅|❌|
|cryptonext|||||||||||
|cryptonext-cnsprovider|||||||||||
|entrust|||||||✅||✅|❌|
|isi-wolfssl|||||||||||
|kris||||❌|||||✅|❌|
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||||||||✅|✅|

# SLH-DSA-SHA2-128f-ipd (1.3.9999.6.4.13)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅||✅||||✅|
|botan|||||||||||
|carl-redhound||✅|✅|✅||✅||||✅|
|cht|||✅|||✅|||||
|corey-digicert||✅|✅|✅||✅||||✅|
|cryptonext|||||||||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||✅|||||✅|||❌|
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅|||✅||||✅|

# SLH-DSA-SHA2-128s-ipd (1.3.9999.6.4.16)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅||✅||||✅|
|botan|||||||||||
|carl-redhound||✅|✅|✅||✅||||✅|
|cht|||✅|||✅|||||
|corey-digicert||✅|✅|✅||✅||||✅|
|cryptonext|||||||||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||✅|||||✅|||❌|
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅|||✅||||✅|

# SLH-DSA-SHA2-192f-ipd (1.3.9999.6.5.10)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅||✅||||✅|
|botan|||||||||||
|carl-redhound||✅|✅|✅||✅||||✅|
|cht|||✅|||✅|||||
|corey-digicert||✅|✅|✅||✅||||✅|
|cryptonext|||||||||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||✅|||||✅|||❌|
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅|||✅||||✅|

# SLH-DSA-SHA2-192s-ipd (1.3.9999.6.5.12)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅||✅||||✅|
|botan|||||||||||
|carl-redhound||✅|✅|✅||✅||||✅|
|cht|||✅|||✅|||||
|corey-digicert||✅|✅|✅||✅||||✅|
|cryptonext|||||||||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||✅|||||✅|||❌|
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅|||||||✅|

# SLH-DSA-SHA2-256f-ipd (1.3.9999.6.6.10)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅||✅||||✅|
|botan|||||||||||
|carl-redhound||✅|✅|✅||✅||||✅|
|cht|||✅|||✅|||||
|corey-digicert||✅|✅|✅||✅||||✅|
|cryptonext|||||||||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||✅|||||✅|||❌|
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅|||||||✅|

# SLH-DSA-SHA2-256s-ipd (1.3.9999.6.6.12)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅||✅||||✅|
|botan|||||||||||
|carl-redhound||✅|✅|✅||✅||||✅|
|cht|||✅|||✅|||||
|corey-digicert||✅|✅|✅||✅||||✅|
|cryptonext|||||||||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||✅|||||✅|||❌|
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅|||||||✅|

# SLH-DSA-SHAKE-128f-ipd (1.3.9999.6.7.13)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|❌|✅||||✅|
|botan|||||||||||
|carl-redhound||✅|✅|✅|❌|✅||||✅|
|cht|||✅|||✅|||||
|corey-digicert||✅|✅|✅|❌|✅||||✅|
|cryptonext|||❌|❌|✅|✅|||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||✅|✅||❌|✅||||❌|
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅||❌|✅||||✅|

# SLH-DSA-SHAKE-128s-ipd (1.3.9999.6.7.16)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅||✅||||✅|
|botan|||||||||||
|carl-redhound||✅|✅|✅||✅||||✅|
|cht|||✅|||✅|||||
|corey-digicert||✅|✅|✅||✅||||✅|
|cryptonext|||||||||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||✅|✅|||✅||||❌|
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅|||||||✅|

# SLH-DSA-SHAKE-192f-ipd (1.3.9999.6.8.10)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|✅|✅||||✅|
|botan|||||||||||
|carl-redhound||✅|✅|✅|✅|✅||||✅|
|cht|||✅|||✅|||||
|corey-digicert||✅|✅|✅|✅|✅||||✅|
|cryptonext|||✅|✅|✅|✅|||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||✅|✅||✅|✅||||❌|
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅||✅|||||✅|

# SLH-DSA-SHAKE-192s-ipd (1.3.9999.6.8.12)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅||✅||||✅|
|botan|||||||||||
|carl-redhound||✅|✅|✅||✅||||✅|
|cht|||✅|||✅|||||
|corey-digicert||✅|✅|✅||✅||||✅|
|cryptonext|||||||||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||✅|✅|||✅||||❌|
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅|||||||✅|

# SLH-DSA-SHAKE-256f-ipd (1.3.9999.6.9.10)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅|❌|✅||||✅|
|botan|||||||||||
|carl-redhound||✅|✅|✅|❌|✅||||✅|
|cht|||✅|||✅|||||
|corey-digicert||✅|✅|✅|❌|✅||||✅|
|cryptonext|||❌|❌|✅|✅|||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||✅|✅||❌|✅||||❌|
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅||❌|||||✅|

# SLH-DSA-SHAKE-256s-ipd (1.3.9999.6.9.12)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅|✅|✅||✅||||✅|
|botan|||||||||||
|carl-redhound||✅|✅|✅||✅||||✅|
|cht|||✅|||✅|||||
|corey-digicert||✅|✅|✅||✅||||✅|
|cryptonext|||||||||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||✅|✅|||✅||||❌|
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅|||||||✅|

# MLDSA44-RSA2048-PSS-SHA256 (2.16.840.1.114027.80.8.1.1)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert|||||||||||
|cryptonext|||||||||||
|cryptonext-cnsprovider|||||||||||
|entrust|||||||||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅||||||||

# MLDSA65-Ed25519-SHA512 (2.16.840.1.114027.80.8.1.10)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert|||||||||||
|cryptonext|||||||||||
|cryptonext-cnsprovider|||||||||||
|entrust|||||||||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅||||||||

# MLDSA87-ECDSA-P384-SHA512 (2.16.840.1.114027.80.8.1.11)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||✅|||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert|||||||||||
|cryptonext|||||||||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||||||✅|||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅|||✅|||||

# MLDSA87-ECDSA-brainpoolP384r1-SHA512 (2.16.840.1.114027.80.8.1.12)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert|||||||||||
|cryptonext|||||||||||
|cryptonext-cnsprovider|||||||||||
|entrust|||||||||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅||||||||

# MLDSA87-Ed448-SHA512 (2.16.840.1.114027.80.8.1.13)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert|||||||||||
|cryptonext|||||||||||
|cryptonext-cnsprovider|||||||||||
|entrust|||||||||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅||||||||

# MLDSA44-RSA2048-PKCS15-SHA256 (2.16.840.1.114027.80.8.1.2)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||✅|||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert|||||||||||
|cryptonext|||||||||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||||||✅|||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅|||✅|||||

# MLDSA44-Ed25519-SHA512 (2.16.840.1.114027.80.8.1.3)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert|||||||||||
|cryptonext|||||||||||
|cryptonext-cnsprovider|||||||||||
|entrust|||||||||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅||||||||

# MLDSA44-ECDSA-P256-SHA256 (2.16.840.1.114027.80.8.1.4)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||✅|||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert|||||||||||
|cryptonext|||||||||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||||||✅|||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅|||✅|||||

# MLDSA44-ECDSA-brainpoolP256r1-SHA256 (2.16.840.1.114027.80.8.1.5)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert|||||||||||
|cryptonext|||||||||||
|cryptonext-cnsprovider|||||||||||
|entrust|||||||||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅||||||||

# MLDSA65-RSA3072-PSS-SHA512 (2.16.840.1.114027.80.8.1.6)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert|||||||||||
|cryptonext|||||||||||
|cryptonext-cnsprovider|||||||||||
|entrust|||||||||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||❌||||||||

# MLDSA65-RSA3072-PKCS15-SHA512 (2.16.840.1.114027.80.8.1.7)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||✅|||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert|||||||||||
|cryptonext|||||||||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||||||✅|||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅|||✅|||||

# MLDSA65-ECDSA-P256-SHA512 (2.16.840.1.114027.80.8.1.8)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||✅|||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert|||||||||||
|cryptonext|||||||||||
|cryptonext-cnsprovider||||||✅|||||
|entrust||||||✅|||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅|||✅|||||

# MLDSA65-ECDSA-brainpoolP256r1-SHA512 (2.16.840.1.114027.80.8.1.9)


Rows are producers. Columns are parsers.

|-|bc|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||
|botan|||||||||||
|carl-redhound|||||||||||
|cht|||||||||||
|corey-digicert|||||||||||
|cryptonext|||||||||||
|cryptonext-cnsprovider|||||||||||
|entrust|||||||||||
|isi-wolfssl|||||||||||
|kris|||||||||||
|openca|||||||||||
|oqs-gnutls|||||||||||
|oqs-openssl111|||||||||||
|oqs-provider|||✅||||||||
