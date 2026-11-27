#!/bin/bash
# Builds the result pages for artifacts_cms_v3.zip into docs/:
# - the manual results, from the CSVs in providers/*/compatMatrices/artifacts_cms_v3/, leaving out results
#   older than the zip they verify. CI builds these; locally, pass --local.
# - the automated results, from the CSVs the CI verifier jobs write to output/cms/, if there are any.
#
# usage: src/rebuild_results_cms_v3.sh [--local]

source src/build_report_pages.sh
require_ci_or_local "$@"

# NUL-separated, so that no file name is split or expanded
mapfile -d "" files < <(find providers/*/compatMatrices/artifacts_cms_v3 -name "*.csv" -print0 2>/dev/null)

# with CI verifier results, link the manual results' producers to them
automated=()
[ -d ./output/cms ] && automated=(--automated pqc_hackathon_results_cms_v3_automated_tests)
build_report_pages pqc_hackathon_results_cms_v3 CMS "${automated[@]}" "${files[@]}" || exit 1

if [ -d ./output/cms ]; then
    mapfile -d "" automated_files < <(find ./output/cms -name "*.csv" -print0)
    build_report_pages pqc_hackathon_results_cms_v3_automated_tests "CMS Automated Verification" "${automated_files[@]}" || exit 1
fi
