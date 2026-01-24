#! /usr/bin/env bash
#set -x

output=$(openssl list -providers)
if echo "$output" | grep -q "SafeLogic"; then
    echo  "Found SafeLogic's provider."
else
    echo "SafeLogic's provider wasn't found."
    exit 1
fi

mldsa_names=(ml-dsa-{44,65,87})
mldsa_oids=(2.16.840.1.101.3.4.3.{17,18,19})
mlkem_names=(ml-kem-{512,768,1024})
mlkem_oids=(2.16.840.1.101.3.4.4.{1,2,3})
slh2s_names=(slh-dsa-sha2-{128,192,256}s)
slh2s_oids=(2.16.840.1.101.3.4.3.{20,22,24})
slh2f_names=(slh-dsa-sha2-{128,192,256}f)
slh2f_oids=(2.16.840.1.101.3.4.3.{21,23,25})
slh3s_names=(slh-dsa-shake-{128,192,256}s)
slh3s_oids=(2.16.840.1.101.3.4.3.{26,28,30})
slh3f_names=(slh-dsa-shake-{128,192,256}f)
slh3f_oids=(2.16.840.1.101.3.4.3.{27,29,31})
md2_names=(sha{256,512,512})
md3_names=(sha3-{256,512,512})

mkdir -p cms
printf 'plaintext\r\n' > cms/expected_plaintext.txt

gencms() {
    if [[ $# -ne 3 ]]; then die "Usage: gencms algorithm oid md"; fi
     
    local name=$1 oid=$2 md=$3
    echo generating cms for ${name} ${oid} ${md}
    local ee_key="cms/${name}-prv.pem"
    local ee_pub="cms/${name}-pub.pem"
    local ee_crt="cms/${name}-crt.pem"
    local ee_cms="cms/${name}-${oid}_signed_attrs.der"
    openssl genpkey -algorithm "${name}" -out "$ee_key"
    openssl pkey -in "$ee_key" -pubout -out "${ee_pub}"
    openssl x509 -new -out "${ee_crt}" \
        -CAform DER -CAkey cms/takey.der -CA cms/ta.der \
        -force_pubkey "${ee_pub}" -days 36524 -subj / \
        -extfile <(
            printf "subjectKeyIdentifier=none\n"
            printf "subjectAltName=critical,DNS:${name}.cms.example\n"
            printf "basicConstraints=critical,CA:false\n"
            printf "keyUsage=critical,digitalSignature\n" )
    openssl cms -sign -md "$md" -nodetach -in cms/expected_plaintext.txt \
        -signer "${ee_crt}" -inkey "${ee_key}" \
        -outform DER -out "${ee_cms}"
    /bin/rm -f "$ee_key" "$ee_pub" "$ee_crt"
}

while [[ ${#mldsa_names[@]} -gt 0 ]]
do
    #
    # ML-DSA
    #
    mldsa_key="${mldsa_names[0]}-prv.pem"
    mldsa_der="${mldsa_names[0]}-${mldsa_oids[0]}"
    openssl genpkey -algorithm "${mldsa_names[0]}" -out "$mldsa_key"
    #
    openssl pkey -in "${mldsa_key}" -outform DER \
        -provparam ml-dsa.output_formats=seed-only \
        -out ${mldsa_der}_seed_priv.der
    openssl pkey -in "${mldsa_key}" -outform DER \
        -provparam ml-dsa.output_formats=priv-only \
        -out ${mldsa_der}_expandedkey_priv.der
    openssl pkey -in "${mldsa_key}" -outform DER \
        -provparam ml-dsa.output_formats=seed-priv \
        -out ${mldsa_der}_both_priv.der
    #
    openssl req -new -x509 -days 36524 -subj "/CN=SafeLogic Inc $V ${mldsa_names[0]} Root" \
        -key "${mldsa_key}" -out "${mldsa_der}_ta.der" \
        -addext "basicConstraints=critical,CA:true" \
        -addext "keyUsage=critical,keyCertSign,cRLSign" -outform DER

    case "${mldsa_names[0]}" in
    ml-dsa-44)
        cp $mldsa_key cms/takey.der
        cp "${mldsa_der}_ta.der" cms/ta.der
        ;;
    esac

    gencms "${mldsa_names[0]}" "${mldsa_oids[0]}" "${md2_names[0]}"

    unset "mldsa_names[0]"; mldsa_names=("${mldsa_names[@]}")
    unset "mldsa_oids[0]"; mldsa_oids=( "${mldsa_oids[@]}")
done

zip -qq default.zip $(ls *.der)
#zip -qq -j artifacts_cms_v3.zip $(ls cms/*.txt cms/ta.der cms/*_signed_attrs.der)
/bin/rm -f *.der
/bin/rm -f *.pem
/bin/rm -f  cms/*
