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
			echo "ERROR: Cannot convert $DIR/ta/ta.der into PEM format"
			echo
			exit 1
		fi
	fi
}

# The check() function expects the following input:
# $1 ....: Directory for the specific OID
function check() {

	# Extracts the argument
	DIR=$1

	# Change directory
	if ! [ -d "$DIR" ] ; then
		echo "ERROR: missing dir $DIR"
		exit 1;
	fi

	# Change Directory
	cd "$DIR"

	# Generate PEM files if missing
	if ! [ -f ta/ta.pem ]; then

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

		echo "Converting ta/ta.der to ta/ta.pem ... "
		openssl x509 -inform DER -in ta/ta.der -out ta/ta.pem
		if [ $? -gt 0 ] ; then
			echo
			echo "ERROR: Cannot convert ta/ta.der into PEM format"
			echo
			exit 1
		fi
	fi

	if ! [ -f ca/ca.pem ]; then

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

		echo "Converting ca/ca.der to ca/ca.pem ... "
		openssl x509 -inform DER -in ca/ca.der -out ca/ca.pem
		if [ $? -gt 0 ] ; then
			echo
			echo "ERROR: Cannot convert ta/ta.der into PEM format"
			echo
			exit 1
		fi
	fi

	# Baseline test whether TA cert is well formed 
	openssl x509 -in ta/ta.pem -text -noout > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo "No suitable ta/ta.pem found. Exiting $1."
		return
	fi
	
	# Checking for some parsing errors
	openssl x509 -in ta/ta.pem -text -noout | grep error
	if [ $? -ne 0 ]; then
		echo "No error parsing TA certificate in $1";
		# Extracting algorithm name
		openssl x509 -in ta/ta.pem -text -noout | grep "Public Key Algorithm"
		# Verifying cert chain TA->CA
		openssl verify -CAfile ta/ta.pem ca/ca.pem
		if [ $? -ne 0 ]; then
			echo "Error verifying $1/ca/ca.pem"
			exit 1
		else
			echo "cert chain TA->CA verified for $1"
		fi
	else
		echo "Error parsing TA certificate in $1"
		exit 2
	fi
	echo "--------------"
	cd ..
}

# Checks for the input
# List of Sub Directories
SUBDIRS=libpki

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
			&& check_dir "${target}" && check "${target}" )
		echo "$result" && echo
	fi

done

