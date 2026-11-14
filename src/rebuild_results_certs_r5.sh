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
source src/build_report_pages.sh

build_report_pages pqc_hackathon_results_certs_r5 Certificate $files

if [ -d ./output/certs ]; then
    build_report_pages pqc_hackathon_results_certs_r5_automated_tests "Certificate Automated Verification" $(find ./output/certs -name "*.csv")
fi
