#!/bin/bash

PRODUCT_DIR=product_dir

gen() {
   # Function to generate the ta/, ca/, and ee/
   # directories and X.509 key + req + cert.
   #
   # Additionally it also creates the crl/ and
   # ocsp/ directories.
}

# Generates the product's directory (if missing)
[ -d "${PRODUCT_DIR}" ] || mkdir -p "${PRODUCT_DIR}"

# PQC Implementation
result=$(cd ${PRODUCT_DIR} && gen dilithium2 1.3.6.1.4.1.2.267.7.4.4)
result=$(cd ${PRODUCT_DIR} && gen dilithium3 1.3.6.1.4.1.2.267.7.6.5)
result=$(cd ${PRODUCT_DIR} && gen dilithium5 1.3.6.1.4.1.2.267.7.8.7)
result=$(cd ${PRODUCT_DIR} && gen falcon512 1.3.9999.3.1)
result=$(cd ${PRODUCT_DIR} && gen falcon1024 1.3.9999.3.4)
result=$(cd ${PRODUCT_DIR} && gen sphincssha256128frobust 1.3.9999.6.4.1)

# Composite Implementation
result=$(cd ${PRODUCT_DIR} && gen composite 1.3.6.7.8. )

exit 0;