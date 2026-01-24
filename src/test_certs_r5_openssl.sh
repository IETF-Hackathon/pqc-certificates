#!/bin/bash

# set -x

echo "Running OpenSSL 3.5 verifier." | tee $logfile

certsdir="artifacts_certs_r5"
certszip="artifacts_certs_r5.zip"
cmszipr1="artifacts_cms_v1.zip"
inputdir="./providers"
outputdir="./output/certs"
logfile=$outputdir/openssl_certs.log

# Start the results CSV file
mkdir -p $outputdir
printf "Build time: %s\n\n" "$(date)" | tee -a $logfile

alreadyTestedSigOIDs=";"
alreadyTestedKEMOIDs=";"

check_ta() {
    TA=$1

    # Baseline test whether TA cert is well formed
    openssl x509 -in $TA -text -noout
    if [ $? -ne 0 ]; then
        echo "ERROR: malformed cert" | tee -a $logfile
        return 1
    fi

    # Baseline test whether TA cert is self-signed
    openssl verify -no_check_time -check_ss_sig -CAfile $TA $TA
    if [ $? -ne 0 ]; then
        echo "ERROR: self-signed signature" | tee -a $logfile
        return 1
    fi
    return 0
}

check_ee_kem() {
    EE=$1

    # Baseline test whether EE cert is well formed
    openssl x509 -in $EE -text -noout
    if [ $? -ne 0 ]; then
        echo "ERROR: malformed cert" | tee -a $logfile
        return 1
    fi

    openssl x509 -pubkey -noout -in $EE > pubkey.pem
    if [ $? -ne 0 ]; then
        echo "ERROR: getting pub key" | tee -a $logfile
        return 1
    fi
    openssl pkeyutl -encap -inkey pubkey.pem -pubin -secret ss.bin -out ct.bin
    if [ $? -ne 0 ]; then
        echo "ERROR: encap" | tee -a $logfile
        return 1
    fi

    return 0
}

get_prov_param() {
    # Just return all possible provparams
    type=$1
    if [ $type == "seed" ]; then
        echo "-provparam ml-kem.input_formats=seed-only -provparam ml-dsa.input_formats=seed-only"
    elif [ $type == "expandedkey" ]; then
        echo "-provparam ml-kem.input_formats=priv-only -provparam ml-dsa.input_formats=priv-only"
    elif [ $type == "both" ]; then
        echo "-provparam ml-kem.input_formats=seed-priv -provparam ml-dsa.input_formats=seed-priv"
    fi
}

check_consistent() {
    priv=$1
    cert=$2
    type=$3
    pub1=$(mktemp)
    pub2=$(mktemp)
    local prov_param=$(get_prov_param $type)

    openssl pkey $prov_param -in "$priv" -pubout -out $pub1
    if [ $? -ne 0 ]; then
        echo "ERROR: consistency getting pub from priv" | tee -a $logfile
        return 1
    fi

    openssl x509 -in $cert -pubkey -nocert -out $pub2
    if [ $? -ne 0 ]; then
        echo "ERROR: consistency getting pub from cert" | tee -a $logfile
        return 1
    fi

    diff $pub1 $pub2
    if [ $? -ne 0 ]; then
        echo "ERROR: consistency no match" | tee -a $logfile
        return 1
    fi

    rm $pub1 $pub2

    return 0
}

check_sig_priv() {
    priv=$1
    ta=$2
    type=$3
    pub=$(mktemp)
    sig=$(mktemp)
    plaintext=$(mktemp)
    local prov_param=$(get_prov_param $type)
    echo "This is a test of signature data" > $plaintext

    openssl x509 -in $ta -pubkey -nocert -out $pub
    if [ $? -ne 0 ]; then
        echo "ERROR: sig_priv getting pub" | tee -a $logfile
        rm $pub $sig $plaintext
        return 1
    fi

    openssl pkeyutl $prov_param -sign -inkey $priv -rawin -out $sig -in $plaintext
    if [ $? -ne 0 ]; then
        echo "ERROR: sig_priv signing" | tee -a $logfile
        rm $pub $sig $plaintext
        return 1
    fi

    openssl pkeyutl -verify -inkey $pub -pubin -rawin -sigfile $sig -in $plaintext
    if [ $? -ne 0 ]; then
        echo "ERROR: sig_priv verifying" | tee -a $logfile
        rm $pub $sig $plaintext
        return 1
    fi

    rm $pub $sig $plaintext
    return 0
}

check_sig_private_key() {
    priv=$1
    ta=$2
    type=$3

    check_sig_priv $priv $ta $type
    if [ $? != 0 ]; then
        echo "Sig Private Key Result: FAIL" | tee -a $logfile
        echo "${oid},${type},N" >> $resultsfile
        return 1
    fi

    echo "Sig Private Key Result: SUCCESS" | tee -a $logfile
    echo "${oid},${type},Y" >> $resultsfile
    return 0
}

check_kem_priv() {
    PRIV_KEY=$1
    OID=$2
    type=$3
    my_ss=$(mktemp)
    local prov_param=$(get_prov_param $type)

    CIPHERTEXT=$(find $(dirname $PRIV_KEY) -name *-${OID}_ciphertext.bin)
    SS=$(find $(dirname $PRIV_KEY) -name *-${OID}_ss.bin)
    openssl pkeyutl $prov_param -decap -inkey $PRIV_KEY -secret $my_ss -in $CIPHERTEXT
    if [ $? -ne 0 ]; then
        echo "ERROR: kem_priv decap" | tee -a $logfile
        return 1
    fi

    diff $my_ss $SS
    if [ $? -ne 0 ]; then
        echo "ERROR: kem_priv ss doesn't match" | tee -a $logfile
        return 1
    fi

    rm $my_ss
    return 0
}

check_kem_private_key() {
    priv=$1
    oid=$2
    type=$3

    check_kem_priv $priv $oid $type
    if [ $? != 0 ]; then
        echo "KEM Private Key Result: FAIL" | tee -a $logfile
        echo "${oid},${type},N" >> $resultsfile
        return 1
    fi

    echo "KEM Private Key Result: SUCCESS" | tee -a $logfile
    echo "${oid},${type},Y" >> $resultsfile
    return 0
}

# Requires an input: the TA file to test
test_sig_ta () {
    tafile=$1
    resultsfile=$2

    output=""
    tafilename=$(basename $tafile)

    # strip off the friendly name
    tafileBasename=$(echo $tafilename | egrep -o '[^-]*_ta.der$')

    if [[ $tafilename == external_* ]] || [[ $tafilename == catalyst_* ]] || [[ $tafilename == chameleon_* ]]; then
        printf "\nSkipping %s, hybrid cert\n" $tafilename | tee -a $logfile
        return
    fi

    # strip off the file suffix to get the OID name
    if [ $(expr match "$tafileBasename" ".*_ta\.der$") != 0 ]; then
        oid=${tafileBasename%_ta.der}
    else  # It's some other filename
        printf "\nERROR: file name is not in the expected format: %s\n" $tafile | tee -a $logfile
        return
    fi

    # some artifacts submit multiple copies of the same cert as .pem, .der, etc. Just skip the second one
    if [ $(expr match "$alreadyTestedSigOIDs" ".*\;$oid\;.*") != 0 ]; then
        printf "\nWarning: %s has been submitted multiple times by this provider. Skipping\n" $oid | tee -a $logfile
        return
    fi

    openssl list --signature-algorithms --kem-algorithms | grep " $oid,"
    if [ $? != 0 ]; then
        printf "\nSkipping %s, unsupported\n" $tafilename | tee -a $logfile
        return
    fi

    alreadyTestedSigOIDs=${alreadyTestedSigOIDs}$oid";"

    printf "\nTesting %s\n" $tafile | tee -a $logfile

    result_consistent_success=0
    result_consistent_fail=0
    both_priv=$( find $(dirname $tafile) -name "*${oid}_both_priv.der" -print -quit )
    if ! [ -z "$both_priv" ]; then
        printf "\nTesting key %s\n" $both_priv | tee -a $logfile
        output+=$(check_sig_private_key $both_priv $tafile "both")
        printf "\nTesting consistency %s\n" $both_priv | tee -a $logfile
        output+=$(check_consistent $both_priv $tafile "both")
        status=$?
        [ $status != 0 ] && ((result_consistent_fail+=1))
        [ $status == 0 ] && ((result_consistent_success+=1))
    fi
    seed_priv=$( find $(dirname $tafile) -name "*${oid}_seed_priv.der" -print -quit )
    if ! [ -z "$seed_priv" ]; then
        printf "\nTesting key %s\n" $seed_priv | tee -a $logfile
        output+=$(check_sig_private_key $seed_priv $tafile "seed")
        printf "\nTesting consistency %s\n" $seed_priv | tee -a $logfile
        output+=$(check_consistent $seed_priv $tafile "seed")
        status=$?
        [ $status != 0 ] && ((result_consistent_fail+=1))
        [ $status == 0 ] && ((result_consistent_success+=1))
    fi
    expanded_priv=$( find $(dirname $tafile) -name "*${oid}_expandedkey_priv.der" -print -quit )
    if ! [ -z "$expanded_priv" ]; then
        printf "\nTesting key %s\n" $expanded_priv | tee -a $logfile
        output+=$(check_sig_private_key $expanded_priv $tafile "expandedkey")
        printf "\nTesting consistency %s\n" $expanded_priv | tee -a $logfile
        output+=$(check_consistent $expanded_priv $tafile "expandedonly")
        status=$?
        [ $status != 0 ] && ((result_consistent_fail+=1))
        [ $status == 0 ] && ((result_consistent_success+=1))
    fi
    normal_priv=$( find $(dirname $tafile) -name "*${oid}_priv.der" -print -quit )
    if ! [ -z "$normal_priv" ]; then
        printf "\nTesting key %s\n" $normal_priv | tee -a $logfile
        output+=$(check_sig_private_key $normal_priv $tafile "priv")
        printf "\nTesting consistency %s\n" $normal_priv | tee -a $logfile
        output+=$(check_consistent $normal_priv $tafile "priv")
        status=$?
        [ $status != 0 ] && ((result_consistent_fail+=1))
        [ $status == 0 ] && ((result_consistent_success+=1))
    fi

    if [ $result_consistent_fail -gt 0 ]; then
        echo "Consistency Result: FAIL" | tee -a $logfile
        echo "${oid},consistent,N" >> $resultsfile
    elif [ $result_consistent_success -gt 0 ]; then
        echo "Consistency Result: SUCCESS" | tee -a $logfile
        echo "${oid},consistent,Y" >> $resultsfile
    fi

    printf "\nTesting cert %s\n" $tafile | tee -a $logfile
    output=$(check_ta "$tafile")
    if [ $? == 0 ]; then
        echo "Sig Cert Result: SUCCESS" | tee -a $logfile
        echo "${oid},cert,Y" >> $resultsfile
    else
        echo "Sig Cert Result: FAIL" | tee -a $logfile
        echo "${oid},cert,N" >> $resultsfile
    fi

    # log it to file and to stdout
    echo "$output" | tee -a $logfile
}

# Requires an input: the TA file to test
test_kem_ee () {
    eefile=$1
    resultsfile=$2

    output=""
    eefileBasename=$(basename $eefile)

    # strip off the friendly name
    eefileBasename=$(echo $eefileBasename | egrep -o '[^-]*_ee.der$')

    if [[ $eefileBasename == external_* ]] || [[ $eefileBasename == catalyst_* ]] || [[ $eefileBasename == chameleon_* ]]; then
        printf "\nSkipping %s, hybrid cert\n" $eefileBasename | tee -a $logfile
        return
    fi

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

    result_consistent_success=0
    result_consistent_fail=0
    both_priv=$( find $(dirname $eefile) -name "*${oid}_both_priv.der" -print -quit )
    if ! [ -z "$both_priv" ]; then
        printf "\nTesting key %s\n" $both_priv | tee -a $logfile
        output+=$(check_kem_private_key $both_priv $oid "both")
        printf "\nTesting consistency %s\n" $both_priv | tee -a $logfile
        output+==$(check_consistent $both_priv $eefile "both")
        status=$?
        [ $status != 0 ] && ((result_consistent_fail+=1))
        [ $status == 0 ] && ((result_consistent_success+=1))
    fi
    seed_priv=$( find $(dirname $eefile) -name "*${oid}_seed_priv.der" -print -quit )
    if ! [ -z "$seed_priv" ]; then
        printf "\nTesting key %s\n" $seed_priv | tee -a $logfile
        output+=$(check_kem_private_key $seed_priv $oid "seed")
        printf "\nTesting consistency %s\n" $seed_priv | tee -a $logfile
        output=$(check_consistent $seed_priv $eefile "seed")
        status=$?
        [ $status != 0 ] && ((result_consistent_fail+=1))
        [ $status == 0 ] && ((result_consistent_success+=1))
    fi
    expanded_priv=$( find $(dirname $eefile) -name "*${oid}_expandedkey_priv.der" -print -quit )
    if ! [ -z "$expanded_priv" ]; then
        printf "\nTesting key %s\n" $expanded_priv | tee -a $logfile
        output+=$(check_kem_private_key $expanded_priv $oid "expandedkey")
        printf "\nTesting consistency %s\n" $expanded_priv | tee -a $logfile
        output+=$(check_consistent $expanded_priv $eefile "expandedkey")
        status=$?
        [ $status != 0 ] && ((result_consistent_fail+=1))
        [ $status == 0 ] && ((result_consistent_success+=1))
    fi
    normal_priv=$( find $(dirname $eefile) -name "*${oid}_normal_priv.der" -print -quit )
    if ! [ -z "$normal_priv" ]; then
        printf "\nTesting key %s\n" $normal_priv | tee -a $logfile
        output+=$(check_kem_private_key $normal_priv $oid "priv")
        printf "\nTesting consistency %s\n" $normal_priv | tee -a $logfile
        output+=$(check_consistent $normal_priv $eefile "priv")
        status=$?
        [ $status != 0 ] && ((result_consistent_fail+=1))
        [ $status == 0 ] && ((result_consistent_success+=1))
    fi

    if [ $result_consistent_fail -gt 0 ]; then
        echo "KEM Consistency Result: FAIL" | tee -a $logfile
        echo "${oid},consistent,N" >> $resultsfile
    elif [ $result_consistent_success -gt 0 ]; then
        echo "KEM Consistency Result: SUCCESS" | tee -a $logfile
        echo "${oid},consistent,Y" >> $resultsfile
    fi

    printf "\nTesting cert %s\n" $eefile | tee -a $logfile
    result=$(check_ee_kem "${eefile}")
    if [ $? == 0 ]; then
        echo "KEM Cert Result: SUCCESS" | tee -a $logfile
        echo "${oid},cert,Y" >> $resultsfile
    else
        echo "KEM Cert Result: FAIL" | tee -a $logfile
        echo "${oid},cert,N" >> $resultsfile
    fi

    # log it to file and to stdout
    echo "$output" | tee -a $logfile
}

# First, recurse into any provider dir
for providerdir in $(ls -d $inputdir/*/); do
    provider=$(basename $providerdir)

    printf "\n**** BEGIN provider %s **** \n" $provider | tee -a $logfile

    # process certs
    zip=${providerdir}$certszip
    if ! [ -f $zip ]; then
        continue
    fi
    unzipdir=${providerdir}$certsdir
    printf "\nUnzipping %s to %s\n" $zip $unzipdir | tee -a $logfile
    unzip -o $zip -d $unzipdir

    resultsfile=${outputdir}/${provider}_openssl.csv
    echo "key_algorithm_oid,type,test_result" > $resultsfile  # CSV header row

    alreadyTestedSigOIDs=";"  # for a guard to skip testing the same cert multiple times
    alreadyTestedKEMOIDs=";"  # for a guard to skip testing the same cert multiple times
    # test each TA file
    for tafile in $(find $unzipdir \( -iname "*_ta.pem" -o -iname "*_ta.der" -o -iname "*_ta.der.pem" \)); do
        test_sig_ta "$tafile" "$resultsfile"
    done
    # test each EE file
    for eefile in $(find $unzipdir \( -iname "*_ee.pem" -o -iname "*_ee.der" -o -iname "*_ee.der.pem" \)); do
        test_kem_ee "$eefile" "$resultsfile"
    done

    printf "\n**** DONE provider %s **** \n" $provider | tee -a $logfile
done

printf "\n**** DONE **** \n" | tee -a $logfile
