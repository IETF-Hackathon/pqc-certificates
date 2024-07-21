#!/bin/sh

certszipr3="artifacts_certs_r3.zip"
cmszipr1="artifacts_cms_v1.zip"
inputdir="./providers"
outputdir="./output/certs"

# Requires an input: the TA file to test
test_ta () {
    tafile=$1
    resultsfile=$2

    printf "\nTesting %s\n" $tafile
    printf "\nTesting %s\n" $tafile >> ${outputdir}/oqs.log

    # openssl always exits with 0, so we can't use exit status to tell if the cert was valid :/
    ossl_output=$(openssl verify -check_ss_sig -verbose -CAfile $tafile $tafile 2>&1)
    ossl_status=$?

    # log it to file and to stdout
    echo "$ossl_output" >> ${outputdir}/oqs.log
    echo "$ossl_output"


    tafileBasename=$(basename $tafile)
    oid=${tafileBasename%_ta.pem}  # remove the suffix "_ta.pem"

    # test for an error and print a link in the results CSV file
    if [[ $ossl_status -ne 0 ]]; then
        echo "Certificate Validation Result: FAIL"
        echo $oid,N >> $resultsfile
    else
        echo "Certificate Validation Result: SUCCESS"
        echo $oid,Y >> $resultsfile
    fi
}

# First, recurse into any provider dir
for providerdir in $(ls -d $inputdir/*/); do
    provider=$(basename $providerdir)

    # process certs
    zip=${providerdir}$certszipr3
    unzipdir=${providerdir}"artifacts_certs_r3"
    printf "Unziping %s\n" $zip
    unzip -o $zip -d $unzipdir

    # Start the results CSV file
    mkdir -p $outputdir
    resultsfile=${outputdir}/${provider}_$1.csv
    echo "key_algorithm_oid,test_result" > $resultsfile

    # test each TA file
    for tafile in $(find $unzipdir -name "*_ta.pem"); do
        test_ta "$tafile" "$resultsfile"
    done
done

