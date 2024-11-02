#!/bin/bash
# set -x

DIR=artifacts
source oids.sh

gen() {
   ALG=$1
   NAME=$2
   OID=$3

   # Root/TA:
   mkdir -p ${DIR}
   # Generate key pair
   openssl req -x509 -new -newkey ${ALG} -keyout ${DIR}/${NAME}-${OID}_ta_priv.pem -extensions v3_ca -out ${DIR}/${NAME}-${OID}_ta.pem -nodes -subj "/CN=TA anti-atlas (PQShield)"
   # Also generate cert in DER
   openssl x509 -in ${DIR}/${NAME}-${OID}_ta.pem -out ${DIR}/${NAME}-${OID}_ta.der -outform DER
}

# ML-DSA
gen mldsa44 ml-dsa-44 ${MLDSA_44}
gen mldsa65 ml-dsa-65 ${MLDSA_65}
gen mldsa87 ml-dsa-87 ${MLDSA_87}

# Falcon
gen falcon512 falcon512 ${FALCON_512}
gen falcon1024 falcon1024 ${FALCON_1024}
