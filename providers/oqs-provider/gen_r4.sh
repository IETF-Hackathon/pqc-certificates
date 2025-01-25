#!/bin/bash

set -eux

# be sure to not add wrapped pubkeys:
unset DRAFT_MASSIMO_LAMPS_PQ_SIG_CERTIFICATES_00

gen() {

   # Function to generate the ta/, ca/, and ee/
   # directories and X.509 key + req + cert.
   #
   # Additionally it also creates the crl/ and
   # ocsp/ directories.
   ALGORITHM="$1"
   OID="$2"
   DIR="$3"

   NAME="${ALGORITHM}-${OID}"

   openssl req -x509 -config ta.cnf -new -newkey ${ALG} -extensions v3_ca -out ${DIR}/${NAME}_ta.der -outform DER -nodes -subj "/CN=OQS TA"
}

runandlog() {
   ALG="$1"
   OID="$2"
   DIR="./oqsprovider/artifacts"
   gen "${ALG}" "${OID}" "${DIR}" >> log 2>&1
   echo "${ALG} done..."
}

   rm -rf log

   mkdir -p oqsprovider/artifacts

   # Classic/baseline test:
   runandlog ed448 1.3.101.113

   # ML-DSA
   runandlog mldsa44 2.16.840.1.101.3.4.3.17
   runandlog mldsa65 2.16.840.1.101.3.4.3.18
   runandlog mldsa87 2.16.840.1.101.3.4.3.19

   ## Dilithium
   #runandlog dilithium2 1.3.6.1.4.1.2.267.7.4.4
   #runandlog dilithium3 1.3.6.1.4.1.2.267.7.6.5
   #runandlog dilithium5 1.3.6.1.4.1.2.267.7.8.7

   ## Falcon
   #runandlog falcon512 1.3.9999.3.6
   #runandlog falcon1024 1.3.9999.3.9

   ## Sphincs+
   #runandlog sphincssha2128fsimple 1.3.9999.6.4.13
   #runandlog sphincssha2128ssimple 1.3.9999.6.4.16
   #runandlog sphincssha2192fsimple 1.3.9999.6.5.10
   #runandlog sphincssha2192ssimple 1.3.9999.6.5.12
   #runandlog sphincssha2256fsimple 1.3.9999.6.6.10
   #runandlog sphincssha2256ssimple 1.3.9999.6.6.12
   #runandlog sphincsshake128fsimple 1.3.9999.6.7.13
   #runandlog sphincsshake128ssimple 1.3.9999.6.7.16
   #runandlog sphincsshake192fsimple 1.3.9999.6.8.10
   #runandlog sphincsshake192ssimple 1.3.9999.6.8.12
   #runandlog sphincsshake256fsimple 1.3.9999.6.9.10
   #runandlog sphincsshake256ssimple 1.3.9999.6.9.12

   # draft-ietf-lamps-pq-composite-sigs
   runandlog mldsa44_pss2048 2.16.840.1.114027.80.8.1.1
   runandlog mldsa44_rsa2048 2.16.840.1.114027.80.8.1.2
   runandlog mldsa44_ed25519 2.16.840.1.114027.80.8.1.3
   runandlog mldsa44_p256 2.16.840.1.114027.80.8.1.4
   runandlog mldsa44_bp256 2.16.840.1.114027.80.8.1.5
   runandlog mldsa65_pss3072 2.16.840.1.114027.80.8.1.6
   runandlog mldsa65_rsa3072 2.16.840.1.114027.80.8.1.7
   runandlog mldsa65_p256 2.16.840.1.114027.80.8.1.8
   runandlog mldsa65_bp256 2.16.840.1.114027.80.8.1.9
   runandlog mldsa65_ed25519 2.16.840.1.114027.80.8.1.10
   runandlog mldsa87_p384 2.16.840.1.114027.80.8.1.11
   runandlog mldsa87_bp384 2.16.840.1.114027.80.8.1.12
   runandlog mldsa87_ed448 2.16.840.1.114027.80.8.1.13

echo "All data successfully generated."
