# NOTE: Generic OpenSSL-based checker added as a community contribution.
# It validates that TA certs are parsable and self-signed. Leancrypto
# maintainers can replace this with leancrypto_check_with_ietf.sh or a
# more complete harness later.
#!/usr/bin/env bash
set -euo pipefail

PROVIDER="leancrypto"
ARTIFACTS_DIR="${ARTIFACTS_DIR:-_leancrypto_unzipped/artifacts_certs_r5}"
COMPAT_DIR="compatMatrices/artifacts_certs_r5"
OUT_CSV="${COMPAT_DIR}/generic_${PROVIDER}.csv"

mkdir -p "${COMPAT_DIR}"

echo "[ ${PROVIDER} ] check.sh: generic verification of artifacts in ${ARTIFACTS_DIR}"

echo "oid,provider_ok,notes" > "${OUT_CSV}"

shopt -s nullglob
for ta in "${ARTIFACTS_DIR}"/*_ta.der; do
  base="$(basename "$ta" _ta.der)"
  # Leancrypto’s files are like ML-DSA44-<oid>_ta.der or SLH-DSA-...-<oid>_ta.der
  oid_part="${base##*-}"

  ta_pem="$(mktemp)"
  if ! openssl x509 -inform der -in "$ta" -out "$ta_pem" >/dev/null 2>&1; then
    echo "${oid_part},no,failed to parse TA DER (${base})" >> "${OUT_CSV}"
    rm -f "$ta_pem"
    continue
  fi

  # Just a structural test: confirm the TA is self-signed
  if openssl verify -CAfile "$ta_pem" "$ta_pem" >/dev/null 2>&1; then
    echo "${oid_part},yes,TA self-signed and parsable (generic OpenSSL check)" >> "${OUT_CSV}"
  else
    echo "${oid_part},no,TA not self-signed or verify failed (generic OpenSSL check)" >> "${OUT_CSV}"
  fi

  rm -f "$ta_pem"
done
shopt -u nullglob

echo "[ ${PROVIDER} ] Done. Compat matrix written to ${OUT_CSV}"

