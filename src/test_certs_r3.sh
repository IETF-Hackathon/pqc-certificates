#!/bin/sh

certszipr3="artifacts_certs_r3.zip"
cmszipr1="artifacts_cms_v1.zip"
inputdir="./providers"
outputdir="./output/certs"
logfile=$outputdir/oqs_certs.log

# Start the results CSV file
mkdir -p $outputdir
printf "Build time: %s\n\n" "$(date)" > $logfile

alreadyTestedOIDs=";"

# Requires an input: the TA file to test
test_ta () {
    tafile=$1
    resultsfile=$2

    tafileBasename=$(basename $tafile)

    # strip off the file suffix to get the OID name
    if [[ $(expr match "$tafileBasename" ".*_ta\.pem$") != 0 ]]; then
        oid=${tafileBasename%_ta.pem}
    elif [[ $(expr match "$tafileBasename" ".*_ta\.der$") != 0 ]]; then
        oid=${tafileBasename%_ta.der}
    elif [[ $(expr match "$tafileBasename" ".*_ta\.der\.pem$") != 0 ]]; then
        oid=${tafileBasename%_ta.der.pem}
    else  # It's some other filename
        printf "ERROR: file name is not in the expected format: %s\n" $tafileBasename
        return
    fi

printf "DEBUG: searching for %s in %s\n" $oid $alreadyTestedOIDs

    # some artifacts submit multiple copies of the same cert as .pem, .der, etc. Just skip the second one
    if [[ $(expr match "$alreadyTestedOIDs" ".*\;$oid\;.*") != 0 ]]; then
        printf "\nWarning: %s has been submitted multiple times by this provider. Skipping\n" $oid 
        return
    fi

    alreadyTestedOIDs=${alreadyTestedOIDs}$oid";"

    printf "\nTesting %s\n" $tafile
    printf "\nTesting %s\n" $tafile >> $logfile

    # openssl always exits with 0, so we can't use exit status to tell if the cert was valid :/
    ossl_output=$(openssl verify -check_ss_sig -verbose -CAfile $tafile $tafile 2>&1)
    ossl_status=$?

    # log it to file and to stdout
    echo "$ossl_output" >> $logfile
    echo "$ossl_output"


printf "DEBUG: writing a result for %s\n" $tafile

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
    printf "Unziping %s to %s\n" $zip $unzipdir
    unzip -o $zip -d $unzipdir

    resultsfile=${outputdir}/${provider}_oqs-provider.csv
    echo "key_algorithm_oid,test_result" > $resultsfile  # CSV header row

    alreadyTestedOIDs=""  # for a guard to skip testing the same cert multiple times
    # test each TA file
    for tafile in $(find $unzipdir \( -iname "*_ta.pem" -o -iname "*_ta.der" -o -iname "*_ta.der.pem" \)); do
        test_ta "$tafile" "$resultsfile"
    done
done

