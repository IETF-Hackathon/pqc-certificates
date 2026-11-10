#!/bin/bash
# Regenerates artifacts_certs_r5.zip from the Go standard library.
# Run from the provider directory (providers/go-crypto).
set -euo pipefail
cd "$(dirname "$0")/src"
exec go run ./cmd/gen -out ../artifacts_certs_r5.zip
