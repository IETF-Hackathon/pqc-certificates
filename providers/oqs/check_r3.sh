#!/bin/bash

#set -x

function check_cert() {

	# We want to check that the needed structures
	# are all in place
    CERT=$1

	# Checks if we have the PEM version of the RootCA
	if ! [ -f "$CERT.pem" ]; then

		# Checks for the RootCA in DER format
		if [ -f "$CERT.der" ] ; then

		    # Providing the PEM version of the RootCA
		    # echo "Converting $CERT.der to $CERT.pem ... "
		    openssl x509 -inform DER -in "$CERT.der" -out "$CERT.pem"
		    if [ $? -gt 0 ] ; then
			    echo
			    echo "ERROR: Cannot convert $CERT.der into PEM format"
			    echo
			    exit 1
		    fi
		fi
	fi
}

check() {
	
	# Extracts the argument
	PEM=$1

	# Baseline test whether TA cert is well formed 
	openssl x509 -in $PEM -text -noout 2>/dev/null > /dev/null
	if [ $? -ne 0 ]; then
		# echo "${PEM} not suitable."
        echo "N"
		return
	fi
	# Baseline test whether TA cert is self-signed 
	openssl verify -CAfile $PEM $PEM 2>/dev/null >/dev/null
	if [ $? -ne 0 ]; then
        echo "N"
		# echo "${PEM} not self-signed."
		return
	fi
	# Checking for some parsing errors
	openssl x509 -in $PEM -text -noout | grep error 2>/dev/null > /dev/null
	if [ $? -ne 0 ]; then
		#echo "No error parsing TA certificate in $1";
		# Extracting algorithm name
		openssl x509 -in $PEM -text -noout | grep "Public Key Algorithm" 2>&1 > /dev/null
        if [ $? -ne 0 ]; then
           echo "N"
           return
        fi
	else
        echo "N"
		# echo "Error parsing ${PEM}"
        return
	fi

    echo "Y"
	cd ..
}

    if [ $# -ne 1 ]; then
       echo "No target directory to check provided. Exiting."
       exit -1
    else
        pushd $1 >/dev/null 2>/dev/null
    fi
    #echo "Checking in $(pwd)"
    if [ ! -d "artifacts" ]; then
        echo "No artifacts found. Exiting."
        exit -1
    fi
    cd artifacts
    echo "key_algorithm_oid,test_result"
    for oid_folder in 1*_ta.*; do
	   target=$(echo $oid_folder | sed -r "s/(.*)_ta.*/\1/g")
       check_cert "${target}_ta"
       result=$(check "${target}_ta.pem")
	   echo "${target},${result}"
    done
    popd 2>/dev/null >/dev/null
