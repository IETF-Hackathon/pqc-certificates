
IETF PQC Hackathon Interoperability Results
===========================================

Algorithms
==========

* [ecPublicKey (1.2.840.10045.2.1)](#ecpublickey-128401004521)
* [prime256v1 (1.2.840.10045.3.1.7)](#prime256v1-1284010045317)
* [prime256v1 & Dilithium2 (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.4.4)](#prime256v1--dilithium2-1284010045317_1361412267744)
* [prime256v1 & Dilithium2 & ~~Falcon-1024~~ (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.4.4_1.3.9999.3.4)](#prime256v1--dilithium2--falcon-1024-1284010045317_1361412267744_13999934)
* [prime256v1 & Dilithium3 (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.6.5)](#prime256v1--dilithium3-1284010045317_1361412267765)
* [prime256v1 & Dilithium3 & ~~Falcon-512~~ (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.6.5_1.3.9999.3.1)](#prime256v1--dilithium3--falcon-512-1284010045317_1361412267765_13999931)
* [ecdsa-with-SHA256 (1.2.840.10045.4.3.2)](#ecdsa-with-sha256-1284010045432)
* [rsaEncryption (1.2.840.113549.1.1.1)](#rsaencryption-12840113549111)
* [~~DilithiumAES2~~ (1.3.6.1.4.1.2.267.11.4.4)](#dilithiumaes2-13614122671144)
* [~~DilithiumAES3~~ (1.3.6.1.4.1.2.267.11.6.5)](#dilithiumaes3-13614122671165)
* [~~DilithiumAES5~~ (1.3.6.1.4.1.2.267.11.8.7)](#dilithiumaes5-13614122671187)
* [Dilithium2 (1.3.6.1.4.1.2.267.7.4.4)](#dilithium2-1361412267744)
* [Dilithium3 (1.3.6.1.4.1.2.267.7.6.5)](#dilithium3-1361412267765)
* [Dilithium5 (1.3.6.1.4.1.2.267.7.8.7)](#dilithium5-1361412267787)
* [kyber512 (1.3.6.1.4.1.22554.5.6.1)](#kyber512-13614122554561)
* [kyber768 (1.3.6.1.4.1.22554.5.6.2)](#kyber768-13614122554562)
* [kyber1024 (1.3.6.1.4.1.22554.5.6.3)](#kyber1024-13614122554563)
* [~~Falcon-512~~ (1.3.9999.3.1)](#falcon-512-13999931)
* [~~Falcon-1024~~ (1.3.9999.3.4)](#falcon-1024-13999934)
* [Falcon-512 (1.3.9999.3.6)](#falcon-512-13999936)
* [Falcon-1024 (1.3.9999.3.9)](#falcon-1024-13999939)
* [~~SPHINCS+-SHA256-128f-robust~~ (1.3.9999.6.4.1)](#sphincs-sha256-128f-robust-139999641)
* [~~SPHINCS+-SHA256-128s-simple~~ (1.3.9999.6.4.10)](#sphincs-sha256-128s-simple-1399996410)
* [~~SPHINCS+-SHA256-128f-simple~~ (1.3.9999.6.4.4)](#sphincs-sha256-128f-simple-139999644)
* [~~SPHINCS+-SHA256-128s-robust~~ (1.3.9999.6.4.7)](#sphincs-sha256-128s-robust-139999647)
* [~~SPHINCS+-SHA256-192f-robust~~ (1.3.9999.6.5.1)](#sphincs-sha256-192f-robust-139999651)
* [~~SPHINCS+-SHA256-192f-simple~~ (1.3.9999.6.5.3)](#sphincs-sha256-192f-simple-139999653)
* [~~SPHINCS+-SHA256-192s-robust~~ (1.3.9999.6.5.5)](#sphincs-sha256-192s-robust-139999655)
* [~~SPHINCS+-SHA256-192s-simple~~ (1.3.9999.6.5.7)](#sphincs-sha256-192s-simple-139999657)
* [~~SPHINCS+-SHA256-256f-robust~~ (1.3.9999.6.6.1)](#sphincs-sha256-256f-robust-139999661)
* [~~SPHINCS+-SHA256-256f-simple~~ (1.3.9999.6.6.3)](#sphincs-sha256-256f-simple-139999663)
* [~~SPHINCS+-SHA256-256s-robust~~ (1.3.9999.6.6.5)](#sphincs-sha256-256s-robust-139999665)
* [~~SPHINCS+-SHA256-256s-simple~~ (1.3.9999.6.6.7)](#sphincs-sha256-256s-simple-139999667)
* [sphincsshake128fsimple (1.3.9999.6.7.4)](#sphincsshake128fsimple-139999674)
* [sphincsshake192fsimple (1.3.9999.6.8.3)](#sphincsshake192fsimple-139999683)
* [sphincsshake256fsimple (1.3.9999.6.9.3)](#sphincsshake256fsimple-139999693)
* [COMPOSITE-KEY (2.16.840.1.114027.80.4.1)](#composite-key-21684011140278041)
* [COMPOSITE_KEY_HASH_N_SIGN (2.16.840.1.114027.80.4.1.2)](#composite_key_hash_n_sign-216840111402780412)
* [COMPOSITE-KEY & Unknown (2.16.840.1.114027.80.4.1_generic_traditional)](#composite-key--unknown-21684011140278041_generic_traditional)
* [ExplicitCompositeSignature (2.16.840.1.114027.80.5.1)](#explicitcompositesignature-21684011140278051)
* [id-Dilithium3-RSA-PKCS15-SHA256 (2.16.840.1.114027.80.5.1.1)](#id-dilithium3-rsa-pkcs15-sha256-216840111402780511)
* [id-Dilithium3-RSA-PSS-SHA256 (2.16.840.1.114027.80.5.1.14)](#id-dilithium3-rsa-pss-sha256-2168401114027805114)
* [id-Dilithium3-ECDSA-P256-SHA256 (2.16.840.1.114027.80.5.1.2)](#id-dilithium3-ecdsa-p256-sha256-216840111402780512)
* [id-Dilithium3-ECDSA-brainpoolP256r1-SHA256 (2.16.840.1.114027.80.5.1.3)](#id-dilithium3-ecdsa-brainpoolp256r1-sha256-216840111402780513)
* [id-Dilithium5-ECDSA-P384-SHA384 (2.16.840.1.114027.80.5.1.5)](#id-dilithium5-ecdsa-p384-sha384-216840111402780515)
* [id-Dilithium5-ECDSA-brainpoolP384r1-SHA384 (2.16.840.1.114027.80.5.1.6)](#id-dilithium5-ecdsa-brainpoolp384r1-sha384-216840111402780516)
* [~~id-Falcon512-ECDSA-P256-SHA256~~ (2.16.840.1.114027.80.5.1.8)](#id-falcon512-ecdsa-p256-sha256-216840111402780518)
* [~~id-Falcon512-ECDSA-brainpoolP256r1-SHA256~~ (2.16.840.1.114027.80.5.1.9)](#id-falcon512-ecdsa-brainpoolp256r1-sha256-216840111402780519)
* [Unknown & Unknown (artifacts)](#unknown--unknown-artifacts)
* [Unknown & Unknown (chameleon-base)](#unknown--unknown-chameleon-base)
* [Unknown & Unknown (chameleon-delta)](#unknown--unknown-chameleon-delta)
* [Unknown & Unknown (chameleon-extracted-delta)](#unknown--unknown-chameleon-extracted-delta)
* [Unknown & Unknown (hybrid-catalyst)](#unknown--unknown-hybrid-catalyst)


Rows are producers. Columns are parsers.

# ecPublicKey (1.2.840.10045.2.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|cryptonext||TA: ✅<br>CA: ✅<br>EE: ✅||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||TA: ❌<br>CA: ❌<br>EE: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# prime256v1 (1.2.840.10045.3.1.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ❌<br>EE: ❌||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# prime256v1 & Dilithium2 (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.4.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# prime256v1 & Dilithium2 & ~~Falcon-1024~~ (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.4.4_1.3.9999.3.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# prime256v1 & Dilithium3 (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.6.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# prime256v1 & Dilithium3 & ~~Falcon-512~~ (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.6.5_1.3.9999.3.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ecdsa-with-SHA256 (1.2.840.10045.4.3.2)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ❌<br>CA: ❌<br>EE: ❌||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|||TA: ❌<br>CA: ❌||||||
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

# rsaEncryption (1.2.840.113549.1.1.1)

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
|openca|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ~~DilithiumAES2~~ (1.3.6.1.4.1.2.267.11.4.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ✅<br>CA: ✅<br>EE: ✅||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|botan|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅|||||TA: ❌<br>CA: ❌<br>EE: ❌||||||
|carl-redhound|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext|||||||||||||
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅|||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-provider|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||

# ~~DilithiumAES3~~ (1.3.6.1.4.1.2.267.11.6.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ✅<br>CA: ✅<br>EE: ✅||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|botan|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅|||||TA: ❌<br>CA: ❌<br>EE: ❌||||||
|carl-redhound|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext|||||||||||||
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅|||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-provider|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||

# ~~DilithiumAES5~~ (1.3.6.1.4.1.2.267.11.8.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ✅<br>CA: ✅<br>EE: ✅||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|botan|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅|||||TA: ❌<br>CA: ❌<br>EE: ❌||||||
|carl-redhound|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext|||||||||||||
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅|||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-provider|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||

# Dilithium2 (1.3.6.1.4.1.2.267.7.4.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||||||
|botan|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||TA: ✅<br>CA: ✅<br>EE: ✅||||||
|carl-redhound|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ❌<br>EE: ❌||||||
|corey-digicert|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|cryptonext||TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ❌<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||||||
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|isi-wolfssl|||||||||||||
|kris|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|openca|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ✅<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-gnutls|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-openssl111|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-provider|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅|||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||

# Dilithium3 (1.3.6.1.4.1.2.267.7.6.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||||||
|botan|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||TA: ✅<br>CA: ✅<br>EE: ✅||||||
|carl-redhound|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ❌<br>EE: ❌||||||
|corey-digicert|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|cryptonext||TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ❌<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||||||
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|isi-wolfssl|||||||||||||
|kris|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|openca|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ✅<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-gnutls|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||||||
|oqs-openssl111|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-provider|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅|||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||

# Dilithium5 (1.3.6.1.4.1.2.267.7.8.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||||||
|botan|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||TA: ✅<br>CA: ✅<br>EE: ✅||||||
|carl-redhound|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ❌<br>EE: ❌||||||
|corey-digicert|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|cryptonext||TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ❌<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||||||
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|isi-wolfssl|||||||||||||
|kris|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|openca|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ✅<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-gnutls|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-openssl111|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-provider|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅|||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||

# kyber512 (1.3.6.1.4.1.22554.5.6.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|botan|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|carl-redhound|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|corey-digicert|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|cryptonext|||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌||TA: ✅<br>CA: ✅<br>EE: ❌||||||
|entrust|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|openca|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-gnutls|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-openssl111|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-provider|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||

# kyber768 (1.3.6.1.4.1.22554.5.6.2)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|botan|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|carl-redhound|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|corey-digicert|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|cryptonext|||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌||TA: ✅<br>CA: ✅<br>EE: ❌||||||
|entrust|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|openca|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-gnutls|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-openssl111|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-provider|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||

# kyber1024 (1.3.6.1.4.1.22554.5.6.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|botan|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|carl-redhound|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|corey-digicert|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|cryptonext|||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌||TA: ✅<br>CA: ✅<br>EE: ❌||||||
|entrust|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|openca|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-gnutls|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-openssl111|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-provider|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||

# ~~Falcon-512~~ (1.3.9999.3.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||||||
|botan|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|carl-redhound|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ❌<br>EE: ❌||||||
|corey-digicert|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext||TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|isi-wolfssl|||||||||||||
|kris|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|openca|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-gnutls|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-openssl111|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-provider|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||

# ~~Falcon-1024~~ (1.3.9999.3.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||||||
|botan|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|carl-redhound|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ✅<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ❌<br>EE: ❌||||||
|corey-digicert|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext||TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|isi-wolfssl|||||||||||||
|kris|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|openca|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-gnutls|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-openssl111|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-provider|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||

# Falcon-512 (1.3.9999.3.6)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||TA: ❌<br>CA: ❌<br>EE: ❌||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# Falcon-1024 (1.3.9999.3.9)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||TA: ❌<br>CA: ❌<br>EE: ❌||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ~~SPHINCS+-SHA256-128f-robust~~ (1.3.9999.6.4.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext|||||||||||||
|entrust||TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-provider||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||

# ~~SPHINCS+-SHA256-128s-simple~~ (1.3.9999.6.4.10)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext|||||||||||||
|entrust||TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ~~SPHINCS+-SHA256-128f-simple~~ (1.3.9999.6.4.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext|||||||||||||
|entrust||TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ~~SPHINCS+-SHA256-128s-robust~~ (1.3.9999.6.4.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext|||||||||||||
|entrust||TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ~~SPHINCS+-SHA256-192f-robust~~ (1.3.9999.6.5.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext|||||||||||||
|entrust||TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ~~SPHINCS+-SHA256-192f-simple~~ (1.3.9999.6.5.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext|||||||||||||
|entrust||TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ~~SPHINCS+-SHA256-192s-robust~~ (1.3.9999.6.5.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext|||||||||||||
|entrust||TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
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
|carl-redhound||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext|||||||||||||
|entrust||TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ~~SPHINCS+-SHA256-256f-robust~~ (1.3.9999.6.6.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext|||||||||||||
|entrust||TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ~~SPHINCS+-SHA256-256f-simple~~ (1.3.9999.6.6.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext|||||||||||||
|entrust||TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ~~SPHINCS+-SHA256-256s-robust~~ (1.3.9999.6.6.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext|||||||||||||
|entrust||TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
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
|carl-redhound||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert||TA: ❌<br>CA: ❌<br>EE: ❌||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|cryptonext|||||||||||||
|entrust||TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# sphincsshake128fsimple (1.3.9999.6.7.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|botan|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|carl-redhound|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|corey-digicert|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|cryptonext||TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||||||
|entrust|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|openca|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-gnutls|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-openssl111|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-provider|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||

# sphincsshake192fsimple (1.3.9999.6.8.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|botan|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|carl-redhound|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|corey-digicert|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|cryptonext||TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||||||
|entrust|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|openca|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-gnutls|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-openssl111|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-provider|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||

# sphincsshake256fsimple (1.3.9999.6.9.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|botan|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|carl-redhound|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|corey-digicert|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|cryptonext||TA: ❌<br>CA: ❌<br>EE: ❌|||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅||||||
|entrust|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|isi-wolfssl|||||||||||||
|kris|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|openca|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-gnutls|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-openssl111|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-provider|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||

# COMPOSITE-KEY (2.16.840.1.114027.80.4.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ❌<br>CA: ❌<br>EE: ❌||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||TA: ❌<br>CA: ❌||||||
|botan|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|carl-redhound|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|corey-digicert|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|cryptonext||TA: ❌<br>CA: ❌<br>EE: ❌||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ✅<br>CA: ✅<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ❌<br>CRL CA: ❌|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||
|isi-wolfssl|||||||||||||
|kris|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|openca|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||TA: ❌<br>CA: ❌<br>EE: ❌||||||
|oqs-gnutls|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-openssl111|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||
|oqs-provider|||||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌||||||||

# COMPOSITE_KEY_HASH_N_SIGN (2.16.840.1.114027.80.4.1.2)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext||TA: ❌<br>CA: ❌<br>EE: ❌||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|||TA: ❌<br>CA: ❌<br>EE: ❌||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# COMPOSITE-KEY & Unknown (2.16.840.1.114027.80.4.1_generic_traditional)

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
|openca|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# ExplicitCompositeSignature (2.16.840.1.114027.80.5.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅||TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|corey-digicert|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ❌<br>CA: ❌<br>EE: ❌||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# id-Dilithium3-RSA-PKCS15-SHA256 (2.16.840.1.114027.80.5.1.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|||||||||||||
|cryptonext|||||||||||||
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||||TA: ❌<br>CA: ❌||||||
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
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
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
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||||TA: ❌<br>CA: ❌||||||
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
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
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
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
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
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
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
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||||TA: ❌<br>CA: ❌||||||
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
|entrust|TA: ❌<br>CA: ❌<br>EE: ❌<br>CRL TA: ❌<br>CRL CA: ❌|TA: ❌<br>CA: ❌<br>EE: ❌|||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# Unknown & Unknown (artifacts)

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
|oqs-provider|||||||||||||

# Unknown & Unknown (chameleon-base)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# Unknown & Unknown (chameleon-delta)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# Unknown & Unknown (chameleon-extracted-delta)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert||||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|||||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||

# Unknown & Unknown (hybrid-catalyst)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|isi-wolfssl|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|||||||||||||
|botan|||||||||||||
|carl-redhound|||||||||||||
|corey-digicert|TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅|TA: ✅<br>CA: ✅<br>EE: ✅||TA: ✅<br>CA: ✅<br>EE: ✅<br>CRL TA: ✅<br>CRL CA: ✅||TA: ✅<br>CA: ❌<br>EE: ❌<br>CRL TA: ✅<br>CRL CA: ❌|||||||
|cryptonext|||||||||||||
|entrust|||||||||||||
|isi-wolfssl|||||||||||||
|kris|||||||||||||
|openca|||||||||||||
|oqs-gnutls|||||||||||||
|oqs-openssl111|||||||||||||
|oqs-provider|||||||||||||
