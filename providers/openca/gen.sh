gen_dirs() {

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

gen_composite_key() {

   # The OpenCA's LibPKI tools do not allow for
   # direct generation of composite keys but their
   # aggregation from individual ones

   # Output file for the key
   OUT=$1

   # Algorithms for up to three different components
   ALGS=$2 $3 $4

   # Cycle through the algorithms and builds the key
   for algorithm in ${ALGS} ; do
      options=
      if ! [ "x$algorithm" = "x" ] ; then
         # Generate the first component
         result=`pki-tool genkey -algor $algorithm -batch -out comp_$algorithm.key`;
         if [ $? -gt 0 ] ; then
            echo
            echo "    ERROR: Cannot generate component key $1";
            echo
            exit 1
         fi
      fi
      options+= -addkey comp_$algorithm.key
   done
   pki-tool genkey -out "$OUT" -algor composite $options
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

   # Root/TA:
   # ========

   # Generate key pair
   if [ "$1" = "composite" ] ; then
      gen_composite_key "ta/ta_priv.pem" "$1" "RSA" "ECDSA"
   else
      pki-tool genkey -algor "$1" -batch -out "ta/ta_priv.pem"
   fi

   # Converts the key pair
   # pki-tool format -outform DER -in ta/ta_priv.pem \
   #    -out ta/ta_priv.der
   # Generate the request
   pki-tool genreq -batch -signkey "ta/ta_priv.pem" \
      -subject "CN=PQC Test" -out "ta/ta_req.pem"
   # Generate the certificate
   pki-tool gencert -batch -selfsign \
      -config "../config" -profile "RootCA" \
      -in ta/ta_req.pem -out ta/ta.pem \
      -signkey "ta/ta_priv.pem"
   # Output the key in DER
   # pki-tool format -outform DER -in ta/ta.pem \
   #    -out ta/ta.der

   # Intermediate CA:
   # ================

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
      -config "../config" -profile "IntermediateCA" \
      -signkey "ta/ta_priv.pem" -signcert "ta/ta.pem" \
      -in "ca/ca_req.pem" -out "ca/ca.pem"
   # Converts the certificate to DER format
   # pki-tool format -outform DER -in ca/ca.pem \
   #    -out ca/ca.der

   # End Entity cert:
   # ================

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
      -config "../config" -profile "EndEntity"
   # Converts the certificate to DER format
   # pki-tool format -outform DER -in ca/ca.pem \
   #    -out ca/ca.der

   # All Done
   cd ..
}


# Sub folders for the provider
SUBDIRS=libpki

for dir in ${SUBDIRS} ; do 

   # Generates the LibPKI directory
   [ -d "${dir}" ] || mkdir -p "${dir}"
   [ -d "${dir}/artifacts" ] || mkdir -p "${dir}/artifacts"

   # PQC Implementation: Dilithium
   result=$(cd ${dir}/artifacts && gen dilithium2 1.3.6.1.4.1.2.267.7.4.4)
   result=$(cd ${dir}/artifacts && gen dilithium3 1.3.6.1.4.1.2.267.7.6.5)
   result=$(cd ${dir}/artifacts && gen dilithium5 1.3.6.1.4.1.2.267.7.8.7)

   # PQC Implementation: Falcon
   result=$(cd ${dir}/artifacts && gen falcon512 1.3.9999.3.1)
   result=$(cd ${dir}/artifacts && gen falcon1024 1.3.9999.3.4)

   # PQC Implementation: Sphincs+
   # result=$(cd ${dir}/artifacts && gen sphincssha256128frobust 1.3.9999.6.4.1)

   # Composite Implementation
   # result=$(cd ${dir}/artifacts && gen composite 1.3.6. )

done

exit 0;