#!/bin/sh
#
# Generate artifacts_certs_r5.zip for oqs-provider. See README.md.

set -eu

# OpenSSL 3.6.0 + oqs-provider 0.11.0 + liboqs 0.15.0.
# Also pinned in the oqs_cert_validation job in .github/workflows/artifact_validation.yaml.
IMAGE="openquantumsafe/oqs-ossl3:latest@sha256:fbb6e06842a2ba2bce0721ebb5ffe62c909ce8443382fd9a102c8381b2d1b3f7"
# Signature algorithms to generate, as <name>=<oid>, with the OIDs oqs-provider uses (see docs/oid_mapping.md)
# Only Falcon for now; README.md explains why.
ALGS="
    falcon512=1.3.9999.3.11
    falcon1024=1.3.9999.3.14
    falconpadded512=1.3.9999.3.16
    falconpadded1024=1.3.9999.3.19
"

report_error() { echo "ERROR: $*" >&2; exit 1; }

# Runs inside the container and writes the artifacts to /out.
generate() {
    cd /tmp
    openssl list -providers | grep -q 'OQS Provider' || report_error "oqsprovider is not loaded"

    # Dummy data to sign 
    echo "This is a test of signature data" > msg.txt

    for entry in $ALGS; do
        alg=${entry%%=*} # text before "="
        oid=${entry#*=} # text after "="

        openssl genpkey -algorithm "$alg" -out key.pem

        ta="/out/$alg-${oid}_ta.der"
        priv="/out/$alg-${oid}_priv.der"

        openssl req -new -x509 -days 36524 -key key.pem \
            -subj "/CN=oqs-provider $alg Root" \
            -addext "basicConstraints=critical,CA:true" \
            -addext "keyUsage=critical,keyCertSign,cRLSign" \
            -outform DER -out "$ta"
        openssl pkey -in key.pem -outform DER -out "$priv"

        # Check the artifacts the way verifiers will
        openssl verify -check_ss_sig -CAfile "$ta" "$ta"
        openssl pkeyutl -sign -rawin -inkey "$priv" -in msg.txt -out sig.bin
        openssl pkeyutl -verify -rawin -certin -inkey "$ta" -in msg.txt -sigfile sig.bin
    done
}

# If inside the container, run the generate function
if [ "${1:-}" = --inside ]; then
    generate
    exit
fi

# Verify every provider's artifacts as CI does.
if [ "${1:-}" = --verify ]; then
    cd "$(dirname "$0")/../.."
    docker run --rm --user "$(id -u):$(id -g)" \
        -v "$PWD:/repo" -w /repo \
        "$IMAGE" ./src/test_certs_r5.sh oqs
    exit
fi

# Run this script in the container and zip what it wrote.
cd "$(dirname "$0")"
out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT

docker run --rm --user "$(id -u):$(id -g)" \
    -v "$PWD/gen_r5.sh:/gen_r5.sh:ro" -v "$out:/out" \
    "$IMAGE" /gen_r5.sh --inside

rm -f artifacts_certs_r5.zip
zip -q -j -X artifacts_certs_r5.zip "$out"/*.der
echo "Wrote $PWD/artifacts_certs_r5.zip"
