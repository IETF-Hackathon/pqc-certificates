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

check() {

	# Extracts the argument
	DIR=$1

	# Change directory
	if ! [ -d "$DIR" ] ; then
		echo "ERROR: missing dir $DIR"
		exit 1;
	fi

	cd "$DIR"
	
	# Generate PEM files if missing
	if [ ! -f ta/ta.pem ]; then
		openssl x509 -in ta/ta.der -out ta/ta.pem
	fi
	if [ ! -f ca/ca.pem ]; then
		openssl x509 -in ca/ca.der -out ca/ca.pem
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
		else
			echo "cert chain TA->CA verified for $1"
		fi
	else
		echo "Error parsing TA certificate in $1"
	fi
	echo "--------------"
	
	cd ..
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
			&& check_dir "${target}" && check "${target}" )
		echo "$result" && echo
	fi

done