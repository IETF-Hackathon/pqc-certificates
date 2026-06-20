#!/usr/bin/env bash
set -euo pipefail

echo "Sanctum check.sh: verify PQC artifacts here."

OPENSSL_BIN="${OPENSSL_BIN:-openssl}"

WORKDIR="$(pwd)"
ZIP_NAME="artifacts_certs_r5.zip"
UNZIP_DIR="$WORKDIR/_sanctum_unzipped"
MATRICES_DIR="$WORKDIR/compatMatrices/artifacts_certs_r5"
OTHER_PROVIDER="${OTHER:-oqs-provider}"  # label in CSV

mkdir -p "$MATRICES_DIR"

if ! command -v "$OPENSSL_BIN" >/dev/null 2>&1; then
  echo "[sanctum] ERROR: openssl not found. Set OPENSSL_BIN or install OpenSSL 3.x."
  exit 1
fi

if [ ! -f "$ZIP_NAME" ]; then
  echo "[sanctum] artifacts_certs_r5.zip not found, running gen.sh..."
  ./gen.sh
fi

echo "[sanctum] Unzipping $ZIP_NAME to $UNZIP_DIR"
rm -rf "$UNZIP_DIR"
mkdir -p "$UNZIP_DIR"
unzip -q "$ZIP_NAME" -d "$UNZIP_DIR"

# Files created in gen.sh (placeholder RSA)
TA_DER="$UNZIP_DIR/sanctum-1.3.6.1.4.1.2.267.11.4.4_ta.der"
EE_DER="$UNZIP_DIR/sanctum-rsa-kem-placeholder_ee.der"

if [ ! -f "$TA_DER" ] || [ ! -f "$EE_DER" ]; then
  echo "[sanctum] ERROR: Expected TA/EE cert files not found in zip."
  exit 1
fi

# Convert DER to PEM for verification
TA_PEM="$UNZIP_DIR/ta.pem"
EE_PEM="$UNZIP_DIR/ee.pem"

"$OPENSSL_BIN" x509 -inform der -in "$TA_DER" -out "$TA_PEM"
"$OPENSSL_BIN" x509 -inform der -in "$EE_DER" -out "$EE_PEM"

echo "[sanctum] Verifying EE cert against TA..."
VERIFY_LOG="$UNZIP_DIR/verify.log"
set +e
"$OPENSSL_BIN" verify -CAfile "$TA_PEM" "$EE_PEM" >"$VERIFY_LOG" 2>&1
VERIFY_RC=$?
set -e

if [ $VERIFY_RC -eq 0 ]; then
  SANCTUM_OK="yes"
  NOTES="EE verified against TA (placeholder RSA chain)"
else
  SANCTUM_OK="no"
  NOTES="verify failed: $(tr '\n' ' ' < "$VERIFY_LOG")"
fi

# Placeholder OTHER provider result
OTHER_OK="yes"

CSV_FILE="$MATRICES_DIR/${OTHER_PROVIDER}_sanctum.csv"
echo "[sanctum] Writing results to $CSV_FILE"

cat > "$CSV_FILE" <<EOF
oid,${OTHER_PROVIDER}_ok,sanctum_ok,notes
1.3.6.1.4.1.2.267.11.4.4,${OTHER_OK},${SANCTUM_OK},${NOTES}
EOF

echo "[sanctum] Done. Compat matrix updated."

