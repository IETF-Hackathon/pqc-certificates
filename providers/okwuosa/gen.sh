#!/bin/bash
# Regenerates artifacts_certs_r5.zip with CIRCL and hand-built DER.
# Run from the provider directory (providers/okwuosa).
set -euo pipefail
cd "$(dirname "$0")/src"
exec go run ./cmd/gen -out ../artifacts_certs_r5.zip
