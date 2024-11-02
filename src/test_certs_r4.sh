#!/bin/sh

if [ $# -lt 1 ]; then
    echo "Error: must provide the name of the verifier to use, which must match a .cmd file in the /src dir."
    exit -1
fi

verifier=$1
verifierCmd=$(cat ./src/${verifier}.cmd)

echo "DEBUG: verifiercmd: $verifierCmd"

exit -1



certsdir_r4="artifacts_certs_r4"
certszip_r4="artifacts_certs_r4.zip"
cmszipr1="artifacts_cms_v1.zip"
inputdir="./providers"
outputdir="./output/certs"
logfile=$outputdir/${verifier}_certs.log

# Start the results CSV file
mkdir -p $outputdir
printf "Build time: %s\n\n" "$(date)" > $logfile

alreadyTestedOIDs=";"

# Requires an input: the TA file to test
test_ta () {
    tafile=$1
    resultsfile=$2

    tafileBasename=$(basename $tafile)

    # strip off the friendly name
    tafileBasename=$(echo $tafileBasename | egrep -o '[^-]+_ta.der$')


    # strip off the file suffix to get the OID name
    if [[ $(expr match "$tafileBasename" ".*_ta\.der$") != 0 ]]; then
        oid=${tafileBasename%_ta.der}        
    else  # It's some other filename
        printf "ERROR: file name is not in the expected format: %s\n" $tafileBasename
        printf "ERROR: file name is not in the expected format: %s\n" $tafileBasename >> $logfile
        return
    fi

    # some artifacts submit multiple copies of the same cert as .pem, .der, etc. Just skip the second one
    if [[ $(expr match "$alreadyTestedOIDs" ".*\;$oid\;.*") != 0 ]]; then
        printf "\nWarning: %s has been submitted multiple times by this provider. Skipping\n" $oid
        printf "\nWarning: %s has been submitted multiple times by this provider. Skipping\n" $oid >> $logfile
        return
    fi

    alreadyTestedOIDs=${alreadyTestedOIDs}$oid";"

    printf "\nTesting %s\n" $tafile
    printf "\nTesting %s\n" $tafile >> $logfile

    # The actual openssl command that is the heart of this script
    ossl_output=$(eval $verifierCmd)
    ossl_status=$?

    # log it to file and to stdout
    echo "$ossl_output" >> $logfile
    echo "$ossl_output"


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
    zip=${providerdir}$certszip_r4
    unzipdir=${providerdir}$certsdir_r4
    printf "Unziping %s to %s\n" $zip $unzipdir
    unzip -o $zip -d $unzipdir

    resultsfile=${outputdir}/${provider}_oqs-provider.csv
    echo "key_algorithm_oid,test_result" > $resultsfile  # CSV header row

    alreadyTestedOIDs=";"  # for a guard to skip testing the same cert multiple times
    # test each TA file
    for tafile in $(find $unzipdir \( -iname "*_ta.pem" -o -iname "*_ta.der" -o -iname "*_ta.der.pem" \)); do
        test_ta "$tafile" "$resultsfile"
    done
done

