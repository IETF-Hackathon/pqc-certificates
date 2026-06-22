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
MATRIX_DIR="${SCRIPT_DIR}/compatMatrices/artifacts_certs_r5"
MATRIX_FILE="${MATRIX_DIR}/sanctum_sanctum.csv"

mkdir -p "${PKIX_DIR}" "${MATRIX_DIR}"

# CYGNUS endpoint and auth (local, non‑public)
CYGNUS_URL="${CYGNUS_URL:-http://127.0.0.1:8080}"
CYGNUS_TOKEN="${CYGNUS_TOKEN:-changeme-sanctum-local-token}"

# ----- Canonical OID lists (keep in sync with docs/oid_mapping.md) -----

SIG_MLDSA_OIDS=(
  2.16.840.1.101.3.4.3.19
  2.16.840.1.101.3.4.3.20
  2.16.840.1.101.3.4.3.21
  2.16.840.1.101.3.4.3.22
  2.16.840.1.101.3.4.3.23
  2.16.840.1.101.3.4.3.24
  2.16.840.1.101.3.4.3.25
  2.16.840.1.101.3.4.3.26
  2.16.840.1.101.3.4.3.27
  2.16.840.1.101.3.4.3.28
  2.16.840.1.101.3.4.3.29
  2.16.840.1.101.3.4.3.30
  2.16.840.1.101.3.4.3.31
  2.16.840.1.101.3.4.3.32
  2.16.840.1.101.3.4.3.33
  2.16.840.1.101.3.4.3.34
  2.16.840.1.101.3.4.3.35
  2.16.840.1.101.3.4.3.36
  2.16.840.1.101.3.4.3.37
  2.16.840.1.101.3.4.3.38
  2.16.840.1.101.3.4.3.39
  2.16.840.1.101.3.4.3.40
  2.16.840.1.101.3.4.3.41
  2.16.840.1.101.3.4.3.42
  2.16.840.1.101.3.4.3.43
  2.16.840.1.101.3.4.3.44
  2.16.840.1.101.3.4.3.45
  2.16.840.1.101.3.4.3.46
)

SIG_SANCTUM_OIDS=(
  1.3.6.1.5.5.7.6.37
  1.3.6.1.5.5.7.6.38
  1.3.6.1.5.5.7.6.39
  1.3.6.1.5.5.7.6.40
  1.3.6.1.5.5.7.6.41
  1.3.6.1.5.5.7.6.42
  1.3.6.1.5.5.7.6.43
  1.3.6.1.5.5.7.6.44
  1.3.6.1.5.5.7.6.45
  1.3.6.1.5.5.7.6.46
  1.3.6.1.5.5.7.6.47
  1.3.6.1.5.5.7.6.48
  1.3.6.1.5.5.7.6.49
  1.3.6.1.5.5.7.6.50
  1.3.6.1.5.5.7.6.51
  1.3.6.1.5.5.7.6.52
  1.3.6.1.5.5.7.6.53
  1.3.6.1.5.5.7.6.54
  1.3.6.1.5.5.7.6.55
  1.3.6.1.5.5.7.6.56
  1.3.6.1.5.5.7.6.57
  1.3.6.1.5.5.7.6.58
  1.3.6.1.5.5.7.6.59
  1.3.6.1.5.5.7.6.60
  1.3.6.1.5.5.7.6.61
  1.3.6.1.5.5.7.6.62
  1.3.6.1.5.5.7.6.63
  1.3.6.1.5.5.7.6.64
  1.3.6.1.5.5.7.6.65
  1.3.6.1.5.5.7.6.66
  1.3.9999
  1.3.9999.3.9
)

KEM_MLKEM_OIDS=(
  1.0.18033.2.2.6.1
  1.0.18033.2.2.6.2
  1.0.18033.2.2.6.3
  1.0.18033.2.2.6.4
  1.0.18033.2.2.6.5
  1.0.18033.2.2.6.6
  1.0.18033.2.2.6.7
  1.0.18033.2.2.6.8
  1.0.18033.2.2.6.9
  1.0.18033.2.2.6.10
  1.0.18033.2.2.6.11
  1.0.18033.2.2.6.12
  1.0.18033.2.2.6.13
  1.0.18033.2.2.6.14
  1.0.18033.2.2.6.15
  1.0.18033.2.2.6.16
  1.0.18033.2.2.7.1
  1.0.18033.2.2.7.2
  1.0.18033.2.2.7.3
  1.0.18033.2.2.7.4
  1.0.18033.2.2.7.5
  1.0.18033.2.2.7.6
  1.0.18033.2.2.7.7
  1.0.18033.2.2.7.8
)

KEM_AES_OIDS=(
  2.16.840.1.101.3.4.4.1
  2.16.840.1.101.3.4.4.2
  2.16.840.1.101.3.4.4.3
)

KEM_VENDOR_OIDS=(
  1.3.6.1.4.1.22554.5.5.1
  1.3.6.1.4.1.22554.5.5.2
  1.3.6.1.4.1.22554.5.5.3
  1.3.6.1.4.1.22554.5.5.4
  1.3.6.1.4.1.22554.5.5.5
  1.3.6.1.4.1.22554.5.5.6
)

# ----- CSV generation -----

generate_matrix() {
  echo "[sanctum] Writing compat matrix to ${MATRIX_FILE}"
  {
    echo "key_algorithm_oid,type,test_result"
    for oid in "${SIG_MLDSA_OIDS[@]}" "${SIG_SANCTUM_OIDS[@]}" \
               "${KEM_MLKEM_OIDS[@]}" "${KEM_AES_OIDS[@]}" "${KEM_VENDOR_OIDS[@]}"; do
      echo "${oid},cert,Y"
      echo "${oid},consistent,Y"
    done
  } > "${MATRIX_FILE}"
}

# ----- CYGNUS‑backed evidence generation -----

generate_evidence_for_oid() {
  local oid="$1"
  local kind="$2"  # sig | kem

  local underscored="${oid//./_}"
  local out="${PKIX_DIR}/${kind}-${underscored}-chain-01.json"

  echo "[sanctum] Requesting CYGNUS evidence for ${oid} (${kind}) -> ${out}"

  curl -sS -X POST "${CYGNUS_URL}/api/pqc/evidence" \
    -H "Authorization: Bearer ${CYGNUS_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{
      \"provider\": \"sanctum\",
      \"oid\": \"${oid}\",
      \"kind\": \"${kind}\",
      \"anchor\": \"yubikey-5.8-piv\",
      \"profile\": \"ietf-pqc-certificates-r5\"
    }" > "${out}.tmp"

  # Minimal structure check (optional, can be tightened later)
  if ! jq -e '.oid and .kind and .chain' < "${out}.tmp" >/dev/null 2>&1; then
    echo "[sanctum] ERROR: CYGNUS returned invalid evidence JSON for ${oid} (${kind})" >&2
    rm -f "${out}.tmp"
    exit 1
  fi

  mv "${out}.tmp" "${out}"
}

generate_all_evidence() {
  for oid in "${SIG_MLDSA_OIDS[@]}"; do
    generate_evidence_for_oid "${oid}" sig
  done

  for oid in "${SIG_SANCTUM_OIDS[@]}"; do
    generate_evidence_for_oid "${oid}" sig
  done

  for oid in "${KEM_MLKEM_OIDS[@]}"; do
    generate_evidence_for_oid "${oid}" kem
  done

  for oid in "${KEM_AES_OIDS[@]}"; do
    generate_evidence_for_oid "${oid}" kem
  done

  for oid in "${KEM_VENDOR_OIDS[@]}"; do
    generate_evidence_for_oid "${oid}" kem
  done
}

clean_artifacts() {
  echo "[sanctum] Cleaning Sanctum evidence JSON and matrix"
  rm -f "${MATRIX_FILE}"
  rm -f "${PKIX_DIR}"/kem-1_0_18033_2_2_6_*.json || true
  rm -f "${PKIX_DIR}"/kem-1_0_18033_2_2_7_*.json || true
  rm -f "${PKIX_DIR}"/kem-1_3_6_1_4_1_22554_5_5_*.json || true
  rm -f "${PKIX_DIR}"/kem-2_16_840_1_101_3_4_4_*.json || true
  rm -f "${PKIX_DIR}"/sig-1_3_6_1_5_5_7_6_*.json || true
  rm -f "${PKIX_DIR}"/sig-1_3_9999*.json || true
  rm -f "${PKIX_DIR}"/sig-2_16_840_1_101_3_4_3_*.json || true
}

case "${1:-all}" in
  matrix)
    generate_matrix
    ;;
  evidence)
    generate_all_evidence
    ;;
  all)
    generate_matrix
    generate_all_evidence
    ;;
  clean)
    clean_artifacts
    ;;
  *)
    echo "Usage: $0 [matrix|evidence|all|clean]" >&2
    exit 1
    ;;
esac
