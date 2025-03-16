#! /usr/bin/env bash

V=3.5

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
printf 'Attack at dawn!\r\n' > cms/expected_plaintext.txt

gencms() {
    if [[ $# -ne 3 ]]; then die "Usage: gencms algorithm oid md"; fi
    local name=$1 oid=$2 md=$3

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
    openssl req -new -x509 -days 36524 -subj "/CN=OpenSSL $V ${mldsa_names[0]} Root" \
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

    #
    # SLH-DSA
    #
    slh2f_key="${slh2f_names[0]}-prv.pem"
    slh2f_der="${slh2f_names[0]}-${slh2f_oids[0]}"
    slh2s_key="${slh2s_names[0]}-prv.pem"
    slh2s_der="${slh2s_names[0]}-${slh2s_oids[0]}"
    slh3f_key="${slh3f_names[0]}-prv.pem"
    slh3f_der="${slh3f_names[0]}-${slh3f_oids[0]}"
    slh3s_key="${slh3s_names[0]}-prv.pem"
    slh3s_der="${slh3s_names[0]}-${slh3s_oids[0]}"
    openssl genpkey -algorithm "${slh2f_names[0]}" -out "$slh2f_key"
    openssl genpkey -algorithm "${slh2s_names[0]}" -out "$slh2s_key"
    openssl genpkey -algorithm "${slh3f_names[0]}" -out "$slh3f_key"
    openssl genpkey -algorithm "${slh3s_names[0]}" -out "$slh3s_key"
    openssl pkey -in "$slh2f_key" -outform DER -out "${slh2f_der}_priv.der"
    openssl pkey -in "$slh2s_key" -outform DER -out "${slh2s_der}_priv.der"
    openssl pkey -in "$slh3f_key" -outform DER -out "${slh3f_der}_priv.der"
    openssl pkey -in "$slh3s_key" -outform DER -out "${slh3s_der}_priv.der"
    openssl req -new -x509 -days 36524 -subj "/CN=OpenSSL $V ${slh2f_names[0]} Root" \
        -key "${slh2f_key}" -out "${slh2f_der}_ta.der" \
        -addext "basicConstraints=critical,CA:true" \
        -addext "keyUsage=critical,keyCertSign,cRLSign" -outform DER
    openssl req -new -x509 -days 36524 -subj "/CN=OpenSSL $V ${slh2s_names[0]} Root" \
        -key "${slh2s_key}" -out "${slh2s_der}_ta.der" \
        -addext "basicConstraints=critical,CA:true" \
        -addext "keyUsage=critical,keyCertSign,cRLSign" -outform DER
    openssl req -new -x509 -days 36524 -subj "/CN=OpenSSL $V ${slh3f_names[0]} Root" \
        -key "${slh3f_key}" -out "${slh3f_der}_ta.der" \
        -addext "basicConstraints=critical,CA:true" \
        -addext "keyUsage=critical,keyCertSign,cRLSign" -outform DER
    openssl req -new -x509 -days 36524 -subj "/CN=OpenSSL $V ${slh3s_names[0]} Root" \
        -key "${slh3s_key}" -out "${slh3s_der}_ta.der" \
        -addext "basicConstraints=critical,CA:true" \
        -addext "keyUsage=critical,keyCertSign,cRLSign" -outform DER

    gencms "${slh2f_names[0]}" "${slh2f_oids[0]}" "${md2_names[0]}"
    gencms "${slh2s_names[0]}" "${slh2s_oids[0]}" "${md2_names[0]}"
    gencms "${slh3f_names[0]}" "${slh3f_oids[0]}" "${md3_names[0]}"
    gencms "${slh3s_names[0]}" "${slh3s_oids[0]}" "${md3_names[0]}"

    #
    # ML-KEM
    #
    mlkem_key="${mlkem_names[0]}-prv.pem"
    mlkem_pub="${mlkem_names[0]}-pub.pem"
    mlkem_der="${mlkem_names[0]}-${mlkem_oids[0]}"
    openssl genpkey -algorithm "${mlkem_names[0]}" -out "${mlkem_key}"
    openssl pkey -in "${mlkem_key}" -pubout -out "${mlkem_pub}"
    #
    openssl pkey -in "${mlkem_key}" -outform DER \
        -provparam ml-kem.output_formats=seed-only \
        -out "${mlkem_der}_seed_priv.der"
    openssl pkey -in "${mlkem_key}" -outform DER \
        -provparam ml-kem.output_formats=priv-only \
        -out "${mlkem_der}_expandedkey_priv.der"
    openssl pkey -in "${mlkem_key}" -outform DER \
        -provparam ml-kem.output_formats=seed-priv \
        -out "${mlkem_der}_both_priv.der"
    #
    openssl x509 -new -outform DER -out "${mlkem_der}_ee.der" \
        -CAform DER -CAkey "${mldsa_key}" -CA "${mldsa_der}_ta.der" \
        -force_pubkey "${mlkem_pub}" -days 36524 -subj / \
        -extfile <(
            printf "subjectKeyIdentifier=none\n"
            printf "subjectAltName=critical,DNS:${mlkem_names[0]}.ee.example\n"
            printf "basicConstraints=critical,CA:false\n"
            printf "keyUsage=critical,keyEncipherment\n" )
    #
    openssl pkeyutl -encap -inkey "${mlkem_pub}" \
        -out "${mlkem_der}_ciphertext.bin" \
        -secret "${mlkem_der}_ss.bin"
    #
    unset "md2_names[0]"; md2_names=("${md2_names[@]}")
    unset "md3_names[0]"; md3_names=("${md3_names[@]}")
    unset "mldsa_names[0]"; mldsa_names=("${mldsa_names[@]}")
    unset "mlkem_names[0]"; mlkem_names=("${mlkem_names[@]}")
    unset "slh2f_names[0]"; slh2f_names=("${slh2f_names[@]}")
    unset "slh2s_names[0]"; slh2s_names=("${slh2s_names[@]}")
    unset "slh3f_names[0]"; slh3f_names=("${slh3f_names[@]}")
    unset "slh3s_names[0]"; slh3s_names=("${slh3s_names[@]}")
    unset "mldsa_oids[0]"; mldsa_oids=( "${mldsa_oids[@]}")
    unset "mlkem_oids[0]"; mlkem_oids=( "${mlkem_oids[@]}")
    unset "slh2f_oids[0]"; slh2f_oids=( "${slh2f_oids[@]}")
    unset "slh2s_oids[0]"; slh2s_oids=( "${slh2s_oids[@]}")
    unset "slh3f_oids[0]"; slh3f_oids=( "${slh3f_oids[@]}")
    unset "slh3s_oids[0]"; slh3s_oids=( "${slh3s_oids[@]}")
done
zip -qq artifacts_certs_r5.zip $(ls *.der *.bin)
zip -qq -j artifacts_cms_v3.zip $(ls cms/*.txt cms/ta.der cms/*_signed_attrs.der)
/bin/rm -f *.der *.pem *.bin cms/*
