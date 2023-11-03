#!/bin/bash

set -e

# be sure to not add wrapped pubkeys:
unset DRAFT_MASSIMO_LAMPS_PQ_SIG_CERTIFICATES_00

runandlog() {
   ALG=$1
   OID=$2
   DIR="./oqsprovider/artifacts"
   openssl req -x509 -config ta.cnf -new -newkey ${ALG} -extensions v3_ca -out ${DIR}/${OID}_ta.pem -nodes -subj "/CN=OQS TA" >> log 2>&1 
   # openssl req -x509 -config ta.cnf -new -newkey ${ALG} -extensions v3_ca -keyout ${DIR}/${OID}_key.pem -out ${DIR}/${OID}_ta.pem -nodes -subj "/CN=OQS TA" >> log 2>&1 
   echo "${ALG} done..."
}

   rm -rf log

   mkdir -p oqsprovider/artifacts

   # Classic/baseline test:
   runandlog ed448 1.3.101.113

   # Dilithium
   runandlog dilithium2 1.3.6.1.4.1.2.267.7.4.4
   runandlog dilithium3 1.3.6.1.4.1.2.267.7.6.5
   runandlog dilithium5 1.3.6.1.4.1.2.267.7.8.7

   # Falcon
   runandlog falcon512 1.3.9999.3.6
   runandlog falcon1024 1.3.9999.3.9

   # Sphincs+
   runandlog sphincssha2128fsimple 1.3.9999.6.4.13
   runandlog sphincssha2128ssimple 1.3.9999.6.4.16
   runandlog sphincssha2192fsimple 1.3.9999.6.5.10
   runandlog sphincssha2192ssimple 1.3.9999.6.5.12
   runandlog sphincssha2256fsimple 1.3.9999.6.6.10
   runandlog sphincssha2256ssimple 1.3.9999.6.6.12
   runandlog sphincsshake128fsimple 1.3.9999.6.7.13
   runandlog sphincsshake128ssimple 1.3.9999.6.7.16
   runandlog sphincsshake192fsimple 1.3.9999.6.8.10
   runandlog sphincsshake192ssimple 1.3.9999.6.8.12
   runandlog sphincsshake256fsimple 1.3.9999.6.9.10
   runandlog sphincsshake256ssimple 1.3.9999.6.9.12

echo "All data successfully generated."
