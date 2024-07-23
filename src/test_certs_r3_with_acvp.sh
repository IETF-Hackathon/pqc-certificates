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
logfile=$outputdir/nist-acvp.log

acvpTestDir="$acvpDir/gen-val/src/crypto/test"
dilithiumTestDir=$acvpTestDir"/NIST.CVP.ACVTS.Libraries.Crypto.Dilithium.Tests"
slhdsaTestDir=$acvpTestDir"/NIST.CVP.ACVTS.Libraries.Crypto.SLHDSA.Tests"

# These are expected to be JSON files with a list of {"oid":"alg_name"}, for example:
# {"1.3.6.1.4.1.2.267.12.4.4": "ML-DSA-44-ipd", "1.3.6.1.4.1.2.267.12.6.5": "ML-DSA-65-ipd", "1.3.6.1.4.1.2.267.12.8.7": "ML-DSA-87-ipd"}
supportedMLDSA_OIDs_json=$(cat $(dirname "$0")/../providers/nist-acvts-test/supported_mldsa_oids.json)
supportedSLHDSA_OIDs_json=$(cat $(dirname "$0")/../providers/nist-acvts-test/supported_slhdsa_oids.json)

printf "DEBUG: ls dilithiumTestDir: %s\n\n" "$(ls $dilithiumTestDir)"

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

    # some artifacts submit multiple copies of the same cert as .pem, .der, etc. Just skip the second one
    if [[ $(expr match "$alreadyTestedOIDs" ".*\;$oid\;.*") != 0 ]]; then
        printf "\nWarning: %s has been submitted multiple times by this provider. Skipping\n" $oid 
        return
    fi

    alreadyTestedOIDs=${alreadyTestedOIDs}$oid";"

    printf "\nTesting %s\n" $tafile |tee -a $logfile

    # The actual test command that is the heart of this script
    if [[ $(expr match "$supportedMLDSA_OIDs_json" ".*\"$oid\".*") != 0 ]]; then
        # this is a supported ML-DSA
        printf "\nTesting %s\n" $tafile |tee -a $logfile
        test_output=$(dotnet $dilithiumTestDir/test NIST.CVP.ACVTS.Libraries.Crypto.Dilithium.Tests.csproj $tafile 2>&1)
        test_status=$?
    elif [[ $(expr match "$supportedSLHDSA_OIDs_json" ".*\"$oid\".*") != 0 ]]; then
        # this is a supported SLH-DSA
        printf "\nTesting %s\n" $tafile |tee -a $logfile
        test_output=$(dotnet $slhdsaTestDir/test NIST.CVP.ACVTS.Libraries.Crypto.SLHDSA.Tests.csproj $tafile 2>&1)
        test_status=$?
    else
        # this is not supported
        printf "Algorithm %s is not supported by the NIST ACVP Tests. Skipping\n\n" $oid
        return
    fi

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

    resultsfile=${outputdir}/${provider}_nist-acvp.csv
    echo "key_algorithm_oid,test_result" > $resultsfile  # CSV header row

    alreadyTestedOIDs=";"  # for a guard to skip testing the same cert multiple times
    # test each TA file
    for tafile in $(find $unzipdir \( -iname "*_ta.pem" -o -iname "*_ta.der" -o -iname "*_ta.der.pem" \)); do
        test_ta "$tafile" "$resultsfile"
    done
done
