#!/bin/bash
set -e
cd "$(dirname "$0")"

DIR=${1:-artifacts_jose_cose_v1}
OUT=${2:-/dev/stdout}

npm install --no-fund --no-audit -q

node bin/pqc_jose_cose.mjs verify "$DIR" "$OUT"
