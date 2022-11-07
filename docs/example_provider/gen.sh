#!/bin/bash

PRODUCT_DIR=product_dir

gen() {
   # Function to generate the ta/, ca/, and ee/
   # directories and X.509 key + req + cert.
   #
   # Additionally it also creates the crl/ and
   # ocsp/ directories.
}

# Sub folders for the provider
SUBDIRS=default

for dir in ${SUBDIRS} ; do 

   # Generates the product's directory (if missing)
   [ -d "${dir}" ] || mkdir -p "${dir}"

   # PQC Implementation
   result=$(cd ${dir} && gen dilithium2 1.3.6.1.4.1.2.267.7.4.4)
   result=$(cd ${dir} && gen dilithium3 1.3.6.1.4.1.2.267.7.6.5)
   result=$(cd ${dir} && gen dilithium5 1.3.6.1.4.1.2.267.7.8.7)
   result=$(cd ${dir} && gen falcon512 1.3.9999.3.1)
   result=$(cd ${dir} && gen falcon1024 1.3.9999.3.4)
   result=$(cd ${dir} && gen sphincssha256128frobust 1.3.9999.6.4.1)

   # Composite Implementation
   result=$(cd ${dir} && gen composite 1.3.6.7.8. )

done

exit 0;