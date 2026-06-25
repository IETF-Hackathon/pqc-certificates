#!/usr/bin/env bash
# Botan (3.6+) port of providers/ossl35/gen.sh — SLH-DSA + ML-DSA.
# Per variant, flat dir, matching filenames:
#   SLH-DSA: <name>-<oid>_priv.der        + <name>-<oid>_ta.der
#   ML-DSA:  <name>-<oid>_seed_priv.der   + <name>-<oid>_ta.der
# Private key MATCHES the key in the TA (single keypair per variant).
# ML-DSA key is assumed to be in Botan's default (seed) format.
set -euo pipefail
V=3.6
BOTAN=${BOTAN:-botan}

# --- ML-DSA ---------------------------------------------------------------
mldsa_names=(ml-dsa-44 ml-dsa-65 ml-dsa-87)
mldsa_oids=(2.16.840.1.101.3.4.3.17 2.16.840.1.101.3.4.3.18 2.16.840.1.101.3.4.3.19)
mldsa_params=(ML-DSA-4x4 ML-DSA-6x5 ML-DSA-8x7)

# --- SLH-DSA --------------------------------------------------------------
slh_names=(
  slh-dsa-sha2-128s slh-dsa-sha2-192s slh-dsa-sha2-256s
  slh-dsa-sha2-128f slh-dsa-sha2-192f slh-dsa-sha2-256f
  slh-dsa-shake-128s slh-dsa-shake-192s slh-dsa-shake-256s
  slh-dsa-shake-128f slh-dsa-shake-192f slh-dsa-shake-256f
)
slh_oids=(
  2.16.840.1.101.3.4.3.20 2.16.840.1.101.3.4.3.22 2.16.840.1.101.3.4.3.24
  2.16.840.1.101.3.4.3.21 2.16.840.1.101.3.4.3.23 2.16.840.1.101.3.4.3.25
  2.16.840.1.101.3.4.3.26 2.16.840.1.101.3.4.3.28 2.16.840.1.101.3.4.3.30
  2.16.840.1.101.3.4.3.27 2.16.840.1.101.3.4.3.29 2.16.840.1.101.3.4.3.31
)

slh_params_name() {  # slh-dsa-sha2-128s -> SLH-DSA-SHA2-128s
  local rest=${1#slh-dsa-}; local hash=${rest%%-*}; local size=${rest#*-}
  printf 'SLH-DSA-%s-%s' "${hash^^}" "$size"
}

# key PEM -> key DER  (try botan pkcs8 first, then openssl)
key_pem2der() {  # $1=pem-in $2=der-out
  if "$BOTAN" pkcs8 --der-out "$1" > "$2" 2>/dev/null && [ -s "$2" ]; then return 0; fi
  if command -v openssl >/dev/null 2>&1; then openssl pkey -in "$1" -outform DER -out "$2"; return 0; fi
  echo "ERROR: need 'botan pkcs8' or 'openssl' to export the private key as DER." >&2; exit 1
}

# Generate one keypair, the DER private-key artifact, and the self-signed TA.
#   $1=friendly name  $2=oid  $3=botan algo  $4=botan params  $5=priv suffix
gen_variant() {
  local name=$1 oid=$2 algo=$3 params=$4 suffix=$5
  local base="${name}-${oid}"
  local key_pem="${name}-prv.pem"

  "$BOTAN" keygen --algo="$algo" --params="$params" > "$key_pem"
  key_pem2der "$key_pem" "${base}${suffix}"
  "$BOTAN" gen_self_signed "$key_pem" "OpenSSL $V ${name} Root" --ca --der > "${base}_ta.der"
  /bin/rm -f "$key_pem"
}

# ML-DSA — default (seed) private-key format -> _seed_priv.der
for i in "${!mldsa_names[@]}"; do
  gen_variant "${mldsa_names[$i]}" "${mldsa_oids[$i]}" \
              "ML-DSA" "${mldsa_params[$i]}" "_seed_priv.der"
done

# SLH-DSA — single private-key format -> _priv.der
for i in "${!slh_names[@]}"; do
  gen_variant "${slh_names[$i]}" "${slh_oids[$i]}" \
              "SLH-DSA" "$(slh_params_name "${slh_names[$i]}")" "_priv.der"
done

zip -qq artifacts_certs_r5.zip $(ls *.der)
/bin/rm -f *.der *.pem
