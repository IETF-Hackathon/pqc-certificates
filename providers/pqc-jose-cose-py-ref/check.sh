#!/bin/bash
set -e
cd "$(dirname "$0")"

DIR=${1:-artifacts_jose_cose_v1}
OUT=${2:-/dev/stdout}

pip install -r requirements.txt --break-system-packages -q

python3 bin/pqc_jose_cose.py verify "$DIR" "$OUT"
