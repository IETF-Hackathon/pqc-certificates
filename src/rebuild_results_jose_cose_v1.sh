#!/bin/bash

dirs=$(ls ../providers)
for dir in $dirs; do
    dir=../providers/$dir
    if [ ! -d $dir ]; then continue; fi
    files+=$(find $dir/compatMatrices/artifacts_jose_cose_v1 -name "*.csv" 2>/dev/null)
    files+=" "
done

python3 pqc_report_writer_jose_cose.py ../docs/jose_cose_alg_mapping.md pqc_hackathon_results_jose_cose_v1.md JOSE/COSE $files

pandoc -f markdown pqc_hackathon_results_jose_cose_v1.md > pqc_hackathon_results_jose_cose_v1.html
mv pqc_hackathon_results_jose_cose_v1.md pqc_hackathon_results_jose_cose_v1.html ../docs