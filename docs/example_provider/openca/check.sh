#!/bin/bash

# Default directory
PRODUCT_DIR=new_product

function check_dir() {

	# We want to check that the needed structures
	# are all in place

	# Checks if we have the PEM version of the RootCA
	if ! [ -f ta/ta.pem ]; then

		# Special handling for the Entrust artifacts
		if [ `echo $1 | grep 'entrust'` ] ; then
			mv ta/ta.der ta/ta.pem
			openssl x509 -in ta/ta.pem -out ta/ta.der -outform DER
		fi

		# Checks for the RootCA in DER format
		if ! [ -f ta/ta.der ] ; then
			echo
			echo "ERROR: missing ta/ta.der file ... "
			echo
			exit 1;
		fi

		# Providing the PEM version of the RootCA
		echo "Converting ta/ta.der to ta/ta.pem ... "
		openssl x509 -inform DER -in ta/ta.der -out ta/ta.pem
		if [ $? -gt 0 ] ; then
			echo
			echo "ERROR: Cannot convert ta/ta.der into PEM format"
			echo
			exit 1
		fi
	fi

	# Checks if we have the PEM version of the
	# Intermediate CA
	if ! [ -f ca/ca.pem ]; then

		# Special trick for Entrust's artifacts
		if [ `echo $1 | grep 'entrust'` ] ; then
			mv ca/ca.der ca/ca.pem
			openssl x509 -in ca/ca.pem -out ca/ca.der -outform DER
		fi

		# Checks for the RootCA in DER format
		if ! [ -f ca/ca.der ] ; then
			echo
			echo "ERROR: missing ca/ca.der file ... "
			echo
			exit 1;
		fi

		# Converts the DER into PEM
		openssl x509 -inform DER -in ca/ca.der -out ca/ca.pem
		if [ $? -gt 0 ] ; then
			echo
			echo "ERROR: Cannot convert ta/ta.der into PEM format"
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

}

# Checks for the input
if ! [ "x$1" = "x" ] ; then
	PRODUCT_DIR=$1
fi

# Checks each directory 
for oid_dir in ${PRODUCT_DIR}/*; do
	if [ -d "${oid_dir}" ] ; then
		echo -n "Checking ${oid_dir} ... "
		result=$( cd "${oid_dir}" && check_dir && check )
		echo "Done"
	fi
done
