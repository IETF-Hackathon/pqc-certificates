#!/bin/bash

gen() {
   mkdir $2 && cd $2
   export $1=$2

   # Root/TA:
   mkdir ta
   # Generate key pair
   openssl req -x509 -new -newkey $1 -keyout ta/ta_priv.pem -out ta/ta.pem -nodes -subj "/CN=TA"  -addext basicConstraints=critical,CA:TRUE -days 730
   # Also generate DER for private key
   openssl pkcs8 -topk8 -inform PEM -outform DER -in ta/ta_priv.pem -out ta/ta_priv.der -nocrypt
   # Also generate cert in DER
   openssl x509 -in ta/ta.pem -out ta/ta.der -outform DER

   # Intermediate CA:
   mkdir ca
   # Generate key pair in PEM format
   openssl req -new -newkey $1 -keyout ca/ca_priv.pem -out ca/ca.csr -nodes -subj "/CN=CA"  -addext basicConstraints=critical,CA:TRUE
   # Also generate DER for private key
   openssl pkcs8 -topk8 -inform PEM -outform DER -in ca/ca_priv.pem -out ca/ca_priv.der -nocrypt
   # Generate CSR in PEM
   openssl x509 -req -in ca/ca.csr -out ca/ca.pem -CA ta/ta.pem -CAkey ta/ta_priv.pem -CAcreateserial -days 730
   # Generate cert in DER format
   openssl x509 -outform der -req -in ca/ca.csr -out ca/ca.der -CA ta/ta.pem -CAkey ta/ta_priv.pem -CAcreateserial -days 730
   # Also generate cert in PEM format
   openssl x509 -req -in ca/ca.csr -out ca/ca.pem -CA ta/ta.pem -CAkey ta/ta_priv.pem -CAcreateserial -days 730

   # End Entity cert:
   mkdir ee
   # Generate key pair in PEM format
   openssl req -new -newkey $1 -keyout ee/cert_priv.pem -out ee/cert.csr -nodes -subj "/CN=EE"  -addext basicConstraints=CA:FALSE
   # Also generate DER for private key
   openssl pkcs8 -topk8 -inform PEM -outform DER -in ee/cert_priv.pem -out ee/cert_priv.der -nocrypt
   # Generate CSR in PEM
   openssl x509 -req -in ee/cert.csr -out ee/cert.pem -CA ca/ca.pem -CAkey ca/ca_priv.pem -CAcreateserial -days 730
   # Generate cert in DER format
   openssl x509 -outform der -req -in ee/cert.csr -out ee/cert.der -CA ca/ca.pem -CAkey ca/ca_priv.pem -CAcreateserial -days 730
   # Also generate cert in PEM format
   openssl x509 -req -in ee/cert.csr -out ee/cert.pem -CA ca/ca.pem -CAkey ca/ca_priv.pem -CAcreateserial -days 730
   cd ..
}

# Classic/baseline test: 
# gen ed448 1.3.101.113
gen DILITHIUM_2 1.3.6.1.4.1.2.267.7.4.4
gen DILITHIUM_3 1.3.6.1.4.1.2.267.7.6.5
gen DILITHIUM_5 1.3.6.1.4.1.2.267.7.8.7
gen FALCON_512 1.3.9999.3.1
gen FALCON_1024 1.3.9999.3.4
