#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Cross-checks the RFC example vectors in test/vectors/ with OpenSSL 3.5 or later.
#   TA   openssl verify -x509_strict -check_ss_sig, with the TA as its own trust anchor
#   EE   openssl verify -x509_strict, with the ML-DSA TA of the same level in the folder
#   key  openssl pkey -check: the import, where OpenSSL 3.5 compares seed and expandedKey and
#        checks an expandedKey against its own public part (ML-DSA: t0 and tr; ML-KEM: H(ek) and a
#        pairwise test). For a key that imports: its public key equals the certificate's, and a
#        signature made with it verifies under the certificate (ML-DSA, SLH-DSA), or it
#        decapsulates a ciphertext that OpenSSL made for the certificate's public key to the same
#        shared secret (ML-KEM)
#   r5   bin/verify_r5.mjs on rfc9935/ with those OpenSSL ciphertexts and shared secrets added
#        under R5 names, so that the R5 decapsulation test of the RFC ML-KEM keys runs across the
#        two libraries (OpenSSL encapsulates, @noble/post-quantum decapsulates)
# Expected: every check of a valid vector passes; every key under invalid/ is refused on import.
# Usage: test/openssl_kat_check.sh [<out-dir>]   (default: the current directory; OPENSSL=<binary>)
#   Writes <out-dir>/openssl_kat_check.csv (folder,file,check,expected,result,detail),
#   <out-dir>/openssl_kat_check.log and <out-dir>/verify_r5_rfc9935_openssl_ct.csv and .log.
#   Exit status 1 when a result differs from the expected one, 2 without a usable OpenSSL.
set -uo pipefail
here=$(cd "$(dirname "$0")" && pwd)
vec=$here/vectors
verify=$here/../bin/verify_r5.mjs
mkdir -p "${1:-.}" && out=$(cd "${1:-.}" && pwd)
ossl=${OPENSSL:-openssl}
ver=$("$ossl" version 2> /dev/null) || { echo "openssl_kat_check: cannot run $ossl" >&2; exit 2; }
if [[ ! $ver =~ ^OpenSSL\ (3\.([5-9]|[1-9][0-9])|[4-9])\. ]]; then
  echo "openssl_kat_check: needs OpenSSL 3.5 or later (ML-DSA, ML-KEM, SLH-DSA), found: $ver" >&2
  exit 2
fi
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
csv=$out/openssl_kat_check.csv
log=$out/openssl_kat_check.log
printf 'folder,file,check,expected,result,detail\n' > "$csv"
{ echo "# $ver"; echo "# node $(node --version)"; } > "$log"
mismatches=0
printf 'Attack at dawn\n' > "$tmp/msg"

tidy() { sed -E -e "s#$tmp/##g" -e "s#$vec/#vectors/#g"; }
# run <cmd...>: runs a command and logs it with its output; returns its exit status
run() {
  echo "\$ $*" | tidy >> "$log"
  "$@" > "$tmp/out" 2>&1
  local s=$?
  sed 's/^/    /' "$tmp/out" | tidy >> "$log"
  return $s
}
# detail <pass|fail>: the last output line, or for a failure the root OpenSSL error (function: reason)
detail() {
  local l
  if [[ $1 == pass ]]; then tail -n 1 "$tmp/out" | tidy; return; fi
  l=$(grep -m 1 ':error:' "$tmp/out")
  if [[ -n $l ]]; then awk -F: '{ if (NF >= 9) print $5 ": " $NF; else print $0 }' <<< "$l" | tidy
  else tail -n 1 "$tmp/out" | tidy; fi
}
# row <folder> <file> <check> <expected> <result> <detail>
row() {
  local d=${6//\"/\'}
  printf '%s,%s,%s,%s,%s,"%s"\n' "$1" "$2" "$3" "$4" "$5" "$d" >> "$csv"
  if [[ $4 != "$5" ]]; then
    mismatches=$((mismatches + 1))
    echo "UNEXPECTED: $1/$2 $3: expected $4, got $5 ($d)" >&2
  fi
}
pem() { "$ossl" x509 -inform DER -in "$1" -out "$2" 2>> "$log"; }
ta_oid_for() {
  case $1 in
    2.16.840.1.101.3.4.4.1) echo 2.16.840.1.101.3.4.3.17 ;;
    2.16.840.1.101.3.4.4.2) echo 2.16.840.1.101.3.4.3.18 ;;
    2.16.840.1.101.3.4.4.3) echo 2.16.840.1.101.3.4.3.19 ;;
  esac
}
# the certificate for <prefix>: in the folder, else in the valid RFC folders
cert_for() {
  local f
  for f in "$1/$2_ta.der" "$1/$2_ee.der" "$vec"/rfc*/"$2"_ta.der "$vec"/rfc*/"$2"_ee.der; do
    if [[ -f $f ]]; then echo "$f"; return; fi
  done
}

mkdir -p "$tmp/ct"
for dir in "$vec"/rfc* "$vec"/invalid/*; do
  rel=${dir#"$vec"/}
  expect_key=pass
  [[ $rel == invalid/* ]] && expect_key=fail
  for f in "$dir"/*.der; do
    name=${f##*/}
    prefix=${name%%_*}
    oid=${prefix##*-}
    case $name in
      *_ta.der)
        pem "$f" "$tmp/c.pem"
        if run "$ossl" verify -x509_strict -check_ss_sig -CAfile "$tmp/c.pem" "$tmp/c.pem"; then r=pass; else r=fail; fi
        row "$rel" "$name" ta_verify pass $r "$(detail $r)"
        ;;
      *_ee.der)
        ta=$(compgen -G "$dir/*-$(ta_oid_for "$oid")_ta.der")
        if [[ -z $ta ]]; then row "$rel" "$name" ee_verify pass fail 'no ML-DSA TA of the same level in the folder'; continue; fi
        pem "$ta" "$tmp/ta.pem"
        pem "$f" "$tmp/c.pem"
        if run "$ossl" verify -x509_strict -CAfile "$tmp/ta.pem" "$tmp/c.pem"; then r=pass; else r=fail; fi
        row "$rel" "$name" ee_verify pass $r "$(detail $r) (CAfile ${ta##*/})"
        ;;
      *_priv.der)
        if run "$ossl" pkey -inform DER -in "$f" -noout -check; then r=pass; else r=fail; fi
        row "$rel" "$name" key_import "$expect_key" $r "$(detail $r)"
        [[ $r == pass ]] || continue
        cert=$(cert_for "$dir" "$prefix")
        if [[ -z $cert ]]; then row "$rel" "$name" key_pub_eq_cert "$expect_key" fail 'no certificate for this OID'; continue; fi
        pem "$cert" "$tmp/c.pem"
        "$ossl" pkey -inform DER -in "$f" -pubout -outform DER -out "$tmp/k.pub" 2>> "$log"
        "$ossl" x509 -in "$tmp/c.pem" -noout -pubkey | "$ossl" pkey -pubin -outform DER -out "$tmp/c.pub" 2>> "$log"
        if cmp -s "$tmp/k.pub" "$tmp/c.pub"; then r=pass; d="equals the public key of ${cert#"$vec"/}"
        else r=fail; d="differs from the public key of ${cert#"$vec"/}"; fi
        row "$rel" "$name" key_pub_eq_cert "$expect_key" $r "$d"
        if [[ $oid == 2.16.840.1.101.3.4.4.* ]]; then
          ct=$tmp/ct/$prefix
          [[ -f $ct.ct ]] || run "$ossl" pkeyutl -encap -certin -inkey "$tmp/c.pem" -out "$ct.ct" -secret "$ct.ss"
          if ! run "$ossl" pkeyutl -decap -inkey "$f" -keyform DER -in "$ct.ct" -secret "$tmp/ss"; then
            r=fail; d="$(detail fail)"
          elif cmp -s "$tmp/ss" "$ct.ss"; then
            r=pass; d="shared secret equals the encapsulation's (${cert#"$vec"/})"
          else r=fail; d="shared secret differs from the encapsulation's (${cert#"$vec"/})"; fi
          row "$rel" "$name" decap_openssl_ct "$expect_key" $r "$d"
        else
          if run "$ossl" pkeyutl -sign -rawin -inkey "$f" -keyform DER -in "$tmp/msg" -out "$tmp/sig" \
            && run "$ossl" pkeyutl -verify -rawin -certin -inkey "$tmp/c.pem" -in "$tmp/msg" -sigfile "$tmp/sig"; then r=pass; else r=fail; fi
          row "$rel" "$name" sign_verify "$expect_key" $r "$(detail $r) (${cert#"$vec"/})"
        fi
        ;;
    esac
  done
done

# The R5 test of the RFC ML-KEM keys with the OpenSSL ciphertexts.
r5=$tmp/r5
mkdir -p "$r5"
cp "$vec"/rfc9935/*.der "$r5"/
n=0
for c in "$tmp"/ct/*.ct; do
  [[ -f $c ]] || continue
  b=${c##*/}
  b=${b%.ct}
  cp "$c" "$r5/${b}_ciphertext.bin"
  cp "${c%.ct}.ss" "$r5/${b}_ss.bin"
  n=$((n + 1))
done
r5csv=$out/verify_r5_rfc9935_openssl_ct.csv
node "$verify" "$r5" > "$r5csv" 2> "$out/verify_r5_rfc9935_openssl_ct.log"
s=$?
rows=$(($(wc -l < "$r5csv") - 1))
ys=$(grep -c ',Y$' "$r5csv")
if [[ $s == 0 && $n == 3 && $rows == 18 && $ys == 18 && ! -s $out/verify_r5_rfc9935_openssl_ct.log ]]; then r=pass; else r=fail; fi
row rfc9935 '(folder)' r5_with_openssl_ct pass $r "$n OpenSSL ciphertexts; $rows rows; $ys Y; $(wc -l < "$out/verify_r5_rfc9935_openssl_ct.log") warnings"

total=$(($(wc -l < "$csv") - 1))
summary="openssl_kat_check: $total checks, $mismatches differ from the expected result ($(cut -d' ' -f1-2 <<< "$ver"))"
echo "# $summary" >> "$log"
echo "$summary"
[[ $mismatches == 0 ]]
