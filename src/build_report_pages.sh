#!/bin/bash
# Sourced by the rebuild_results_*.sh scripts.
#
# build_report_pages <basename> <interop type> <csv files...>
#
# Writes two pages into docs/:
#   <basename>.html               - pre-standard algorithms
#   <basename>_standardized.html  - standardized algorithms
# The split is controlled by docs/standardized_oids.txt.

build_report_pages() {
    local base=$1
    local interop_type=$2
    shift 2

    local page suffix other
    for page in standardized prestandard; do
        if [ "$page" = standardized ]; then
            suffix="_standardized"
            other="${base}.html"
        else
            suffix=""
            other="${base}_standardized.html"
        fi

        python3 src/pqc_report_writer_common.py docs/oid_mapping.md "${base}${suffix}.md" "$interop_type" \
            --standardized-oids docs/standardized_oids.txt --page "$page" --other-page "$other" "$@" || return 1
        pandoc -f markdown "${base}${suffix}.md" > "${base}${suffix}.html" || return 1
        mv "${base}${suffix}.md" "${base}${suffix}.html" docs
    done
}
