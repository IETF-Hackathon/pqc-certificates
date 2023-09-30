
IETF PQC Hackathon Interoperability Results
===========================================

Algorithms
==========

* [Algorithms Tested](#algorithms-tested)
* [1.3.101.113 (1.3.101.113)](#13101113-13101113)
* [~~DilithiumAES2~~ (1.3.6.1.4.1.2.267.11.4.4)](#dilithiumaes2-13614122671144)
* [Dilithium2 (1.3.6.1.4.1.2.267.12.4.4)](#dilithium2-13614122671244)
* [Dilithium3 (1.3.6.1.4.1.2.267.12.6.5)](#dilithium3-13614122671265)
* [Dilithium5 (1.3.6.1.4.1.2.267.12.8.7)](#dilithium5-13614122671287)
* [~~Dilithium2~~ (1.3.6.1.4.1.2.267.7.4.4)](#dilithium2-1361412267744)
* [~~Dilithium3~~ (1.3.6.1.4.1.2.267.7.6.5)](#dilithium3-1361412267765)
* [~~Dilithium5~~ (1.3.6.1.4.1.2.267.7.8.7)](#dilithium5-1361412267787)
* [kyber512 (1.3.6.1.4.1.22554.5.6.1)](#kyber512-13614122554561)
* [kyber768 (1.3.6.1.4.1.22554.5.6.2)](#kyber768-13614122554562)
* [kyber1024 (1.3.6.1.4.1.22554.5.6.3)](#kyber1024-13614122554563)
* [~~Falcon-512~~ (1.3.9999.3.1)](#falcon-512-13999931)
* [~~Falcon-1024~~ (1.3.9999.3.4)](#falcon-1024-13999934)
* [Falcon-512 (1.3.9999.3.6)](#falcon-512-13999936)
* [Falcon-1024 (1.3.9999.3.9)](#falcon-1024-13999939)
* [~~SPHINCS+-SHA256-128f-robust~~ (1.3.9999.6.4.1)](#sphincs-sha256-128f-robust-139999641)
* [~~SPHINCS+-SHA256-128s-simple~~ (1.3.9999.6.4.10)](#sphincs-sha256-128s-simple-1399996410)
* [SPHINCS+-SHA2-128f (1.3.9999.6.4.13)](#sphincs-sha2-128f-1399996413)
* [SPHINCS+-SHA2-128s (1.3.9999.6.4.16)](#sphincs-sha2-128s-1399996416)
* [~~SPHINCS+-SHA256-128f-simple~~ (1.3.9999.6.4.4)](#sphincs-sha256-128f-simple-139999644)
* [SPHINCS+-SHA2-192f (1.3.9999.6.5.10)](#sphincs-sha2-192f-1399996510)
* [SPHINCS+-SHA2-192s (1.3.9999.6.5.12)](#sphincs-sha2-192s-1399996512)
* [~~SPHINCS+-SHA256-192f-simple~~ (1.3.9999.6.5.3)](#sphincs-sha256-192f-simple-139999653)
* [~~SPHINCS+-SHA256-192s-simple~~ (1.3.9999.6.5.7)](#sphincs-sha256-192s-simple-139999657)
* [SPHINCS+-SHA2-256f (1.3.9999.6.6.10)](#sphincs-sha2-256f-1399996610)
* [SPHINCS+-SHA2-256s (1.3.9999.6.6.12)](#sphincs-sha2-256s-1399996612)
* [~~SPHINCS+-SHA256-256f-simple~~ (1.3.9999.6.6.3)](#sphincs-sha256-256f-simple-139999663)
* [~~SPHINCS+-SHA256-256s-simple~~ (1.3.9999.6.6.7)](#sphincs-sha256-256s-simple-139999667)
* [SPHINCS+-SHAKE-128f (1.3.9999.6.7.13)](#sphincs-shake-128f-1399996713)
* [SPHINCS+-SHAKE-128s (1.3.9999.6.7.16)](#sphincs-shake-128s-1399996716)
* [1.3.9999.6.7.4 (1.3.9999.6.7.4)](#139999674-139999674)
* [SPHINCS+-SHAKE-192f (1.3.9999.6.8.10)](#sphincs-shake-192f-1399996810)
* [SPHINCS+-SHAKE-192s (1.3.9999.6.8.12)](#sphincs-shake-192s-1399996812)
* [1.3.9999.6.8.3 (1.3.9999.6.8.3)](#139999683-139999683)
* [SPHINCS+-SHAKE-256f (1.3.9999.6.9.10)](#sphincs-shake-256f-1399996910)
* [SPHINCS+-SHAKE-256s (1.3.9999.6.9.12)](#sphincs-shake-256s-1399996912)
* [1.3.9999.6.9.3 (1.3.9999.6.9.3)](#139999693-139999693)
* [id-Dilithium3-RSA-PKCS15-SHA256 (2.16.840.1.114027.80.5.1.1)](#id-dilithium3-rsa-pkcs15-sha256-216840111402780511)
* [id-Dilithium3-RSA-PSS-SHA256 (2.16.840.1.114027.80.5.1.14)](#id-dilithium3-rsa-pss-sha256-2168401114027805114)
* [id-Dilithium3-ECDSA-P256-SHA256 (2.16.840.1.114027.80.5.1.2)](#id-dilithium3-ecdsa-p256-sha256-216840111402780512)
* [id-Dilithium3-ECDSA-brainpoolP256r1-SHA256 (2.16.840.1.114027.80.5.1.3)](#id-dilithium3-ecdsa-brainpoolp256r1-sha256-216840111402780513)
* [id-Dilithium5-ECDSA-P384-SHA384 (2.16.840.1.114027.80.5.1.5)](#id-dilithium5-ecdsa-p384-sha384-216840111402780515)
* [id-Dilithium5-ECDSA-brainpoolP384r1-SHA384 (2.16.840.1.114027.80.5.1.6)](#id-dilithium5-ecdsa-brainpoolp384r1-sha384-216840111402780516)
* [~~id-Falcon512-ECDSA-P256-SHA256~~ (2.16.840.1.114027.80.5.1.8)](#id-falcon512-ecdsa-p256-sha256-216840111402780518)
* [~~id-Falcon512-ECDSA-brainpoolP256r1-SHA256~~ (2.16.840.1.114027.80.5.1.9)](#id-falcon512-ecdsa-brainpoolp256r1-sha256-216840111402780519)
* [catalyst_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.7.8.7 (catalyst_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.7.8.7)](#catalyst_1284010045434_with_1361412267787-catalyst_1284010045434_with_1361412267787)
* [catalyst_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.7.4.4 (catalyst_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.7.4.4)](#catalyst_128401135491111_with_1361412267744-catalyst_128401135491111_with_1361412267744)
* [chameleon-base (chameleon-base)](#chameleon-base-chameleon-base)
* [chameleon-delta (chameleon-delta)](#chameleon-delta-chameleon-delta)
* [chameleon-extracted-delta (chameleon-extracted-delta)](#chameleon-extracted-delta-chameleon-extracted-delta)
* [composite_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.7.8.7 (composite_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.7.8.7)](#composite_1284010045434_with_1361412267787-composite_1284010045434_with_1361412267787)
* [composite_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.7.4.4 (composite_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.7.4.4)](#composite_128401135491111_with_1361412267744-composite_128401135491111_with_1361412267744)
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


In all tables below, Rows are producers. Columns are parsers.

# Algorithms Tested


To be in this table, an algorithm must have a test result in one of the tables below (pass or fail). Algorithms for which we have artifacts but no test results are not shown.

|-|1.3.101.113|~~DilithiumAES2~~|Dilithium2|Dilithium3|Dilithium5|~~Dilithium2~~|~~Dilithium3~~|~~Dilithium5~~|kyber512|kyber768|kyber1024|~~Falcon-512~~|~~Falcon-1024~~|Falcon-512|Falcon-1024|~~SPHINCS+-SHA256-128f-robust~~|~~SPHINCS+-SHA256-128s-simple~~|SPHINCS+-SHA2-128f|SPHINCS+-SHA2-128s|~~SPHINCS+-SHA256-128f-simple~~|SPHINCS+-SHA2-192f|SPHINCS+-SHA2-192s|~~SPHINCS+-SHA256-192f-simple~~|~~SPHINCS+-SHA256-192s-simple~~|SPHINCS+-SHA2-256f|SPHINCS+-SHA2-256s|~~SPHINCS+-SHA256-256f-simple~~|~~SPHINCS+-SHA256-256s-simple~~|SPHINCS+-SHAKE-128f|SPHINCS+-SHAKE-128s|1.3.9999.6.7.4|SPHINCS+-SHAKE-192f|SPHINCS+-SHAKE-192s|1.3.9999.6.8.3|SPHINCS+-SHAKE-256f|SPHINCS+-SHAKE-256s|1.3.9999.6.9.3|id-Dilithium3-RSA-PKCS15-SHA256|id-Dilithium3-RSA-PSS-SHA256|id-Dilithium3-ECDSA-P256-SHA256|id-Dilithium3-ECDSA-brainpoolP256r1-SHA256|id-Dilithium5-ECDSA-P384-SHA384|id-Dilithium5-ECDSA-brainpoolP384r1-SHA384|~~id-Falcon512-ECDSA-P256-SHA256~~|~~id-Falcon512-ECDSA-brainpoolP256r1-SHA256~~|catalyst_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.7.8.7|catalyst_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.7.4.4|chameleon-base|chameleon-delta|chameleon-extracted-delta|composite_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.7.8.7|composite_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.7.4.4|hybrid-catalyst|hybrid[catalyst(1.2.840.10045.4.3.2|hybrid[catalyst(1.2.840.10045.4.3.4|hybrid[catalyst(1.2.840.113549.1.1.11|hybrid[chameleon(1.2.840.10045.4.3.2|hybrid[chameleon(1.2.840.10045.4.3.4|hybrid[chameleon(1.2.840.113549.1.1.11|hybrid[composite(1.2.840.10045.4.3.2|hybrid[composite(1.2.840.10045.4.3.4|hybrid[composite(1.2.840.113549.1.1.11|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||✅|✅|✅|✅|✅|✅|✅|✅|✅|✅|✅|||||✅|✅||✅|✅|||✅|✅|||✅|✅|✅|✅|✅|✅|✅|✅|✅|||||||||✅|✅||||✅|✅||✅|✅|✅|✅|✅|✅|✅|✅|✅|
|botan||||||✅|✅|✅|✅|✅|✅|✅|✅||||||||||||||||||✅|||✅|||✅|||||||||✅|✅||||✅|✅|||||||||||
|carl-redhound||||||✅|✅|✅|✅|✅|✅|✅|✅||||||||||||||||||✅|||✅|||✅|||||||||✅|✅||||✅|✅|||||||||||
|corey-digicert||||||✅|✅|✅|✅|✅|✅|✅|✅|✅|✅||||||||||||||||✅|||✅|||✅|||||||||✅|✅|✅|✅|✅|✅|✅|✅||||||||||
|cryptonext||||||✅|✅|✅|✅|✅|✅|✅|✅||||||||||||||||||✅|||✅|||✅|||||||||✅|✅||||✅|✅|||||||||||
|entrust||||||✅|✅|✅|✅|✅|✅|✅|✅|✅|✅||✅|✅|✅|✅|✅|✅|✅|✅|✅|✅|✅|✅|||✅|||✅|||✅|✅|✅|✅|✅|✅|✅|✅|✅|✅|✅||||✅|✅|||||||||||
|isi-wolfssl|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|kris||||||✅|✅|✅|✅|✅|✅|✅|✅||||||||||||||||||✅|||✅|||✅|||||||||✅|✅||||✅|✅|||||||||||
|openca||||||✅|✅|✅|✅|✅|✅|✅|✅||||||||||||||||||✅|||✅|||✅|||||||||✅|✅||||✅|✅|||||||||||
|oqs-gnutls||||||✅|✅|✅|✅|✅|✅|✅|✅||||||||||||||||||✅|||✅|||✅|||||||||✅|✅||||✅|✅|||||||||||
|oqs-openssl111||✅||||✅|✅|✅||||✅|✅|||✅|||||||||||||||||||||||||||||||||||||||||||||||
|oqs-provider|✅|||||✅|✅|✅|✅|✅|✅|✅|✅|✅|✅|||✅|✅||✅|✅|||✅|✅|||✅|✅|✅|✅|✅|✅|✅|✅|✅|||||||||✅|✅||||✅|✅|||||||||||

# 1.3.101.113 (1.3.101.113)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider||||||||||||✅|

# ~~DilithiumAES2~~ (1.3.6.1.4.1.2.267.11.4.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111||||||||||||❌|
|oqs-provider|||||||||||||

# Dilithium2 (1.3.6.1.4.1.2.267.12.4.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||❌|
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# Dilithium3 (1.3.6.1.4.1.2.267.12.6.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||❌|
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# Dilithium5 (1.3.6.1.4.1.2.267.12.8.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||❌|
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ~~Dilithium2~~ (1.3.6.1.4.1.2.267.7.4.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|❌|✅|✅||||||
|botan|❌|✅||✅|✅||✅|||||✅|
|carl-redhound|✅|❌||✅|✅|✅|✅|||||✅|
|corey-digicert|✅|✅||✅|✅|✅|❌|||||✅|
|cryptonext||✅||✅|✅|✅|✅|||||❌|
|entrust|❌|✅||❌|✅|✅||||||✅|
|isi-wolfssl|||||||||||||
|kris|❌|❌|||❌|❌|❌|||||❌|
|openca|❌|❌||✅|❌|❌|❌|||||✅|
|oqs-gnutls|||||❌||||||||
|oqs-openssl111|✅|✅||✅||❌|❌|||||❌|
|oqs-provider|✅|✅|||✅|❌|❌|||||✅|

# ~~Dilithium3~~ (1.3.6.1.4.1.2.267.7.6.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|❌|✅|✅||||||
|botan|❌|✅||✅|❌||✅||||||
|carl-redhound|✅|❌||✅|✅|✅|✅|||||✅|
|corey-digicert|✅|✅||✅|✅|✅|❌|||||✅|
|cryptonext||✅||✅|✅|✅|✅|||||❌|
|entrust|❌|✅||❌|✅|✅||||||✅|
|isi-wolfssl|||||||||||||
|kris|❌|❌|||❌|❌|❌|||||❌|
|openca|❌|❌||✅|❌|❌|❌|||||✅|
|oqs-gnutls|❌|✅||✅|✅|✅|✅|||||✅|
|oqs-openssl111|✅|✅||✅||❌|❌|||||❌|
|oqs-provider|✅|✅|||✅|❌|❌|||||✅|

# ~~Dilithium5~~ (1.3.6.1.4.1.2.267.7.8.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||✅||✅|❌|✅|✅||||||
|botan|❌|✅||✅|✅||✅|||||✅|
|carl-redhound|✅|❌||✅|✅|✅|✅|||||✅|
|corey-digicert|✅|✅||✅|✅|✅|❌|||||✅|
|cryptonext||✅||✅|✅|✅|✅|||||❌|
|entrust|❌|✅||❌|✅|✅||||||✅|
|isi-wolfssl|||||||||||||
|kris|❌|❌|||❌|❌|❌|||||❌|
|openca|❌|❌||✅|❌|❌|❌|||||✅|
|oqs-gnutls|||||❌||||||||
|oqs-openssl111|✅|✅||✅||❌|❌|||||❌|
|oqs-provider|✅|✅|||✅|❌|❌|||||✅|

# kyber512 (1.3.6.1.4.1.22554.5.6.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||||❌||||||||
|botan|||||❌||||||||
|carl-redhound|||||❌||||||||
|corey-digicert|||||❌||||||||
|cryptonext|||||✅||✅||||||
|entrust|||||❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||❌||||||||
|openca|||||❌||||||||
|oqs-gnutls|||||❌||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||❌||||||||

# kyber768 (1.3.6.1.4.1.22554.5.6.2)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||||❌||||||||
|botan|||||❌||||||||
|carl-redhound|||||❌||||||||
|corey-digicert|||||❌||||||||
|cryptonext|||||✅||✅||||||
|entrust|||||❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||❌||||||||
|openca|||||❌||||||||
|oqs-gnutls|||||❌||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||❌||||||||

# kyber1024 (1.3.6.1.4.1.22554.5.6.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅||||❌||||||||
|botan|||||❌||||||||
|carl-redhound|||||❌||||||||
|corey-digicert|||||❌||||||||
|cryptonext|||||✅||✅||||||
|entrust|||||❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||❌||||||||
|openca|||||❌||||||||
|oqs-gnutls|||||❌||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||❌||||||||

# ~~Falcon-512~~ (1.3.9999.3.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||❌|||❌||✅||||||
|botan|||||❌||||||||
|carl-redhound|✅|❌|||❌|✅|✅|||||❌|
|corey-digicert|✅|❌|||❌|✅|||||||
|cryptonext||❌|||✅|❌|❌|||||❌|
|entrust|❌|❌|||❌||||||||
|isi-wolfssl|||||||||||||
|kris|❌|❌|||❌|❌|❌|||||❌|
|openca|❌|❌|||❌|❌|❌|||||❌|
|oqs-gnutls|||||❌||||||||
|oqs-openssl111|✅|❌||||❌|❌|||||❌|
|oqs-provider|✅|❌|||❌|❌|❌||||||

# ~~Falcon-1024~~ (1.3.9999.3.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||❌|||❌|✅|✅||||||
|botan|||||❌||||||||
|carl-redhound|✅|❌|||❌|✅|✅|||||❌|
|corey-digicert|✅|❌|||❌|✅|||||||
|cryptonext||❌|||✅|❌|❌|||||❌|
|entrust|❌|❌|||❌||||||||
|isi-wolfssl|||||||||||||
|kris|❌|❌|||❌|❌|❌|||||❌|
|openca|❌|❌|||❌|❌|❌|||||❌|
|oqs-gnutls|||||❌||||||||
|oqs-openssl111|✅|❌||||❌|❌|||||❌|
|oqs-provider|✅|❌|||❌|❌|❌||||||

# Falcon-512 (1.3.9999.3.6)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert||||✅|||❌|||||✅|
|cryptonext|||||||||||||
|entrust||||||✅||||||✅|
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider||||||||||||✅|

# Falcon-1024 (1.3.9999.3.9)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert||||✅|||❌|||||✅|
|cryptonext|||||||||||||
|entrust||||||✅||||||✅|
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider||||||||||||✅|

# ~~SPHINCS+-SHA256-128f-robust~~ (1.3.9999.6.4.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111||||||||||||❌|
|oqs-provider|||||||||||||

# ~~SPHINCS+-SHA256-128s-simple~~ (1.3.9999.6.4.10)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust||||||||||||✅|
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# SPHINCS+-SHA2-128f (1.3.9999.6.4.13)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||❌|
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust||||||✅|||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider||||||||||||✅|

# SPHINCS+-SHA2-128s (1.3.9999.6.4.16)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||❌|
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust||||||✅|||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider||||||||||||✅|

# ~~SPHINCS+-SHA256-128f-simple~~ (1.3.9999.6.4.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust||||||||||||✅|
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# SPHINCS+-SHA2-192f (1.3.9999.6.5.10)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||❌|
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust||||||✅|||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider||||||||||||✅|

# SPHINCS+-SHA2-192s (1.3.9999.6.5.12)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||❌|
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust||||||✅|||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider||||||||||||✅|

# ~~SPHINCS+-SHA256-192f-simple~~ (1.3.9999.6.5.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust||||||||||||✅|
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ~~SPHINCS+-SHA256-192s-simple~~ (1.3.9999.6.5.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust||||||||||||✅|
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# SPHINCS+-SHA2-256f (1.3.9999.6.6.10)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||❌|
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust||||||✅|||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider||||||||||||✅|

# SPHINCS+-SHA2-256s (1.3.9999.6.6.12)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||❌|
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust||||||✅|||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider||||||||||||✅|

# ~~SPHINCS+-SHA256-256f-simple~~ (1.3.9999.6.6.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust||||||||||||✅|
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ~~SPHINCS+-SHA256-256s-simple~~ (1.3.9999.6.6.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust||||||||||||✅|
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# SPHINCS+-SHAKE-128f (1.3.9999.6.7.13)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||❌|
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider||||||||||||✅|

# SPHINCS+-SHAKE-128s (1.3.9999.6.7.16)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||❌|
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider||||||||||||✅|

# 1.3.9999.6.7.4 (1.3.9999.6.7.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||❌||||||||
|botan|||||❌||||||||
|carl-redhound|||||❌||||||||
|corey-digicert|||||❌||||||||
|cryptonext||❌|||✅|❌|✅|||||❌|
|entrust|||||❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||❌||||||||
|openca|||||❌||||||||
|oqs-gnutls|||||❌||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||❌||||||||

# SPHINCS+-SHAKE-192f (1.3.9999.6.8.10)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||❌|
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider||||||||||||✅|

# SPHINCS+-SHAKE-192s (1.3.9999.6.8.12)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||❌|
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider||||||||||||✅|

# 1.3.9999.6.8.3 (1.3.9999.6.8.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||❌||||||||
|botan|||||❌||||||||
|carl-redhound|||||❌||||||||
|corey-digicert|||||❌||||||||
|cryptonext||❌|||✅|❌|✅|||||❌|
|entrust|||||❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||❌||||||||
|openca|||||❌||||||||
|oqs-gnutls|||||❌||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||❌||||||||

# SPHINCS+-SHAKE-256f (1.3.9999.6.9.10)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||❌|
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider||||||||||||✅|

# SPHINCS+-SHAKE-256s (1.3.9999.6.9.12)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|||||||||||❌|
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider||||||||||||✅|

# 1.3.9999.6.9.3 (1.3.9999.6.9.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||❌||||||||
|botan|||||❌||||||||
|carl-redhound|||||❌||||||||
|corey-digicert|||||❌||||||||
|cryptonext||❌|||✅|❌|✅|||||❌|
|entrust|||||❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||❌||||||||
|openca|||||❌||||||||
|oqs-gnutls|||||❌||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||❌||||||||

# id-Dilithium3-RSA-PKCS15-SHA256 (2.16.840.1.114027.80.5.1.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|❌|❌||||✅|❌||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# id-Dilithium3-RSA-PSS-SHA256 (2.16.840.1.114027.80.5.1.14)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust||❌||||❌|||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# id-Dilithium3-ECDSA-P256-SHA256 (2.16.840.1.114027.80.5.1.2)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|❌|❌||||✅|❌||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# id-Dilithium3-ECDSA-brainpoolP256r1-SHA256 (2.16.840.1.114027.80.5.1.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|❌|❌||||✅|||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# id-Dilithium5-ECDSA-P384-SHA384 (2.16.840.1.114027.80.5.1.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|❌|❌||||✅|||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# id-Dilithium5-ECDSA-brainpoolP384r1-SHA384 (2.16.840.1.114027.80.5.1.6)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|❌|❌||||✅|||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ~~id-Falcon512-ECDSA-P256-SHA256~~ (2.16.840.1.114027.80.5.1.8)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|❌|❌||||✅|❌||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ~~id-Falcon512-ECDSA-brainpoolP256r1-SHA256~~ (2.16.840.1.114027.80.5.1.9)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|❌|❌||||✅|||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# catalyst_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.7.8.7 (catalyst_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.7.8.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||❌||||||||
|botan|||||❌||||||||
|carl-redhound|||||❌||||||||
|corey-digicert|||||❌||||||||
|cryptonext|||||✅||||||||
|entrust|||||❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||❌||||||||
|openca|||||❌||||||||
|oqs-gnutls|||||❌||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||❌||||||||

# catalyst_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.7.4.4 (catalyst_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.7.4.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||❌||||||||
|botan|||||❌||||||||
|carl-redhound|||||❌||||||||
|corey-digicert|||||❌||||||||
|cryptonext|||||✅||||||||
|entrust|||||❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||❌||||||||
|openca|||||❌||||||||
|oqs-gnutls|||||❌||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||❌||||||||

# chameleon-base (chameleon-base)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert||||✅|||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# chameleon-delta (chameleon-delta)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert||||✅|||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# chameleon-extracted-delta (chameleon-extracted-delta)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert||||✅|||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# composite_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.7.8.7 (composite_1.2.840.10045.4.3.4_with_1.3.6.1.4.1.2.267.7.8.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||❌||||||||
|botan|||||❌||||||||
|carl-redhound|||||❌||||||||
|corey-digicert|||||❌||||||||
|cryptonext|||||✅||||||||
|entrust|||||❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||❌||||||||
|openca|||||❌||||||||
|oqs-gnutls|||||❌||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||❌||||||||

# composite_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.7.4.4 (composite_1.2.840.113549.1.1.11_with_1.3.6.1.4.1.2.267.7.4.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||❌||||||||
|botan|||||❌||||||||
|carl-redhound|||||❌||||||||
|corey-digicert|||||❌||||||||
|cryptonext|||||✅||||||||
|entrust|||||❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||❌||||||||
|openca|||||❌||||||||
|oqs-gnutls|||||❌||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||❌||||||||

# hybrid-catalyst (hybrid-catalyst)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert||✅||✅||✅|||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# hybrid[catalyst(1.2.840.10045.4.3.2 (hybrid[catalyst(1.2.840.10045.4.3.2)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# hybrid[catalyst(1.2.840.10045.4.3.4 (hybrid[catalyst(1.2.840.10045.4.3.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# hybrid[catalyst(1.2.840.113549.1.1.11 (hybrid[catalyst(1.2.840.113549.1.1.11)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# hybrid[chameleon(1.2.840.10045.4.3.2 (hybrid[chameleon(1.2.840.10045.4.3.2)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# hybrid[chameleon(1.2.840.10045.4.3.4 (hybrid[chameleon(1.2.840.10045.4.3.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# hybrid[chameleon(1.2.840.113549.1.1.11 (hybrid[chameleon(1.2.840.113549.1.1.11)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# hybrid[composite(1.2.840.10045.4.3.2 (hybrid[composite(1.2.840.10045.4.3.2)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# hybrid[composite(1.2.840.10045.4.3.4 (hybrid[composite(1.2.840.10045.4.3.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# hybrid[composite(1.2.840.113549.1.1.11 (hybrid[composite(1.2.840.113549.1.1.11)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|❌||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||
