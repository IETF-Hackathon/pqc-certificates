#!/bin/bash

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

gen() {
   # Function to generate the ta/, ca/, and ee/
   # directories and X.509 key + req + cert.
   #
   # Additionally it also creates the crl/ and
   # ocsp/ directories.

   # Generates the directories
   gen_dirs "$2"
   
   if [ "$1" = "dilithium2" ]
   then
   	ALGO="Dilithium"
   	PARAMS="Dilithium-4x4-r3"
   elif [ "$1" = "dilithium3" ]
   then
   	ALGO="Dilithium"
   	PARAMS="Dilithium-6x5-r3"
   elif [ "$1" = "dilithium5" ]
   then
   	ALGO="Dilithium"
   	PARAMS="Dilithium-8x7-r3"
   elif [ "$1" = "dilithium2aes" ]
   then
   	ALGO="Dilithium"
   	PARAMS="Dilithium-4x4-AES-r3"
   elif [ "$1" = "dilithium3aes" ]
   then
   	ALGO="Dilithium"
   	PARAMS="Dilithium-6x5-AES-r3"
   elif [ "$1" = "dilithium5aes" ]
   then
   	ALGO="Dilithium"
   	PARAMS="Dilithium-8x7-AES-r3"
   fi
   
   botan keygen --algo=${ALGO} --params=${PARAMS} > "$2/ta/ta_key.pem"
   botan keygen --algo=${ALGO} --params=${PARAMS} > "$2/ca/ca_key.pem"
   botan keygen --algo=${ALGO} --params=${PARAMS} > "$2/ee/ee_key.pem"
   
   botan gen_self_signed "$2/ta/ta_key.pem" "Trust Root CA ${PARAMS}" --ca > "$2/ta/ta.pem"
   
   botan gen_pkcs10 "$2/ca/ca_key.pem" "CA ${PARAMS}" --ca > "$2/ca/ca.csr.pem"
   botan sign_cert "$2/ta/ta.pem" "$2/ta/ta_key.pem" "$2/ca/ca.csr.pem" > "$2/ca/ca.pem"
   
   botan gen_pkcs10 "$2/ee/ee_key.pem" "End Entity ${PARAMS}" > "$2/ee/ee.csr.pem"
   botan sign_cert "$2/ca/ca.pem" "$2/ca/ca_key.pem" "$2/ee/ee.csr.pem" > "$2/ee/ee.pem"
}

# Sub folders for the provider
ARTIFACTDIRS=default

for dir in ${ARTIFACTDIRS} ; do 

   # Generates the product's directory (if missing)
   [ -d "${dir}" ] || mkdir -p "${dir}"
   [ -d "${dir}i/artifacts" ] || mkdir -p "${dir}/artifacts"

   # PQC Implementation
   result=$(cd ${dir}/artifacts && gen dilithium2 1.3.6.1.4.1.2.267.7.4.4)
   result=$(cd ${dir}/artifacts && gen dilithium3 1.3.6.1.4.1.2.267.7.6.5)
   result=$(cd ${dir}/artifacts && gen dilithium5 1.3.6.1.4.1.2.267.7.8.7)
   result=$(cd ${dir}/artifacts && gen dilithium2aes 1.3.6.1.4.1.2.267.11.4.4)
   result=$(cd ${dir}/artifacts && gen dilithium3aes 1.3.6.1.4.1.2.267.11.6.5)
   result=$(cd ${dir}/artifacts && gen dilithium5aes 1.3.6.1.4.1.2.267.11.8.7)
#   result=$(cd ${dir}/artifacts && gen falcon512 1.3.9999.3.1)
#   result=$(cd ${dir}/artifacts && gen falcon1024 1.3.9999.3.4)
#   result=$(cd ${dir}/artifacts && gen sphincssha256128frobust 1.3.9999.6.4.1)

   # Composite Implementation
   # result=$(cd ${dir}/artifacts && gen composite 1.3.6.7.8. )

done

exit 0;