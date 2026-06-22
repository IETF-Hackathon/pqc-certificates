#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SANCTUM_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

YAML="$SCRIPT_DIR/sanctum_mlkem_profiles.yml"

if ! command -v yq >/dev/null 2>&1; then
  echo "[gen_mlkem768] Please install yq (YAML processor) to use this helper." >&2
  exit 1
fi

cd "$SANCTUM_DIR"

echo "[gen_mlkem768] Generating Sanctum chains for ML-KEM-768 profiles from $YAML"

count=$(yq '.profiles | length' "$YAML")
for i in $(seq 0 $((count - 1))); do
  name=$(yq -r ".profiles[$i].name" "$YAML")
  oid=$(yq -r ".profiles[$i].oid" "$YAML")

  echo "[gen_mlkem768] -> $name ($oid)"

  OID="$oid" PROFILE_NAME="$name" ./gen.sh one
done
