#!/bin/bash
# Checks an artifact zip and writes the go-crypto results CSV.
# Usage: ./check.sh [<provider-dir> | <zip>]
#   <provider-dir>  a directory with artifacts_certs_r5.zip (default: this one)
#   <zip>           an artifact zip; the generator name is its directory name
# The CSV is written to compatMatrices/artifacts_certs_r5/<generator>_go-crypto.csv
# in this provider's directory. Findings (JSON lines) go to stderr.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
target=$(realpath "${1:-$here}")
if [ -d "$target" ]; then
  zip="$target/artifacts_certs_r5.zip"
else
  zip="$target"
fi
[ -f "$zip" ] || { echo "check.sh: no such zip: $zip" >&2; exit 2; }
generator=$(basename "$(dirname "$zip")")
cd "$here/src"
exec go run ./cmd/check -zip "$zip" -generator "$generator" \
  -out "$here/compatMatrices/artifacts_certs_r5/${generator}_go-crypto.csv"
