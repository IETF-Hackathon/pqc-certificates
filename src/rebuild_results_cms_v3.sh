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
source src/build_report_pages.sh

build_report_pages pqc_hackathon_results_cms_v3 CMS $files

if [ -d ./output/cms ]; then
    build_report_pages pqc_hackathon_results_cms_v3_automated_tests "CMS Automated Verification" $(find ./output/cms -name "*.csv")
fi
