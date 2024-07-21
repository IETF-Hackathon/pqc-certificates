
IETF PQC Hackathon Certificate Interoperability Results
=======================================================

Algorithms
==========

* [Algorithms Tested](#algorithms-tested)
* [ML-DSA-44-ipd (1.3.6.1.4.1.2.267.12.4.4)](#ml-dsa-44-ipd-13614122671244)
* [ML-DSA-65-ipd (1.3.6.1.4.1.2.267.12.6.5)](#ml-dsa-65-ipd-13614122671265)
* [ML-DSA-87-ipd (1.3.6.1.4.1.2.267.12.8.7)](#ml-dsa-87-ipd-13614122671287)
* [ML-KEM-512-ipd (1.3.6.1.4.1.22554.5.6.1)](#ml-kem-512-ipd-13614122554561)
* [ML-KEM-768-ipd (1.3.6.1.4.1.22554.5.6.2)](#ml-kem-768-ipd-13614122554562)
* [ML-KEM-1024-ipd (1.3.6.1.4.1.22554.5.6.3)](#ml-kem-1024-ipd-13614122554563)
* [Falcon-512 (1.3.9999.3.6)](#falcon-512-13999936)
* [Falcon-1024 (1.3.9999.3.9)](#falcon-1024-13999939)
* [SLH-DSA-SHA2-128f-ipd (1.3.9999.6.4.13)](#slh-dsa-sha2-128f-ipd-1399996413)
* [SLH-DSA-SHA2-128s-ipd (1.3.9999.6.4.16)](#slh-dsa-sha2-128s-ipd-1399996416)
* [SLH-DSA-SHA2-192f-ipd (1.3.9999.6.5.10)](#slh-dsa-sha2-192f-ipd-1399996510)
* [SLH-DSA-SHA2-192s-ipd (1.3.9999.6.5.12)](#slh-dsa-sha2-192s-ipd-1399996512)
* [SLH-DSA-SHA2-256f-ipd (1.3.9999.6.6.10)](#slh-dsa-sha2-256f-ipd-1399996610)
* [SLH-DSA-SHA2-256s-ipd (1.3.9999.6.6.12)](#slh-dsa-sha2-256s-ipd-1399996612)
* [SLH-DSA-SHAKE-128f-ipd (1.3.9999.6.7.13)](#slh-dsa-shake-128f-ipd-1399996713)
* [SLH-DSA-SHAKE-128s-ipd (1.3.9999.6.7.16)](#slh-dsa-shake-128s-ipd-1399996716)
* [SLH-DSA-SHAKE-192f-ipd (1.3.9999.6.8.10)](#slh-dsa-shake-192f-ipd-1399996810)
* [SLH-DSA-SHAKE-192s-ipd (1.3.9999.6.8.12)](#slh-dsa-shake-192s-ipd-1399996812)
* [SLH-DSA-SHAKE-256f-ipd (1.3.9999.6.9.10)](#slh-dsa-shake-256f-ipd-1399996910)
* [SLH-DSA-SHAKE-256s-ipd (1.3.9999.6.9.12)](#slh-dsa-shake-256s-ipd-1399996912)


<style> table { border-collapse: collapse; } th, td { border: solid black 1px; padding: 0 1ex; } </style>

In the individual algorithm tables below, Rows are producers. Columns are parsers.

# Algorithms Tested


To be in this table, an algorithm must have a test result in one of the tables below (pass or fail). Algorithms for which we have artifacts but no test results are not shown.

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|ML-DSA-44-ipd|✅||✅|✅|✅|✅|✅|✅||✅||||||
|ML-DSA-65-ipd|✅||✅|✅|✅|✅|✅|✅||✅||||||
|ML-DSA-87-ipd|✅||✅|✅|✅|✅|✅|✅||✅||||||
|ML-KEM-512-ipd|✅||||✅|✅|✅|||||||||
|ML-KEM-768-ipd|✅||||✅|✅|✅|||||||||
|ML-KEM-1024-ipd|✅||||✅|✅|✅|||||||||
|Falcon-512|✅||✅||✅|||✅||✅||||✅||
|Falcon-1024|✅||✅||✅|||✅||✅||||✅||
|SLH-DSA-SHA2-128f-ipd|✅||✅|✅|✅||✅|✅||||||✅|✅|
|SLH-DSA-SHA2-128s-ipd|✅||✅|✅|✅||✅|✅||||||✅|✅|
|SLH-DSA-SHA2-192f-ipd|✅||✅|✅|✅||✅|✅||||||✅|✅|
|SLH-DSA-SHA2-192s-ipd|✅||✅|✅|✅||✅|✅||||||✅|✅|
|SLH-DSA-SHA2-256f-ipd|✅||✅|✅|✅||✅|✅||||||✅|✅|
|SLH-DSA-SHA2-256s-ipd|✅||✅|✅|✅||✅|✅||||||✅|✅|
|SLH-DSA-SHAKE-128f-ipd|✅||✅|✅|✅|✅|✅|✅||||||✅|✅|
|SLH-DSA-SHAKE-128s-ipd|✅||✅|✅|✅||✅|✅||||||✅|✅|
|SLH-DSA-SHAKE-192f-ipd|✅||✅|✅|✅|✅|✅|✅||||||✅|✅|
|SLH-DSA-SHAKE-192s-ipd|✅||✅|✅|✅||✅|✅||||||✅|✅|
|SLH-DSA-SHAKE-256f-ipd|✅||✅|✅|✅|✅|✅|✅||||||✅|✅|
|SLH-DSA-SHAKE-256s-ipd|✅||✅|✅|✅||✅|✅||||||✅|✅|

# ML-DSA-44-ipd (1.3.6.1.4.1.2.267.12.4.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅|✅|✅|||✅||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅|✅|✅|||✅||||✅||
|cht||||✅|||✅|||||||||
|corey-digicert|||✅|✅|✅|✅|✅|||✅||||✅||
|cryptonext|||✅|✅|✅|✅|✅|||✅||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust||||✅||||||||||||
|isi-wolfssl||||||||||||||||
|kris|||✅|✅|✅|✅|✅|||✅||||❌||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# ML-DSA-65-ipd (1.3.6.1.4.1.2.267.12.6.5)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅|✅|✅|||✅||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅|✅|✅|||✅||||✅||
|cht||||✅|||✅|||||||||
|corey-digicert|||✅|✅|✅|✅|✅|||✅||||✅||
|cryptonext|||✅|✅|✅|✅|✅|||✅||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust||||✅||||||||||||
|isi-wolfssl||||||||||||||||
|kris|||✅|✅|✅|✅|✅|||✅||||❌||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# ML-DSA-87-ipd (1.3.6.1.4.1.2.267.12.8.7)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅|✅|✅|||✅||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅|✅|✅|||✅||||✅||
|cht||||✅|||✅|||||||||
|corey-digicert|||✅|✅|✅|✅|✅|||✅||||✅||
|cryptonext|||✅|✅|✅|✅|✅|||✅||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust||||✅||||||||||||
|isi-wolfssl||||||||||||||||
|kris|||✅|✅|✅|✅|✅|||✅||||❌||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# ML-KEM-512-ipd (1.3.6.1.4.1.22554.5.6.1)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||||✅|✅|✅|||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert|||||✅|✅|✅|||||||||
|cryptonext|||||✅|✅|✅||✅|||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# ML-KEM-768-ipd (1.3.6.1.4.1.22554.5.6.2)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||||✅|✅|✅|||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert|||||✅|✅|✅|||||||||
|cryptonext|||||✅|✅|✅||✅|||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# ML-KEM-1024-ipd (1.3.6.1.4.1.22554.5.6.3)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||||✅|✅|✅|||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert|||||✅|✅|✅|||||||||
|cryptonext|||||✅|✅|✅||✅|||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# Falcon-512 (1.3.9999.3.6)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||||❌||
|botan||||||||||||||||
|carl-redhound|||||✅|||||✅||||❌||
|cht||||||||||||||||
|corey-digicert|||✅||✅||||❌|✅||||❌||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||✅||✅||||❌||
|isi-wolfssl||||||||||||||||
|kris|||||❌|||||✅||||❌||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||✅||||✅||
|oqsprovider||||||||||||||||

# Falcon-1024 (1.3.9999.3.9)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||||❌||
|botan||||||||||||||||
|carl-redhound|||||✅|||||✅||||❌||
|cht||||||||||||||||
|corey-digicert|||✅||✅||||❌|✅||||❌||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||✅||✅||||❌||
|isi-wolfssl||||||||||||||||
|kris|||||❌|||||✅||||❌||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||✅||||✅||
|oqsprovider||||||||||||||||

# SLH-DSA-SHA2-128f-ipd (1.3.9999.6.4.13)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅||✅|||||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅||✅|||||||✅||
|cht||||✅|||✅|||||||||
|corey-digicert|||✅|✅|✅||✅|||||||✅||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|||✅||||✅|✅||||||❌||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider|||||||✅|||||||✅||
|oqsprovider||||✅||||||||||||

# SLH-DSA-SHA2-128s-ipd (1.3.9999.6.4.16)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅||✅|||||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅||✅|||||||✅||
|cht||||✅|||✅|||||||||
|corey-digicert|||✅|✅|✅||✅|||||||✅||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|||✅||||✅|✅||||||❌||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider|||||||✅|||||||✅||
|oqsprovider||||✅||||||||||||

# SLH-DSA-SHA2-192f-ipd (1.3.9999.6.5.10)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅||✅|||||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅||✅|||||||✅||
|cht||||✅|||✅|||||||||
|corey-digicert|||✅|✅|✅||✅|||||||✅||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|||✅||||✅|✅||||||❌||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider|||||||✅|||||||✅||
|oqsprovider||||✅||||||||||||

# SLH-DSA-SHA2-192s-ipd (1.3.9999.6.5.12)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅||✅|||||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅||✅|||||||✅||
|cht||||✅|||✅|||||||||
|corey-digicert|||✅|✅|✅||✅|||||||✅||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|||✅||||✅|✅||||||❌||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider|||||||✅|||||||✅||
|oqsprovider||||✅||||||||||||

# SLH-DSA-SHA2-256f-ipd (1.3.9999.6.6.10)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅||✅|||||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅||✅|||||||✅||
|cht||||✅|||✅|||||||||
|corey-digicert|||✅|✅|✅||✅|||||||✅||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|||✅||||✅|✅||||||❌||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider|||||||✅|||||||✅||
|oqsprovider||||✅||||||||||||

# SLH-DSA-SHA2-256s-ipd (1.3.9999.6.6.12)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅||✅|||||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅||✅|||||||✅||
|cht||||✅|||✅|||||||||
|corey-digicert|||✅|✅|✅||✅|||||||✅||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|||✅||||✅|✅||||||❌||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider|||||||✅|||||||✅||
|oqsprovider||||✅||||||||||||

# SLH-DSA-SHAKE-128f-ipd (1.3.9999.6.7.13)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅|❌|✅|||||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅|❌|✅|||||||✅||
|cht||||✅|||✅|||||||||
|corey-digicert|||✅|✅|✅|❌|✅|||||||✅||
|cryptonext||||❌|❌|✅|✅|||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|||✅|✅||❌|✅|||||||❌||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||❌|✅|||||||✅||
|oqsprovider||||✅||||||||||||

# SLH-DSA-SHAKE-128s-ipd (1.3.9999.6.7.16)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅||✅|||||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅||✅|||||||✅||
|cht||||✅|||✅|||||||||
|corey-digicert|||✅|✅|✅||✅|||||||✅||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|||✅|✅|||✅|||||||❌||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider|||||||✅|||||||✅||
|oqsprovider||||✅||||||||||||

# SLH-DSA-SHAKE-192f-ipd (1.3.9999.6.8.10)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅|✅|✅|||||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅|✅|✅|||||||✅||
|cht||||✅|||✅|||||||||
|corey-digicert|||✅|✅|✅|✅|✅|||||||✅||
|cryptonext||||✅|✅|✅|✅|||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|||✅|✅||✅|✅|||||||❌||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||✅|✅|||||||✅||
|oqsprovider||||✅||||||||||||

# SLH-DSA-SHAKE-192s-ipd (1.3.9999.6.8.12)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅||✅|||||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅||✅|||||||✅||
|cht||||✅|||✅|||||||||
|corey-digicert|||✅|✅|✅||✅|||||||✅||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|||✅|✅|||✅|||||||❌||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider|||||||✅|||||||✅||
|oqsprovider||||✅||||||||||||

# SLH-DSA-SHAKE-256f-ipd (1.3.9999.6.9.10)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅|❌|✅|||||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅|❌|✅|||||||✅||
|cht||||✅|||✅|||||||||
|corey-digicert|||✅|✅|✅|❌|✅|||||||✅||
|cryptonext||||❌|❌|✅|✅|||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|||✅|✅||❌|✅|||||||❌||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||❌|✅|||||||✅||
|oqsprovider||||✅||||||||||||

# SLH-DSA-SHAKE-256s-ipd (1.3.9999.6.9.12)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅||✅|||||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅||✅|||||||✅||
|cht||||✅|||✅|||||||||
|corey-digicert|||✅|✅|✅||✅|||||||✅||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|||✅|✅|||✅|||||||❌||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider|||||||✅|||||||✅||
|oqsprovider||||✅||||||||||||
