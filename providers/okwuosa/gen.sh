#!/bin/bash
# Regenerates artifacts_certs_r5.zip with CIRCL and hand-built DER.
# Can be run from any directory; it changes to src/ next to this script.
set -euo pipefail
cd "$(dirname "$0")/src"
exec go run ./cmd/gen -out ../artifacts_certs_r5.zip
