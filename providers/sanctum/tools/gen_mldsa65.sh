#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SANCTUM_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

YAML="$SCRIPT_DIR/sanctum_mldsa65_profiles.yml"

if ! command -v yq >/dev/null 2>&1; then
  echo "[gen_mldsa65] Please install yq to use this helper." >&2
  exit 1
fi

cd "$SANCTUM_DIR"

echo "[gen_mldsa65] Generating Sanctum chains for ML-DSA-65 profiles from $YAML"

count=$(yq '.profiles | length' "$YAML")
for i in $(seq 0 $((count - 1))); do
  name=$(yq -r ".profiles[$i].name" "$YAML")
  oid=$(yq -r ".profiles[$i].oid" "$YAML")

  echo "[gen_mldsa65] -> $name ($oid)"

  OID="$oid" PROFILE_NAME="$name" ./gen.sh all
done
