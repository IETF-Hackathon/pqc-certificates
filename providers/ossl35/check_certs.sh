#! /usr/bin/env bash

die() { printf "$@" >&2; exit 1; }
if [[ $# != 1 ]]; then die 'Usage: %s <zipfile>\n' "$0"; fi

tmp=$(mktemp -t -d)
trap 'e=$?; rm -rf ${tmp}; exit $e' EXIT HUP INT TERM
unzip -qq -j -d "$tmp" "$1" || die 'Error unzipping %s\n' "$1"

ptext="${tmp}/plaintext"
printf "Attack at dawn\n" > "$ptext"
sigfile="${tmp}/sig.dat"

mldsa_oids=(2.16.840.1.101.3.4.3.{17,18,19})
mlkem_oids=(2.16.840.1.101.3.4.4.{1,2,3})
slh2s_oids=(2.16.840.1.101.3.4.3.{20,22,24})
slh2f_oids=(2.16.840.1.101.3.4.3.{21,23,25})
slh3s_oids=(2.16.840.1.101.3.4.3.{26,28,30})
slh3f_oids=(2.16.840.1.101.3.4.3.{27,29,31})
while [[ ${#mldsa_oids[@]} -gt 0 ]]
do
    #
    # ML-DSA
    #
    (
        set -e
        set -o pipefail
        shopt -s nullglob
        pubs=()
        set -- "$tmp"/*-"${mldsa_oids[0]}"_*.der
        if [[ $# -eq 0 ]]; then exit 2; fi
        for form in seed expandedkey both ta
        do
            pubout="$tmp/${mldsa_oids[0]}_${form}_pub.der"
            /bin/rm -f "$pubout"
            count=0
            for obj in "$tmp"/*-"${mldsa_oids[0]}_${form}"*.der
            do
                if [[ $count > 0 ]]; then
                    die 'Too many inputs match %s for %s\n' 
                        "$form" "${mldsa_oids[0]}"
                fi
                case $form in
                ta) openssl x509 -in "$obj" -pubkey -noout |
                        openssl pkey -pubin -pubout -outform DER -out "$pubout"
                    openssl verify -verify_depth 0 -trusted "$obj" "$obj" >/dev/null
                    ;;
                *)  openssl pkey -in "$obj" -pubout -outform DER -out "$pubout"
                    openssl pkeyutl -sign -rawin -inkey "$obj" -in "$ptext" -out "$sigfile"
                    openssl pkeyutl -verify -rawin -in "$ptext" -pubin -inkey "$pubout" \
                        -sigfile "$sigfile" >/dev/null ||
                        die 'Signature verification failed for %s %s\n' \
                            "$form" "${mldsa_oids[0]}"
                    ;;
                esac
                dgst=$(openssl dgst -sha256 -binary < "$pubout" | xxd -p -c32)
                pubs=("${pubs[@]}" "$dgst")
                count=$((count + 1))
            done
            if [[ $count -ne 1 ]]; then
                die 'Missing key form %s for %s\n' \
                    "$form" "${mldsa_oids[0]}"
            fi
        done
        uniq=$(for dgst in "${pubs[@]}"; do printf "%s\n" "$dgst"; done | sort -u | wc -l)
        if [[ $uniq -ne 1 ]]; then
            die 'Multiple distinct pubkeys for %s\n' \
                "${mldsa_oids[0]}"
        fi
    )
    case $? in
    0) printf "%s,%s\n" "${mldsa_oids[0]}" "Y";;
    1) printf "%s,%s\n" "${mldsa_oids[0]}" "N";;
    *) : ignored ;;
    esac

    #
    # SLH-DSA
    #
    for oid in \
        "${slh2f_oids[0]}" "${slh2s_oids[0]}" \
        "${slh3f_oids[0]}" "${slh3s_oids[0]}"
    do
        (
            set -e
            set -o pipefail
            shopt -s nullglob
            count=0
            for obj in "$tmp"/*-"${oid}_ta.der"
            do
                if [[ $count > 0 ]]; then
                    die 'Too many inputs for %s\n' "${oid}"
                fi
                openssl verify -verify_depth 0 -trusted "$obj" "$obj" >/dev/null
                count=$((count + 1))
            done
            if [[ $count -eq 0 ]]; then exit 2; fi
        )
        case $? in
        0) printf "%s,%s\n" "${oid}" "Y";;
        1) printf "%s,%s\n" "${oid}" "N";;
        *) : ignored ;;
        esac
    done

    #
    # ML-KEM
    #
    (
        set -e
        set -o pipefail
        shopt -s nullglob
        set -- "$tmp"/*-"${mlkem_oids[0]}"_*.der
        if [[ $# -eq 0 ]]; then exit 2; fi
        count=0; for ta in "$tmp"/*-"${mldsa_oids[0]}_ta.der"
        do
            if [[ $count > 0 ]]; then
                die 'Too many TA files for %s\n' \
                    "${mldsa_oids[0]}"
            fi
            count=$((count + 1))
        done
        count=0; for ct in "$tmp"/*-"${mlkem_oids[0]}_ciphertext.bin"
        do
            if [[ $count > 0 ]]; then
                die 'Too many ciphertext files for %s\n' \
                    "${mlkem_oids[0]}"
            fi
            count=$((count + 1))
        done
        if [[ $count -ne 1 ]]; then
            die 'No ciphertext file for %s\n' \
                "${mlkem_oids[0]}"
        fi
        count=0; for ss in "$tmp"/*-"${mlkem_oids[0]}_ss.bin"
        do
            if [[ $count > 0 ]]; then
                die 'Too many shared secret files for %s\n' \
                    "${mlkem_oids[0]}"
            fi
            count=$((count + 1))
        done
        if [[ $count -ne 1 ]]; then
            die 'No shared secret file for %s\n' \
                "${mlkem_oids[0]}"
        fi
        pubs=()
        for form in seed expandedkey both ee
        do
            pubout="$tmp/${mlkem_oids[0]}_${form}_pub.der"
            /bin/rm -f "$pubout"
            count=0; for obj in "$tmp"/*-"${mlkem_oids[0]}_${form}"*.der
            do
                if [[ $count > 0 ]]; then
                    die 'Too many inputs match %s for %s\n' \
                        "$form" "${mlkem_oids[0]}"
                fi
                case $form in
                ee) openssl x509 -in "$obj" -pubkey -noout |
                        openssl pkey -pubin -pubout -outform DER -out "$pubout"
                    openssl verify -verify_depth 0 -trusted "$ta" "$obj" >/dev/null
                    ;;
                *)  openssl pkey -in "$obj" -pubout -outform DER -out "$pubout"
                    cmp -s "$ss" <(
                        openssl pkeyutl -decap -inkey "$obj" -in "$ct" -secret /dev/stdout) ||
                        die 'Shared secret mismatch for %s of %s\n' \
                            "$form" "${mlkem_names[0]}"
                    ;;
                esac
                dgst=$(openssl dgst -sha256 -binary < "$pubout" | xxd -p -c32)
                pubs=("${pubs[@]}" "$dgst")
                count=$((count + 1))
            done
            if [[ $count -ne 1 ]]; then
                die 'Missing key form %s for %s\n' \
                    "$form" "${mlkem_oids[0]}"
            fi
        done
        uniq=$(for dgst in "${pubs[@]}"; do printf "%s\n" "$dgst"; done | sort -u | wc -l)
        if [[ $uniq -ne 1 ]]; then
            die 'Multiple distinct pubkeys for %s\n' \
                "${mlkem_oids[0]}"
        fi
    )
    case $? in
    0) printf "%s,%s\n" "${mldsa_oids[0]}" "Y";;
    1) printf "%s,%s\n" "${mldsa_oids[0]}" "N";;
    *) : ignored ;;
    esac

    unset "mldsa_oids[0]" 
    unset "mlkem_oids[0]"
    unset "slh2f_oids[0]" 
    unset "slh2s_oids[0]" 
    unset "slh3f_oids[0]" 
    unset "slh3s_oids[0]" 
    mldsa_oids=( "${mldsa_oids[@]}")
    mlkem_oids=( "${mlkem_oids[@]}")
    slh2f_oids=( "${slh2f_oids[@]}")
    slh2s_oids=( "${slh2s_oids[@]}")
    slh3f_oids=( "${slh3f_oids[@]}")
    slh3s_oids=( "${slh3s_oids[@]}")
done
