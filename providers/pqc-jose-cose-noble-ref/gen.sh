#!/bin/bash
set -e
cd "$(dirname "$0")"

npm install --no-fund --no-audit -q

node bin/pqc_jose_cose.mjs generate .
