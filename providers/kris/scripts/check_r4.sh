#!/bin/bash
# This script must be run from the root directory of pqc-certificates
# Stolen from seventhsense.ai and retrofitted to work with OpenSSL and
# anti-atlas.

certszipr4="artifacts_certs_r4.zip"
inputdir="./providers"
outputdir="./output/certs"
logfile=$outputdir/kris.log

# Start the results CSV file
mkdir -p $outputdir
printf "Build time: %s\n\n" "$(date)" > $logfile

source providers/kris/scripts/oids.sh

supported_ta_oids=("${PQSP_OID_MLDSA44}" "${PQSP_OID_MLDSA65}" "${PQSP_OID_MLDSA87}" "${FALCON_512}" "${FALCON_1024}")


function convert_to_pem {
	# We want to check that the needed structures
	# are all in place
    certfile=$1
    pemfile=$2

    echo $certfile
	# Checks if we have the PEM version of the RootCA
	if [ -f "$certfile" ]; then
        openssl x509 -inform DER -in "$certfile" -out "$pemfile"
        if [ $? -gt 0 ] ; then
            echo
            echo "ERROR: Cannot convert $certfile into PEM format"
            echo
            exit 1
        fi
	fi
}

check() {
	# Extracts the argument
	pemfile=$1

	# Baseline test whether TA cert is well formed
	openssl x509 -in $pemfile -text -noout 2>/dev/null > /dev/null
	if [ $? -ne 0 ]; then
		echo "${pemfile} not suitable."
		return 0
	fi

	# Baseline test whether TA cert is self-signed
	openssl verify -CAfile $pemfile $pemfile 2>/dev/null >/dev/null
	if [ $? -ne 0 ]; then
		echo "${pemfile} not self-signed."
		return 0
	fi

	# Checking for some parsing errors
	openssl x509 -in $pemfile -text -noout | grep error 2>/dev/null > /dev/null
	if [ $? -ne 0 ]; then
		#echo "No error parsing TA certificate in $1";
		# Extracting algorithm name
		openssl x509 -in $pemfile -text -noout | grep "Public Key Algorithm" 2>&1 > /dev/null
        if [ $? -ne 0 ]; then
            echo "Can't extract the algorithm name"
            echo "N"
            return
        fi
	else
        echo "Error parsing ${PEM}"
        return 0
	fi
    return 1
}

# First, recurse into any provider dir
for providerdir in $(ls -d $inputdir/*/); do
    provider=$(basename $providerdir)

    # process certs
    zip=${providerdir}$certszipr4
    unzipdir=${providerdir}"artifacts_certs_r4"
    unzip -o $zip -d $unzipdir 2> /dev/null
    if [ $? -ne 0 ]; then
        echo "$provider: artifacts not found"
        continue
    else
        echo "Processing $provider"
    fi

    resultsfile=${outputdir}/${provider}_kris.csv
    echo "key_algorithm_oid,test_result" > $resultsfile  # CSV header row

    for oid in ${supported_ta_oids[@]}; do
        for certfile in `ls ${unzipdir}/artifacts_certs_r4/*-${oid}_ta.der`; do
            pemfile=`dirname $certfile`/`basename $certfile .der`.pem
            convert_to_pem $certfile $pemfile
            check $pemfile
            if [ $? -eq 1 ]; then
                echo "${oid},Y" >> $resultsfile
            else
                echo "${oid},N" >> $resultsfile
            fi
        done
    done
done
