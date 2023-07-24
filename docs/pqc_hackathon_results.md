
IETF PQC Hackathon Interoperability Results
===========================================

Algorithms
==========

* [Unknown (1.2.840.10045.2.1)](#unknown-128401004521)
* [Unknown (1.2.840.10045.3.1.7)](#unknown-1284010045317)
* [Unknown & Dilithium2  (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.4.4)](#unknown--dilithium2--1284010045317_1361412267744)
* [Unknown & Dilithium2  & Unknown (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.4.4_1.3.9999.3.4)](#unknown--dilithium2---unknown-1284010045317_1361412267744_13999934)
* [Unknown & Dilithium3  (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.6.5)](#unknown--dilithium3--1284010045317_1361412267765)
* [Unknown & Dilithium3  & Unknown (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.6.5_1.3.9999.3.1)](#unknown--dilithium3---unknown-1284010045317_1361412267765_13999931)
* [Unknown (1.2.840.10045.4.3.2)](#unknown-1284010045432)
* [Unknown (1.2.840.113549.1.1.1)](#unknown-12840113549111)
* [Unknown (1.3.6.1.4.1.2.267.11.4.4)](#unknown-13614122671144)
* [Unknown (1.3.6.1.4.1.2.267.11.6.5)](#unknown-13614122671165)
* [Unknown (1.3.6.1.4.1.2.267.11.8.7)](#unknown-13614122671187)
* [Dilithium2  (1.3.6.1.4.1.2.267.7.4.4)](#dilithium2--1361412267744)
* [Dilithium3  (1.3.6.1.4.1.2.267.7.6.5)](#dilithium3--1361412267765)
* [Dilithium5  (1.3.6.1.4.1.2.267.7.8.7)](#dilithium5--1361412267787)
* [Unknown (1.3.9999.3.1)](#unknown-13999931)
* [Unknown (1.3.9999.3.4)](#unknown-13999934)
* [Falcon-512  (1.3.9999.3.6)](#falcon-512--13999936)
* [Falcon-1024  (1.3.9999.3.9)](#falcon-1024--13999939)
* [Unknown (1.3.9999.6.4.1)](#unknown-139999641)
* [Unknown (1.3.9999.6.4.10)](#unknown-1399996410)
* [Unknown (1.3.9999.6.4.4)](#unknown-139999644)
* [Unknown (1.3.9999.6.4.7)](#unknown-139999647)
* [Unknown (1.3.9999.6.5.1)](#unknown-139999651)
* [Unknown (1.3.9999.6.5.3)](#unknown-139999653)
* [Unknown (1.3.9999.6.5.5)](#unknown-139999655)
* [Unknown (1.3.9999.6.5.7)](#unknown-139999657)
* [Unknown (1.3.9999.6.6.1)](#unknown-139999661)
* [Unknown (1.3.9999.6.6.3)](#unknown-139999663)
* [Unknown (1.3.9999.6.6.5)](#unknown-139999665)
* [Unknown (1.3.9999.6.6.7)](#unknown-139999667)
* [Unknown (1.3.9999.6.7.4)](#unknown-139999674)
* [Unknown (1.3.9999.6.8.3)](#unknown-139999683)
* [Unknown (1.3.9999.6.9.3)](#unknown-139999693)
* [COMPOSITE-KEY  (2.16.840.1.114027.80.4.1)](#composite-key--21684011140278041)
* [Unknown (2.16.840.1.114027.80.4.1.2)](#unknown-216840111402780412)
* [COMPOSITE-KEY  & Unknown (2.16.840.1.114027.80.4.1_generic_traditional)](#composite-key---unknown-21684011140278041_generic_traditional)
* [Unknown (2.16.840.1.114027.80.5.1)](#unknown-21684011140278051)
* [Unknown (2.16.840.1.114027.80.5.1.1)](#unknown-216840111402780511)
* [Unknown (2.16.840.1.114027.80.5.1.14)](#unknown-2168401114027805114)
* [Unknown (2.16.840.1.114027.80.5.1.2)](#unknown-216840111402780512)
* [Unknown (2.16.840.1.114027.80.5.1.3)](#unknown-216840111402780513)
* [Unknown (2.16.840.1.114027.80.5.1.5)](#unknown-216840111402780515)
* [Unknown (2.16.840.1.114027.80.5.1.6)](#unknown-216840111402780516)
* [Unknown (2.16.840.1.114027.80.5.1.8)](#unknown-216840111402780518)
* [Unknown (2.16.840.1.114027.80.5.1.9)](#unknown-216840111402780519)
* [Unknown & Unknown (artifacts)](#unknown--unknown-artifacts)
* [Unknown & Unknown (base)](#unknown--unknown-base)
* [Unknown & Unknown (delta)](#unknown--unknown-delta)
* [Unknown & Unknown (extracted)](#unknown--unknown-extracted)
* [Unknown & Unknown (hybrid)](#unknown--unknown-hybrid)


Rows are producers. Columns are parsers.

# Unknown (1.2.840.10045.2.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||TA: ✓<br>CA: ✓<br>EE: ✓||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||TA: X<br>CA: X<br>EE: X||||||
|entrust||||||||||||
|kris||||||||||||
|openca|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.2.840.10045.3.1.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown & Dilithium2  (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.4.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown & Dilithium2  & Unknown (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.4.4_1.3.9999.3.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown & Dilithium3  (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.6.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown & Dilithium3  & Unknown (1.2.840.10045.3.1.7_1.3.6.1.4.1.2.267.7.6.5_1.3.9999.3.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.2.840.10045.4.3.2)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: X<br>CA: X<br>EE: X||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.2.840.113549.1.1.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.3.6.1.4.1.2.267.11.4.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ✓<br>CA: ✓<br>EE: ✓||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|botan|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||||||||||
|carl-redhound|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: ✓<br>CA: ✓<br>EE: ✓||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|oqsprovider|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||

# Unknown (1.3.6.1.4.1.2.267.11.6.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ✓<br>CA: ✓<br>EE: ✓||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|botan|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||||||||||
|carl-redhound|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: ✓<br>CA: ✓<br>EE: ✓||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|oqsprovider|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||

# Unknown (1.3.6.1.4.1.2.267.11.8.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ✓<br>CA: ✓<br>EE: ✓||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|botan|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||||||||||
|carl-redhound|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: ✓<br>CA: ✓<br>EE: ✓||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|oqsprovider|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||

# Dilithium2  (1.3.6.1.4.1.2.267.7.4.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|botan|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||||
|carl-redhound|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: X<br>CRL TA: X<br>CRL CA: X||TA: ✓<br>CA: ✓<br>EE: X<br>CRL TA: ✓<br>CRL CA: ✓||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||||
|kris|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X||||||
|openca|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||TA: ✓<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|oqs-gnutls||||||||||||
|oqs-openssl111|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|oqsprovider|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||

# Dilithium3  (1.3.6.1.4.1.2.267.7.6.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|botan|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||||
|carl-redhound|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: X<br>CRL TA: X<br>CRL CA: X||TA: ✓<br>CA: ✓<br>EE: X<br>CRL TA: ✓<br>CRL CA: ✓||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||||
|kris|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X||||||
|openca|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||TA: ✓<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|oqs-gnutls|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|oqs-openssl111|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|oqsprovider|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||

# Dilithium5  (1.3.6.1.4.1.2.267.7.8.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|botan|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||||
|carl-redhound|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: X<br>CRL TA: X<br>CRL CA: X||TA: ✓<br>CA: ✓<br>EE: X<br>CRL TA: ✓<br>CRL CA: ✓||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||||
|kris|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X||||||
|openca|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||TA: ✓<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|oqs-gnutls||||||||||||
|oqs-openssl111|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|oqsprovider|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: ✓<br>CA: ✓<br>EE: ✓||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||

# Unknown (1.3.9999.3.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|botan||||||||||||
|carl-redhound|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||||||||
|kris|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X||||||
|openca|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|oqs-gnutls||||||||||||
|oqs-openssl111|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|oqsprovider|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||

# Unknown (1.3.9999.3.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|botan||||||||||||
|carl-redhound|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||||||||
|kris|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X||||||
|openca|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|oqs-gnutls||||||||||||
|oqs-openssl111|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|oqsprovider|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||

# Falcon-512  (1.3.9999.3.6)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Falcon-1024  (1.3.9999.3.9)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.3.9999.6.4.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust||TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|oqsprovider||TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||

# Unknown (1.3.9999.6.4.10)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust||TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.3.9999.6.4.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust||TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.3.9999.6.4.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust||TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.3.9999.6.5.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust||TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.3.9999.6.5.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust||TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.3.9999.6.5.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust||TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.3.9999.6.5.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust||TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.3.9999.6.6.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust||TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.3.9999.6.6.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust||TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.3.9999.6.6.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust||TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.3.9999.6.6.7)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|corey-digicert||TA: X<br>CA: X<br>EE: X||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust||TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.3.9999.6.7.4)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.3.9999.6.8.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (1.3.9999.6.9.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||TA: X<br>CA: X<br>EE: X||||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# COMPOSITE-KEY  (2.16.840.1.114027.80.4.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||TA: X<br>CA: X<br>EE: X||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||TA: X<br>CA: X<br>EE: X||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||TA: X<br>CA: X<br>EE: X||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||TA: ✓<br>CA: ✓<br>EE: X<br>CRL TA: X<br>CRL CA: X||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|kris||||||||||||
|openca|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (2.16.840.1.114027.80.4.1.2)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||TA: X<br>CA: X<br>EE: X||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# COMPOSITE-KEY  & Unknown (2.16.840.1.114027.80.4.1_generic_traditional)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (2.16.840.1.114027.80.5.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X||||||
|corey-digicert|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: X<br>CA: X<br>EE: X||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (2.16.840.1.114027.80.5.1.1)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (2.16.840.1.114027.80.5.1.14)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (2.16.840.1.114027.80.5.1.2)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (2.16.840.1.114027.80.5.1.3)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (2.16.840.1.114027.80.5.1.5)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (2.16.840.1.114027.80.5.1.6)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (2.16.840.1.114027.80.5.1.8)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown (2.16.840.1.114027.80.5.1.9)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust|TA: X<br>CA: X<br>EE: X<br>CRL TA: X<br>CRL CA: X|TA: X<br>CA: X<br>EE: X||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown & Unknown (artifacts)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||||||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown & Unknown (base)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown & Unknown (delta)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown & Unknown (extracted)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert||||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||

# Unknown & Unknown (hybrid)

|-|bc|botan|carl-redhound|corey-digicert|cryptonext|entrust|kris|openca|oqs-gnutls|oqs-openssl111|oqsprovider|
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
|bc||||||||||||
|botan||||||||||||
|carl-redhound||||||||||||
|corey-digicert|TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓|TA: ✓<br>CA: ✓<br>EE: ✓||TA: ✓<br>CA: ✓<br>EE: ✓<br>CRL TA: ✓<br>CRL CA: ✓||TA: ✓<br>CA: X<br>EE: X<br>CRL TA: ✓<br>CRL CA: X||||||
|cryptonext||||||||||||
|entrust||||||||||||
|kris||||||||||||
|openca||||||||||||
|oqs-gnutls||||||||||||
|oqs-openssl111||||||||||||
|oqsprovider||||||||||||
