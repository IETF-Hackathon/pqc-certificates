#!/bin/bash

#set -x

function check_dir() {

	# We want to check that the needed structures
	# are all in place
	DIR=$1

	# Checks if we have the PEM version of the RootCA
	if ! [ -f "$DIR/ta/ta.pem" ]; then

		# Checks for the RootCA in DER format
		if [ -f "$DIR/ta/ta.der" ] ; then

		    # Providing the PEM version of the RootCA
		    echo "Converting $DIR/ta/ta.der to $DIR/ta/ta.pem ... "
		    openssl x509 -inform DER -in "$DIR/ta/ta.der" -out "$DIR/ta/ta.pem"
		    if [ $? -gt 0 ] ; then
			    echo
			    echo "ERROR: Cannot convert $DIR/ta/ta.der into PEM format"
			    echo
			    exit 1
		    fi
		fi
	fi

	# Checks if we have the PEM version of the
	# Intermediate CA
	if ! [ -f "$DIR/ca/ca.pem" ]; then

		# Checks for the RootCA in DER format
		if [ -f "$DIR/ca/ca.der" ] ; then
		    # Converts the DER into PEM
		    openssl x509 -inform DER -in "$DIR/ca/ca.der" -out "$DIR/ca/ca.pem"
		    if [ $? -gt 0 ] ; then
			    echo
			    echo "ERROR: Cannot convert $DIR/ca/ca.der into PEM format"
			    echo
			    exit 1
		    fi
		fi
	fi

	# Checks if we have the PEM version of the
	# EE cert
	if ! [ -f "$DIR/ee/cert.pem" ]; then
		# Checks for the EE cert in DER format
		if [ -f "$DIR/ee/cert.der" ] ; then
		   # Converts the DER into PEM
		   openssl x509 -inform DER -in "$DIR/ee/cert.der" -out "$DIR/ee/cert.pem"
		   if [ $? -gt 0 ] ; then
	   		   echo
			   echo "ERROR: Cannot convert $DIR/ee/cert.der into PEM format"
			   echo
			   exit 1
		   fi
        fi
    fi

}

check() {
	
	# Extracts the argument
	DIR=$1
    result=""

	# Change directory
	if ! [ -d "$DIR" ] ; then
		#echo "ERROR: missing dir $DIR"
        echo "N,N,N,N,N,N"
        return
	fi

	# Change Directory
	cd "$DIR"

	# Baseline test whether TA cert is well formed 
	openssl x509 -in ta/ta.pem -text -noout 2>/dev/null > /dev/null
	if [ $? -ne 0 ]; then
		#echo "No suitable ta/ta.pem found."
        echo "N,N,N,N,N,N"
		return
	fi
	# Baseline test whether TA cert is self-signed 
	openssl verify -CAfile ta/ta.pem ta/ta.pem 2>/dev/null >/dev/null
	if [ $? -ne 0 ]; then
		#echo "ta/ta.pem not self-signed."
        echo "N,N,N,N,N,N"
		return
	fi
	# Checking for some parsing errors
	openssl x509 -in ta/ta.pem -text -noout | grep error 2>/dev/null > /dev/null
	if [ $? -ne 0 ]; then
		#echo "No error parsing TA certificate in $1";
		# Extracting algorithm name
		openssl x509 -in ta/ta.pem -text -noout | grep "Public Key Algorithm" 2>&1 > /dev/null
        if [ $? -ne 0 ]; then
           echo "N,N,N,N,N,N"
           return
        fi
		# Verifying cert chain TA->CA
		openssl verify -CAfile ta/ta.pem ca/ca.pem 2>/dev/null >/dev/null
		if [ $? -ne 0 ]; then
			#echo "Error verifying $1/ca/ca.pem"
            echo "Y,N,N,N,N,N"
            return
		#else
		#	echo "cert chain TA->CA verified for $1"
		fi
	else
		#echo "Error parsing TA certificate in $1"
        echo "N,N,N,N,N,N"
        return
	fi

    # From this point on we know TA & CA are OK, so we collect specific test results
    ee_csr="N"
    ta_crl="N"
    ca_crl="N"

    # Now check EE
    # First create cert chain
    cat ca/ca.pem ta/ta.pem > ca-chain.pem
    # then verify
    openssl verify -CAfile ca-chain.pem ee/cert.pem 2>/dev/null > /dev/null
	if [ $? -ne 0 ]; then
			#echo "Error verifying $1/ee/cert.pem"
            ee_crt="N"
    else
        ee_crt="Y"
    fi

    if [ -f ee/cert.csr ]; then
        # EE CSR check
        openssl req -verify -in ee/cert.csr 2>/dev/null > /dev/null
	    if [ $? -eq 0 ]; then
            ee_csr="Y"
        fi
    fi

    if [ -f crl/crl_ta.crl ]; then
        # TA CRL check
        openssl crl -verify -in crl/crl_ta.crl -CAfile ta/ta.pem 2>/dev/null >/dev/null
	    if [ $? -eq 0 ]; then
            ta_crl="Y"
        fi
    fi

    if [ -f crl/crl_ca.crl ]; then
        # CA CRL check
        openssl crl -verify -in crl/crl_ca.crl -CAfile ca-chain.pem 2>/dev/null >/dev/null
	    if [ $? -eq 0 ]; then
            ca_crl="Y"
        fi
    fi

    # TODO: How to check OCSP artifact(s)??

    echo "Y,Y,${ee_crt},${ee_csr},${ta_crl},${ca_crl}"
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
    echo "key_algorithm_oid,ta,ca,ee,csr,crl_ta,crl_ca"
    for oid_folder in *; do

	   target=${oid_folder}

   	   # Executing the Check Script
	   check_dir "${target}"
       if [ $? -ne 0 ]; then
          echo "${target},N,N,N,N,N,N"
       else
       result=$(check "${target}")
          echo "${target},${result}"
	   fi

    done
    popd 2>/dev/null >/dev/null
