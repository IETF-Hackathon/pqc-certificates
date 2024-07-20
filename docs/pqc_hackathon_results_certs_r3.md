
IETF PQC Hackathon Certificate Interoperability Results
=======================================================

Algorithms
==========

* [Algorithms Tested](#algorithms-tested)
* [ecPublicKey (1.2.840.10045.2.1)](#ecpublickey-128401004521)
* [rsaEncryption (1.2.840.113549.1.1.1)](#rsaencryption-12840113549111)
* [ED448 (1.3.101.113)](#ed448-13101113)
* [~~DilithiumAES2~~ (1.3.6.1.4.1.2.267.11.4.4)](#dilithiumaes2-13614122671144)
* [ML-DSA-44-ipd (1.3.6.1.4.1.2.267.12.4.4)](#ml-dsa-44-ipd-13614122671244)
* [ML-DSA-65-ipd (1.3.6.1.4.1.2.267.12.6.5)](#ml-dsa-65-ipd-13614122671265)
* [ML-DSA-87-ipd (1.3.6.1.4.1.2.267.12.8.7)](#ml-dsa-87-ipd-13614122671287)
* [~~Dilithium2~~ (1.3.6.1.4.1.2.267.7.4.4)](#dilithium2-1361412267744)
* [~~Dilithium3~~ (1.3.6.1.4.1.2.267.7.6.5)](#dilithium3-1361412267765)
* [~~Dilithium5~~ (1.3.6.1.4.1.2.267.7.8.7)](#dilithium5-1361412267787)
* [NTRUHPS2048677 (1.3.6.1.4.1.22554.5.5.2)](#ntruhps2048677-13614122554552)
* [NTRUHPS4096821 (1.3.6.1.4.1.22554.5.5.3)](#ntruhps4096821-13614122554553)
* [NTRUHRSS701 (1.3.6.1.4.1.22554.5.5.4)](#ntruhrss701-13614122554554)
* [ML-KEM-512-ipd (1.3.6.1.4.1.22554.5.6.1)](#ml-kem-512-ipd-13614122554561)
* [ML-KEM-768-ipd (1.3.6.1.4.1.22554.5.6.2)](#ml-kem-768-ipd-13614122554562)
* [ML-KEM-1024-ipd (1.3.6.1.4.1.22554.5.6.3)](#ml-kem-1024-ipd-13614122554563)
* [~~kyber512_shake~~ (1.3.6.1.4.1.22554.5.6.7)](#kyber512_shake-13614122554567)
* [~~kyber768_shake~~ (1.3.6.1.4.1.22554.5.6.8)](#kyber768_shake-13614122554568)
* [~~kyber1024_shake~~ (1.3.6.1.4.1.22554.5.6.9)](#kyber1024_shake-13614122554569)
* [1.3.6.1.4.1.59634.9999.2.2.1 (1.3.6.1.4.1.59634.9999.2.2.1)](#136141596349999221-136141596349999221)
* [1.3.6.1.4.1.59634.9999.2.2.2 (1.3.6.1.4.1.59634.9999.2.2.2)](#136141596349999222-136141596349999222)
* [1.3.6.1.4.1.59634.9999.2.2.3 (1.3.6.1.4.1.59634.9999.2.2.3)](#136141596349999223-136141596349999223)
* [1.3.9999.2.7.2 (1.3.9999.2.7.2)](#139999272-139999272)
* [1.3.9999.2.7.4 (1.3.9999.2.7.4)](#139999274-139999274)
* [~~Falcon-512~~ (1.3.9999.3.1)](#falcon-512-13999931)
* [~~Falcon-1024~~ (1.3.9999.3.4)](#falcon-1024-13999934)
* [Falcon-512 (1.3.9999.3.6)](#falcon-512-13999936)
* [Falcon-1024 (1.3.9999.3.9)](#falcon-1024-13999939)
* [~~SPHINCS+-SHA256-128f-robust~~ (1.3.9999.6.4.1)](#sphincs-sha256-128f-robust-139999641)
* [SLH-DSA-SHA2-128f-ipd (1.3.9999.6.4.13)](#slh-dsa-sha2-128f-ipd-1399996413)
* [SLH-DSA-SHA2-128s-ipd (1.3.9999.6.4.16)](#slh-dsa-sha2-128s-ipd-1399996416)
* [SLH-DSA-SHA2-192f-ipd (1.3.9999.6.5.10)](#slh-dsa-sha2-192f-ipd-1399996510)
* [SLH-DSA-SHA2-192s-ipd (1.3.9999.6.5.12)](#slh-dsa-sha2-192s-ipd-1399996512)
* [SLH-DSA-SHA2-256f-ipd (1.3.9999.6.6.10)](#slh-dsa-sha2-256f-ipd-1399996610)
* [SLH-DSA-SHA2-256s-ipd (1.3.9999.6.6.12)](#slh-dsa-sha2-256s-ipd-1399996612)
* [SLH-DSA-SHAKE-128f-ipd (1.3.9999.6.7.13)](#slh-dsa-shake-128f-ipd-1399996713)
* [SLH-DSA-SHAKE-128s-ipd (1.3.9999.6.7.16)](#slh-dsa-shake-128s-ipd-1399996716)
* [1.3.9999.6.7.4 (1.3.9999.6.7.4)](#139999674-139999674)
* [SLH-DSA-SHAKE-192f-ipd (1.3.9999.6.8.10)](#slh-dsa-shake-192f-ipd-1399996810)
* [SLH-DSA-SHAKE-192s-ipd (1.3.9999.6.8.12)](#slh-dsa-shake-192s-ipd-1399996812)
* [1.3.9999.6.8.3 (1.3.9999.6.8.3)](#139999683-139999683)
* [SLH-DSA-SHAKE-256f-ipd (1.3.9999.6.9.10)](#slh-dsa-shake-256f-ipd-1399996910)
* [SLH-DSA-SHAKE-256s-ipd (1.3.9999.6.9.12)](#slh-dsa-shake-256s-ipd-1399996912)
* [1.3.9999.6.9.3 (1.3.9999.6.9.3)](#139999693-139999693)
* [id-Dilithium3-RSA-PKCS15-SHA256 (2.16.840.1.114027.80.5.1.1)](#id-dilithium3-rsa-pkcs15-sha256-216840111402780511)
* [id-Dilithium3-RSA-PSS-SHA256 (2.16.840.1.114027.80.5.1.14)](#id-dilithium3-rsa-pss-sha256-2168401114027805114)
* [id-Dilithium3-ECDSA-P256-SHA256 (2.16.840.1.114027.80.5.1.2)](#id-dilithium3-ecdsa-p256-sha256-216840111402780512)
* [id-Dilithium3-ECDSA-brainpoolP256r1-SHA256 (2.16.840.1.114027.80.5.1.3)](#id-dilithium3-ecdsa-brainpoolp256r1-sha256-216840111402780513)
* [id-Dilithium5-ECDSA-P384-SHA384 (2.16.840.1.114027.80.5.1.5)](#id-dilithium5-ecdsa-p384-sha384-216840111402780515)
* [id-Dilithium5-ECDSA-brainpoolP384r1-SHA384 (2.16.840.1.114027.80.5.1.6)](#id-dilithium5-ecdsa-brainpoolp384r1-sha384-216840111402780516)
* [~~id-Falcon512-ECDSA-P256-SHA256~~ (2.16.840.1.114027.80.5.1.8)](#id-falcon512-ecdsa-p256-sha256-216840111402780518)
* [~~id-Falcon512-ECDSA-brainpoolP256r1-SHA256~~ (2.16.840.1.114027.80.5.1.9)](#id-falcon512-ecdsa-brainpoolp256r1-sha256-216840111402780519)
* [catalyst (catalyst_1.2.840.10045.4.3.2_with_1.3.6.1.4.1.2.267.12.4.4)](#catalyst-catalyst_1284010045432_with_13614122671244)
* [catalyst (catalyst_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.12.8.7)](#catalyst-catalyst_1284010045434_with_13614122671287)
* [catalyst (catalyst_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.7.8.7)](#catalyst-catalyst_1284010045434_with_1361412267787)
* [catalyst (catalyst_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.12.4.4)](#catalyst-catalyst_128401135491111_with_13614122671244)
* [catalyst (catalyst_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.7.4.4)](#catalyst-catalyst_128401135491111_with_1361412267744)
* [chameleon (chameleon_1.2.840.10045.4.3.2_with_1.3.6.1.4.1.2.267.12.4.4)](#chameleon-chameleon_1284010045432_with_13614122671244)
* [chameleon (chameleon_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.12.8.7)](#chameleon-chameleon_1284010045434_with_13614122671287)
* [chameleon (chameleon_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.12.4.4)](#chameleon-chameleon_128401135491111_with_13614122671244)
* [composite (composite_1.2.840.10045.4.3.2_with_1.3.6.1.4.1.2.267.12.4.4)](#composite-composite_1284010045432_with_13614122671244)
* [composite (composite_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.12.8.7)](#composite-composite_1284010045434_with_13614122671287)
* [composite (composite_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.7.8.7)](#composite-composite_1284010045434_with_1361412267787)
* [composite (composite_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.12.4.4)](#composite-composite_128401135491111_with_13614122671244)
* [composite (composite_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.7.4.4)](#composite-composite_128401135491111_with_1361412267744)
* [hybrid-catalyst (hybrid-catalyst)](#hybrid-catalyst-hybrid-catalyst)
* [hybrid[catalyst(1.2.840.10045.4.3.2 (hybrid[catalyst(1.2.840.10045.4.3.2)](#hybridcatalyst1284010045432-hybridcatalyst1284010045432)
* [hybrid[catalyst(1.2.840.10045.4.3.4 (hybrid[catalyst(1.2.840.10045.4.3.4)](#hybridcatalyst1284010045434-hybridcatalyst1284010045434)
* [hybrid[catalyst(1.2.840.113549.1.1.11 (hybrid[catalyst(1.2.840.113549.1.1.11)](#hybridcatalyst128401135491111-hybridcatalyst128401135491111)
* [hybrid[chameleon(1.2.840.10045.4.3.2 (hybrid[chameleon(1.2.840.10045.4.3.2)](#hybridchameleon1284010045432-hybridchameleon1284010045432)
* [hybrid[chameleon(1.2.840.10045.4.3.4 (hybrid[chameleon(1.2.840.10045.4.3.4)](#hybridchameleon1284010045434-hybridchameleon1284010045434)
* [hybrid[chameleon(1.2.840.113549.1.1.11 (hybrid[chameleon(1.2.840.113549.1.1.11)](#hybridchameleon128401135491111-hybridchameleon128401135491111)
* [hybrid[composite(1.2.840.10045.4.3.2 (hybrid[composite(1.2.840.10045.4.3.2)](#hybridcomposite1284010045432-hybridcomposite1284010045432)
* [hybrid[composite(1.2.840.10045.4.3.4 (hybrid[composite(1.2.840.10045.4.3.4)](#hybridcomposite1284010045434-hybridcomposite1284010045434)
* [hybrid[composite(1.2.840.113549.1.1.11 (hybrid[composite(1.2.840.113549.1.1.11)](#hybridcomposite128401135491111-hybridcomposite128401135491111)


<style> table { border-collapse: collapse; } th, td { border: solid black 1px; padding: 0 1ex; } </style>

In the individual algorithm tables below, Rows are producers. Columns are parsers.

# Algorithms Tested


To be in this table, an algorithm must have a test result in one of the tables below (pass or fail). Algorithms for which we have artifacts but no test results are not shown.

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|ecPublicKey||||||✅|✅|||||||||
|rsaEncryption||||||✅|✅|||||||||
|ED448|||||||✅|||||||✅||
|ML-DSA-44-ipd|✅||✅|✅|✅|✅|✅|✅||✅||||||
|ML-DSA-65-ipd|✅||✅|✅|✅|✅|✅|✅||✅||||||
|ML-DSA-87-ipd|✅||✅|✅|✅|✅|✅|✅||✅||||||
|~~Dilithium2~~|✅|✅|✅||✅|✅|✅|✅||✅|✅||✅|✅||
|~~Dilithium3~~|✅|✅|✅||✅|✅|✅|✅||✅|✅|✅|✅|✅||
|~~Dilithium5~~|✅|✅|✅||✅|✅|✅|✅||✅|✅||✅|✅||
|NTRUHPS2048677|✅|||||||||||||||
|NTRUHPS4096821|✅|||||||||||||||
|NTRUHRSS701|✅|||||||||||||||
|ML-KEM-512-ipd|✅||||✅|✅|✅|||||||||
|ML-KEM-768-ipd|✅||||✅|✅|✅|||||||||
|ML-KEM-1024-ipd|✅||||✅|✅|✅|||||||||
|~~kyber512_shake~~||||||✅|✅|||||||||
|~~kyber768_shake~~||||||✅|✅|||||||||
|~~kyber1024_shake~~||||||✅|✅|||||||||
|1.3.6.1.4.1.59634.9999.2.2.1||||||✅||||||||||
|1.3.6.1.4.1.59634.9999.2.2.2||||||✅||||||||||
|1.3.6.1.4.1.59634.9999.2.2.3||||||✅||||||||||
|1.3.9999.2.7.2||||||✅||||||||||
|1.3.9999.2.7.4||||||✅||||||||||
|~~Falcon-512~~|✅||✅||✅|✅|✅|✅||✅|✅||✅|✅||
|~~Falcon-1024~~|✅||✅||✅|✅|✅|✅||✅|✅||✅|✅||
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
|1.3.9999.6.7.4||||||✅||||||||||
|SLH-DSA-SHAKE-192f-ipd|✅||✅|✅|✅|✅|✅|✅||||||✅|✅|
|SLH-DSA-SHAKE-192s-ipd|✅||✅|✅|✅||✅|✅||||||✅|✅|
|1.3.9999.6.8.3||||||✅||||||||||
|SLH-DSA-SHAKE-256f-ipd|✅||✅|✅|✅|✅|✅|✅||||||✅|✅|
|SLH-DSA-SHAKE-256s-ipd|✅||✅|✅|✅||✅|✅||||||✅|✅|
|1.3.9999.6.9.3||||||✅||||||||||
|id-Dilithium3-RSA-PKCS15-SHA256||||||||✅||||||||
|id-Dilithium3-RSA-PSS-SHA256||||||||✅||||||||
|id-Dilithium3-ECDSA-P256-SHA256||||||||✅||||||||
|id-Dilithium3-ECDSA-brainpoolP256r1-SHA256||||||||✅||||||||
|id-Dilithium5-ECDSA-P384-SHA384||||||||✅||||||||
|id-Dilithium5-ECDSA-brainpoolP384r1-SHA384||||||||✅||||||||
|~~id-Falcon512-ECDSA-P256-SHA256~~||||||||✅||||||||
|~~id-Falcon512-ECDSA-brainpoolP256r1-SHA256~~||||||||✅||||||||
|catalyst||||||✅||||||||||
|catalyst||||||✅||||||||||
|composite|✅|||||||||||||✅||
|composite||||||✅||||||||||
|composite||||||✅||||||||||
|hybrid-catalyst|||||✅|||||||||||
|hybrid[catalyst(1.2.840.10045.4.3.2|✅|||||||||||||||
|hybrid[catalyst(1.2.840.10045.4.3.4|✅|||||||||||||||
|hybrid[catalyst(1.2.840.113549.1.1.11|✅|||||||||||||||
|hybrid[chameleon(1.2.840.10045.4.3.2|✅|||||||||||||||
|hybrid[chameleon(1.2.840.10045.4.3.4|✅|||||||||||||||
|hybrid[chameleon(1.2.840.113549.1.1.11|✅|||||||||||||||
|hybrid[composite(1.2.840.10045.4.3.2|✅|||||||||||||||
|hybrid[composite(1.2.840.10045.4.3.4|✅|||||||||||||||
|hybrid[composite(1.2.840.113549.1.1.11|✅|||||||||||||||

# ecPublicKey (1.2.840.10045.2.1)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||✅|✅|||✅||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# rsaEncryption (1.2.840.113549.1.1.1)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||✅|✅|||✅||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# ED448 (1.3.101.113)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider|||||||✅|||✅||||✅||
|oqsprovider||||||||||||||||

# ~~DilithiumAES2~~ (1.3.6.1.4.1.2.267.11.4.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# ML-DSA-44-ipd (1.3.6.1.4.1.2.267.12.4.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅|✅|✅|||✅||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅|✅|✅|||✅||||✅||
|cht||||✅||||||||||||
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
|cht||||✅||||||||||||
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
|cht||||✅||||||||||||
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

# ~~Dilithium2~~ (1.3.6.1.4.1.2.267.7.4.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||||||✅|✅|||||||
|botan|❌|✅||||✅|✅||✅|✅||||✅||
|carl-redhound|✅|❌||||||✅|✅|||||||
|cht||||||||||||||||
|corey-digicert|✅|✅||||||✅|❌|||||||
|cryptonext||✅||||✅|✅|✅|✅|✅||||❌||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|❌|✅||||✅|✅|✅||✅||||❌||
|isi-wolfssl||||||||||||||||
|kris|❌|❌||||✅|✅|❌|❌|✅||||❌||
|openca|❌|❌||||❌|✅|❌|❌|✅||||✅||
|oqs-gnutls||||||||||||||||
|oqs-openssl111|✅|✅||||✅|✅|❌|❌|❌||||||
|oqs-provider|✅|✅||||✅|✅|❌|❌|✅||||✅||
|oqsprovider||||||||||||||||

# ~~Dilithium3~~ (1.3.6.1.4.1.2.267.7.6.5)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||||||✅|✅|||||||
|botan|❌|✅|||||||✅|||||||
|carl-redhound|✅|❌||||||✅|✅|||||||
|cht||||||||||||||||
|corey-digicert|✅|✅||||||✅|❌|||||||
|cryptonext||✅||||✅|✅|✅|✅|✅||||❌||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|❌|✅||||✅|✅|✅||✅||||❌||
|isi-wolfssl||||||||||||||||
|kris|❌|❌||||✅|✅|❌|❌|✅||||❌||
|openca|❌|❌||||❌|✅|❌|❌|✅||||✅||
|oqs-gnutls|❌|✅||||✅|✅|✅|✅|✅||||❌||
|oqs-openssl111|✅|✅||||✅|✅|❌|❌|❌||||||
|oqs-provider|✅|✅||||✅|✅|❌|❌|✅||||✅||
|oqsprovider||||||||||||||||

# ~~Dilithium5~~ (1.3.6.1.4.1.2.267.7.8.7)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||||||✅|✅|||||||
|botan|❌|✅||||✅|✅||✅|✅||||✅||
|carl-redhound|✅|❌||||||✅|✅|||||||
|cht||||||||||||||||
|corey-digicert|✅|✅||||||✅|❌|||||||
|cryptonext||✅||||✅|✅|✅|✅|✅||||❌||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|❌|✅||||✅|✅|✅||✅||||❌||
|isi-wolfssl||||||||||||||||
|kris|❌|❌||||✅|✅|❌|❌|✅||||❌||
|openca|❌|❌||||❌|✅|❌|❌|✅||||✅||
|oqs-gnutls||||||||||||||||
|oqs-openssl111|✅|✅||||✅|✅|❌|❌|❌||||||
|oqs-provider|✅|✅||||✅|✅|❌|❌|✅||||✅||
|oqsprovider||||||||||||||||

# NTRUHPS2048677 (1.3.6.1.4.1.22554.5.5.2)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# NTRUHPS4096821 (1.3.6.1.4.1.22554.5.5.3)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# NTRUHRSS701 (1.3.6.1.4.1.22554.5.5.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
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

# ~~kyber512_shake~~ (1.3.6.1.4.1.22554.5.6.7)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||✅|✅|||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# ~~kyber768_shake~~ (1.3.6.1.4.1.22554.5.6.8)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||✅|✅|||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# ~~kyber1024_shake~~ (1.3.6.1.4.1.22554.5.6.9)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||✅|✅|||||||||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# 1.3.6.1.4.1.59634.9999.2.2.1 (1.3.6.1.4.1.59634.9999.2.2.1)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||❌|✅|||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# 1.3.6.1.4.1.59634.9999.2.2.2 (1.3.6.1.4.1.59634.9999.2.2.2)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||❌|✅|||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# 1.3.6.1.4.1.59634.9999.2.2.3 (1.3.6.1.4.1.59634.9999.2.2.3)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||❌|✅|||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# 1.3.9999.2.7.2 (1.3.9999.2.7.2)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||✅||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# 1.3.9999.2.7.4 (1.3.9999.2.7.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||✅||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# ~~Falcon-512~~ (1.3.9999.3.1)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||❌|||||||✅|||||||
|botan||||||||||||||||
|carl-redhound|✅|❌||||||✅|✅|||||||
|cht||||||||||||||||
|corey-digicert|✅|❌||||||✅||||||||
|cryptonext||❌||||✅|✅|❌|❌|||||❌||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|❌|❌||||||||||||||
|isi-wolfssl||||||||||||||||
|kris|❌|❌||||||❌|❌|||||||
|openca|❌|❌||||❌|✅|❌|❌|||||❌||
|oqs-gnutls||||||||||||||||
|oqs-openssl111|✅|❌||||❌|✅|❌|❌|||||||
|oqs-provider|✅|❌||||||❌|❌|||||||
|oqsprovider||||||||||||||||

# ~~Falcon-1024~~ (1.3.9999.3.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||❌||||||✅|✅|||||||
|botan||||||||||||||||
|carl-redhound|✅|❌||||||✅|✅|||||||
|cht||||||||||||||||
|corey-digicert|✅|❌||||||✅||||||||
|cryptonext||❌||||✅|✅|❌|❌|||||❌||
|cryptonext-cnsprovider|||||||✅|||||||||
|entrust|❌|❌||||||||||||||
|isi-wolfssl||||||||||||||||
|kris|❌|❌||||||❌|❌|||||||
|openca|❌|❌||||❌|✅|❌|❌|||||❌||
|oqs-gnutls||||||||||||||||
|oqs-openssl111|✅|❌||||❌|✅|❌|❌|||||||
|oqs-provider|✅|❌||||||❌|❌|||||||
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

# ~~SPHINCS+-SHA256-128f-robust~~ (1.3.9999.6.4.1)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# SLH-DSA-SHA2-128f-ipd (1.3.9999.6.4.13)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅||✅|||||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅||✅|||||||✅||
|cht||||✅||||||||||||
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
|cht||||✅||||||||||||
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
|cht||||✅||||||||||||
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
|cht||||✅||||||||||||
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
|cht||||✅||||||||||||
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
|cht||||✅||||||||||||
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
|cht||||✅||||||||||||
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
|cht||||✅||||||||||||
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

# 1.3.9999.6.7.4 (1.3.9999.6.7.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||❌||||✅|✅|❌|✅|||||❌||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# SLH-DSA-SHAKE-192f-ipd (1.3.9999.6.8.10)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅|✅|✅|||||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅|✅|✅|||||||✅||
|cht||||✅||||||||||||
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
|cht||||✅||||||||||||
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

# 1.3.9999.6.8.3 (1.3.9999.6.8.3)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||❌||||✅|✅|❌|✅|||||❌||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# SLH-DSA-SHAKE-256f-ipd (1.3.9999.6.9.10)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||✅|✅|✅|❌|✅|||||||✅||
|botan||||||||||||||||
|carl-redhound|||✅|✅|✅|❌|✅|||||||✅||
|cht||||✅||||||||||||
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
|cht||||✅||||||||||||
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

# 1.3.9999.6.9.3 (1.3.9999.6.9.3)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||❌||||✅|✅|❌|✅|||||❌||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# id-Dilithium3-RSA-PKCS15-SHA256 (2.16.840.1.114027.80.5.1.1)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust|❌|❌||||||✅|❌|||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# id-Dilithium3-RSA-PSS-SHA256 (2.16.840.1.114027.80.5.1.14)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||❌||||||❌||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# id-Dilithium3-ECDSA-P256-SHA256 (2.16.840.1.114027.80.5.1.2)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust|❌|❌||||||✅|❌|||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# id-Dilithium3-ECDSA-brainpoolP256r1-SHA256 (2.16.840.1.114027.80.5.1.3)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust|❌|❌||||||✅||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# id-Dilithium5-ECDSA-P384-SHA384 (2.16.840.1.114027.80.5.1.5)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust|❌|❌||||||✅||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# id-Dilithium5-ECDSA-brainpoolP384r1-SHA384 (2.16.840.1.114027.80.5.1.6)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust|❌|❌||||||✅||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# ~~id-Falcon512-ECDSA-P256-SHA256~~ (2.16.840.1.114027.80.5.1.8)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust|❌|❌||||||✅|❌|||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# ~~id-Falcon512-ECDSA-brainpoolP256r1-SHA256~~ (2.16.840.1.114027.80.5.1.9)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust|❌|❌||||||✅||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# catalyst (catalyst_1.2.840.10045.4.3.2_with_1.3.6.1.4.1.2.267.12.4.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# catalyst (catalyst_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.12.8.7)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# catalyst (catalyst_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.7.8.7)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||✅||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# catalyst (catalyst_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.12.4.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# catalyst (catalyst_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.7.4.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||✅||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# chameleon (chameleon_1.2.840.10045.4.3.2_with_1.3.6.1.4.1.2.267.12.4.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# chameleon (chameleon_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.12.8.7)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# chameleon (chameleon_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.12.4.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# composite (composite_1.2.840.10045.4.3.2_with_1.3.6.1.4.1.2.267.12.4.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||❌||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||❌||
|oqsprovider||||||||||||||||

# composite (composite_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.12.8.7)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# composite (composite_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.7.8.7)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||✅||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# composite (composite_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.12.4.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# composite (composite_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.7.4.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||✅||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# hybrid-catalyst (hybrid-catalyst)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||✅||||||✅||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# hybrid[catalyst(1.2.840.10045.4.3.2 (hybrid[catalyst(1.2.840.10045.4.3.2)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌|||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# hybrid[catalyst(1.2.840.10045.4.3.4 (hybrid[catalyst(1.2.840.10045.4.3.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌|||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# hybrid[catalyst(1.2.840.113549.1.1.11 (hybrid[catalyst(1.2.840.113549.1.1.11)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌|||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# hybrid[chameleon(1.2.840.10045.4.3.2 (hybrid[chameleon(1.2.840.10045.4.3.2)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌|||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# hybrid[chameleon(1.2.840.10045.4.3.4 (hybrid[chameleon(1.2.840.10045.4.3.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌|||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# hybrid[chameleon(1.2.840.113549.1.1.11 (hybrid[chameleon(1.2.840.113549.1.1.11)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌|||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# hybrid[composite(1.2.840.10045.4.3.2 (hybrid[composite(1.2.840.10045.4.3.2)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌|||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# hybrid[composite(1.2.840.10045.4.3.4 (hybrid[composite(1.2.840.10045.4.3.4)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌|||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||

# hybrid[composite(1.2.840.113549.1.1.11 (hybrid[composite(1.2.840.113549.1.1.11)

|-|bc|botan|carl-redhound|cht|corey-digicert|cryptonext|cryptonext-cnsprovider|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌|||||||||||||||
|botan||||||||||||||||
|carl-redhound||||||||||||||||
|cht||||||||||||||||
|corey-digicert||||||||||||||||
|cryptonext||||||||||||||||
|cryptonext-cnsprovider||||||||||||||||
|entrust||||||||||||||||
|isi-wolfssl||||||||||||||||
|kris||||||||||||||||
|openca||||||||||||||||
|oqs-gnutls||||||||||||||||
|oqs-openssl111||||||||||||||||
|oqs-provider||||||||||||||||
|oqsprovider||||||||||||||||
