#!/bin/bash

check() {
	cd $1
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

for file in *; do
	if [ -d "$file" ]; then 
		check $file
	fi
done
