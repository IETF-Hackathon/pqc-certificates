#! /usr/bin/env bash

die() { printf "$@" >&2; exit 1; }
if [[ $# != 1 ]]; then die 'Usage: %s <zipfile>\n' "$0"; fi

tmp=$(mktemp -t -d)
trap 'e=$?; rm -rf ${tmp}; exit $e' EXIT HUP INT TERM
unzip -qq -j -d "$tmp" "$1" || die 'Error unzipping %s\n' "$1"

if [[ ! -f "$tmp/ta.der" ]]; then
    die 'Missing Trust anchor file\n'
fi
/bin/rm -f "$tmp/ta.pem"
openssl x509 -in "$tmp/ta.der" -inform DER -out "$tmp/ta.pem" ||
    die 'Error decoding TA certificate\n'

check_cms() {
    local oid=$1
    if [[ $# -ne 1 ]]; then die 'Usage: check_cms <oid>\n'; fi
    (
        set -e
        set -o pipefail
        shopt -s nullglob
        pubs=()

        count=0
        for obj in "$tmp"/*-"${oid}_signed_attrs.der"
        do
            if [[ $count > 0 ]]; then
                die 'Too many inputs match %s\n' "${oid}"
            fi
            openssl cms -verify -CAfile "$tmp/ta.pem" -in "$obj" -inform DER >/dev/null 2>&1 || exit 1
            count=$((count + 1))
        done
        if [[ $count -eq 0 ]]; then exit 2; fi
    )
    case $? in
    0) printf "%s,%s\n" "${oid}" "Y";;
    1) printf "%s,%s\n" "${oid}" "N";;
    *) : ignored;;
    esac
}

mldsa_oids=(2.16.840.1.101.3.4.3.{17,18,19})
slh2s_oids=(2.16.840.1.101.3.4.3.{20,22,24})
slh2f_oids=(2.16.840.1.101.3.4.3.{21,23,25})
slh3s_oids=(2.16.840.1.101.3.4.3.{26,28,30})
slh3f_oids=(2.16.840.1.101.3.4.3.{27,29,31})
while [[ ${#mldsa_oids[@]} -gt 0 ]]
do
    check_cms "${mldsa_oids[0]}"
    check_cms "${slh2f_oids[0]}"
    check_cms "${slh2s_oids[0]}"
    check_cms "${slh3f_oids[0]}"
    check_cms "${slh3s_oids[0]}"

    unset "mldsa_oids[0]"; mldsa_oids=("${mldsa_oids[@]}")
    unset "slh2f_oids[0]"; slh2f_oids=("${slh2f_oids[@]}")
    unset "slh2s_oids[0]"; slh2s_oids=("${slh2s_oids[@]}")
    unset "slh3f_oids[0]"; slh3f_oids=("${slh3f_oids[@]}")
    unset "slh3s_oids[0]"; slh3s_oids=("${slh3s_oids[@]}")
done
