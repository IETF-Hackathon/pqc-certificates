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

   # Root/TA:
   # ========

   # Generate key pair
   certtool --generate-privkey --key-type=dilithium3 --outder --outfile ta/ta_priv.der

   # Generate cert in DER
   cat >ta/ta.tmpl <<EOF
cn = GnuTLS test TA
ca
cert_signing_key
EOF
   certtool --generate-self-signed --inder --load-privkey ta/ta_priv.der --outder --outfile ta/ta.der --template ta/ta.tmpl

   # Convert it to PEM
   certtool -i --inder --infile ta/ta.der --outfile ta/ta.pem

   # Intermediate CA:
   # ================

   # Generate key pair
   certtool --generate-privkey --key-type=dilithium3 --outder --outfile ca/ca_priv.der

   # Generate cert in DER
   cat >ca/ca.tmpl <<EOF
cn = GnuTLS test CA
ca
cert_signing_key
EOF
   certtool --generate-certificate --inder --load-ca-privkey ta/ta_priv.der --load-ca-certificate ta/ta.der --load-privkey ca/ca_priv.der --outder --outfile ca/ca.der --template ca/ca.tmpl

   # Convert it to PEM
   certtool -i --inder --infile ca/ca.der --outfile ca/ca.pem

   # End Entity cert:
   # ================

   # Generate key pair
   certtool --generate-privkey --key-type=dilithium3 --outder --outfile ee/ee_priv.der

   # Generate cert in DER
   cat >ee/ee.tmpl <<EOF
organization = GnuTLS test server
cn = test.gnutls.org
tls_www_server
encryption_key
signing_key
dns_name = test.gnutls.org
EOF
   certtool --generate-certificate --inder --load-ca-privkey ca/ca_priv.der --load-ca-certificate ca/ca.der --load-privkey ee/ee_priv.der --outder --outfile ee/ee.der --template ee/ee.tmpl

   # Convert it to PEM
   certtool -i --inder --infile ee/ee.der --outfile ee/ee.pem
}

gen dilithium3 1.3.6.1.4.1.2.267.7.6.5
