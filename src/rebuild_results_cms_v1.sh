#!/bin/bash

# build a list of all compat matrix files in provider dirs
dirs=$(ls ../providers)
for dir in $dirs; do
    dir=../providers/$dir
    if [ ! -d $dir ]; then continue; fi
    files+=$(find $dir/compatMatrices/artifacts_cms_v1 -name "*.csv" )
    files+=" "
done

# build the compat matrix
python3 pqc_report_writer_common.py ../docs/oid_mapping.md pqc_hackathon_results_cms_v1.md CMS $files

# convert to html
pandoc -f markdown pqc_hackathon_results_cms_v1.md > pqc_hackathon_results_cms_v1.html
mv pqc_hackathon_results_cms_v1.md pqc_hackathon_results_cms_v1.html oids.json ../docs