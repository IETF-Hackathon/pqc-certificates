#!/bin/bash
#
# Written by Stephan Mueller <smueller@chronox.de>
#
# Generate self-signed certificates with leancrypto
#
# Invoke the script with the following steps:
#
# 1. compile leancrypto with X.509 generator enabled
# 2. update variable LC_X509_GENERATOR below to point to the lc_x509_generator
#    tool
# 3. execute this script - the resulting CA certificates are stored in
#    $TARGETDIR (NOTE: The private keys are deleted in the gen_cert function.)
#

LC_X509_GENERATOR="/home/sm/hacking/sources/leancrypto/leancrypto/build/apps/src/lc_x509_generator"
#LC_X509_GENERATOR="lc_x509_generator"

TARGETDIR="artifacts_certs_r5"

CERTTYPES_ML_DSA="
	ML-DSA87:2.16.840.1.101.3.4.3.19
	ML-DSA65:2.16.840.1.101.3.4.3.18
	ML-DSA44:2.16.840.1.101.3.4.3.17"

CERTTYPES_SLH_DSA="
	SLH-DSA-SHAKE-256S:2.16.840.1.101.3.4.3.30
	SLH-DSA-SHAKE-256F:2.16.840.1.101.3.4.3.31
	SLH-DSA-SHAKE-192S:2.16.840.1.101.3.4.3.28
	SLH-DSA-SHAKE-192F:2.16.840.1.101.3.4.3.29
	SLH-DSA-SHAKE-128S:2.16.840.1.101.3.4.3.26
	SLH-DSA-SHAKE-128F:2.16.840.1.101.3.4.3.27"

CERTTYPES_COMPOSITE_ML_DSA="
	ML-DSA44-ED25519:SHA512-1.3.6.1.5.5.7.6.39
	ML-DSA65-ED25519:SHA512-1.3.6.1.5.5.7.6.48
	ML-DSA87-ED448:SHAKE256-1.3.6.1.5.5.7.6.51"

CERTTYPES="$CERTTYPES_SLH_DSA $CERTTYPES_COMPOSITE_ML_DSA"

################################################################################
# No further configurations below this line
################################################################################

# Generate CA certificate
gen_cert()
{
	local input=$1
	local priv_ext=$2
	local priv_gentype=$3

	if [ -z "$input" ]
	then
		echo "Rejecting empty input"
		exit 1
	fi

	local certtype=$(echo $input | cut -d":" -f1)
	local fileext=$(echo $input | cut -d":" -f2)

	echo "Generating CA certificate for key type $certtype"

	CA_FILENAME="${certtype}-${fileext}_ta.der"
	PRIV_FILENAME="${certtype}-${fileext}_${priv_ext}.der"
	${LC_X509_GENERATOR}						\
	  --keyusage digitalSignature					\
	  --keyusage keyEncipherment					\
	  --keyusage keyCertSign					\
	  --keyusage critical						\
	  --ca 								\
	  --valid-days 3650						\
	  --subject-cn "$certtype leancrypto CA"			\
	  -o ${TARGETDIR}/${CA_FILENAME}				\
	  --sk-file ${TARGETDIR}/${PRIV_FILENAME}			\
	  ${priv_gentype} ${certtype}

	if [ $? -eq 0 ]
	then
		echo "CA certificate generation successful"
	else
		echo "CA certificate generation failed"
		exit 1
	fi
}

rm -rf $TARGETDIR
mkdir -p $TARGETDIR

for i in $CERTTYPES
do
	gen_cert $i "priv" "--create-keypair-pkcs8"
done

gen_cert "ML-DSA87:2.16.840.1.101.3.4.3.19" "seed_priv" "--create-keypair-pkcs8-seed"
gen_cert "ML-DSA65:2.16.840.1.101.3.4.3.18" "expandedkey_priv" "--create-keypair-pkcs8"
gen_cert "ML-DSA44:2.16.840.1.101.3.4.3.17" "expandedkey_priv" "--create-keypair-pkcs8"
