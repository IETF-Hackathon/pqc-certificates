#!/bin/bash
# Builds the result pages for artifacts_certs_r5.zip into docs/:
# - the manual results, from the CSVs in providers/*/compatMatrices/artifacts_certs_r5/, leaving out results
#   older than the zip they verify. CI builds these; locally, pass --local.
# - the automated results, from the CSVs the CI verifier jobs write to output/certs/, if there are any.
#
# usage: src/rebuild_results_certs_r5.sh [--local]

source src/build_report_pages.sh
require_ci_or_local "$@"

# NUL-separated, so that no file name is split or expanded
mapfile -d "" files < <(find providers/*/compatMatrices/artifacts_certs_r5 -name "*.csv" -print0 2>/dev/null)

# with CI verifier results, link the manual results' producers to them
automated=()
[ -d ./output/certs ] && automated=(--automated pqc_hackathon_results_certs_r5_automated_tests)
build_report_pages pqc_hackathon_results_certs_r5 Certificate "${automated[@]}" "${files[@]}" || exit 1

if [ -d ./output/certs ]; then
    mapfile -d "" automated_files < <(find ./output/certs -name "*.csv" -print0)
    build_report_pages pqc_hackathon_results_certs_r5_automated_tests "Certificate Automated Verification" "${automated_files[@]}" || exit 1
fi
