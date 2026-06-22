#!/usr/bin/env bash
set -euo pipefail

# Robust script location
if [[ -n "${BASH_SOURCE[0]-}" ]]; then
  SCRIPT_PATH="${BASH_SOURCE[0]}"
else
  SCRIPT_PATH="$0"
fi

SCRIPT_DIR="$(cd "$(dirname "${SCRIPT_PATH}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

PKIX_DIR="${REPO_ROOT}/evidence/pkix"
MATRIX_FILE="${SCRIPT_DIR}/compatMatrices/artifacts_certs_r5/sanctum_sanctum.csv"
OTHER_PROVIDER="${OTHER:-}"

OPENSSL_BIN="${OPENSSL_BIN:-openssl}"

echo "[sanctum] check.sh starting"
echo "[sanctum] REPO_ROOT=${REPO_ROOT}"
echo "[sanctum] PKIX_DIR=${PKIX_DIR}"
echo "[sanctum] MATRIX_FILE=${MATRIX_FILE}"

if ! command -v "${OPENSSL_BIN}" >/dev/null 2>&1; then
  echo "[sanctum] ERROR: openssl not found. Set OPENSSL_BIN or install OpenSSL 3.x." >&2
  exit 1
fi

# 1. Ensure matrix exists (generate if missing)
if [[ ! -f "${MATRIX_FILE}" ]]; then
  echo "[sanctum] Matrix not found; running gen.sh matrix..."
  (cd "${SCRIPT_DIR}" && ./gen.sh matrix)
fi

if [[ ! -f "${MATRIX_FILE}" ]]; then
  echo "[sanctum] ERROR: matrix still missing after gen.sh" >&2
  exit 1
fi

echo "[sanctum] Using matrix ${MATRIX_FILE}"

# 2. CSV sanity: header + no duplicate (OID,type) pairs
echo "[sanctum] Checking CSV header and duplicates"

grep -q '^key_algorithm_oid,type,test_result$' "${MATRIX_FILE}" \
  || { echo "[sanctum] ERROR: bad CSV header" >&2; exit 1; }

awk -F',' 'NR>1{key=$1","$2; if (seen[key]++) {print "[sanctum] ERROR: duplicate " key > "/dev/stderr"; exit 1}}' \
  "${MATRIX_FILE}"

# 3. Every Y row has corresponding evidence JSON
echo "[sanctum] Checking that every Y row has evidence JSON"

awk -F',' 'NR>1 && $3=="Y"{print $1,$2}' "${MATRIX_FILE}" | \
while read -r oid type; do
  underscored="${oid//./_}"
  sig_path="${PKIX_DIR}/sig-${underscored}-chain-01.json"
  kem_path="${PKIX_DIR}/kem-${underscored}-chain-01.json"

  if [[ ! -f "${sig_path}" && ! -f "${kem_path}" ]]; then
    echo "[sanctum] ERROR: missing evidence JSON for ${oid} (${type})" >&2
    exit 1
  fi
done

echo "[sanctum] CSV ↔ evidence consistency OK"

# 4. Optional cross-verify hook (placeholder to avoid leaks)
if [[ -n "${OTHER_PROVIDER}" ]]; then
  echo "[sanctum] Cross-verify enabled with OTHER=${OTHER_PROVIDER}"
  echo "[sanctum] (placeholder) here you could call repo-level verify to compare Sanctum vs providers/${OTHER_PROVIDER}"
fi

echo "[sanctum] All checks passed"
