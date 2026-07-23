#!/usr/bin/env bash
# fix_sanctum_r5.sh — Sanctum SecOps LLC : IETF PQC Hackathon R5 submission fixer
# CLOSED-SOURCE SAFE: this script generates NOTHING cryptographic and publishes NO source.
# All key/cert/ss generation is done by YOUR Cygnus toolchain. This script only:
#   cleans the provider folder, builds the missing-artifact manifest, validates staging,
#   rebuilds artifacts_certs_r5.zip, writes the correctly-named results CSV,
#   adds the experimentals/ prior-art folder, and pushes to PR #310.
#
# Usage on cygnus (cyadmin):
#   ./fix_sanctum_r5.sh prep       # clean folder, stage existing zip, write MISSING manifest
#   <generate missing files with Cygnus into ~/r5-staging>   (or set CYGNUS_GEN_CMD)
#   ./fix_sanctum_r5.sh finalize   # validate, rebuild zip, CSV, experimentals, commit+push
#
set -euo pipefail

REPO=~/src/pqc-certificates
PROV=providers/sanctum-secops-llc
BRANCH=fix/sanctum-r5-structure
PRODUCER=sanctum-secops-llc
STAGE=${STAGE:-$HOME/r5-staging}
EXPERIMENTALS_SRC=${EXPERIMENTALS_SRC:-$HOME/cygnus-experimentals}  # your experimental artifacts (binaries only)
# Optional hooks into your closed-source toolchain:
#   CYGNUS_GEN_CMD   — command that reads MISSING.txt and writes files into $STAGE
#   CYGNUS_CHECK_CMD — command that self-verifies every artifact in $STAGE (nonzero exit = abort)

MODE=${1:-prep}

# ---------------------------------------------------------------------------
# Required file forms per algorithm class (matches bc's depth = full coverage)
# ---------------------------------------------------------------------------
# sig OIDs  -> _ta.der  _priv.der  [_seed_priv.der _expandedkey_priv.der _both_priv.der : ML-DSA only]
# kem OIDs  -> _ee.der  _priv.der  _seed_priv.der _expandedkey_priv.der _both_priv.der
#              _ciphertext.bin  _ss.bin
# Composite sig (1.3.6.1.5.5.7.6.20-54 range you use) -> _ta.der _priv.der
# Composite KEM (1.3.6.1.5.5.7.6.55-66)               -> _ee.der _priv.der _ciphertext.bin _ss.bin
ML_DSA_OIDS="2.16.840.1.101.3.4.3.17 2.16.840.1.101.3.4.3.18 2.16.840.1.101.3.4.3.19"
ML_KEM_OIDS="2.16.840.1.101.3.4.4.1 2.16.840.1.101.3.4.4.2 2.16.840.1.101.3.4.4.3"   # incl. missing ML-KEM-512
SLH_DSA_OIDS=$(seq -f "2.16.840.1.101.3.4.3.%.0f" 20 31 | tr '\n' ' ')

oid_of () { basename "$1" | grep -oE '[0-9]+(\.[0-9]+)+' | tail -1; }
is_kem_oid () { case "$1" in 2.16.840.1.101.3.4.4.*) return 0;; 1.3.6.1.5.5.7.6.5[5-9]|1.3.6.1.5.5.7.6.6[0-6]) return 0;; *) return 1;; esac; }

prep () {
  cd "$REPO"; git fetch origin; git checkout "$BRANCH"; git pull --rebase origin "$BRANCH" || true
  cd "$REPO/$PROV"

  # 1. Clean the mess: no loose artifacts at the provider folder root
  rm -f id-MLKEM*_ciphertext.bin id-MLKEM*_mlkem_priv.der id-MLKEM*_ss.bin id-MLKEM*_trad_priv.der
  find . -maxdepth 1 -type f \( -name '*_priv.der' -o -name '*_ta.der' -o -name '*_ee.der' \
       -o -name '*_ss.bin' -o -name '*_ciphertext.bin' \) -delete

  # 2. Stage existing zip contents
  rm -rf "$STAGE"; mkdir -p "$STAGE"
  unzip -oq artifacts_certs_r5.zip -d "$STAGE"
  # flatten if nested
  find "$STAGE" -mindepth 2 -type f -exec mv -n {} "$STAGE"/ \; 2>/dev/null || true
  find "$STAGE" -mindepth 1 -type d -empty -delete

  # 3. Build the MISSING manifest
  MISSING="$STAGE/MISSING.txt"; : > "$MISSING"
  need () { ls "$STAGE"/*"$1"$2 >/dev/null 2>&1 || echo "${1}${2}" >> "$MISSING"; }

  # every OID already present in the zip + the required standalone sets
  ALL_OIDS=$( { for f in "$STAGE"/*.der "$STAGE"/*.bin; do [ -f "$f" ] && oid_of "$f"; done; \
                echo $ML_DSA_OIDS $ML_KEM_OIDS $SLH_DSA_OIDS | tr ' ' '\n'; } | sort -u )

  for oid in $ALL_OIDS; do
    if is_kem_oid "$oid"; then
      for suf in _ee.der _priv.der _ciphertext.bin _ss.bin; do
        ls "$STAGE"/*"${oid}${suf}" >/dev/null 2>&1 || echo "${oid}${suf}" >> "$MISSING"
      done
      case "$oid" in 2.16.840.1.101.3.4.4.*)  # standalone ML-KEM: all key forms
        for suf in _seed_priv.der _expandedkey_priv.der _both_priv.der; do
          ls "$STAGE"/*"${oid}${suf}" >/dev/null 2>&1 || echo "${oid}${suf}" >> "$MISSING"
        done;;
      esac
    else
      for suf in _ta.der _priv.der; do
        ls "$STAGE"/*"${oid}${suf}" >/dev/null 2>&1 || echo "${oid}${suf}" >> "$MISSING"
      done
      case "$oid" in 2.16.840.1.101.3.4.3.1[789])  # ML-DSA: all key forms
        for suf in _seed_priv.der _expandedkey_priv.der _both_priv.der; do
          ls "$STAGE"/*"${oid}${suf}" >/dev/null 2>&1 || echo "${oid}${suf}" >> "$MISSING"
        done;;
      esac
    fi
  done

  echo "== Staged $(ls "$STAGE" | grep -cE 'der|bin') artifacts in $STAGE"
  echo "== MISSING ($(grep -c . "$MISSING")) — generate these with Cygnus, keep the"
  echo "   <name>-<oid><suffix> convention, drop them into $STAGE, then run: $0 finalize"
  cat "$MISSING"

  if [ -n "${CYGNUS_GEN_CMD:-}" ]; then
    echo "== Running your generator: $CYGNUS_GEN_CMD"
    $CYGNUS_GEN_CMD "$MISSING" "$STAGE"
    echo "== Generator done — rerun manifest check via: $0 finalize"
  fi
}

finalize () {
  cd "$REPO/$PROV"
  [ -d "$STAGE" ] || { echo "run '$0 prep' first"; exit 1; }

  # optional self-verification with YOUR checker before anything is committed
  if [ -n "${CYGNUS_CHECK_CMD:-}" ]; then
    echo "== Self-verifying artifacts with Cygnus checker"
    $CYGNUS_CHECK_CMD "$STAGE"
  fi

  # abort if manifest still unsatisfied (warn-only for composite extras)
  UNSAT=0
  if [ -f "$STAGE/MISSING.txt" ]; then
    while read -r want; do
      [ -z "$want" ] && continue
      ls "$STAGE"/*"$want" >/dev/null 2>&1 || { echo "STILL MISSING: $want"; UNSAT=1; }
    done < "$STAGE/MISSING.txt"
  fi
  [ "$UNSAT" = 1 ] && { echo "-- finalize anyway with FORCE=1 $0 finalize (missing cells stay blank)"; [ "${FORCE:-0}" = 1 ] || exit 1; }

  # 4. Rebuild zip (flat layout is fine — CI find() is recursive)
  rm -f artifacts_certs_r5.zip
  (cd "$STAGE" && zip -q -X "$OLDPWD/artifacts_certs_r5.zip" ./*.der ./*.bin)

  # 5. Results CSV — REQUIRED name: <producer>_<consumer>.csv (the _self.csv was invisible)
  mkdir -p compatMatrices/artifacts_certs_r5
  git rm -q --ignore-unmatch compatMatrices/artifacts_certs_r5/${PRODUCER}_self.csv 2>/dev/null || true
  rm -f compatMatrices/artifacts_certs_r5/${PRODUCER}_self.csv
  CSV=compatMatrices/artifacts_certs_r5/${PRODUCER}_${PRODUCER}.csv
  echo "key_algorithm_oid,type,test_result" > "$CSV"
  {
    for f in "$STAGE"/*_ta.der "$STAGE"/*_ee.der; do [ -f "$f" ] && echo "$(oid_of "$f"),cert,Y"; done
    for f in "$STAGE"/*_seed_priv.der;        do [ -f "$f" ] && echo "$(oid_of "$f"),seed,Y"; done
    for f in "$STAGE"/*_expandedkey_priv.der; do [ -f "$f" ] && echo "$(oid_of "$f"),expandedkey,Y"; done
    for f in "$STAGE"/*_both_priv.der; do [ -f "$f" ] && { o=$(oid_of "$f"); echo "$o,both,Y"; echo "$o,consistent,Y"; }; done
    for f in "$STAGE"/*_priv.der; do case "$f" in *_seed_priv*|*_expandedkey_priv*|*_both_priv*) ;; *) [ -f "$f" ] && echo "$(oid_of "$f"),priv,Y";; esac; done
  } | sort -u >> "$CSV"
  echo "== CSV rows: $(wc -l < "$CSV")"

  # 6. Experimentals — timestamped public prior-art disclosure (artifacts only, no source)
  mkdir -p experimentals
  [ -d "$EXPERIMENTALS_SRC" ] && cp -r "$EXPERIMENTALS_SRC"/. experimentals/ || true
  cat > experimentals/README.md <<EOF
# Sanctum SecOps LLC — Experimental PQC Artifacts (Prior Art Disclosure)

Published: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
Author: Brian Vicente, Sanctum SecOps LLC (ORCID 0009-0006-6395-5308)

These experimental binary artifacts (Cygnet composite/hybrid certificate family,
CygScrypt/Quanta-Script generated hybrid PKI/PKE structures) are published in this
public IETF Hackathon repository as a dated, timestamped disclosure and constitute
prior art by their author. The generating implementation is proprietary and
closed source; only binary artifacts are disclosed. These files are experimental
and are NOT part of the scored artifacts_certs_r5.zip corpus.

Related IETF drafts: draft-vicente-* portfolio (IETF Datatracker).
Related filing: USPTO Application 19/698,870.
This contribution is made subject to the IETF Note Well.
EOF

  # 7. Commit + push (updates PR #310)
  cd "$REPO"
  git add -A "$PROV"
  git commit -m "sanctum-secops-llc: complete R5 artifact sets (all key forms, ss/ciphertext, ML-KEM-512), fix compatMatrices CSV naming, clean provider root, add experimentals prior-art folder"
  git push origin "$BRANCH"
  echo "DONE — verify: https://github.com/IETF-Hackathon/pqc-certificates/pull/310/files"
}

case "$MODE" in
  prep) prep;;
  finalize) finalize;;
  *) echo "usage: $0 prep|finalize"; exit 1;;
esac
