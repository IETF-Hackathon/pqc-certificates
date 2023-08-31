#!/bin/bash

# build a list of all compat matrix files in provider dirs
dirs=$(ls ../providers)
for dir in $dirs; do
    dir=../providers/$dir
    if [ ! -d $dir ]; then continue; fi
    files+=$(find $dir/compatMatrices/artifacts_certs_r3 -name "*.csv" )
    files+=" "
done

# build the compat matrix
# outputs to `pqc_hackathon_results.md`
python3 pqc_report_writer_certs_r3.py ../docs/oid_mapping.md $files

# convert to html
pandoc -f markdown pqc_hackathon_results_certs_r3.md > pqc_hackathon_results_certs_r3.html
mv pqc_hackathon_results_certs_r3.md pqc_hackathon_results_certs_r3.html ../docs