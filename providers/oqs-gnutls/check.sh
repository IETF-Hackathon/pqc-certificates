#!/bin/bash

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

	CERTTOOL="docker run --rm -v $(pwd):/artifacts -w /artifacts ghcr.io/ueno/oqs-gnutls:main /install/bin/certtool"

	cat ee/ee.pem ca/ca.pem > chain.pem
	$CERTTOOL --verify --load-ca-certificate ta/ta.pem --infile chain.pem
	# Returns
	cd -
}

# List of Sub Directories
SUBDIRS=default

# Checks for the input
if ! [ "x$1" = "x" ] ; then
	SUBDIRS=$1
fi

# Checks each directory 
for oid_folder in ${SUBDIRS}/artifacts/*; do

	# Extracts the target
	target=${oid_folder##$SUBDIRS/artifacts/};
	dir=${oid_folder%%$target}

	# Executing the Check Script
	if [ -d "${dir}" ] ; then
		result=$(cd "${dir}" && echo "${oid_folder}:" \
			&& check "${target}" )
		echo "$result" && echo
	fi

done
