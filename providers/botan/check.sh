#!/bin/bash

function check_dir() {

	# We want to check that the needed structures
	# are all in place
	DIR=$1

	# Checks if we have the PEM version of the RootCA
	if ! [ -f "$DIR/ta/ta.pem" ]; then

		# Special handling for the Entrust artifacts
		if [ `echo $1 | grep 'entrust'` ] ; then
			mv "$DIR/ta/ta.der" "$DIR/ta/ta.pem"
			openssl x509 -in "$DIR/ta/ta.pem" -out "$DIR/ta/ta.der" -outform DER
		fi

		# Checks for the RootCA in DER format
		if ! [ -f "$DIR/ta/ta.der" ] ; then
			echo
			echo "ERROR: missing $DIR/ta/ta.der file ... "
			echo
			exit 1;
		fi

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

	# Checks if we have the PEM version of the
	# Intermediate CA
	if ! [ -f "$DIR/ca/ca.pem" ]; then

		# Special trick for Entrust's artifacts
		if [ `echo $1 | grep 'entrust'` ] ; then
			mv "$DIR/ca/ca.der" "$DIR/ca/ca.pem"
			openssl x509 -in "$DIR/ca/ca.pem" -out "$DIR/ca/ca.der" -outform DER
		fi

		# Checks for the RootCA in DER format
		if ! [ -f "$DIR/ca/ca.der" ] ; then
			echo
			echo "ERROR: missing $DIR/ca/ca.der file ... "
			echo
			exit 1;
		fi

		# Converts the DER into PEM
		openssl x509 -inform DER -in "$DIR/ca/ca.der" -out "$DIR/ca/ca.pem"
		if [ $? -gt 0 ] ; then
			echo
			echo "ERROR: Cannot convert $DIR/ca/ca.der into PEM format"
			echo
			exit 1
		fi
	fi
}

# The check() function expects the following input:
# $1 ....: Directory for the specific OID
function check() {

	# Here you can use the data from
	# the ZIP structure
	#
	# <ALG_OID>
	#     |
	#     +--> ./ta (RootCA)
	#           |
	#           +--> ./ta.der (Cert)
	#           |
	#           +--> ./ta_priv.der (KeyPair)
	#     +--> ./ca (IntermediateCA)
	#           |
	#           +--> ./ca.der (Cert)
	#           |
	#           +--> ./ca_priv.der (KeyPair)
	#     +--> ./ee (End Entity)
	#           |
	#           +--> ./ca.der (Cert)
	#           |
	#           +--> ./ca_priv.der (KeyPair)
	#     +--> ./crl (Rev. Lists)
	#           |
	#           +--> ./ca.der (Cert)
	#           |
	#           +--> ./ca_priv.der (KeyPair)
	#     +--> ./ocsp (Online Status)
	#           |
	#           +--> ./ocsp_ca.der (ICA's OCSP)
	#           |
	#           +--> ./ocsp_cert.der (EE's OCSP)

	# Extracts the argument
	DIR=$1

	# Change directory
	if ! [ -d "$DIR" ] ; then
		echo "ERROR: missing dir $DIR"
		exit 1;
	fi

	# Change Directory
	cd "$DIR"

	# Perform some actions
	
	# uncomment next line for debugging (logging)
	#exec 2>&1
	
	# check certificate chain
	if [ -f "ta/ta.der" ] ; then
		cert_format="der"
	elif [ -f "ta/ta.pem" ] ; then
		cert_format="pem"
	else
		echo "Missing TA or unknown format."
		cd ..
		return
	fi
	
	if [ -f "ee/ee."$cert_format ] ; then
		cert_ee="ee"
	elif [ -f "ee/cert."$cert_format ] ; then
		cert_ee="cert"
	else
		echo "Missing EE or unknown format."
		cd ..
		return
	fi
	
	result=$(botan cert_verify ee/$cert_ee.$cert_format ca/ca.$cert_format ta/ta.$cert_format)
	
	# Returns
	cd ..
	
	echo $result
}

# List of Sub Directories
SUBDIRS="default/artifacts"

# Checks for the input
if ! [ "x$1" = "x" ] ; then
	SUBDIRS=$1
fi

# Checks each directory 
for oid_folder in ${SUBDIRS}/*; do

	# Extracts the target
	target=${oid_folder##$SUBDIRS/};
	dir=${oid_folder%%$target}

	# Executing the Check Script
	if [ -d "${dir}" ] ; then
		result=$(cd "${dir}" && echo "${oid_folder}:" \
			&& check_dir "${target}" && check "${target}" )
		echo "$result" && echo
	fi

done
