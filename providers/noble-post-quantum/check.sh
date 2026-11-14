#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Checks one provider's R5 zip and writes the R5 CSV for this verifier.
# Usage: ./check.sh [<provider-dir> | <zip>]     (default: this directory)
#   <provider-dir>  a directory with artifacts_certs_r5.zip; the producer is its name
#   <zip>           an artifact zip; the producer is the name of its directory
# Writes compatMatrices/artifacts_certs_r5/<producer>_noble-post-quantum.csv here (only when
# the run succeeds) and the reasons for every N and every check not performed to logs/<producer>.log.
set -euo pipefail
me=noble-post-quantum
here=$(cd "$(dirname "$0")" && pwd)
target=$(realpath "${1:-$here}")
if [[ -d $target ]]; then zip="$target/artifacts_certs_r5.zip"; else zip=$target; fi
[[ -f $zip ]] || { echo "check.sh: no such zip: $zip" >&2; exit 2; }
producer=$(basename "$(dirname "$zip")")
out="$here/compatMatrices/artifacts_certs_r5"
mkdir -p "$out" "$here/logs"
tmp="$out/.${producer}_${me}.csv.tmp"
if "$here/check_certs.sh" "$zip" > "$tmp" 2> "$here/logs/$producer.log"; then
  rows=$(($(wc -l < "$tmp") - 1))
  if (( rows == 0 )); then
    # Nothing this verifier covers was checked: no matrix, as for a check that did not run.
    rm -f "$tmp" "$out/${producer}_${me}.csv"
    echo "[ $me ] $producer: no rows, no matrix written"
  else
    mv "$tmp" "$out/${producer}_${me}.csv"
    echo "[ $me ] $producer: $rows rows"
  fi
else
  status=$?
  rm -f "$tmp"
  echo "[ $me ] $producer: not written (exit $status, see logs/$producer.log)" >&2
  exit "$status"
fi
