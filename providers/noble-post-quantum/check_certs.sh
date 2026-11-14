#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Usage: ./check_certs.sh <artifacts_certs_r5.zip>   -> CSV on stdout, reasons on stderr
set -euo pipefail
if [[ $# != 1 ]]; then printf 'Usage: %s <zipfile>\n' "$0" >&2; exit 1; fi
here=$(cd "$(dirname "$0")" && pwd)
zip=$(cd "$(dirname "$1")" && pwd)/$(basename "$1")

# Refuse a zip before reading any entry when it is far larger than any R5 zip in the repository
# (the same limits as the go-crypto checker in #341). The declared sizes in a zip can lie, so the
# extraction itself is also capped per file (ulimit -f, in KiB): 16 MiB, above the largest R5 file
# expected (a Classic McEliece certificate is about 1.4 MB).
max_zip=$((64 * 1024 * 1024)) max_entries=4096 max_file_kib=$((16 * 1024)) max_unzipped_kib=$((256 * 1024))
size=$(wc -c < "$zip")
if (( size > max_zip )); then echo "refused: $zip is $size bytes (limit $max_zip)" >&2; exit 3; fi
entries=$(unzip -Z1 "$zip" | wc -l)
if (( entries > max_entries )); then echo "refused: $zip has $entries entries (limit $max_entries)" >&2; exit 3; fi
# Symlinks would be restored by unzip and followed when the folder is read; a repeated path makes
# unzip stop and ask on stdin.
if unzip -Z "$zip" | awk 'substr($1, 1, 1) == "l" { found = 1 } END { exit !found }'; then
  echo "refused: $zip contains symbolic links" >&2; exit 3
fi
dups=$(unzip -Z1 "$zip" | sort | uniq -d | awk 'NR <= 3')
if [[ -n "$dups" ]]; then echo "refused: $zip repeats entry names: ${dups//$'\n'/, }" >&2; exit 3; fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
# Keep the folders (a basename may occur in two folders); never read stdin; exit status 1 is a
# warning (for example a stripped "../" or absolute path) and does not stop the run.
rc=0
( ulimit -c 0; ulimit -f "$max_file_kib"; exec unzip -qq -d "$tmp" "$zip" < /dev/null ) || rc=$?
if (( rc > 1 )); then echo "refused: unzip failed with status $rc (a file larger than $max_file_kib KiB?)" >&2; exit 3; fi
used=$(du -sk "$tmp" | cut -f1)
if (( used > max_unzipped_kib )); then echo "refused: $zip expands to $used KiB (limit $max_unzipped_kib)" >&2; exit 3; fi
node "$here/bin/verify_r5.mjs" "$tmp"
