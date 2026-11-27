#!/bin/bash
# Sourced by the rebuild_results_*.sh scripts.
#
# build_report_pages <basename> <interop type> [--automated <automated basename>] <csv files...>
#
# Writes two pages into docs/:
#   <basename>.html               - pre-standard algorithms
#   <basename>_standardized.html  - standardized algorithms
# The split is controlled by docs/standardized_oids.txt. With --automated, the manual results' producers link to
# the automated results page for the same algorithms.

# require_ci_or_local "$@"
#
# The manual result pages are built by CI, from the committed results, and are not committed. Stops with an
# error when not run in CI (GitHub Actions), unless the script's arguments include --local.
require_ci_or_local() {
    local arg
    for arg in "$@"; do
        [ "$arg" = --local ] && return 0
    done
    [ "${GITHUB_ACTIONS:-}" = true ] && return 0
    echo "warning: the manual result pages are built by CI from the committed results, and are not committed." >&2
    echo "To build them here anyway (to preview your results, say), run: $0 --local" >&2
    exit 1
}

build_report_pages() {
    local base=$1
    local interop_type=$2
    shift 2
    local automated=""
    if [ "${1:-}" = --automated ]; then
        automated=$2
        shift 2
    fi

    local page suffix other link
    for page in standardized prestandard; do
        if [ "$page" = standardized ]; then
            suffix="_standardized"
            other="${base}.html"
        else
            suffix=""
            other="${base}_standardized.html"
        fi

        link=()
        [ -n "$automated" ] && link=(--automated-page "${automated}${suffix}.html")
        python3 src/pqc_report_writer_common.py docs/oid_mapping.md "${base}${suffix}.md" "$interop_type" \
            --standardized-oids docs/standardized_oids.txt --page "$page" --other-page "$other" "${link[@]}" \
            "$@" || return 1
        # Pandoc writes a fragment without <head>; declare UTF-8 so a page opened locally shows the emoji.
        { echo '<meta charset="utf-8">' && pandoc -f markdown "${base}${suffix}.md"; } > "${base}${suffix}.html" || return 1
        mv "${base}${suffix}.md" "${base}${suffix}.html" docs
    done
}
