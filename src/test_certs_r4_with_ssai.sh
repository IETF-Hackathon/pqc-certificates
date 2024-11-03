#!/bin/bash

# to run this script, please use the docker image quantcrypt_ta_validator_0.2.0 which can be retrieved here:
# docker pull jethrolow/quantcrypt_validator:0.3.1
# sudo docker run -it --rm -v $(pwd):/app -w /app quancrypt_ta_validator_0.2.0 -c "./providers/seventhsense.ai/test_certs_r4_with_ssai.sh"

certszipr4="artifacts_certs_r4.zip"
inputdir="./providers"
outputdir="./output/certs"
logfile=$outputdir/seventhsense_certs.log

# Start the results CSV file
mkdir -p $outputdir
printf "Build time: %s\n\n" "$(date)" > $logfile

alreadyTestedOIDs=";"

# Manually declare an associative array (hash map) for manual TA-EE mapping, since the formatting is different for each provider
declare -A ta_ee_map_sevensenseai
ta_ee_map_sevensenseai["MlDsa44_MlKem512-2.16.840.1.101.3.4.4.1_ee.der"]="MlDsa44-2.16.840.1.101.3.4.3.17_ta.der"
ta_ee_map_sevensenseai["MlDsa65_MlKem768-2.16.840.1.101.3.4.4.2_ee.der"]="MlDsa65-2.16.840.1.101.3.4.3.18_ta.der"
ta_ee_map_sevensenseai["MlDsa87_MlKem1024-2.16.840.1.101.3.4.4.3_ee.der"]="MlDsa87-2.16.840.1.101.3.4.3.19_ta.der"

declare -A ta_ee_map_bc
ta_ee_map_bc["ml-kem-512-2.16.840.1.101.3.4.4.1_ee.der"]="ml-dsa-44-2.16.840.1.101.3.4.3.17_ta.der"
ta_ee_map_bc["ml-kem-768-2.16.840.1.101.3.4.4.2_ee.der"]="ml-dsa-65-2.16.840.1.101.3.4.3.18_ta.der"
ta_ee_map_bc["ml-kem-1024-2.16.840.1.101.3.4.4.3_ee.der"]="ml-dsa-87-2.16.840.1.101.3.4.3.19_ta.der"

declare -A ta_ee_map_cht
ta_ee_map_cht["ML-KEM-512-2.16.840.1.101.3.4.4.1_ee.der"]="ML-DSA-44-2.16.840.1.101.3.4.3.17_ta.der"
ta_ee_map_cht["ML-KEM-768-2.16.840.1.101.3.4.4.2_ee.der"]="ML-DSA-65-2.16.840.1.101.3.4.3.18_ta.der"
ta_ee_map_cht["ML-KEM-1024-2.16.840.1.101.3.4.4.3_ee.der"]="ML-DSA-87-2.16.840.1.101.3.4.3.19_ta.der"


declare -A ta_ee_map_cns
ta_ee_map_cns["ML-KEM-512-2.16.840.1.101.3.4.4.1_ee.der"]="ML-DSA-44-2.16.840.1.101.3.4.3.17_ta.der"
ta_ee_map_cns["ML-KEM-768-2.16.840.1.101.3.4.4.2_ee.der"]="ML-DSA-65-2.16.840.1.101.3.4.3.18_ta.der"
ta_ee_map_cns["ML-KEM-1024-2.16.840.1.101.3.4.4.3_ee.der"]="ML-DSA-87-2.16.840.1.101.3.4.3.19_ta.der"



# Requires an input: the TA file to test
test_ta_ee () {
    certfile=$1
    resultsfile=$2
    provider=$3

    certfileBasename=$(basename $certfile)
    
    echo "basename: $certfileBasename"

    # strip off the file suffix to get the OID name
    if [[ "$certfileBasename" =~ .*_ta\.pem$ ]]; then
        oid=${certfileBasename%_ta.pem}
    elif [[ "$certfileBasename" =~ .*_ta\.der$ ]]; then
        oid=${certfileBasename%_ta.der}
    elif [[ "$certfileBasename" =~ .*_ta\.der\.pem$ ]]; then
        oid=${certfileBasename%_ta.der.pem}
    elif [[ "$certfileBasename" =~ .*_ee\.pem$ ]]; then
        oid=${certfileBasename%_ee.pem}
    elif [[ "$certfileBasename" =~ .*_ee\.der$ ]]; then
        oid=${certfileBasename%_ee.der}
    elif [[ "$certfileBasename" =~ .*_ee\.der\.pem$ ]]; then
        oid=${certfileBasename%_ee.der.pem}
    else  # It's some other filename
        printf "ERROR: file name is not in the expected format: %s\n" "$certfileBasename"
        printf "ERROR: file name is not in the expected format: %s\n" "$certfileBasename" >> "$logfile"
        return 1  # Indicate failure with a non-zero exit code
    fi

    # parse the oid to get only the number using awk
    oid=$(echo "$oid" | awk -F'-' '{print $NF}')


    # some artifacts submit multiple copies of the same cert as .pem, .der, etc. Just skip the second one
    if [[ $(expr match "$alreadyTestedOIDs" ".*\;$oid\;.*") != 0 ]]; then
        printf "\nWarning: %s has been submitted multiple times by this provider. Skipping\n" $oid
        printf "\nWarning: %s has been submitted multiple times by this provider. Skipping\n" $oid >> $logfile
        return
    fi

    alreadyTestedOIDs=${alreadyTestedOIDs}$oid";"

    printf "\nTesting %s\n" "$certfile"
    printf "\nTesting %s\n" "$certfile" >> $logfile

    # The actual quantcrypt command that is the heart of this script
    # print the current directory
    echo "Current directory: $(pwd)"
    if [[ "$certfile" =~ .*_ta\.(pem|der|der\.pem)$ ]]; then
        # Run the TA command
        echo "Processing TA certificate: $certfile"
        ossl_output=$(validator ta --ta-certificate "$certfile" 2>&1)
        ossl_status=$?
    elif [[ "$certfile" =~ .*_ee\.(pem|der|der\.pem)$ ]]; then
        # Run the EE command
        echo "Processing EE certificate: $certfile"
        # get the matching TA file
        certfilename=$(basename $certfile)
        certfiledir=$(dirname $certfile)
        echo "certfilename: $certfilename"
        echo "certfiledir: $certfiledir"
        echo "provider: $provider"
        case "$provider" in
            "seventhsense.ai")
                tafile="${ta_ee_map_sevensenseai[$certfilename]}"
                ;;
            "bc")
                tafile="${ta_ee_map_bc[$certfilename]}"
                ;;
            "cht")
                tafile="${ta_ee_map_cht[$certfilename]}"
                ;;
            "cryptonext-cnsprovider")
                tafile="${ta_ee_map_cns[$certfilename]}"
                ;;
            *)
                echo "ERROR: Unrecognized provider: $provider" | tee -a "$logfile"
                return 1
                ;;
        esac

        echo "tafile extracted from mapping: $tafile"
        tafile=$certfiledir/$tafile
        echo "final tafile: $tafile"
        ossl_output=$(validator ee --ta-certificate "$tafile" --ee-certificate "$certfile" 2>&1)
        ossl_status=$?
    else
        echo "ERROR: Unrecognized file type: $certfile"
        continue  # Skip to the next iteration
    fi

    # log it to file and to stdout
    echo "$ossl_output" >> $logfile
    echo "$ossl_output"

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
    zip=${providerdir}$certszipr4
    unzipdir=${providerdir}"artifacts_certs_r4"
    printf "Unziping %s to %s\n" $zip $unzipdir
    unzip -o $zip -d $unzipdir

    resultsfile=${outputdir}/${provider}_seventhsenseai.csv
    echo "key_algorithm_oid,test_result" > $resultsfile  # CSV header row

    alreadyTestedOIDs=";"  # for a guard to skip testing the same cert multiple times
    # test each TA or EE file
for certfile in $(find "$unzipdir" \( \
    -iname "*_ta.pem" -o -iname "*_ta.der" -o -iname "*_ta.der.pem" -o \
    -iname "*_ee.pem" -o -iname "*_ee.der" -o -iname "*_ee.der.pem" \)); do
    test_ta_ee "$certfile" "$resultsfile" "$provider"
done
done

