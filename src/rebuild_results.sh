#!/bin/bash

# build a list of all compat matrix files in provider dirs
dirs=$(ls ../providers)
for dir in $dirs; do
    dir=../providers/$dir
    if [ ! -d $dir ]; then continue; fi
    files+=$(find $dir/compatMatrices/ -name "*.csv" )
    files+=" "
done

# build the compat matrix
# outputs to `pqc_hackathon_results.md`
python3 pqc_report_writer.py ../docs/oid_mapping.md $files

# convert to html
pandoc -f markdown pqc_hackathon_results.md > pqc_hackathon_results.html
mv pqc_hackathon_results.md pqc_hackathon_results.html oids.json ../docs