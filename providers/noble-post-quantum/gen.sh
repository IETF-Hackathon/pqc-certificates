#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Rewrites artifacts_certs_r5.zip in this directory with new keys (see bin/gen_r5.mjs).
set -euo pipefail
cd "$(dirname "$0")"
exec node bin/gen_r5.mjs artifacts_certs_r5.zip "$@"
