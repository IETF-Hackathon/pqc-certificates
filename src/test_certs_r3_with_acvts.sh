#!/bin/bash

# params:
# $1 - PQC Certs dir (the root of the pqc-certificates repo)
# $2 - ACVP-Server dir (the root of the ACVP-Server repo)

if [ -z "$1" ]; then
    pqcCertsDir="./"
else
    pqcCertsDir=$1
fi

if [ -z "$2" ]; then
    acvpDir="./"
else
    acvpDir=$2
fi

certszipr3="artifacts_certs_r3.zip"
inputdir="$pqcCertsDir/providers"
outputdir="./output/certs"
logfile=$outputdir/nist-acvts.log

# These are expected to be JSON files with a list of {"oid":"alg_name"}, for example:
# {"1.3.6.1.4.1.2.267.12.4.4": "ML-DSA-44-ipd", "1.3.6.1.4.1.2.267.12.6.5": "ML-DSA-65-ipd", "1.3.6.1.4.1.2.267.12.8.7": "ML-DSA-87-ipd"}
supported_OIDs_json="$pqcCertsDir/src/nist-acvts-verifier/supported_oids.json"

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
    elif [[ $(expr match "$tafileBasename" ".*_ta\.der\.pem$") != 0 ]]; then
        oid=${tafileBasename%_ta.der.pem}
    else  # It's some other filename
        printf "ERROR: file name is not in the expected format: %s\n" $tafileBasename
        return
    fi

    # some artifacts submit multiple copies of the same cert as .pem, .der, etc. Just skip the second one
    if [[ $(expr match "$alreadyTestedOIDs" ".*\;$oid\;.*") != 0 ]]; then
        printf "Warning: %s has been submitted multiple times by this provider. Skipping\n" $oid 
        return
    fi

    alreadyTestedOIDs=${alreadyTestedOIDs}$oid";"

    # The actual test command that is the heart of this script
    printf "Testing %s\n" $tafile |tee -a $logfile
    lastWorkingDir=$(pwd)
    cd $pqcCertsDir/src/nist-acvts-verifier/
    # Usage: dotnet run <expected-file-type: pem|der> <path-to-file>
    test_output=$(BuildGenValPackages=false dotnet run pem $tafile)
    test_status=$?
    cd $lastWorkingDir

    # log it to file and to stdout
    echo "$test_output" |tee -a $logfile


    # test for an error and print a link in the results CSV file
    if [[ $test_status -ne 0 ]]; then
        echo "Certificate Validation Result: FAIL" |tee -a $logfile
        echo $oid,N >> $resultsfile
    else
        echo "Certificate Validation Result: SUCCESS" |tee -a $logfile
        echo $oid,Y >> $resultsfile
    fi
}



# MAIN()

printf "Running in working directory %s\n" $(pwd)

# First, recurse into any provider dir
for providerdir in $(ls -d $inputdir/*/); do
    provider=$(basename $providerdir)

    # process certs
    zip=${providerdir}$certszipr3
    unzipdir=${providerdir}"artifacts_certs_r3"
    printf "Unziping %s to %s\n" $zip $unzipdir
    unzip -o $zip -d $unzipdir

    resultsfile=${outputdir}/${provider}_nist-acvts-verifier.csv
    echo "key_algorithm_oid,test_result" > $resultsfile  # CSV header row

    alreadyTestedOIDs=";"  # for a guard to skip testing the same cert multiple times
    # test each TA file
    for tafile in $(find $unzipdir \( -iname "*_ta.pem" -o -iname "*_ta.der.pem" \)); do
        test_ta "$tafile" "$resultsfile"
    done
done