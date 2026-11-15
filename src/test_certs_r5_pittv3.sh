#!/bin/bash

# Tests each provider's r5 trust anchor certificates with pittv3 (https://github.com/carl-wallace/rust-pki),
# which checks that each is self-signed: that its signature verifies under its own public key.
#
# Usage: ./src/test_certs_r5_pittv3.sh, from the root of the repository. The pittv3 binary is $PITTV3
# when set, otherwise the pittv3 on the PATH.
#
# Writes output/certs/<provider>_pittv3.csv for each provider and output/certs/pittv3_certs.log.
# A certificate whose signature algorithm pittv3 does not implement is left out of the CSV, as a
# skip, rather than recorded as a failure.

pittv3=${PITTV3:-pittv3}
certszip="artifacts_certs_r5.zip"
inputdir="./providers"
outputdir="./output/certs"
logfile=$outputdir/pittv3_certs.log

if ! command -v "$pittv3" > /dev/null; then
    echo "ERROR: pittv3 not found; set PITTV3 or put pittv3 on the PATH"
    exit 1
fi

mkdir -p $outputdir
printf "Build time: %s\n%s\n\n" "$(date)" "$("$pittv3" --version)" > $logfile

# Each provider's zip is unpacked here rather than into the provider's folder.
workdir=$(mktemp -d "${TMPDIR:-/tmp}/pittv3_certs_r5.XXXXXX") || exit 1
trap 'rm -rf "$workdir"' EXIT

for providerdir in $(ls -d $inputdir/*/); do
    provider=$(basename $providerdir)
    zip=${providerdir}$certszip
    if [ ! -f "$zip" ]; then
        continue
    fi

    resultsfile=${outputdir}/${provider}_pittv3.csv
    echo "key_algorithm_oid,type,test_result" > $resultsfile

    unzipdir=$workdir/$provider
    unzip -q -o "$zip" -d "$unzipdir"

    alreadyTestedOIDs=";"
    for tafile in $(find "$unzipdir" -iname "*_ta.der" | sort); do
        # strip off the friendly name and the suffix to get the OID
        tafileBasename=$(basename "$tafile" | grep -oE '[^-]*_ta\.der$')
        oid=${tafileBasename%_ta.der}
        # A name that does not end in a dotted OID, such as Bouncy Castle's catalyst_<oid>_with_<oid>,
        # names a combination the matrix has no row for.
        if ! echo "$oid" | grep -qE '^[0-9]+(\.[0-9]+)+$'; then
            echo "$provider $(basename "$tafile"): SKIP (no OID in the file name)" | tee -a $logfile
            continue
        fi

        # some artifacts submit multiple copies of the same cert. Just test the first one
        case "$alreadyTestedOIDs" in
            *";$oid;"*)
                printf "Warning: %s has been submitted multiple times by %s. Skipping\n" $oid $provider | tee -a $logfile
                continue
                ;;
        esac
        alreadyTestedOIDs="${alreadyTestedOIDs}${oid};"

        # pittv3 exits 0 whether or not the certificate is self-signed, so the result is read
        # from what it prints.
        output=$("$pittv3" --validate-self-signed --end-entity-file "$tafile" 2>&1)
        printf "\nTesting %s/%s\n%s\n" $provider "$(basename "$tafile")" "$output" >> $logfile
        if echo "$output" | grep -q "unsupported signature algorithm"; then
            echo "$provider $oid: SKIP" | tee -a $logfile
        elif echo "$output" | grep -q " is self-signed"; then
            echo "$oid,cert,Y" >> $resultsfile
            echo "$provider $oid: SUCCESS" | tee -a $logfile
        else
            echo "$oid,cert,N" >> $resultsfile
            echo "$provider $oid: FAIL" | tee -a $logfile
        fi
    done
done
