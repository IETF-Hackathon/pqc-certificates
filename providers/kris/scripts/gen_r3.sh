#!/bin/bash
# set -x

DIR=../artifacts
source oids.sh

gen() {
   ALG=$1
   OID=$2
   export $1=$2

   # Root/TA:
   mkdir -p ${DIR}
   # Generate key pair
   openssl req -x509 -new -newkey ${ALG} -keyout ${DIR}/${OID}_ta_priv.pem -extensions v3_ca -out ${DIR}/${OID}_ta.pem -nodes -subj "/CN=TA Kris (PQCL)"
   # Also generate cert in DER
   openssl x509 -in ${DIR}/${OID}_ta.pem -out ${DIR}/${OID}_ta.der -outform DER
}

# Dilithium
gen DILITHIUM_2 ${DILITHIUM_2}
gen DILITHIUM_3 ${DILITHIUM_3}
gen DILITHIUM_5 ${DILITHIUM_5}
gen MLDSA_44_IPD ${MLDSA_44_IPD}
gen MLDSA_65_IPD ${MLDSA_65_IPD}
gen MLDSA_87_IPD ${MLDSA_87_IPD}

# Falcon
gen FALCON_512 ${FALCON_512}
gen FALCON_1024 ${FALCON_1024}
