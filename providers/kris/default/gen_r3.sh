#!/bin/bash
# set -x

DIR=../artifacts

gen() {
   ALG=$1
   OID=$2
   export $1=$2

   # Root/TA:
   mkdir -p ${DIR}
   # Generate key pair
   openssl req -x509 -new -newkey ${ALG} -keyout ${DIR}/${OID}_ta_priv.pem -out ${DIR}/${OID}_ta.pem -nodes -subj "/CN=TA Kris (PQCL)" -addext basicConstraints=critical,CA:TRUE -days 730
   # Also generate cert in DER
   openssl x509 -in ${DIR}/${OID}_ta.pem -out ${DIR}/${OID}_ta.der -outform DER
}

# Dilithium
gen DILITHIUM_2 1.3.6.1.4.1.2.267.7.4.4
gen DILITHIUM_3 1.3.6.1.4.1.2.267.7.6.5
gen DILITHIUM_5 1.3.6.1.4.1.2.267.7.8.7
gen MLDSA_44_IPD 1.3.6.1.4.1.2.267.12.4.4
gen MLDSA_65_IPD 1.3.6.1.4.1.2.267.12.6.5
gen MLDSA_87_IPD 1.3.6.1.4.1.2.267.12.8.7

# Falcon
gen FALCON_512 1.3.9999.3.6
gen FALCON_1024 1.3.9999.3.9
