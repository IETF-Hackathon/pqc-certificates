#!/usr/bin/env bash
set -euo pipefail

OPENSSL_BIN="${OPENSSL_BIN:-openssl}"

WORKDIR="$(pwd)"
OUTDIR="$WORKDIR/sanctum_artifacts"
ZIP_NAME="artifacts_certs_r5.zip"

echo "[sanctum] Generating placeholder (classical) artifacts in $OUTDIR"
rm -rf "$OUTDIR"
mkdir -p "$OUTDIR"

if ! command -v "$OPENSSL_BIN" >/dev/null 2>&1; then
  echo "[sanctum] ERROR: openssl not found. Set OPENSSL_BIN or install OpenSSL 3.x."
  exit 1
fi

# === 1. Generate RSA TA (self-signed CA) ===
TA_KEY="$OUTDIR/sanctum-ta.key"
TA_CSR="$OUTDIR/sanctum-ta.csr"
TA_CERT_PEM="$OUTDIR/sanctum-ta.pem"
TA_CERT_DER="$OUTDIR/sanctum-ta.der"
TA_CNF="$OUTDIR/ta.cnf"

echo "[sanctum] Generating RSA TA key/cert (CA=TRUE)..."
"$OPENSSL_BIN" genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -out "$TA_KEY"
"$OPENSSL_BIN" req -new -key "$TA_KEY" -out "$TA_CSR" \
  -subj "/CN=Sanctum TA (placeholder RSA)"

# Minimal CA config so OpenSSL treats TA as CA
cat > "$TA_CNF" <<EOF2
[ v3_ca ]
basicConstraints = critical,CA:TRUE
keyUsage = critical,keyCertSign,cRLSign
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
EOF2

"$OPENSSL_BIN" x509 -req -days 3650 -in "$TA_CSR" -signkey "$TA_KEY" \
  -out "$TA_CERT_PEM" -extfile "$TA_CNF" -extensions v3_ca
"$OPENSSL_BIN" x509 -in "$TA_CERT_PEM" -outform der -out "$TA_CERT_DER"

# === 2. Generate RSA EE cert signed by TA ===
EE_KEY="$OUTDIR/sanctum-ee.key"
EE_CSR="$OUTDIR/sanctum-ee.csr"
EE_CERT_PEM="$OUTDIR/sanctum-ee.pem"
EE_CERT_DER="$OUTDIR/sanctum-ee.der"

echo "[sanctum] Generating RSA EE key/cert..."
"$OPENSSL_BIN" genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -out "$EE_KEY"
"$OPENSSL_BIN" req -new -key "$EE_KEY" -out "$EE_CSR" \
  -subj "/CN=Sanctum EE (placeholder RSA)"
"$OPENSSL_BIN" x509 -req -days 3650 -in "$EE_CSR" \
  -CA "$TA_CERT_PEM" -CAkey "$TA_KEY" -CAcreateserial -out "$EE_CERT_PEM"
"$OPENSSL_BIN" x509 -in "$EE_CERT_PEM" -outform der -out "$EE_CERT_DER"

# === 3. Fake KEM ciphertext + shared secret (random) ===
CIPHERTEXT="$OUTDIR/sanctum-kem_ciphertext.bin"
SS_FILE="$OUTDIR/sanctum-kem_ss.bin"

echo "[sanctum] Generating placeholder KEM test vectors (random)..."
head -c 1024 /dev/urandom > "$CIPHERTEXT"
head -c 64 /dev/urandom > "$SS_FILE"

# === 4. Private keys in DER ===
TA_PRIV="$OUTDIR/sanctum-ta_priv.der"
EE_PRIV="$OUTDIR/sanctum-ee_priv.der"

"$OPENSSL_BIN" pkcs8 -topk8 -nocrypt -in "$TA_KEY" -outform der -out "$TA_PRIV"
"$OPENSSL_BIN" pkcs8 -topk8 -nocrypt -in "$EE_KEY" -outform der -out "$EE_PRIV"

# === 5. Rename files to artifacts_certs_r5-style names ===
cp "$TA_CERT_DER" "$OUTDIR/sanctum-1.3.6.1.4.1.2.267.11.4.4_ta.der"
cp "$EE_CERT_DER" "$OUTDIR/sanctum-rsa-kem-placeholder_ee.der"
cp "$TA_PRIV" "$OUTDIR/sanctum-1.3.6.1.4.1.2.267.11.4.4_priv.der"
cp "$EE_PRIV" "$OUTDIR/sanctum-rsa-kem-placeholder_priv.der"
cp "$CIPHERTEXT" "$OUTDIR/sanctum-rsa-kem-placeholder_ciphertext.bin"
cp "$SS_FILE" "$OUTDIR/sanctum-rsa-kem-placeholder_ss.bin"

# === 6. Zip ===
echo "[sanctum] Creating $ZIP_NAME"
rm -f "$ZIP_NAME"
(
  cd "$OUTDIR"
  zip -q "../$ZIP_NAME" ./*
)

echo "[sanctum] Done. Generated $ZIP_NAME in $WORKDIR."

echo "[sanctum] Creating $ZIP_NAME"
rm -f "$ZIP_NAME"
(
  cd "$OUTDIR"
  zip -q "../$ZIP_NAME" ./*
)

echo "[sanctum] Done. Generated $ZIP_NAME in $WORKDIR."
