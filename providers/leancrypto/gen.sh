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

LC_X509_GENERATOR="lc_x509_generator"

TARGETDIR="artifacts_certs_r4"

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
	ML-DSA65-ED25519:SHA512-2.16.840.1.114027.80.8.1.30
	ML-DSA44-ED25519:SHA512-2.16.840.1.114027.80.8.1.23"

CERTTYPES="$CERTTYPES_ML_DSA $CERTTYPES_SLH_DSA $CERTTYPES_COMPOSITE_ML_DSA"

################################################################################
# No further configurations below this line
################################################################################

# Generate CA certificate
gen_cert()
{
	local input=$1

	if [ -z "$input" ]
	then
		echo "Rejecting empty input"
		exit 1
	fi

	local certtype=$(echo $input | cut -d":" -f1)
	local fileext=$(echo $input | cut -d":" -f2)

	echo "Generating CA certificate for key type $certtype"

	CA_FILENAME="${certtype}-${fileext}_ta.der"
	${LC_X509_GENERATOR}						\
	  --keyusage digitalSignature					\
	  --keyusage keyEncipherment					\
	  --keyusage keyCertSign					\
	  --keyusage critical						\
	  --ca 								\
	  --valid-from 1729527728					\
	  --valid-to 2044210606						\
	  --subject-cn "leancrypto test CA"				\
	  --subject-ou "leancrypto test OU"				\
	  --issuer-cn "leancrypto test CA"				\
	  --issuer-ou "leancrypto test OU"				\
	  --serial 0102030405060708					\
	  -o ${TARGETDIR}/${CA_FILENAME}				\
	  --sk-file ${TARGETDIR}/${CA_FILENAME}.privkey			\
	  --create-keypair ${certtype}

	if [ $? -eq 0 ]
	then
		echo "CA certificate generation successful"
	else
		echo "CA certificate generation failed"
		exit 1
	fi

	rm -f ${TARGETDIR}/${CA_FILENAME}.privkey
}

rm -rf $TARGETDIR
mkdir -p $TARGETDIR

for i in $CERTTYPES
do
	gen_cert $i
done
