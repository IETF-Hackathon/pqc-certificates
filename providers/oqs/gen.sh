#!/bin/bash

# be sure to not add wrapped pubkeys:
unset DRAFT_MASSIMO_LAMPS_PQ_SIG_CERTIFICATES_00

gen_dirs() {

   local dir
   # Generates the internal directories
   # An argument is expected for the name of
   # the OID/Parent directory
   _BASE_DIR=$1

   # Creates the Main Dir
   [ -d "$_BASE_DIR" ] || mkdir -p "$_BASE_DIR"

   # Default folders
   SUBDIRS="ta ca ee crl ocsp"

   # Creates the Directory and the SubDirs
   for dir in ${SUBDIRS} ; do
      mkdir -p "${_BASE_DIR}/${dir}"
   done
}

gen() {

   # Function to generate the ta/, ca/, and ee/
   # directories and X.509 key + req + cert.
   #
   # Additionally it also creates the crl/ and
   # ocsp/ directories.
   ALGORITHM=$1
   BASE_DIR=$2
   
   # Generates the directories
   gen_dirs "$BASE_DIR"

   # Change to the newly created directory
   cd "$BASE_DIR"
   echo "Operating in $(pwd)"

   # Root/TA:
   # ========

   # Generate key pair
   openssl req -x509 -new -newkey $1 -keyout ta/ta_priv.pem -out ta/ta.pem -nodes -subj "/CN=TA"
   if [ $? -ne 0 ]; then
	   echo "Failure to generate TA key pair"
	   exit -1
   fi
   # Also generate DER for private key
   openssl pkcs8 -topk8 -inform PEM -outform DER -in ta/ta_priv.pem -out ta/ta_priv.der -nocrypt
   if [ $? -ne 0 ]; then
	   echo "Failure to generate TA private key DER"
	   exit -1
   fi
   # Also generate cert in DER
   openssl x509 -in ta/ta.pem -out ta/ta.der -outform DER
   if [ $? -ne 0 ]; then
	   echo "Failure to generate TA cert DER"
	   exit -1
   fi

   # Intermediate CA:
   # ================

   # Generate key pair in PEM format
   openssl req -new -newkey $1 -keyout ca/ca_priv.pem -out ca/ca.csr -nodes -subj "/CN=CA"
   if [ $? -ne 0 ]; then
	   echo "Failure to generate CA key pair"
	   exit -1
   fi
   # Also generate DER for private key
   openssl pkcs8 -topk8 -inform PEM -outform DER -in ca/ca_priv.pem -out ca/ca_priv.der -nocrypt
   if [ $? -ne 0 ]; then
	   echo "Failure to generate CA key DER" 
	   exit -1
   fi
   # Generate CSR in PEM
   openssl x509 -req -in ca/ca.csr -out ca/ca.pem -CA ta/ta.pem -CAkey ta/ta_priv.pem -CAcreateserial -days 365
   if [ $? -ne 0 ]; then
	   echo "Failure to generate CA CSR"
	   exit -1
   fi
   # Generate cert in DER format
   openssl x509 -outform der -req -in ca/ca.csr -out ca/ca.der -CA ta/ta.pem -CAkey ta/ta_priv.pem -CAcreateserial -days 365
   if [ $? -ne 0 ]; then
	   echo "Failure to generate CA cert"
	   exit -1
   fi
   # Also generate cert in PEM format
   openssl x509 -req -in ca/ca.csr -out ca/ca.pem -CA ta/ta.pem -CAkey ta/ta_priv.pem -CAcreateserial -days 365
   if [ $? -ne 0 ]; then
	   echo "Failure to generate CA PEM"
	   exit -1
   fi

   # End Entity cert:
   # ================

   # Generate key pair in PEM format
   openssl req -new -newkey $1 -keyout ee/cert_priv.pem -out ee/cert.csr -nodes -subj "/CN=EE"
   if [ $? -ne 0 ]; then
	   echo "Failure to generate EE key pair"
	   exit -1
   fi
   # Also generate DER for private key
   openssl pkcs8 -topk8 -inform PEM -outform DER -in ee/cert_priv.pem -out ee/cert_priv.der -nocrypt
   if [ $? -ne 0 ]; then
	   echo "Failure to generate EE privkey PEM"
	   exit -1
   fi
   # Generate CSR in PEM
   openssl x509 -req -in ee/cert.csr -out ee/cert.pem -CA ca/ca.pem -CAkey ca/ca_priv.pem -CAcreateserial -days 365
   if [ $? -ne 0 ]; then
	   echo "Failure to generate EE CSR"
	   exit -1
   fi
   # Generate cert in DER format
   openssl x509 -outform der -req -in ee/cert.csr -out ee/cert.der -CA ca/ca.pem -CAkey ca/ca_priv.pem -CAcreateserial -days 365
   if [ $? -ne 0 ]; then
	   echo "Failure to generate EE cert"
	   exit -1
   fi
   # Also generate cert in PEM format
   openssl x509 -req -in ee/cert.csr -out ee/cert.pem -CA ca/ca.pem -CAkey ca/ca_priv.pem -CAcreateserial -days 365
   if [ $? -ne 0 ]; then
	   echo "Failure to generate EE PEM"
	   exit -1
   fi

   cd ..
}

runandlog() {
   cd $1/artifacts && gen $2 $3 >> ../../log 2>&1 && cd ../..
}
   
rm -rf log
# Sub folders for the provider
SUBDIRS="openssl111 oqsprovider"

for dir in ${SUBDIRS} ; do 

   if [ $dir == "oqsprovider" ]; then
	   # check openssl actually supports providers
	   openssl list --providers | grep oqsprovider > /dev/null
	   if [ $? -ne 0 ]; then
		   echo "oqsprovider not available"
		   continue
	   fi
   fi
   if [ $dir == "openssl111" ]; then
	   # check oqs-openssl111 runs
	   openssl version | grep "Open Quantum Safe" > /dev/null
	   if [ $? -ne 0 ]; then
		   echo "OQS-openssl not active"
		   continue
	   fi
   fi
   # Generates the LibPKI directory
   [ -d "${dir}" ] || mkdir -p "${dir}"
   [ -d "${dir}/artifacts" ] || mkdir -p "${dir}/artifacts"

   # Classic/baseline test: 
   gen ed448 1.3.101.113 >> log 2>&1

   # Dilithium
   runandlog ${dir} dilithium2 1.3.6.1.4.1.2.267.7.4.4
   runandlog ${dir} dilithium3 1.3.6.1.4.1.2.267.7.6.5
   runandlog ${dir} dilithium5 1.3.6.1.4.1.2.267.7.8.7

   # Dilitium AES
   runandlog ${dir} dilithium2_aes 1.3.6.1.4.1.2.267.11.4.4
   runandlog ${dir} dilithium3_aes 1.3.6.1.4.1.2.267.11.6.5
   runandlog ${dir} dilithium5_aes 1.3.6.1.4.1.2.267.11.8.7

   # Falcon
   runandlog ${dir} falcon512 1.3.9999.3.1
   runandlog ${dir} falcon1024 1.3.9999.3.4

   # Sphincs+
   runandlog ${dir} sphincssha256128frobust 1.3.9999.6.4.1

done
echo "All data successfully generated."
