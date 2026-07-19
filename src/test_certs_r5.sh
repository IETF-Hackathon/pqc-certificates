#!/bin/sh

if [ $# -lt 1 ]; then
    echo "Error: must provide the name of the verifier to use, which must match a .cmd file in the /src dir."
    exit -1
fi

verifier=$1
case "$verifier" in
  bc|ssai|openssl|qubip-aurora)
    echo "Running with verifier $verifier." 
    ;;
  *)
    echo "ERROR: verifier \"$verifier\" not supported"
    exit 255
    ;;
esac

certsdir="artifacts_certs_r5"
certszip="artifacts_certs_r5.zip"
cmszipr1="artifacts_cms_v1.zip"
inputdir="./providers"
outputdir="./output/certs"
logfile=$outputdir/${verifier}_certs.log

# Start the results CSV file
mkdir -p $outputdir
printf "Build time: %s\n\n" "$(date)" > $logfile

alreadyTestedOIDs=";"

# Return true (0) if this verifier is an alias for the openssl verifier
alias_for_openssl() {
  case "$1" in
    qubip-aurora|openssl) return 0 ;;
    *) return 1 ;;
  esac
}

# This only tests self-signed TA certs with openssl
# The outcome depends on openssl version and its configuration: extra providers
# can add support for algorithm not supported by the OpenSSL `default`
# provider.
openssl_check_ta() {
    _tafile="$1"
    _oid="$2"

    openssl list --signature-algorithms --kem-algorithms | grep " $oid,"
    if [ $? != 0 ]; then
        printf "\nSkipping %s, unsupported\n" "$_tafile" | tee -a "$logfile"
        return 1
    fi

    # Baseline test whether TA cert is well formed
    openssl x509 -in "$_tafile" -text -noout
    if [ $? -ne 0 ]; then
        echo "ERROR: malformed cert" | tee -a "$logfile"
        return 1
    fi

    # Baseline test whether TA cert is self-signed
    openssl verify -no_check_time -check_ss_sig -CAfile "$_tafile" "$_tafile"
    if [ $? -ne 0 ]; then
        echo "ERROR: self-signed signature verification" | tee -a "$logfile"
        return 1
    fi
    return 0
}

# Requires an input: the TA file to test
test_ta () {
    tafile=$1
    resultsfile=$2

    tafileBasename=$(basename $tafile)

    # strip off the friendly name
    tafileBasename=$(echo $tafileBasename | egrep -o '[^-]*_ta.der$')


    # strip off the file suffix to get the OID name
    if [ $(expr match "$tafileBasename" ".*_ta\.der$") != 0 ]; then
        oid=${tafileBasename%_ta.der}        
    else  # It's some other filename
        printf "ERROR: file name is not in the expected format: %s\n" $tafileBasename
        printf "ERROR: file name is not in the expected format: %s\n" $tafileBasename >> $logfile
        return
    fi

    # some artifacts submit multiple copies of the same cert as .pem, .der, etc. Just skip the second one
    if [ $(expr match "$alreadyTestedOIDs" ".*\;$oid\;.*") != 0 ]; then
        printf "\nWarning: %s has been submitted multiple times by this provider. Skipping\n" $oid
        printf "\nWarning: %s has been submitted multiple times by this provider. Skipping\n" $oid >> $logfile
        return
    fi

    alreadyTestedOIDs=${alreadyTestedOIDs}$oid";"

    printf "\nTesting %s\n" $tafile
    printf "\nTesting %s\n" $tafile >> $logfile

    # The actual command that is the heart of this script
    if [ "$verifier" = "ssai" ]; then
        output=$(validator ta --ta-certificate $tafile 2>&1)
        status=$?
    elif alias_for_openssl "$verifier"; then
        output=$(openssl_check_ta "$tafile" "$oid" 2>&1)
        status=$?
    else
        echo "ERROR: verifier \"$verifier\" not supported"
        exit -1
    fi

    # log it to file and to stdout
    echo "$output" >> $logfile
    echo "$output"


    # test for an error and print a link in the results CSV file
    if [ $status -ne 0 ]; then
        echo "Certificate Validation Result: FAIL"
        echo $oid,cert,N >> $resultsfile
    else
        echo "Certificate Validation Result: SUCCESS"
        echo $oid,cert,Y >> $resultsfile
    fi
}


# First, recurse into any provider dir
for providerdir in $(ls -d $inputdir/*/); do
    provider=$(basename $providerdir)

    # process certs
    zip=${providerdir}$certszip
    resultsfile=${outputdir}/${provider}_${verifier}.csv

    # BC scripts can handle a whole zip file, which has better performance
    # than invoking a new JVM for each cert.
    if [ "$verifier" = "bc" ]; then
        if [ -f  $(pwd)/$zip ]; then
            echo "key_algorithm_oid,type,test_result" > $resultsfile  # CSV header row
            (verify_r3.sh $(pwd)/$zip >> $resultsfile)
        fi
    else # other providers
        unzipdir=${providerdir}$certsdir
        printf "Unziping %s to %s\n" $zip $unzipdir
        unzip -o $zip -d $unzipdir

        echo "key_algorithm_oid,type,test_result" > $resultsfile  # CSV header row

        alreadyTestedOIDs=";"  # for a guard to skip testing the same cert multiple times
        # test each TA file
        for tafile in $(find $unzipdir \( -iname "*_ta.pem" -o -iname "*_ta.der" -o -iname "*_ta.der.pem" \)); do
            test_ta "$tafile" "$resultsfile"
        done
    fi
done
