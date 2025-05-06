#!/bin/bash

# build a list of all compat matrix files in provider dirs
dirs=$(ls providers)
for dir in $dirs; do
    dir=providers/$dir
    if [ ! -d $dir ]; then continue; fi
    files+=$(find $dir/compatMatrices/artifacts_certs_r5 -name "*.csv" )
    files+=" "
done

# build the compat matrix
python3 src/pqc_report_writer_common.py docs/oid_mapping.md pqc_hackathon_results_certs_r5.md Certificate $files

# DEBUG
ls

# convert to html
pandoc -f markdown pqc_hackathon_results_certs_r5.md > pqc_hackathon_results_certs_r5.html
mv pqc_hackathon_results_certs_r5.md pqc_hackathon_results_certs_r5.html docs

if [ -d ./output/certs ]; then
    python3 src/pqc_report_writer_common.py docs/oid_mapping.md pqc_hackathon_results_certs_r5_automated_tests.md "Certificate Automated Verification" $(find ./output/certs -name "*.csv")
    pandoc -f markdown pqc_hackathon_results_certs_r5_automated_tests.md > pqc_hackathon_results_certs_r5_automated_tests.html
    mv pqc_hackathon_results_certs_r5_automated_tests.md pqc_hackathon_results_certs_r5_automated_tests.html docs
fi
