#!/bin/bash

set -e

# be sure to not add wrapped pubkeys:
unset DRAFT_MASSIMO_LAMPS_PQ_SIG_CERTIFICATES_00

# Parameter1: Name of algorithm to create a CA hierarchy for
# Parameter2: Directory containing cnf files
do_cas() {
    # clean up:
    rm -rf ~/oqsCA
    # Prepare persistent data structures
    # For rootCA (TA)
    mkdir -p ~/oqsCA/rootCA/{certs,crl,newcerts,private,csr}
    echo 1000 > ~/oqsCA/rootCA/serial
    echo 0100 > ~/oqsCA/rootCA/crlnumber
    touch ~/oqsCA/rootCA/index.txt

    # For intermediate CA (CA)
    mkdir -p ~/oqsCA/intermediateCA/{certs,crl,newcerts,private,csr}
    echo 1000 > ~/oqsCA/intermediateCA/serial
    echo 0100 > ~/oqsCA/intermediateCA/crlnumber
    touch ~/oqsCA/intermediateCA/index.txt

    # Create TA keys and cert
    openssl req -x509 -config $2/ta.cnf -new -newkey $1 -extensions v3_ca -keyout ~/oqsCA/rootCA/private/ca.key.pem -out ~/oqsCA/rootCA/certs/ca.cert.pem -nodes -subj "/CN=OQS TA"

    # Create CA keys and cert
    openssl req -config $2/ca.cnf -new -newkey $1 -keyout ~/oqsCA/intermediateCA/private/intermediate.key.pem -out ~/oqsCA/intermediateCA/certs/intermediate.csr.pem -nodes -subj "/CN=OQS CA"
    openssl ca -batch -config $2/ta.cnf -extensions v3_intermediate_ca -days 365 -notext -in ~/oqsCA/intermediateCA/certs/intermediate.csr.pem -out ~/oqsCA/intermediateCA/certs/intermediate.cert.pem
    chmod 444 ~/oqsCA/intermediateCA/certs/intermediate.cert.pem
    openssl verify -CAfile ~/oqsCA/rootCA/certs/ca.cert.pem ~/oqsCA/intermediateCA/certs/intermediate.cert.pem

    # Create cert bundle for EE cert verification
    cat ~/oqsCA/intermediateCA/certs/intermediate.cert.pem ~/oqsCA/rootCA/certs/ca.cert.pem > ~/oqsCA/intermediateCA/certs/ca-chain.cert.pem
    openssl verify -CAfile ~/oqsCA/intermediateCA/certs/ca-chain.cert.pem ~/oqsCA/intermediateCA/certs/intermediate.cert.pem

    # Create server keys and cert (EE)
    openssl req -config $2/ca.cnf -new -newkey $1 -keyout ~/oqsCA/intermediateCA/private/ee.key.pem -out ~/oqsCA/intermediateCA/csr/ee.csr.pem -nodes -subj "/CN=OQS EE"
    openssl ca -batch -config $2/ca.cnf -extensions server_cert -days 375 -notext -in ~/oqsCA/intermediateCA/csr/ee.csr.pem -out ~/oqsCA/intermediateCA/certs/ee.cert.pem

    # Verify server cert
    openssl verify -CAfile ~/oqsCA/intermediateCA/certs/ca-chain.cert.pem ~/oqsCA/intermediateCA/certs/ee.cert.pem
    # Revoke cert
    openssl ca -batch -config $2/ca.cnf -revoke ~/oqsCA/intermediateCA/certs/ee.cert.pem

    # Create CRLS for TA and CA
    openssl ca -batch -config $2/ca.cnf -gencrl -out ~/oqsCA/intermediateCA/crl/intermediate.crl.pem
    openssl ca -batch -config $2/ta.cnf -gencrl -out ~/oqsCA/rootCA/crl/root.crl.pem

    # Create OSCP keys and cert
    openssl req -config $2/ca.cnf -new -newkey $1 -keyout ~/oqsCA/intermediateCA/private/ocsp.key.pem -out ~/oqsCA/intermediateCA/csr/ocsp.csr.pem -nodes -subj "/CN=ocsp.openquantumsafe.org"
    openssl ca -batch -config $2/ca.cnf -extensions ocsp -days 375 -notext -in ~/oqsCA/intermediateCA/csr/ocsp.csr.pem -out ~/oqsCA/intermediateCA/certs/ocsp.cert.pem
}

gen() {

   # Function to generate the ta/, ca/, and ee/
   # directories and X.509 key + req + cert.
   #
   # Additionally it also creates the crl/ and
   # ocsp/ directories.
   ALGORITHM=$1
   BASE_DIR=$2
   ROOT_DIR=$3

   do_cas $ALGORITHM $ROOT_DIR
   # Generates the artifact directories
   mkdir -p $BASE_DIR/{ta,ca,ee,crl,ocsp}

   # Extract the artifacts to the correct locations

   # TA:
   cp ~/oqsCA/rootCA/certs/ca.cert.pem $BASE_DIR/ta/ta.pem
   cp ~/oqsCA/rootCA/private/ca.key.pem $BASE_DIR/ta/ta_priv.pem

   # Also generate DER for private key
   openssl pkcs8 -topk8 -inform PEM -outform DER -in $BASE_DIR/ta/ta_priv.pem -out $BASE_DIR/ta/ta_priv.der -nocrypt
   # Also generate cert in DER
   openssl x509 -in $BASE_DIR/ta/ta.pem -out $BASE_DIR/ta/ta.der -outform DER

   # CA:
   cp ~/oqsCA/intermediateCA/certs/intermediate.cert.pem $BASE_DIR/ca/ca.pem
   cp ~/oqsCA/intermediateCA/private/intermediate.key.pem $BASE_DIR/ca/ca_priv.pem

   # Also generate DER for private key
   openssl pkcs8 -topk8 -inform PEM -outform DER -in $BASE_DIR/ca/ca_priv.pem -out $BASE_DIR/ca/ca_priv.der -nocrypt
   # Also generate cert in DER
   openssl x509 -in $BASE_DIR/ca/ca.pem -out $BASE_DIR/ca/ca.der -outform DER

   # EE:
   cp ~/oqsCA/intermediateCA/certs/ee.cert.pem $BASE_DIR/ee/cert.pem
   cp ~/oqsCA/intermediateCA/private/ee.key.pem $BASE_DIR/ee/cert_priv.pem
   cp ~/oqsCA/intermediateCA/csr/ee.csr.pem $BASE_DIR/ee/cert.csr

   # Also generate DER for private key
   openssl pkcs8 -topk8 -inform PEM -outform DER -in $BASE_DIR/ee/cert_priv.pem -out $BASE_DIR/ee/cert_priv.der -nocrypt
   # Also generate cert in DER
   openssl x509 -in $BASE_DIR/ee/cert.pem -out $BASE_DIR/ee/cert.der -outform DER

   # CRLs
   openssl crl -inform PEM -in ~/oqsCA/rootCA/crl/root.crl.pem -outform DER -out $BASE_DIR/crl/crl_ta.crl
   openssl crl -inform PEM -in ~/oqsCA/intermediateCA/crl/intermediate.crl.pem -outform DER -out $BASE_DIR/crl/crl_ca.crl

   # Start OCSP responder and retrieve response
   openssl ocsp -port 2560 -text -index  ~/oqsCA/intermediateCA/index.txt -CA ~/oqsCA/intermediateCA/certs/ca-chain.cert.pem -rkey ~/oqsCA/intermediateCA/private/ocsp.key.pem -rsigner ~/oqsCA/intermediateCA/certs/ocsp.cert.pem -nrequest 1 &
   sleep 1
   openssl ocsp -CAfile ~/oqsCA/intermediateCA/certs/ca-chain.cert.pem -url http://127.0.0.1:2560 -respout $BASE_DIR/ocsp/ocsp_cert.der -issuer ~/oqsCA/intermediateCA/certs/intermediate.cert.pem -cert ~/oqsCA/intermediateCA/certs/ee.cert.pem
}

runandlog() {
   cd oqsprovider/artifacts && gen $1 $2 ../.. >> ../../log 2>&1 && cd ../..
   echo "$1 done..."
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
