#! /bin/bash

#/*
# * Written for the IETF 117 "PQ in X.509, Signatures, KEMs and protocols" Hackathon by
# * George Tasopoulos (Industrial Systems Institute / ATHENA R.C.) at 22-23 July 2023.
# */

	dir_list="bc/java-artifacts botan/default carl_redhound/default \
	corey_digicert/default cryptonext/default entrust/oqs kris/default \
	openca/libpki oqs/openssl111 oqs/oqsprovider oqs-gnutls/default" 


	# Build the C program that we are using
	make


	# Checks if the comptMatrices directory exists and created it if not
	if ! [[ -d "comptMatrices" ]]; then
		mkdir comptMatrices
	fi
	
	# Change directory providers
	cd ..
	echo "We are at ${PWD}" 
	echo


	# Traverse into each one of the prociders in dir_list
	for d in ${dir_list}; do

		# Get the name of the provider without the subdirectory: bc/jana=artifacts --> bc
		provider_without_subdir=${d%/*}

		# Delete any _ characters
		provider="${provider_without_subdir//_}"

		# Delete the csv file if it already exists
		if [[ -f "isi_wolfssl/comptMatrices/${provider}_isiwolfssl.csv" ]]; then
			rm isi_wolfssl/comptMatrices/${provider}_isiwolfssl.csv
		fi

		# Create the csv file from scratch
		echo "key_algorithm_oid,ta,ca,ee,crl_ta,crl_ca" > isi_wolfssl/comptMatrices/${provider}_isiwolfssl.csv

		# Push the current dir to stack
		pushd . > /dev/null

		# Change dir
		cd ${d} || { popd > /dev/null; continue; }

		# Checks for the artifacts directory and unzips it if necessary
		if ! [ -d "artifacts" ] ; then
			echo "Unzipping artifacts for ${d}..."
			unzip -o -q artifacts.zip
		fi

		# The case that the artifact.zip is missing the proper directory artifact so we create it and unzip all in there
		if ! [ -d "artifacts" ] ; then

			# # Delete the mess
			# while read -r _ _ _ file; do
			#   arr+=("$file")
			# done < <(unzip -qql artifacts.zip)
			# rm -rf "${arr[@]}"

			#Unzip them properly
			mkdir artifacts
			unzip -o -q artifacts.zip -d artifacts
		fi

		# Change dir into artifacts
		cd artifacts || { popd > /dev/null; continue; }

		# Traverse in every OID in this dir
		for f in *; do
		    if [ -d "$f" ]; then

		    	# Set the path to the current csv file
		        csv_file="../../../isi_wolfssl/comptMatrices/${provider}_isiwolfssl.csv"

		        # Set path to executable program
		        verify_program="./../../../isi_wolfssl/verify_certs"

				# echo ${f}
		        
		        # Check if OID contains any letters and if yes breaks
		        if [[ "${f}" =~ [a-zA-Z] ]];then
      				break
      			fi

		        # Write the OID in the csv file
		        echo -n "${f}" >> ${csv_file}
		        echo -n "," >> ${csv_file}

		        # Checks if the end entity directory exists
		        if [ -d "${f}/ee" ]; then

		        	# Checks if the end entity certificate is named wrongly "ee.pem"
			        if [[ -f "${f}/ee/ee.pem" ]]; then
			        	${verify_program} ${f}/ta/ta.pem ${f}/ca/ca.pem ${f}/ee/ee.pem >> ${csv_file}

			        # Else it is named correctly "cert.pem"
			        elif [[ -f "${f}/ee/cert.pem" ]]; then
			        	${verify_program} ${f}/ta/ta.pem ${f}/ca/ca.pem ${f}/ee/cert.pem >> ${csv_file}
			        #Else there is only in der format
			        else
			        	${verify_program} ${f}/ta/ta.der ${f}/ca/ca.der ${f}/ee/cert.der >> ${csv_file}
			        fi

			    # The case that the end entity directory does not exist so we continue with just TA and CA 
		        else
		        	${verify_program} ${f}/ta/ta.pem ${f}/ca/ca.pem >> ${csv_file}
		        fi
		    fi
		done

		# Reset the directory
		popd > /dev/null

		# Print done and empty lines
		echo "Done for ${d}"
	done