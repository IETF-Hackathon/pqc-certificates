#! /usr/bin/env bash
#set -x
warn() { printf "$@" >&2; }
die() { warn "$@"; exit 1; }
if [[ $# != 1 ]]; then die 'Usage: %s <zipfile>\n' "$0"; fi
xxd -p </dev/null || die 'Missing xxd command\n'


output=$(openssl list -providers)
if ! echo "$output" | grep -q "SafeLogic"; then
    echo "SafeLogic's provider wasn't found."
    die
fi


set -o pipefail
shopt -s nullglob

tmp=$(mktemp -d)
trap 'e=$?; rm -rf ${tmp}; exit $e' EXIT HUP INT TERM
unzip -qq -j -d "$tmp" "$1" || die 'Error unzipping %s\n' "$1"

ptext="${tmp}/plaintext"
printf "Attack at dawn\n" > "$ptext"

check_keys() {
    local oid=$1
    local -a pubs
    if [[ $# -lt 2 ]]; then warn 'Usage: check_keys <oid> <form> ...\n'; return 1; fi
    shift
    #echo "Working on " ${oid}
    for form in "$@"
    do
        case $form in
        priv|ee|ta) set -- "$tmp"/*-"${oid}_${form}.der";;
        ss|ciphertext) set -- "$tmp"/*-"${oid}_${form}.bin";;
        pubs) set -- pubs;;
        *) set -- "$tmp"/*-"${oid}_${form}_priv.der";;
        esac
        if [[ $# -eq 0 ]]; then continue; fi
        if [[ $# -ne 1 ]]; then
            warn 'Too many inputs match %s for %s\n' \
                "$form" "${oid}"
            continue
        fi
        obj=$1
        pubout="$tmp/${oid}_${form}_pub.der"
        /bin/rm -f "$pubout"
        case $form in
        ss) ss_file=$obj;;
        ciphertext) ct_file=$obj;;
        pubs)
            if [[ "${#pubs[@]}" -gt 1 ]]; then
                uniq=$(for dgst in "${pubs[@]}"; do printf "%s\n" "$dgst"; done | sort -u | wc -l) &&
                [[ $uniq -eq 1 ]] &&
                printf "%s,%s,%s\n" "${oid}" "consistent" "Y" ||
                printf "%s,%s,%s\n" "${oid}" "consistent" "N"
            fi;;
        ta) openssl x509 -in "$obj" -pubkey -noout |
                openssl pkey -pubin -pubout -outform DER -out "$pubout" &&
            openssl verify -verify_depth 0 -check_ss_sig -trusted "$obj" "$obj" >/dev/null &&
            ta_file="$obj" &&
            dgst=$(openssl dgst -sha256 -binary < "$pubout" | xxd -p -c32) &&
            pubs=("${pubs[@]}" "$dgst") &&
            printf "%s,%s,%s\n" "${oid}" "cert" "Y" ||
            printf "%s,%s,%s\n" "${oid}" "cert" "N";;
        ee) openssl x509 -in "$obj" -pubkey -noout |
                openssl pkey -pubin -pubout -outform DER -out "$pubout" &&
            openssl verify -verify_depth 0 -trusted "$ta_file" "$obj" >/dev/null &&
            dgst=$(openssl dgst -sha256 -binary < "$pubout" | xxd -p -c32) &&
            pubs=("${pubs[@]}" "$dgst") &&
            printf "%s,%s,%s\n" "${oid}" "cert" "Y" ||
            printf "%s,%s,%s\n" "${oid}" "cert" "N";;
        *)  openssl pkey -inform DER -in "$obj" -pubout -outform DER -out "$pubout" &&
            if [[ -n "$sigfile" ]]; then
                openssl pkeyutl -sign -rawin -keyform DER -inkey "$obj" -in "$ptext" -out "$sigfile" &&
                openssl pkeyutl -verify -rawin -in "$ptext" -keyform DER -pubin -inkey "$pubout" \
                    -sigfile "$sigfile" >/dev/null
            elif [[ -n "$ct_file" && -n "$ss_file" ]]; then
                cmp -s "$ss_file" <(
                    openssl pkeyutl -decap -inkey "$obj" -in "$ct_file" -secret /dev/stdout)
            fi &&
            dgst=$(openssl dgst -sha256 -binary < "$pubout" | xxd -p -c32) &&
            pubs=("${pubs[@]}" "$dgst") &&
            printf "%s,%s,%s\n" "${oid}" "$form" "Y" ||
            printf "%s,%s,%s\n" "${oid}" "$form" "N"
            ;;
        esac
    done
}

mldsa_oids=(2.16.840.1.101.3.4.3.{17,18,19})
while [[ ${#mldsa_oids[@]} -gt 0 ]]
do
    ta_file=
    ss_file=
    ct_file=


    check_keys "${mldsa_oids[0]}" seed expandedkey both ta pubs

    unset "mldsa_oids[0]"; mldsa_oids=("${mldsa_oids[@]}")
done
