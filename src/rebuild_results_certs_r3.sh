#!/bin/bash

# build a list of all compat matrix files in provider dirs
dirs=$(ls providers)
for dir in $dirs; do
    dir=providers/$dir
    if [ ! -d $dir ]; then continue; fi
    files+=$(find $dir/compatMatrices/artifacts_certs_r3 -name "*.csv" )
    files+=" "
done

printf "Files: %s\n" $files

# build the compat matrix
python3 src/pqc_report_writer_common.py docs/oid_mapping.md pqc_hackathon_results_certs_r3.md Certificate $files

# convert to html
pandoc -f markdown pqc_hackathon_results_certs_r3.md > pqc_hackathon_results_certs_r3.html
mv pqc_hackathon_results_certs_r3.md pqc_hackathon_results_certs_r3.html docs


# Also generate a results html with only automated test results
python3 src/pqc_report_writer_common.py docs/oid_mapping.md pqc_hackathon_results_certs_r3_automated_tests.md Certificate $(ls ./output/certs)
pandoc -f markdown pqc_hackathon_results_certs_r3_automated_tests.md > pqc_hackathon_results_certs_r3_automated_tests.html
mv pqc_hackathon_results_certs_r3_automated_tests.md pqc_hackathon_results_certs_r3_automated_tests.html docs
