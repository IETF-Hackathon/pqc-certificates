#!/bin/bash

function check_dir() {

	# We want to check that the needed structures
	# are all in place
	DIR=$1

	# Checks if we have the PEM version of the RootCA
	if ! [ -f "$DIR/ta/ta.pem" ]; then

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

	# Change Directory
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
			exit -1
		else
			echo "cert chain TA->CA verified for $1"
		fi
	else
		echo "Error parsing TA certificate in $1"
	fi
	echo "--------------"

	cd ..
}

# Checks for the input
# List of Sub Directories
SUBDIRS="oqsprovider"

# Checks for the input
if ! [ "x$1" = "x" ] ; then
	EXT_PREFIX=$1
else
	# if parameter not present, self-test
	EXT_PREFIX="."
fi

# Checks each directory 
for sd in ${SUBDIRS}; do
    if [ $sd == "oqsprovider" ]; then
           # check openssl actually supports providers
           openssl list --providers 2>&1 | grep oqsprovider > /dev/null
           if [ $? -ne 0 ]; then
                   echo "oqsprovider not available"
                   continue
           fi
    fi

    echo "Checking in ${sd}"
    cd $sd/artifacts
    for oid_folder in *; do

	target=${oid_folder}
	if [ $EXT_PREFIX == "." ]; then
	    dir=$EXT_PREFIX
        else
	    dir=../../$EXT_PREFIX
	fi

	# Executing the Check Script
	if [ -d "${dir}" ] ; then
		cd "${dir}" && echo "${oid_folder}:" \
			&& check_dir "${target}" && check "${target}"
		if [ $? -ne 0 ]; then
			echo "Failure testing $EXT_PREFIX. Exiting."
			exit -1
		else
			echo "Successfully tested $dir/$target"
		fi
	else
		echo "Directory $dir not found. Exiting test."
		exit -1
	fi

    done
done
echo "All tests passed successfully"
