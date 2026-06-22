#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CSV="$REPO_ROOT/providers/sanctum/compatMatrices/artifacts_certs_r5/sanctum_sanctum.csv"

ROW_PATTERN="${1:-ML-DSA-65}"

echo "[sanctum-focus] Showing rows matching: $ROW_PATTERN"
rg "$ROW_PATTERN" "$CSV" -n || grep -n "$ROW_PATTERN" "$CSV" || true
