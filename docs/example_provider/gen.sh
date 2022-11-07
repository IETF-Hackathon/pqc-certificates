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
}

# Sub folders for the provider
SUBDIRS=default

for dir in ${SUBDIRS} ; do 

   # Generates the product's directory (if missing)
   [ -d "${dir}" ] || mkdir -p "${dir}"
   [ -d "${dir}i/artifacts" ] || mkdir -p "${dir}/artifacts"

   # PQC Implementation
   result=$(cd ${dir}/artifacts && gen dilithium2 1.3.6.1.4.1.2.267.7.4.4)
   result=$(cd ${dir}/artifacts && gen dilithium3 1.3.6.1.4.1.2.267.7.6.5)
   result=$(cd ${dir}/artifacts && gen dilithium5 1.3.6.1.4.1.2.267.7.8.7)
   result=$(cd ${dir}/artifacts && gen falcon512 1.3.9999.3.1)
   result=$(cd ${dir}/artifacts && gen falcon1024 1.3.9999.3.4)
   result=$(cd ${dir}/artifacts && gen sphincssha256128frobust 1.3.9999.6.4.1)

   # Composite Implementation
   # result=$(cd ${dir}/artifacts && gen composite 1.3.6.7.8. )

done

exit 0;