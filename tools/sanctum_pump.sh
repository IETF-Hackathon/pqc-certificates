#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[sanctum-pump] Repo root: $REPO_ROOT"

cd "$REPO_ROOT/providers/sanctum"

echo "[sanctum-pump] Generating ML-KEM-768 Sanctum chains..."
./tools/gen_mlkem768.sh || echo "[sanctum-pump] gen_mlkem768.sh skipped/failed; continuing"

echo "[sanctum-pump] Regenerating Sanctum evidence + CSV..."
./gen.sh clean
./gen.sh all
./check.sh

CSV="$REPO_ROOT/providers/sanctum/compatMatrices/artifacts_certs_r5/sanctum_sanctum.csv"
echo "[sanctum-pump] Showing ML-KEM-768 OIDs in Sanctum CSV:"
rg '1\.3\.6\.1\.5\.5\.7\.6\.5[5-9]' "$CSV" -n || grep -n '1.3.6.1.5.5.7.6.5[5-9]' "$CSV" || true
rg '1\.3\.6\.1\.5\.5\.7\.6\.6[0-1]' "$CSV" -n || grep -n '1.3.6.1.5.5.7.6.6[0-1]' "$CSV" || true
