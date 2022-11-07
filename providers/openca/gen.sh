#!/bin/bash

MY_DIR=$(echo ${PWD})

gen() {
   mkdir $2 && cd $2

   # Root/TA:
   mkdir ta
   # Generate key pair
   pki-tool genkey -algor $1 -batch -out ta/ta_priv.pem
   # Converts the key pair
   # pki-tool format -outform DER -in ta/ta_priv.pem \
   #    -out ta/ta_priv.der
   # Generate the request
   pki-tool genreq -batch -signkey "ta/ta_priv.pem" \
      -subject "CN=PQC Test" -out "ta/ta_req.pem"
   # Generate the certificate
   pki-tool gencert -batch -selfsign \
      -config "../../config" -profile "RootCA" \
      -in ta/ta_req.pem -out ta/ta.pem \
      -signkey "ta/ta_priv.pem"
   # Output the key in DER
   # pki-tool format -outform DER -in ta/ta.pem \
   #    -out ta/ta.der

   # Intermediate CA:
   mkdir ca
   # Generates the key pair
   pki-tool genkey -batch -algor "$1" -out "ca/ca_priv.pem"
   # Converts the key into DER format
   # pki-tool format -outform DER -in ca/ca_priv.pem \
   #    -out ca/ca_priv.der
   # Generates the CA's PKCS#10 request
   pki-tool genreq -batch -signkey "ca/ca_priv.pem" \
      -subject "CN=Intermediate CA" -out "ca/ca_req.pem"
   # Generates the CA's certificate via the Root CA
   pki-tool gencert -batch \
      -config "../../config" -profile "IntermediateCA" \
      -signkey "ta/ta_priv.pem" -signcert "ta/ta.pem" \
      -in "ca/ca_req.pem" -out "ca/ca.pem"
   # Converts the certificate to DER format
   # pki-tool format -outform DER -in ca/ca.pem \
   #    -out ca/ca.der

   # End Entity cert:
   mkdir ee
   # Generates the key pair
   pki-tool genkey -batch -algor "$1" -out "ee/ee_priv.pem"
   # Converts the key into DER format
   # pki-tool format -outform DER -in ee/ee_priv.pem \
   #    -out ee/ee_priv.der
   # Generates the CA's PKCS#10 request
   pki-tool genreq -batch -signkey "ee/ee_priv.pem" \
      -subject "CN=End Entity" -out ee/ee_req.pem
   # Generates the EE certificate via the ICA
   pki-tool gencert -batch \
      -signkey "ca/ca_priv.pem" -signcert "ca/ca.pem" \
      -in "ee/ee_req.pem" -out "ee/ca.pem" \
      -config "../../config" -profile "EndEntity"
   # Converts the certificate to DER format
   # pki-tool format -outform DER -in ca/ca.pem \
   #    -out ca/ca.der

   # All Done
   cd ..
}

# Generates the LibPKI directory
[ -d libpki ] || mkdir -p "./libpki"

# PQC Implementation
result=$(cd libpki && gen dilithium2 1.3.6.1.4.1.2.267.7.4.4)
result=$(cd libpki && gen dilithium3 1.3.6.1.4.1.2.267.7.6.5)
result=$(cd libpki && gen dilithium5 1.3.6.1.4.1.2.267.7.8.7)
result=$(cd libpki && gen falcon512 1.3.9999.3.1)
result=$(cd libpki && gen falcon1024 1.3.9999.3.4)
# result=$(cd libpki && gen sphincssha256128frobust 1.3.9999.6.4.1)

# Composite Implementation
result=$(cd libpki && gen_composite composite )

exit 0;