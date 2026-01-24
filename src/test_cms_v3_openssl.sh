#!/bin/bash

set -x

echo "Running OpenSSL 3.6 verifier." | tee $logfile

certsdir="artifacts_cms_v3"
cmszip="artifacts_cms_v3.zip"
inputdir="./providers"
outputdir="./output/cms"
logfile=$outputdir/openssl_cms.log

# Start the results CSV file
mkdir -p $outputdir
printf "Build time: %s\n\n" "$(date)" | tee -a $logfile

alreadyTestedSigOIDs=";"
alreadyTestedKEMOIDs=";"

check_signed_attrs() {
    signed_attrs=$1
    ta_file=$2

    openssl cms -verify -no_check_time -in $signed_attrs -inform DER -CAfile $ta_file
    if [ $? -ne 0 ]; then
        echo "ERROR: verifying signed attributes" | tee -a $logfile
        return 1
    fi

    return 0
}

# Requires an input: the TA file to test
test_signed_attrs () {
    signed_attrs_file=$1
    resultsfile=$2

    output=""
    signed_attrs_filename=$(basename $signed_attrs_file)

    # strip off the friendly name
    signed_attrs_fileBasename=$(echo $signed_attrs_filename | egrep -o '[^-]*_signed_attrs.der$')

    # strip off the file suffix to get the OID name
    if [ $(expr match "$signed_attrs_fileBasename" ".*_signed_attrs\.der$") != 0 ]; then
        oid=${signed_attrs_fileBasename%_signed_attrs.der}
    else  # It's some other filename
        printf "\nERROR: file name is not in the expected format: %s\n" $signed_attrs_file | tee -a $logfile
        return
    fi

    # some artifacts submit multiple copies of the same cert as .pem, .der, etc. Just skip the second one
    if [ $(expr match "$alreadyTestedSigOIDs" ".*\;$oid\;.*") != 0 ]; then
        printf "\nWarning: %s has been submitted multiple times by this provider. Skipping\n" $oid | tee -a $logfile
        return
    fi

    openssl list --signature-algorithms --kem-algorithms | grep " $oid,"
    if [ $? != 0 ]; then
        printf "\nSkipping %s, unsupported\n" $signed_attrs_filename | tee -a $logfile
        return
    fi

    alreadyTestedSigOIDs=${alreadyTestedSigOIDs}$oid";"

    printf "\nTesting signed attributes %s\n" $signed_attrs_file | tee -a $logfile
    output+=$(check_signed_attrs $signed_attrs_file $(dirname $signed_attrs_file)/ta.der)
    status=$?
    if [ $status != 0 ]; then
        echo "Signed Attributes Result: FAIL" | tee -a $logfile
        echo "${oid},N" >> $resultsfile
    else
        echo "Signed Attributes Result: SUCCESS" | tee -a $logfile
        echo "${oid},Y" >> $resultsfile
    fi

    # log it to file and to stdout
    echo "$output" | tee -a $logfile
}

check_kemri() {
    eefile=$1
    oid=$2

    priv_key=$( find $(dirname $eefile) -name "*${oid}*_priv.der" -print -quit )
    kemri_base=${eefile%_ee.der}
    for kemri_file in ${kemri_base}_kemri*.der; do
        if [[ "$kemri_file" == *"kmac"* ]]; then
            printf "\nSkipping KMAC %s\n" $kemri_file | tee -a $logfile
            continue
        fi
        OUTFILE=$(mktemp)
        rm -f $OUTFILE

        printf "\nTesting KEMRI %s\n" $kemri_file | tee -a $logfile

        openssl cms -decrypt -inform DER -in ${kemri_file} -recip ${eefile} \
            -inkey ${priv_key} -keyform DER -out $OUTFILE
        if [ $? -ne 0 ]; then
            echo "ERROR: Decrypting KEMRI" | tee -a $logfile
            return 1
        fi
        rm -f $OUTFILE
    done

    return 0
}

# Requires an input: the TA file to test
test_kemri() {
    eefile=$1
    resultsfile=$2

    output=""
    eefileBasename=$(basename $eefile)

    # strip off the friendly name
    eefileBasename=$(echo $eefileBasename | egrep -o '[^-]*_ee.der$')

    # strip off the file suffix to get the OID name
    if [ $(expr match "$eefileBasename" ".*_ee\.der$") != 0 ]; then
        oid=${eefileBasename%_ee.der}
    else  # It's some other filename
        printf "\nERROR: file name is not in the expected format: %s\n" $eefile | tee -a $logfile
        return
    fi

    # some artifacts submit multiple copies of the same cert as .pem, .der, etc. Just skip the second one
    if [ $(expr match "$alreadyTestedKEMOIDs" ".*\;$oid\;.*") != 0 ]; then
        printf "\nWarning: %s has been submitted multiple times by this provider. Skipping\n" $oid | tee -a $logfile
        return
    fi

    openssl list --signature-algorithms --kem-algorithms | grep " $oid,"
    if [ $? != 0 ]; then
        printf "\nSkipping %s, unsupported\n" $eefileBasename | tee -a $logfile
        return
    fi

    alreadyTestedKEMOIDs=${alreadyTestedKEMOIDs}$oid";"

    printf "\nTesting EE %s\n" $eefile | tee -a $logfile
    output+=$(check_kemri $eefile $oid)
    status=$?
    if [ $status != 0 ]; then
        echo "KemRecipientInfo Result: FAIL" | tee -a $logfile
        echo "${oid},N" >> $resultsfile
    else
        echo "KemRecipientInfo Result: SUCCESS" | tee -a $logfile
        echo "${oid},Y" >> $resultsfile
    fi

    # log it to file and to stdout
    echo "$output" | tee -a $logfile
}

# First, recurse into any provider dir
for providerdir in $(ls -d $inputdir/*/); do
    provider=$(basename $providerdir)

    printf "\n**** BEGIN provider %s **** \n" $provider | tee -a $logfile

    # process certs
    zip=${providerdir}$cmszip
    if ! [ -f $zip ]; then
        continue
    fi
    unzipdir=${providerdir}$certsdir
    printf "\nUnzipping %s to %s\n" $zip $unzipdir | tee -a $logfile
    unzip -o $zip -d $unzipdir

    resultsfile=${outputdir}/${provider}_openssl.csv
    echo "key_algorithm_oid,test_result" > $resultsfile  # CSV header row

    alreadyTestedSigOIDs=";"  # for a guard to skip testing the same cert multiple times
    alreadyTestedKEMOIDs=";"  # for a guard to skip testing the same cert multiple times
    # test each signed attributes fileartifact
    for signed_attrs_file in $(find $unzipdir \( -iname "*_signed_attrs.der" \)); do
        test_signed_attrs "$signed_attrs_file" "$resultsfile"
    done
    # test each KEMRI artifact
    for eefile in $(find $unzipdir \( -iname "*_ee.der" \)); do
        test_kemri "$eefile" "$resultsfile"
    done

    printf "\n**** DONE provider %s **** \n" $provider | tee -a $logfile
done

printf "\n**** DONE **** \n" | tee -a $logfile
