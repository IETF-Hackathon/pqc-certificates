#!/bin/bash

# build a list of all compat matrix files in provider dirs
dirs=$(ls providers)
for dir in $dirs; do
    dir=providers/$dir
    if [ ! -d $dir ]; then continue; fi
    files+=$(find $dir/compatMatrices/artifacts_cms_v3 -name "*.csv" )
    files+=" "
done

# build the compat matrix
python3 src/pqc_report_writer_common.py docs/oid_mapping.md pqc_hackathon_results_cms_v3.md CMS $files

# convert to html
pandoc -f markdown pqc_hackathon_results_cms_v3.md > pqc_hackathon_results_cms_v3.html
mv pqc_hackathon_results_cms_v3.md pqc_hackathon_results_cms_v3.html docs

if [ -d ./output/cms ]; then
    python3 src/pqc_report_writer_common.py docs/oid_mapping.md pqc_hackathon_results_cms_v3_automated_tests.md "CMS Automated Verification" $(find ./output/cms -name "*.csv")
    pandoc -f markdown pqc_hackathon_results_cms_v3_automated_tests.md > pqc_hackathon_results_cms_v3_automated_tests.html
    mv pqc_hackathon_results_cms_v3_automated_tests.md pqc_hackathon_results_cms_v3_automated_tests.html docs
fi
