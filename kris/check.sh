#!/bin/bash

check() {
	export $1=$2
	cd $2
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

check DILITHIUM_2 1.3.6.1.4.1.2.267.7.4.4
#check DILITHIUM_3 1.3.6.1.4.1.2.267.7.6.5
#check DILITHIUM_5 1.3.6.1.4.1.2.267.7.8.7
#check FALCON_512 1.3.9999.3.1
#check FALCON_1024 1.3.9999.3.4
