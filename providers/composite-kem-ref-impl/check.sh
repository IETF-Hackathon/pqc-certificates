#!/usr/bin/env bash
set -euo pipefail

PROVIDER="composite-kem-ref-impl"
ARTIFACTS_DIR="${ARTIFACTS_DIR:-_composite_kem_unzipped}"
COMPAT_DIR="compatMatrices/artifacts_certs_r5"
OUT_CSV="${COMPAT_DIR}/generic_${PROVIDER}.csv"

echo "[ ${PROVIDER} ] check.sh: generic verification of artifacts in ${ARTIFACTS_DIR}"

if [ ! -d "${ARTIFACTS_DIR}" ]; then
  echo "[ ${PROVIDER} ] Artifacts directory ${ARTIFACTS_DIR} does not exist; nothing to verify."
  mkdir -p "${COMPAT_DIR}"
  echo "oid,provider_ok,notes" > "${OUT_CSV}"
  echo ",no,artifacts directory missing" >> "${OUT_CSV}"
  echo "[ ${PROVIDER} ] Compat matrix written with placeholder entry to ${OUT_CSV}"
  exit 0
fi

mkdir -p "${COMPAT_DIR}"
echo "oid,provider_ok,notes" > "${OUT_CSV}"

shopt -s nullglob
found_any=false
for ta in "${ARTIFACTS_DIR}"/*_ta.der; do
  found_any=true
  base="$(basename "$ta" _ta.der)"
  oid_part="${base##*-}"

  ta_pem="$(mktemp)"
  if ! openssl x509 -inform der -in "$ta" -out "$ta_pem" >/dev/null 2>&1; then
    echo "${oid_part},no,failed to parse TA DER (${base})" >> "${OUT_CSV}"
    rm -f "$ta_pem"
    continue
  fi

  if openssl verify -CAfile "$ta_pem" "$ta_pem" >/dev/null 2>&1; then
    echo "${oid_part},yes,TA self-signed and parsable (generic OpenSSL check)" >> "${OUT_CSV}"
  else
    echo "${oid_part},no,TA not self-signed or verify failed (generic OpenSSL check)" >> "${OUT_CSV}"
  fi

  rm -f "$ta_pem"
done
shopt -u nullglob

if [ "${found_any}" = false ]; then
  echo ",no,no *_ta.der files found in ${ARTIFACTS_DIR}" >> "${OUT_CSV}"
fi

echo "[ ${PROVIDER} ] Done. Compat matrix written to ${OUT_CSV}"

