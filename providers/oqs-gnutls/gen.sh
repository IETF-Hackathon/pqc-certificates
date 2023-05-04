#!/bin/sh

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

   CERTTOOL="docker run --rm -v $(pwd):/artifacts:Z -w /artifacts ghcr.io/ueno/oqs-gnutls:main /install/bin/certtool"

   # Root/TA:
   # ========

   # Generate key pair
   $CERTTOOL --generate-privkey --key-type=dilithium3 --outder --outfile ta/ta_priv.der

   # Generate cert in DER
   cat >ta/ta.tmpl <<EOF
cn = GnuTLS test TA
ca
cert_signing_key
EOF
   $CERTTOOL --generate-self-signed --inder --load-privkey ta/ta_priv.der --outder --outfile ta/ta.der --template ta/ta.tmpl

   # Convert it to PEM
   $CERTTOOL -i --inder --infile ta/ta.der --outfile ta/ta.pem

   # Intermediate CA:
   # ================

   # Generate key pair
   $CERTTOOL --generate-privkey --key-type=dilithium3 --outder --outfile ca/ca_priv.der

   # Generate cert in DER
   cat >ca/ca.tmpl <<EOF
cn = GnuTLS test CA
ca
cert_signing_key
EOF
   $CERTTOOL --generate-certificate --inder --load-ca-privkey ta/ta_priv.der --load-ca-certificate ta/ta.der --load-privkey ca/ca_priv.der --outder --outfile ca/ca.der --template ca/ca.tmpl

   # Convert it to PEM
   $CERTTOOL -i --inder --infile ca/ca.der --outfile ca/ca.pem

   # End Entity cert:
   # ================

   # Generate key pair
   $CERTTOOL --generate-privkey --key-type=dilithium3 --outder --outfile ee/cert_priv.der

   # Generate cert in DER
   cat >ee/ee.tmpl <<EOF
organization = GnuTLS test server
cn = test.gnutls.org
tls_www_server
encryption_key
signing_key
dns_name = test.gnutls.org
EOF
   $CERTTOOL --generate-certificate --inder --load-ca-privkey ca/ca_priv.der --load-ca-certificate ca/ca.der --load-privkey ee/cert_priv.der --outder --outfile ee/cert.der --template ee/ee.tmpl

   # Convert it to PEM
   $CERTTOOL -i --inder --infile ee/cert.der --outfile ee/cert.pem
}

gen dilithium3 1.3.6.1.4.1.2.267.7.6.5
