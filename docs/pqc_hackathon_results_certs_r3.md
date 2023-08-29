
IETF PQC Hackathon Interoperability Results
===========================================

Algorithms
==========

* [Dilithium2 (1.3.6.1.4.1.2.267.7.4.4)](#dilithium2-1361412267744)
* [Dilithium3 (1.3.6.1.4.1.2.267.7.6.5)](#dilithium3-1361412267765)
* [Dilithium5 (1.3.6.1.4.1.2.267.7.8.7)](#dilithium5-1361412267787)
* [~~Falcon-512~~ (1.3.9999.3.1)](#falcon-512-13999931)
* [~~Falcon-1024~~ (1.3.9999.3.4)](#falcon-1024-13999934)
* [sphincsshake128fsimple (1.3.9999.6.7.4)](#sphincsshake128fsimple-139999674)
* [sphincsshake192fsimple (1.3.9999.6.8.3)](#sphincsshake192fsimple-139999683)
* [sphincsshake256fsimple (1.3.9999.6.9.3)](#sphincsshake256fsimple-139999693)
* [id-Dilithium3-RSA-PKCS15-SHA256 (2.16.840.1.114027.80.5.1.1)](#id-dilithium3-rsa-pkcs15-sha256-216840111402780511)
* [id-Dilithium3-RSA-PSS-SHA256 (2.16.840.1.114027.80.5.1.14)](#id-dilithium3-rsa-pss-sha256-2168401114027805114)
* [id-Dilithium3-ECDSA-P256-SHA256 (2.16.840.1.114027.80.5.1.2)](#id-dilithium3-ecdsa-p256-sha256-216840111402780512)
* [id-Dilithium3-ECDSA-brainpoolP256r1-SHA256 (2.16.840.1.114027.80.5.1.3)](#id-dilithium3-ecdsa-brainpoolp256r1-sha256-216840111402780513)
* [id-Dilithium5-ECDSA-P384-SHA384 (2.16.840.1.114027.80.5.1.5)](#id-dilithium5-ecdsa-p384-sha384-216840111402780515)
* [id-Dilithium5-ECDSA-brainpoolP384r1-SHA384 (2.16.840.1.114027.80.5.1.6)](#id-dilithium5-ecdsa-brainpoolp384r1-sha384-216840111402780516)
* [~~id-Falcon512-ECDSA-P256-SHA256~~ (2.16.840.1.114027.80.5.1.8)](#id-falcon512-ecdsa-p256-sha256-216840111402780518)
* [~~id-Falcon512-ECDSA-brainpoolP256r1-SHA256~~ (2.16.840.1.114027.80.5.1.9)](#id-falcon512-ecdsa-brainpoolp256r1-sha256-216840111402780519)
* [Unknown & Unknown (hybrid-catalyst)](#unknown--unknown-hybrid-catalyst)


Rows are producers. Columns are parsers.

# Dilithium2 (1.3.6.1.4.1.2.267.7.4.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||||||||||
|botan|❌|✅||||||||||
|carl-redhound|✅|❌||||||||||
|corey-digicert|✅|✅||||||||||
|cryptonext||✅||||||||||
|entrust|❌|✅||||||||||
|kris|❌|❌||||||||||
|openca|❌|❌||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111|✅|✅||||||||||
|oqs-provider|✅|✅||||||||||

# Dilithium3 (1.3.6.1.4.1.2.267.7.6.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||||||||||
|botan|❌|✅||||||||||
|carl-redhound|✅|❌||||||||||
|corey-digicert|✅|✅||||||||||
|cryptonext||✅||||||||||
|entrust|❌|✅||||||||||
|kris|❌|❌||||||||||
|openca|❌|❌||||||||||
|oqs-gnutls|❌|✅||||||||||
|oqs-openssl111|✅|✅||||||||||
|oqs-provider|✅|✅||||||||||

# Dilithium5 (1.3.6.1.4.1.2.267.7.8.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|✅||||||||||
|botan|❌|✅||||||||||
|carl-redhound|✅|❌||||||||||
|corey-digicert|✅|✅||||||||||
|cryptonext||✅||||||||||
|entrust|❌|✅||||||||||
|kris|❌|❌||||||||||
|openca|❌|❌||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111|✅|✅||||||||||
|oqs-provider|✅|✅||||||||||

# ~~Falcon-512~~ (1.3.9999.3.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|❌||||||||||
|botan||||||||||||
|carl-redhound|✅|❌||||||||||
|corey-digicert|✅|❌||||||||||
|cryptonext||❌||||||||||
|entrust|❌|❌||||||||||
|kris|❌|❌||||||||||
|openca|❌|❌||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111|✅|❌||||||||||
|oqs-provider|✅|❌||||||||||

# ~~Falcon-1024~~ (1.3.9999.3.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc|✅|❌||||||||||
|botan||||||||||||
|carl-redhound|✅|❌||||||||||
|corey-digicert|✅|❌||||||||||
|cryptonext||❌||||||||||
|entrust|❌|❌||||||||||
|kris|❌|❌||||||||||
|openca|❌|❌||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111|✅|❌||||||||||
|oqs-provider|✅|❌||||||||||

# sphincsshake128fsimple (1.3.9999.6.7.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||❌||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqs-provider||||||||||||

# sphincsshake192fsimple (1.3.9999.6.8.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||❌||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqs-provider||||||||||||

# sphincsshake256fsimple (1.3.9999.6.9.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||❌||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqs-provider||||||||||||

# id-Dilithium3-RSA-PKCS15-SHA256 (2.16.840.1.114027.80.5.1.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust|❌|❌||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqs-provider||||||||||||

# id-Dilithium3-RSA-PSS-SHA256 (2.16.840.1.114027.80.5.1.14)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust||❌||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqs-provider||||||||||||

# id-Dilithium3-ECDSA-P256-SHA256 (2.16.840.1.114027.80.5.1.2)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust|❌|❌||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqs-provider||||||||||||

# id-Dilithium3-ECDSA-brainpoolP256r1-SHA256 (2.16.840.1.114027.80.5.1.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust|❌|❌||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqs-provider||||||||||||

# id-Dilithium5-ECDSA-P384-SHA384 (2.16.840.1.114027.80.5.1.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust|❌|❌||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqs-provider||||||||||||

# id-Dilithium5-ECDSA-brainpoolP384r1-SHA384 (2.16.840.1.114027.80.5.1.6)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust|❌|❌||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqs-provider||||||||||||

# ~~id-Falcon512-ECDSA-P256-SHA256~~ (2.16.840.1.114027.80.5.1.8)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust|❌|❌||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqs-provider||||||||||||

# ~~id-Falcon512-ECDSA-brainpoolP256r1-SHA256~~ (2.16.840.1.114027.80.5.1.9)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust|❌|❌||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqs-provider||||||||||||

# Unknown & Unknown (hybrid-catalyst)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqs-provider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||✅||||||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqs-provider||||||||||||
