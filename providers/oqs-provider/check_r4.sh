#!/bin/bash

set -ux

_check_ta_cert() {
	local FILE="$1"

	# Baseline test whether TA cert is well formed
	openssl x509 -in "$FILE" -inform DER -text -noout >&2
	if [ $? -ne 0 ]; then
		echo "N"
		echo "${FILE} not suitable." >&2
		return
	fi

	# Print raw ASN structure
	OPENSSL_CONF=/dev/null openssl asn1parse -inform DER -in "$FILE" -dump >&2

	# Baseline test whether TA cert is self-signed
	openssl verify -CAfile "$FILE" "$FILE" >&2
	if [ $? -ne 0 ]; then
		echo "N"
		echo "${FILE} not self-signed." >&2
		return
	fi

	# Checking for some parsing errors
	openssl x509 -in "$FILE" -inform DER -text -noout | grep error >&2
	if [ $? -ne 0 ]; then
		echo "No error parsing TA certificate in $FILE" >&2
		# Extracting algorithm name
		openssl x509 -in "$FILE" -inform DER -text -noout | grep "Public Key Algorithm" >&2
		if [ $? -ne 0 ]; then
			echo "N"
			echo "  No error extracting algorithm name from $FILE" >&2
			return
		fi
	else
		echo "N"
		echo "Error parsing ${FILE}" >&2
		return
	fi

	echo "Y"
}

_check_ee_cert() {
	local FILE="$1"
	local TAFILE="$2"

	# TODO: this needs to be implemented yet!
	echo "Verifying $FILE against $TAFILE... SKIPPED" >&2
	echo "SKIPPED"
}

check_ta_cert() {
	local FILE="$1"

	local FRNAME="$(echo "$FILE" | sed -r "s/^(.*)-(.*)_ta\.der$/\1/")"
	local OID="$(echo "$FILE" | sed -r "s/^(.*)-(.*)_ta\.der$/\2/")"

	local result=$(_check_ta_cert "${FILE}")
	echo "${OID},${result}"
}

declare -A _EE_to_TA_map
EE_to_TA_map() {
	local EEOID="$1"
	local TAOID="${_EE_to_TA_map[$OID]:-Unknown}"

	local TAFILE=""

	if [[ "$TAOID" == "Unknown" ]]; then
		TAFILE="${TAOID}_ta.der"
	else
		TAFILE="$(ls "*-${TAOID}_ta.der" 2>/dev/null)"
	fi

	echo "$TAFILE"
}

check_ee_cert() {
	local FILE="$1"

	local FRNAME="$(echo "$FILE" | sed -r "s/^(.*)-(.*)_ee\.der$/\1/")"
	local OID="$(echo "$FILE" | sed -r "s/^(.*)-(.*)_ee\.der$/\2/")"

	local TAFILE="$(EE_to_TA_map "$OID")"
	if [[ ! -f "$TAFILE" ]]; then
		echo "Cannot find $TAFILE to verify $FILE" >&2
		echo "${OID},SKIPPED"
		return
	fi

	local result=$(_check_ee_cert "${FILE}" "${TAFILE}")
	echo "${OID},${result}"
}

check_hybta_cert() {
	local FILE="$1"

	local COMPNAME="$(echo "$FILE" | sed -r "s/^(.*)-(.*)_with_(.*)_ta.der$/\1/")"
	local OID1="$(echo "$FILE" | sed -r "s/^(.*)-(.*)_with_(.*)_ta.der$/")"
	local OID2="$(echo "$FILE" | sed -r "s/^(.*)-(.*)_with_(.*)_ta.der$/")"

	local result=$(_check_ta_cert "${FILE}")
	echo "${COMPNAME}-${OID1}_with_${OID2},${result}"
}

check_r4_dir() {
	local DIR="$1"

	echo "Checking in ${DIR}/artifacts" >&2
	pushd "$DIR" >/dev/null 2>/dev/null

	if [ ! -d "artifacts" ]; then
		echo "No artifacts found. Exiting."
		exit -1
	fi
	cd artifacts

	local TAs=()    # self-signed cert for signature alg oids
	local EEs=()    # ex.: ML-KEM-512 - signed with ML-DSA-44
	local hybTAs=() # ex.: catalyst_1.2.840.10045.4.3.2_with_1.3.6.1.4.1.2.267.12.4.4_ta.der
	for i in *_ta.der; do
		if [[ -f "$i" ]]; then
			if [[ "$i" =~ _with_ ]]; then
				hybTAs+=("$i")
			else
				TAs+=("$i")
			fi
		fi
	done
	for i in *_ee.der; do
		if [[ -f "$i" ]]; then
			EEs+=("$i")
		fi
	done

	echo "key_algorithm_oid,test_result"
	for cert in "${TAs[@]}"; do
		check_ta_cert "$cert"
	done
	for cert in "${EEs[@]}"; do
		check_ee_cert "$cert"
	done
	for cert in "${hybTAs[@]}"; do
		check_hybta_cert "$cert"
	done

	popd 2>/dev/null >/dev/null
}

if [ $# -ne 1 ]; then
	echo "No target directory to check provided. Exiting."
	exit -1
else
	check_r4_dir "$1"
fi
