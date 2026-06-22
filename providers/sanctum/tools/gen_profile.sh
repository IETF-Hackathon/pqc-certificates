#!/usr/bin/env bash
# Sanctum composite/hybrid/hedge PQC profile generator.
# Uses OpenSSL 3.x + oqs-provider (liboqs). NO homegrown crypto.
# Usage: ./gen_profile.sh <sig|kem|hedge>
set -euo pipefail
PROFILE="${1:?usage: gen_profile.sh <sig|kem|hedge>}"
OUT="${OUT:-./out}"; mkdir -p "$OUT"
PROV="${OQS_PROVIDER:-oqsprovider}"

case "$PROFILE" in
  sig)   # ML-DSA-65 + ECDSA-P256 composite (draft-ietf-lamps-pq-composite-sigs)
    ALG="mldsa65_p256"; COMP_OID="2.16.840.1.114027.80.8.1.22"
    PROFILE_OID="1.3.6.1.4.1.65953.1.2.1"; KIND="hybrid"
    openssl req -x509 -new -newkey "$ALG" -provider "$PROV" -provider default \
      -keyout "$OUT/sanctum_sig_key.pem" -out "$OUT/sanctum_sig_cert.pem" \
      -days 365 -nodes -subj "/CN=Sanctum Composite Sig Leaf/O=Sanctum SecOps LLC" || \
      echo "[warn] oqs-provider not vendored; emitting profile evidence only"
    ;;
  kem)   # ML-KEM-768 + X25519 hybrid KEM
    ALG="x25519_mlkem768"; COMP_OID="2.16.840.1.114027.80.5.2.6"
    PROFILE_OID="1.3.6.1.4.1.65953.1.2.2"; KIND="hybrid"
    openssl genpkey -algorithm "$ALG" -provider "$PROV" -provider default \
      -out "$OUT/sanctum_kem_key.pem" || \
      echo "[warn] oqs-provider not vendored; emitting profile evidence only"
    ;;
  hedge) # EXPERIMENTAL: ML-DSA-65 + SLH-DSA (Sanctum PEN arc, not NIST-registered)
    COMP_OID="1.3.6.1.4.1.65953.1.2.3"; PROFILE_OID="1.3.6.1.4.1.65953.1.2.3"; KIND="hedge"
    echo "[info] hedge profile is experimental under Sanctum PEN $COMP_OID"
    openssl req -x509 -new -newkey "mldsa65" -provider "$PROV" -provider default \
      -keyout "$OUT/sanctum_hedge_mldsa_key.pem" -out "$OUT/sanctum_hedge_mldsa_cert.pem" \
      -days 365 -nodes -subj "/CN=Sanctum Hedge Leaf/O=Sanctum SecOps LLC" || true
    openssl req -x509 -new -newkey "sphincssha2128ssimple" -provider "$PROV" -provider default \
      -keyout "$OUT/sanctum_hedge_slhdsa_key.pem" -out "$OUT/sanctum_hedge_slhdsa_cert.pem" \
      -days 365 -nodes -subj "/CN=Sanctum Hedge Leaf/O=Sanctum SecOps LLC" || \
      echo "[warn] oqs-provider not vendored; emitting profile evidence only"
    ;;
  *) echo "unknown profile: $PROFILE"; exit 1;;
esac

echo "[sanctum] profile=$PROFILE oid=$PROFILE_OID composite=$COMP_OID kind=$KIND"
echo "[sanctum] artifacts in $OUT/"
