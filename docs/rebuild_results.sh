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
# echo "files:"
# echo $files
python3 ../src/pqc_report_writer.py oid_mapping.md $files > compat_matrix.md