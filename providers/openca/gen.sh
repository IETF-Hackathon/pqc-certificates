#!/bin/sh

# Output Prefix
CRYPTO_PREFIX=libpki/crypto_tests
ARTIFACTS_PREFIX=libpki/artifacts

#
# OID Section
#
# Public Keys
#
OID_RSA_ENCRYPTION=1.2.840.113549.1.1.1
OID_EC_PUBKEY=1.2.840.10045.2.1
OID_DILITHIUM2=1.3.6.1.4.1.2.267.7.4.4
OID_DILITHIUM3=1.3.6.1.4.1.2.267.7.6.5
OID_DILITHIUM5=1.3.6.1.4.1.2.267.7.8.7
OID_FALCON512=1.3.9999.3.1
OID_FALCON1024=1.3.9999.3.4

#
# Composite Keys
#
OID_COMPOSITE_KEY=2.16.840.1.114027.80.4.1
# OID_MULTI_KEY= What Here ?

#
# Composite Signatures
#
OID_COMPOSITE_NULL=1.3.6.1.4.1.18227.2.1

OID_COMPOSITE_SHA1=1.3.6.1.4.1.18227.2.1.1

OID_COMPOSITE_SHA256=1.3.6.1.4.1.18227.2.1.2
OID_COMPOSITE_SHA384=1.3.6.1.4.1.18227.2.1.2
OID_COMPOSITE_SHA512=1.3.6.1.4.1.18227.2.1.4

OID_COMPOSITE_SHA3_256=1.3.6.1.4.1.18227.2.1.5
OID_COMPOSITE_SHA3_384=1.3.6.1.4.1.18227.2.1.6
OID_COMPOSITE_SHA3_512=1.3.6.1.4.1.18227.2.1.7

OID_COMPOSITE_SHAKE_128=1.3.6.1.4.1.18227.2.1.8
OID_COMPOSITE_SHAKE_256=1.3.6.1.4.1.18227.2.1.9

#
# Explicit Composite Keys and Sigs
#
OID_EXP_DILITHIUM3_RSA_SHA256=2.16.840.1.114027.80.5.1.1
OID_EXP_DILITHIUM3_P256_SHA256=2.16.840.1.114027.80.5.1.2
OID_EXP_DILITHIUM3_BRAINPOOL256R1_SHA256=2.16.840.1.114027.80.5.1.3
OID_EXP_DILITHIUM3_ED25519=2.16.840.1.114027.80.5.1.4
OID_EXP_DILITHIUM5_P384_SHA384=2.16.840.1.114027.80.5.1.5
OID_EXP_DILITHIUM5_BRAINPOOL384R1_SHA384=2.16.840.1.114027.80.5.1.6
OID_EXP_DILITHIUM5_X448=2.16.840.1.114027.80.5.1.7
OID_EXP_FALCON512_P256_SHA256=2.16.840.1.114027.80.5.1.8
OID_EXP_FALCON512_BRAINPOOL256R1_SHA256=2.16.840.1.114027.80.5.1.9
OID_EXP_FALCON512_ED25519=2.16.840.1.114027.80.5.1.10
OID_EXP_SPHINCS_SHA256128S_SIMPLE_P256_SHA256=2.16.840.1.114027.80.5.1.11
OID_EXP_SPHINCS_SHA256128S_SIMPLE_BRAINPOOL256R1_SHA256=2.16.840.1.114027.80.5.1.12
OID_EXP_SPHINCS_SHA256128S_SIMPLE_ED25519=2.16.840.1.114027.80.5.1.13
OID_EXP_DILITHIUM3_RSAPSS_SHA256=2.16.840.1.114027.80.5.1.14

# CRYPTO Tests:
#
# This initial set of tests is meant to provide options to better test
# for interoperability of low-level crypto functions by removing the
# complications of certificate validation (besides self-signed certs).
#
# 1 - Generation of Single-Key Classic Material
#     1.A - RSA (2048) - artifacts/1.A_rsa2048.key - OID: 1.2.840.113549.1.1.1
#     1.B - RSA (3072) - artifacts/1.B_rsa3072.key - OID: 1.2.840.113549.1.1.1
#     1.C - RSA (4096) - artifacts/1.C_rsa3072.key - OID: 1.2.840.113549.1.1.1
#     1.D - EC (P256)  - artifacts/1.D_p256.key    - OID: 1.2.840.10045.2.1
#     1.E - EC (P384)  - artifacts/1.E_p384.key    - OID: 
#     1.F - EC (P521)  - artifacts/1.F_p521.key    - OID: 

# 2 - Generation of Single-Key PQ Material
#     2.A - Dilithium (Level 2) - artifacts/2.A_dilithium2.key - OID: 1.3.6.1.4.1.2.267.7.4.4
#     2.B - Dilithium (Level 3) - artifacts/2.B_dilithium3.key - OID: 1.3.6.1.4.1.2.267.7.6.5
#     2.C - Dilithium (Level 5) - artifacts/2.C_dilithium5.key - OID: 1.3.6.1.4.1.2.267.7.8.7
#     2.D - Falcon (512)        - artifacts/2.D_falcon512.key  - OID: 1.3.9999.3.1
#     2.E - Falcon (1024)       - artifacts/2.E_falcon1024.key - OID: 1.3.9999.3.4
#     2.F - Sphincs+ (small/fast? - which parameters?)     - OID: ???

# 3 - Generation of Generic Composite Keys
#     3.A - RSA (2048) + EC (P256)           - artifacts/3.A_comp_rsa2048_p256.key       - OID: 2.16.840.1.114027.80.4.1 / 1.3.6.1.4.1.18227.2.1.999.1
#     3.B - Dilithium (Level 2) + RSA (2048) - artifacts/3.B_comp_dilithium2_rsa2048.key - OID: 2.16.840.1.114027.80.4.1 / 1.3.6.1.4.1.18227.2.1.999.1
#     3.C - Dilithium (Level 3) + RSA (3072) - artifacts/3.C_comp_dilithium3_rsa3072.key - OID: 2.16.840.1.114027.80.4.1 / 1.3.6.1.4.1.18227.2.1.999.1
#     3.D - Dilithium (Level 3) + EC (P256)  - artifacts/3.D_comp_dilithium3_p256.key    - OID: 2.16.840.1.114027.80.4.1 / 1.3.6.1.4.1.18227.2.1.999.1
#     3.E - Dilithium (Level 5) + RSA (4096) - artifacts/3.E_comp_dilithium5_rsa4096.key - OID: 2.16.840.1.114027.80.4.1 / 1.3.6.1.4.1.18227.2.1.999.1
#     3.F - Dilithium (Level 5) + EC (P521)  - artifacts/3.F_comp_dilithium5_p521.key    - OID: 2.16.840.1.114027.80.4.1 / 1.3.6.1.4.1.18227.2.1.999.1
#     3.G - Falcon (512) + RSA (2048)        - artifacts/3.G_comp_falcon512_rsa2048.key  - OID: 2.16.840.1.114027.80.4.1 / 1.3.6.1.4.1.18227.2.1.999.1
#     3.H - Falcon (512) + RSA (3072)        - artifacts/3.H_comp_falcon1024_rsa3072.key - OID: 2.16.840.1.114027.80.4.1 / 1.3.6.1.4.1.18227.2.1.999.1
#     3.I - Falcon (512) + EC (P256)         - artifacts/3.I_comp_falcon512_p256.key     - OID: 2.16.840.1.114027.80.4.1 / 1.3.6.1.4.1.18227.2.1.999.1
#     3.J - Falcon (1024) + RSA (4096)       - artifacts/3.J_comp_falcon1024_rsa4096.key - OID: 2.16.840.1.114027.80.4.1 / 1.3.6.1.4.1.18227.2.1.999.1
#     3.K - Falcon (1024) + EC (P521)        - artifacts/3.J_comp_falcon1024_p521.key    - OID: 2.16.840.1.114027.80.4.1 / 1.3.6.1.4.1.18227.2.1.999.1

# 4 - Generation of Explicit Composite Keys
#     4.A - Dilithium (Level 3) + RSA (2048) With SHA256 - artifacts/4.A_exp_dilithium3_p256.key    - OID: 2.16.840.1.114027.80.5.1
#     4.B - Dilithium (Level 3) + EC (P256) With SHA256  - artifacts/4.B_exp_dilithium3_rsa2048.key - OID: 2.16.840.1.114027.80.5.2
#     4.C - Dilithium (Level 5) + EC (P384) With SHA384  - artifacts/4.B_exp_dilithium3_rsa2048.key - OID: 2.16.840.1.114027.80.5.2
#     4.D - Falcon (512) + EC (P256) With SHA256         - artifacts/4.C_exp_falcon512_p256.key     - OID: 2.16.840.1.114027.80.5.3 
#     4.E - Dilithium (Level 5) + Falcon (1024) + EC (P521)  - artifacts/4.E_exp_dilithium5_falcon1024_p521.key    - OID: 2.16.840.1.114027.80.5.5
#     4.F - Dilithium (Level 5) + Falcon (1024) + RSA (3072) - artifacts/4.F_exp_dilithium5_falcon1024_rsa3072.key - OID: 2.16.840.1.114027.80.5.6

# 5 - Generation of Single Key CSRs (Tests Key Load and Usage) - Direct Signing (no hash)
#     5.A - Dilithium (Level 2) CSR - Signing Key 2.A - SIG OID: 1.3.6.1.4.1.2.267.7.4.4
#     5.B - Dilithium (Level 3) CSR - Signing Key 2.B - SIG OID: 1.3.6.1.4.1.2.267.7.6.5
#     5.C - Dilithium (Level 5) CSR - Signing Key 2.C - SIG OID: 1.3.6.1.4.1.2.267.7.8.7
#     5.D - Falcon (512) CSR        - Signing Key 2.D - SIG OID: 1.3.9999.3.1
#     5.E - Falcon (1024) CSR       - Signing Key 2.E - SIG OID: 1.3.9999.3.4

# 6 - Generation of Single Key CSRs (Tests Key Load and Usage) - Hash-n-Sign (SHA256)
#     6.A - Dilithium (Level 2) CSR - Signing Key 2.A - SIG OID: 1.3.6.1.4.1.18227.999.1.1.2
#     6.B - Dilithium (Level 3) CSR - Signing Key 2.B - SIG OID: 
#     6.C - Dilithium (Level 5) CSR - Signing Key 2.C - SIG OID: 
#     6.D - Falcon (512) CSR        - Signing Key 2.D - SIG OID: 
#     6.E - Falcon (1024) CSR       - Signing Key 2.E - SIG OID: 
#     6.F - Sphincs+ (small/fast? - which parameters?) - Signing Key 2.F - OID: ???

# 7 - Generation of Generic Composite CSRs (Tests Key Load and Usage) - Direct Signing
#     7.A - RSA (2048) + EC (P256) CSR            - Signing Key 3.A - SIG OID: 1.3.6.1.4.1.18227.2.2.1.2
#     7.B - Dilithium (Level 2) + RSA (2048) CSR  - Signing Key 3.B - SIG OID: 1.3.6.1.4.1.18227.2.2.1.2
#     7.C - Dilithium (Level 3) + RSA (3072) CSR  - Signing Key 3.C - SIG OID: 1.3.6.1.4.1.18227.2.2.1.2
#     7.D - Dilithium (Level 3) + EC (P256) CSR   - Signing Key 3.D - SIG OID: 1.3.6.1.4.1.18227.2.2.1.2
#     7.E - Dilithium (Level 5) + RSA (4096) CSR  - Signing Key 3.E - SIG OID: 1.3.6.1.4.1.18227.2.2.1.2
#     7.F - Dilithium (Level 5) + EC (P521) CSR   - Signing Key 3.F - SIG OID: 1.3.6.1.4.1.18227.2.2.1.2
#     7.G - Falcon (512) + RSA (2048) CSR   - Signing Key 3.F - SIG OID: 1.3.6.1.4.1.18227.2.2.1.2
#     7.H - Falcon (512) + RSA (3072) CSR   - Signing Key 3.F - SIG OID: 1.3.6.1.4.1.18227.2.2.1.2
#     7.I - Falcon (512) + EC (P256) CSR   - Signing Key 3.F - SIG OID: 1.3.6.1.4.1.18227.2.2.1.2
#     7.J - Falcon (1024) + RSA (4096) CSR   - Signing Key 3.F - SIG OID: 1.3.6.1.4.1.18227.2.2.1.2
#     7.K - Falcon (1024) + EC (P521) CSR   - Signing Key 3.F - SIG OID: 1.3.6.1.4.1.18227.2.2.1.2
#     7.L - Sphincs+ (small/fast? - which parameters?) - Signing Key 2.F - OID: ???

# 8 - Generation of Generic Composite CSRs (Tests Key Load and Usage) - Hash-n-Sign (SHA256, SHA384, SHA512, SHA3_256, SHA3_384, SHA3_512, SHAKE128, SHAKE256)
#     8.A - RSA (2048) + EC (P256) CSR            - Signing Key 3.A - SIG OID: 1.3.6.1.4.1.18227.2.2.1.{2/3/4/5/6/7/X/X}
#     8.B - Dilithium (Level 2) + RSA (2048) CSR  - Signing Key 3.B - SIG OID: 1.3.6.1.4.1.18227.2.2.1.{2/3/4/5/6/7/X/X}
#     8.C - Dilithium (Level 3) + RSA (3072) CSR  - Signing Key 3.C - SIG OID: 1.3.6.1.4.1.18227.2.2.1.{2/3/4/5/6/7/X/X}
#     8.D - Dilithium (Level 3) + EC (P256) CSR   - Signing Key 3.D - SIG OID: 1.3.6.1.4.1.18227.2.2.1.{2/3/4/5/6/7/X/X}
#     8.E - Dilithium (Level 5) + RSA (4096) CSR  - Signing Key 3.E - SIG OID: 1.3.6.1.4.1.18227.2.2.1.{2/3/4/5/6/7/X/X}
#     8.F - Dilithium (Level 5) + EC (P521) CSR   - Signing Key 3.F - SIG OID: 1.3.6.1.4.1.18227.2.2.1.{2/3/4/5/6/7/X/X}
#     8.G - Falcon (512) + RSA (2048) CSR   - Signing Key 3.F - SIG OID: 1.3.6.1.4.1.18227.2.2.1.{2/3/4/5/6/7/X/X}
#     8.H - Falcon (512) + RSA (3072) CSR   - Signing Key 3.F - SIG OID: 1.3.6.1.4.1.18227.2.2.1.{2/3/4/5/6/7/X/X}
#     8.I - Falcon (512) + EC (P256) CSR   - Signing Key 3.F - SIG OID: 1.3.6.1.4.1.18227.2.2.1.{2/3/4/5/6/7/X/X}
#     8.J - Falcon (1024) + RSA (4096) CSR   - Signing Key 3.F - SIG OID: 1.3.6.1.4.1.18227.2.2.1.{2/3/4/5/6/7/X/X}
#     8.K - Falcon (1024) + EC (P521) CSR   - Signing Key 3.F - SIG OID: 1.3.6.1.4.1.18227.2.2.1.{2/3/4/5/6/7/X/X}
#     8.L - Sphincs+ (small/fast? - which parameters?) - Signing Key 2.F - OID: ???

# 9 - Generation of Explicit Composite CSRs (Tests Key Load and Usage) - Direct Signing
#     9.A - Dilithium (Level 3) + EC (P256)  - Signing Key 4.A - OID: 
#     9.B - Dilithium (Level 3) + RSA (2048) - Signing Key 4.B - OID:
#     9.C - Falcon (512) + EC (P256)         - Signing Key 4.C - OID: 
#     9.D - Falcon (512) + RSA (2048)        - Signing Key 4.D - OID:
#     9.E - Dilithium (Level 5) + Falcon (1024) + EC (P521)  - Signing Key 4.E  - OID: 
#     9.F - Dilithium (Level 5) + Falcon (1024) + RSA (3072) - Signing Key 4.F  - OID: 

# 10 - Generation of Explicit Composite CSRs (Tests Key Load and Usage) - Hash-n-Sign (SHA256, SHA384, SHA512, SHA3_256, SHA3_384, SHA3_512, SHAKE128, SHAKE256)
#    10.A - Dilithium (Level 3) + EC (P256)  - Signing Key 4.A - OID: 
#    10.B - Dilithium (Level 3) + RSA (2048) - Signing Key 4.B - OID:
#    10.C - Falcon (512) + EC (P256)         - Signing Key 4.C - OID: 
#    10.D - Falcon (512) + RSA (2048)        - Signing Key 4.D - OID:
#    10.E - Dilithium (Level 5) + Falcon (1024) + EC (P521)  - Signing Key 4.E  - OID: 
#    10.F - Dilithium (Level 5) + Falcon (1024) + RSA (3072) - Signing Key 4.F  - OID: 

crypto_test_requirements_checks() {

   # Output Directory
   OUT_DIR="libpki"
   [ -d "$OUT_DIR/artifacts" ] || mkdir -p "$OUT_DIR/artifacts"
   [ -d "$OUT_DIR/crypto_tests" ] || mkdir -p "$OUT_DIR/crypto_tests"

   # PKI Tool (should be in PATH)
   result=$(pki-tool info)
   if [ $? -gt 0 ] ; then
      echo
      echo "ERROR: Missing the 'pki-tool' command in your PATH, aborting."
      echo
      exit 1
   fi

}

# Generates Keys 1.A - 1.D
crypto_test_group_1 () {

   # Checks the requirements
   crypto_test_requirements_checks

   # Generates the folders
   [ -d "${CRYPTO_PREFIX}/$OID_RSA_ENCRYPTION" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_RSA_ENCRYPTION"
   [ -d "${CRYPTO_PREFIX}/$OID_EC_PUBKEY" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_EC_PUBKEY"

   # Generate 1.A
   [ -f "${CRYPTO_PREFIX}/$OID_RSA_ENCRYPTION/1.A_rsa2048.key" ] || \
   pki-tool genkey -batch -algor RSA -bits 2048 -out "${CRYPTO_PREFIX}/$OID_RSA_ENCRYPTION/1.A_rsa2048.key"

   # Generate 1.B
   [ -f "${CRYPTO_PREFIX}/${OID_RSA_ENCRYPTION}/1.B_rsa3072.key" ] || \
   pki-tool genkey -batch -algor RSA -bits 3072 -out "${CRYPTO_PREFIX}/$OID_RSA_ENCRYPTION/1.B_rsa3072.key"

   # Generate 1.C
   [ -f "${CRYPTO_PREFIX}/${OID_RSA_ENCRYPTION}/1.C_rsa4096.key" ] || \
   pki-tool genkey -batch -algor RSA -bits 4096 -out "${CRYPTO_PREFIX}/$OID_RSA_ENCRYPTION/1.C_rsa4096.key"

   # Generate 1.D
   [ -f "${CRYPTO_PREFIX}/${OID_EC_PUBKEY}/1.D_p256.key" ] || \
   pki-tool genkey -batch -algor EC -bits 256 -out "${CRYPTO_PREFIX}/$OID_EC_PUBKEY/1.D_p256.key"

   # Generate 1.E
   [ -f "${CRYPTO_PREFIX}/${OID_EC_PUBKEY}/1.E_p384.key" ] || \
   pki-tool genkey -batch -algor EC -bits 384 -out "${CRYPTO_PREFIX}/$OID_EC_PUBKEY/1.E_p384.key"

   # Generate 1.F
   [ -f "${CRYPTO_PREFIX}/${OID_EC_PUBKEY}/1.F_p521.key" ] || \
   pki-tool genkey -batch -algor EC -bits 521 -out "${CRYPTO_PREFIX}/$OID_EC_PUBKEY/1.F_p521.key"

}

# Generates PQ Keys 2.A - 2.F
crypto_test_group_2 () {

   # Checks the requirements
   crypto_test_requirements_checks

   # Generates the folders
   [ -d "${CRYPTO_PREFIX}/$OID_DILITHIUM2" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_DILITHIUM2"
   [ -d "${CRYPTO_PREFIX}/$OID_DILITHIUM3" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_DILITHIUM3"
   [ -d "${CRYPTO_PREFIX}/$OID_DILITHIUM5" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_DILITHIUM5"
   [ -d "${CRYPTO_PREFIX}/$OID_FALCON512" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_FALCON512"
   [ -d "${CRYPTO_PREFIX}/$OID_FALCON1024" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_FALCON1024"

   # Generate 2.A (dilithium2)
   [ -f "${CRYPTO_PREFIX}/${OID_DILITHIUM2}/2.A_dilithium2.key" ] || \
   pki-tool genkey -batch -algor dilithium -bits 128 -out "${CRYPTO_PREFIX}/$OID_DILITHIUM2/2.A_dilithium2.key"

   # Generate 2.B
   [ -f "${CRYPTO_PREFIX}/${OID_DILITHIUM3}/2.B_dilithium3.key" ] || \
   pki-tool genkey -batch -algor dilithium -bits 191 -out "${CRYPTO_PREFIX}/$OID_DILITHIUM3/2.B_dilithium3.key"

   # Generate 2.C
   [ -f "${CRYPTO_PREFIX}/${OID_DILITHIUM5}/2.C_dilithium5.key" ] || \
   pki-tool genkey -batch -algor dilithium -bits 256 -out "${CRYPTO_PREFIX}/$OID_DILITHIUM5/2.C_dilithium5.key"

   # Generate 2.D
   [ -f "${CRYPTO_PREFIX}/${OID_FALCON512}/2.D_falcon512.key" ] || \
   pki-tool genkey -batch -algor falcon512 -bits 128 -out "${CRYPTO_PREFIX}/$OID_FALCON512/2.D_falcon512.key"

   # Generate 2.E
   [ -f "${CRYPTO_PREFIX}/${OID_FALCON512}/2.E_falcon1024.key" ] || \
   pki-tool genkey -batch -algor falcon1024 -bits 256 -out "${CRYPTO_PREFIX}/$OID_FALCON1024/2.E_falcon1024.key"
}

# Generates Generic Composite Keys 3.A - 3.K
crypto_test_group_3 () {

   # Checks the requirements
   crypto_test_requirements_checks

   # Generates the folders
   [ -d "${CRYPTO_PREFIX}/$OID_COMPOSITE_KEY" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_COMPOSITE_KEY"
   # [-d "${CRYPTO_PREFIX}/$OID_MULTI_KEY" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_MULTI_KEY"

   # Generate 3.A - RSA 2048 + EC P256
   pki-tool genkey -batch -algor composite \
      -addkey "${CRYPTO_PREFIX}/${OID_RSA_ENCRYPTION}/1.A_rsa2048.key" -addkey "${CRYPTO_PREFIX}/${OID_EC_PUBKEY}/1.D_p256.key" \
      -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.A_comp_rsa2048_p256.key"

   # Generates 3.B - Dilithium (Level 2) + RSA (2048)
   pki-tool genkey -batch -algor composite \
      -addkey "${CRYPTO_PREFIX}/${OID_DILITHIUM2}/2.A_dilithium2.key" -addkey "${CRYPTO_PREFIX}/${OID_RSA_ENCRYPTION}/1.A_rsa2048.key" \
      -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.B_comp_dilithium2_rsa2048.key"

   # Generates 3.C - Dilithium (Level 3) + RSA (3072)
   pki-tool genkey -batch -algor composite \
      -addkey "${CRYPTO_PREFIX}/${OID_DILITHIUM3}/2.B_dilithium3.key" -addkey "${CRYPTO_PREFIX}/${OID_RSA_ENCRYPTION}/1.B_rsa3072.key" \
      -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.C_comp_dilithium3_rsa3072.key"

   # Generates 3.D - Dilithium (Level 3) + EC (P256)
   pki-tool genkey -batch -algor composite \
      -addkey "${CRYPTO_PREFIX}/${OID_DILITHIUM3}/2.B_dilithium3.key" -addkey "${CRYPTO_PREFIX}/${OID_EC_PUBKEY}/1.D_p256.key" \
      -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.D_comp_dilithium3_p256.key"

   # Generates 3.E - Dilithium (Level 5) + RSA (4096)
   pki-tool genkey -batch -algor composite \
      -addkey "${CRYPTO_PREFIX}/${OID_DILITHIUM5}/2.C_dilithium5.key" -addkey "${CRYPTO_PREFIX}/${OID_RSA_ENCRYPTION}/1.C_rsa4096.key" \
      -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.E_comp_dilithium5_rsa4096.key"

   # Generates 3.F - Dilithium (Level 5) + EC (P521)
   pki-tool genkey -batch -algor composite \
      -addkey "${CRYPTO_PREFIX}/${OID_DILITHIUM5}/2.C_dilithium5.key" -addkey "${CRYPTO_PREFIX}/${OID_EC_PUBKEY}/1.F_p521.key" \
      -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.F_comp_dilithium5_p521.key"

   # Generates 3.G - Falcon (Level 2) + RSA (2048)
   pki-tool genkey -batch -algor composite \
      -addkey "${CRYPTO_PREFIX}/${OID_FALCON512}/2.D_falcon512.key" -addkey "${CRYPTO_PREFIX}/${OID_RSA_ENCRYPTION}/1.A_rsa2048.key" \
      -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.G_comp_falcon512_rsa2048.key"

   # Generates 3.H - Falcon (Level 2) + RSA (3072)
   pki-tool genkey -batch -algor composite \
      -addkey "${CRYPTO_PREFIX}/${OID_FALCON512}/2.D_falcon512.key" -addkey "${CRYPTO_PREFIX}/${OID_RSA_ENCRYPTION}/1.B_rsa3072.key" \
      -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.H_comp_falcon512_rsa3072.key"

   # Generates 3.I - Falcon (Level 2) + EC (P256)
   pki-tool genkey -batch -algor composite \
      -addkey "${CRYPTO_PREFIX}/${OID_FALCON512}/2.D_falcon512.key" -addkey "${CRYPTO_PREFIX}/${OID_EC_PUBKEY}/1.D_p256.key" \
      -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.I_comp_falcon512_p256.key"

   # Generates 3.J - Falcon (Level 5) + RSA (4096)
   pki-tool genkey -batch -algor composite \
      -addkey "${CRYPTO_PREFIX}/${OID_FALCON1024}/2.E_falcon1024.key" -addkey "${CRYPTO_PREFIX}/${OID_RSA_ENCRYPTION}/1.C_rsa4096.key" \
      -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.J_comp_falcon1024_rsa4096.key"

   # Generates 3.K - Falcon (Level 5) + EC (P521)
   pki-tool genkey -batch -algor composite \
      -addkey "${CRYPTO_PREFIX}/${OID_FALCON1024}/2.E_falcon1024.key" -addkey "${CRYPTO_PREFIX}/${OID_EC_PUBKEY}/1.F_p521.key" \
      -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.K_comp_falcon1024_p521.key"
   
}

# Generates Explicit Composite Keys 4.A - 4.F
crypto_test_group_4 () {

   # Checks the requirements
   crypto_test_requirements_checks

   # Generates the folders
   [ -d "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM3_RSA_SHA256" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM3_RSA_SHA256"
   [ -d "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM3_P256_SHA256" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM3_P256_SHA256"
   # [-d "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM3_BRAINPOOL256R1_SHA256" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM3_BRAINPOOL256R1_SHA256"
   # [-d "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM3_ED25519" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM3_ED25519"
   [ -d "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM5_P384_SHA384" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM5_P384_SHA384"
   # [-d "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM5_BRAINPOOL384R1_SHA384" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM5_BRAINPOOL384R1_SHA384"
   # [-d "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM5_X448" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM5_X448"
   [ -d "${CRYPTO_PREFIX}/$OID_EXP_FALCON512_P256_SHA256" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_EXP_FALCON512_P256_SHA256"
   # [-d "${CRYPTO_PREFIX}/$OID_EXP_FALCON512_BRAINPOOL256R1_SHA256" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_EXP_FALCON512_BRAINPOOL256R1_SHA256"
   # [-d "${CRYPTO_PREFIX}/$OID_EXP_FALCON512_ED25519" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_EXP_FALCON512_ED25519"
   # [-d "${CRYPTO_PREFIX}/$OID_EXP_SPHINCS_SHA256128S_SIMPLE_P256_SHA256" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_EXP_SPHINCS_SHA256128S_SIMPLE_P256_SHA256"
   # [-d "${CRYPTO_PREFIX}/$OID_EXP_SPHINCS_SHA256128S_SIMPLE_BRAINPOOL256R1_SHA256" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_EXP_SPHINCS_SHA256128S_SIMPLE_BRAINPOOL256R1_SHA256"
   # [-d "${CRYPTO_PREFIX}/$OID_EXP_SPHINCS_SHA256128S_SIMPLE_ED25519" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_EXP_SPHINCS_SHA256128S_SIMPLE_ED25519"
   # [-d "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM3_RSAPSS_SHA256" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM3_RSAPSS_SHA256"

   # Generate 4.A - Dilithium (Level 3) + RSA With SHA256
   pki-tool genkey -batch -algor DILITHIUM3-RSA \
      -addkey "${CRYPTO_PREFIX}/${OID_DILITHIUM3}/2.B_dilithium3.key" -addkey "${CRYPTO_PREFIX}/${OID_RSA_ENCRYPTION}/1.A_rsa2048.key" \
      -out "${CRYPTO_PREFIX}/${OID_EXP_DILITHIUM3_RSA_SHA256}/4.A_exp_dilithium3_rsa2048.key"

   # Generate 4.B - Dilithium (Level 3) + EC (P256) With SHA384
   pki-tool genkey -batch -algor DILITHIUM3-P256 \
      -addkey "${CRYPTO_PREFIX}/${OID_DILITHIUM3}/2.B_dilithium3.key" -addkey "${CRYPTO_PREFIX}/${OID_EC_PUBKEY}/1.D_p256.key" \
      -out "${CRYPTO_PREFIX}/$OID_EXP_DILITHIUM3_P256_SHA256/4.B_exp_dilithium3_p256.key"

   # # Generate 4.C - Dilithium (Level 5) + EC (P384) With SHA384
   # pki-tool genkey -batch -algor DILITHIUM5-P384 \
   #    -addkey "${CRYPTO_PREFIX}/${OID_DILITHIUM5}/2.C_dilithium5.key" -addkey "${CRYPTO_PREFIX}/${OID_EC_PUBKEY}/1.D_p384.key" \
   #    -out "${CRYPTO_PREFIX}/OID_EXP_DILITHIUM3_P384_SHA384/4.C_exp_dilithium5_p384.key"

   # # Generate 4.D - Falcon (512) + EC (P256) With SHA256
   # pki-tool genkey -batch -algor FALCON512-P256 \
   #    -addkey "${CRYPTO_PREFIX}/${OID_FALCON512}/2.D_falcon512.key" -addkey "${CRYPTO_PREFIX}/${OID_EC_PUBKEY}/1.D_p256.key" \
   #    -out "${CRYPTO_PREFIX}/${OID_EXP_FALCON512_P256_SHA256}/4.D_exp_falcon512_p256.key"

   # # Generate 4.E - Dilithium (Level 5) + Falcon (1024) + EC (P521)
   # pki-tool genkey -batch -algor DILITHIUM5-FALCON1024-P521 \
   #    -addkey "${CRYPTO_PREFIX}/${OID_DILITHIUM5}/2.C_dilithium5.key" -addkey "${CRYPTO_PREFIX}/${OID_FALCON1024}/2.E_falcon1024.key" -addkey "${CRYPTO_PREFIX}/${OID_EC_PUBKEY}/1.F_p521.key" \
   #    -out "${CRYPTO_PREFIX}/${}/4.E_exp_dilithium5_falcon1024_p521.key"

   # # Generate 4.E - Dilithium (Level 5) + Falcon (1024) + EC (P521)
   # pki-tool genkey -batch -algor DILITHIUM5-FALCON1024-RSA \
   #    -addkey "${CRYPTO_PREFIX}/2.C_dilithium5.key" -addkey "${CRYPTO_PREFIX}/2.E_falcon1024.key" -addkey "${CRYPTO_PREFIX}/1.C_rsa4096.key" \
   #    -out "${CRYPTO_PREFIX}/4.F_exp_dilithium5_falcon1024_rsa4096.key"
}

# Generates Single Key PQC CSRs (Direct Signing) 5.A - 5.F
crypto_test_group_5 () {

   # Checks the requirements
   crypto_test_requirements_checks

   # Generates the folders
   [ -d "${CRYPTO_PREFIX}/$OID_DILITHIUM2" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_DILITHIUM2"
   [ -d "${CRYPTO_PREFIX}/$OID_DILITHIUM3" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_DILITHIUM3"
   [ -d "${CRYPTO_PREFIX}/$OID_DILITHIUM5" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_DILITHIUM5"
   [ -d "${CRYPTO_PREFIX}/$OID_FALCON512" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_FALCON512"
   [ -d "${CRYPTO_PREFIX}/$OID_FALCON1024" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_FALCON1024"

   # Generate 4.A - Dilithium2 CSR (Direct Signing)
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 2)" \
      -signkey "${CRYPTO_PREFIX}/${OID_DILITHIUM2}/2.A_dilithium2.key" -out "${CRYPTO_PREFIX}/${OID_DILITHIUM2}/5.A_dilithium2.req"

   # Generate 4.B - Dilithium3 CSR (Direct Signing)
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 3)" \
      -signkey "${CRYPTO_PREFIX}/${OID_DILITHIUM3}/2.B_dilithium3.key" -out "${CRYPTO_PREFIX}/${OID_DILITHIUM3}/5.B_dilithium3.req"

   # Generate 4.C - Dilithium5 CSR (Direct Signing)
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 5)" \
      -signkey "${CRYPTO_PREFIX}/${OID_DILITHIUM5}/2.C_dilithium5.key" -out "${CRYPTO_PREFIX}/${OID_DILITHIUM5}/5.C_dilithium5.req"

   # Generate 4.D - Falcon512 CSR (Direct Signing)
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Falcon (Level 512)" \
      -signkey "${CRYPTO_PREFIX}/${OID_FALCON512}/2.D_falcon512.key" -out "${CRYPTO_PREFIX}/${OID_FALCON512}/5.D_falcon512.req"

   # Generate 4.E - Falcon1024 CSR (Direct Signing)
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Falcon (Level 1024)" \
      -signkey "${CRYPTO_PREFIX}/${OID_FALCON1024}/2.E_falcon1024.key" -out "${CRYPTO_PREFIX}/${OID_FALCON1024}/5.E_falcon1024.req"
}

# Generates Single Key PQC CSRs (Hash-n-Sign) 6.A - 6.F
crypto_test_group_6 () {

   # Checks the requirements
   crypto_test_requirements_checks

   # Generates the folders
   [ -d "${CRYPTO_PREFIX}/$OID_DILITHIUM2" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_DILITHIUM2"
   [ -d "${CRYPTO_PREFIX}/$OID_DILITHIUM3" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_DILITHIUM3"
   [ -d "${CRYPTO_PREFIX}/$OID_DILITHIUM5" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_DILITHIUM5"
   [ -d "${CRYPTO_PREFIX}/$OID_FALCON512" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_FALCON512"
   [ -d "${CRYPTO_PREFIX}/$OID_FALCON1024" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_FALCON1024"

   # Algorithms (sha256, sha384, sha512, sha3_256, sha3_384, sha3_512, shake128, shake256)
   # for HASH in sha256 sha384 sha512 sha3-256 sha3-384 sha3-512 shake128 shake256 ; do
   for HASH in sha256 sha512 ; do

      # Generate 6.A - Dilithium2 CSR (Direct Signing)
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 2)" \
         -signkey "${CRYPTO_PREFIX}/${OID_DILITHIUM2}/2.A_dilithium2.key" -out "${CRYPTO_PREFIX}/${OID_DILITHIUM2}/6.A_dilithium2_$HASH.req" \
         -digest "$HASH"

      # Generate 6.B - Dilithium3 CSR (Direct Signing)
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 3)" \
         -signkey "${CRYPTO_PREFIX}/${OID_DILITHIUM3}/2.B_dilithium3.key" -out "${CRYPTO_PREFIX}/${OID_DILITHIUM3}/6.B_dilithium3_$HASH.req" \
         -digest "$HASH"

      # Generate 6.C - Dilithium5 CSR (Direct Signing)
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 5)" \
         -signkey "${CRYPTO_PREFIX}/${OID_DILITHIUM5}/2.C_dilithium5.key" -out "${CRYPTO_PREFIX}/${OID_DILITHIUM5}/6.C_dilithium5_$HASH.req" \
         -digest "$HASH"

      # Generate 6.D - Falcon512 CSR (Direct Signing)
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Falcon (Level 512)" \
         -signkey "${CRYPTO_PREFIX}/${OID_FALCON512}/2.D_falcon512.key" -out "${CRYPTO_PREFIX}/${OID_FALCON512}/6.D_falcon512_$HASH.req" \
         -digest "$HASH"

      # Generate 6.E - Falcon1024 CSR (Direct Signing)
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Falcon (Level 1024)" \
         -signkey "${CRYPTO_PREFIX}/${OID_FALCON1024}/2.E_falcon1024.key" -out "${CRYPTO_PREFIX}/${OID_FALCON1024}/6.E_falcon1024_$HASH.req" \
         -digest "$HASH"

   done

   # All Digests Done.
}

# Generates Generic Composite CSRs (Direct Sign) 7.A - 7.K
crypto_test_group_7 () {

   # Checks the requirements
   crypto_test_requirements_checks

   # Generates the folders
   [ -d "${CRYPTO_PREFIX}/$OID_COMPOSITE_NULL" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_COMPOSITE_NULL"

   # Generate 7.A - RSA (2048) + EC (P256)
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=RSA (2048) and ECDSA (P256)" \
      -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.A_comp_rsa2048_p256.key" -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_NULL}/7.A_comp_rsa2048_p256.req"

   # Generate 7.B - DDilithium (Level 2) + RSA (2048)
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 2) and RSA (2048)" \
      -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.B_comp_dilithium2_rsa2048.key" -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_NULL}/7.B_comp_dilithium2_rsa2048.req"

   # Generate 7.C - Dilithium (Level 3) + RSA (3072) CSR
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 3) \+ RSA (3072)" \
      -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.C_comp_dilithium3_rsa3072.key" -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_NULL}/7.C_comp_dilithium3_rsa3072.req"

   # Generate 7.D - Dilithium (Level 3) + EC (P256)
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 3) and EC (P256)" \
      -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.D_comp_dilithium3_p256.key" -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_NULL}/7.D_comp_dilithium3_p256.req"

   # Generate 7.E - Dilithium (Level 5) + RSA (4096)
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 5) and RSA (4096)" \
      -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.E_comp_dilithium5_rsa4096.key" -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_NULL}/7.E_comp_dilithium5_rsa4096.req"

   # Generate 7.F - Dilithium (Level 5) + EC (P521)
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 5) and EC (P521)" \
      -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.F_comp_dilithium5_p521.key" -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_NULL}/7.F_comp_dilithium5_p521.req"

   # Generate 7.G - Falcon (512) + RSA (2048) CSR
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Falcon (512) and RSA (2048)" \
      -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.G_comp_falcon512_rsa2048.key" -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_NULL}/7.G_comp_falcon512_rsa2048.req"

   # Generate 7.H - Falcon (512) + RSA (3072) CSR
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Falcon (512) and RSA (3072)" \
      -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.H_comp_falcon512_rsa3072.key" -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_NULL}/7.H_comp_falcon512_rsa3072.req"

   # Generate 7.I - Falcon (512) + EC (P256) CSR
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Falcon (512) and EC (P256)" \
      -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.I_comp_falcon512_p256.key" -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_NULL}/7.I_comp_falcon512_p256.req"

   # Generate 7.J - Falcon (1024) + RSA (4096) CSR
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Falcon (1024) and RSA (4096)" \
      -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.J_comp_falcon1024_rsa4096.key" -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_NULL}/7.J_comp_falcon1024_rsa4096.req"
   
   # Generate 7.K - Falcon (1024) + EC (P521) CSR
   pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Falcon (1024) and EC (P521)" \
      -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.K_comp_falcon1024_p521.key" -out "${CRYPTO_PREFIX}/${OID_COMPOSITE_NULL}/7.K_comp_falcon1024_p521.req"

   # Generate 7.L - Sphincs+ (No support, yet)
}

# Generates Generic Composite CSRs (Hash-n-Sign - SHA384) 8.A - 8.K
crypto_test_group_8 () {

   # Checks the requirements
   crypto_test_requirements_checks

   # Generates the folders
   [ -d "${CRYPTO_PREFIX}/$OID_COMPOSITE_SHA256" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_COMPOSITE_SHA256"
   [ -d "${CRYPTO_PREFIX}/$OID_COMPOSITE_SHA384" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_COMPOSITE_SHA384"
   [ -d "${CRYPTO_PREFIX}/$OID_COMPOSITE_SHA512" ] || mkdir -p "${CRYPTO_PREFIX}/$OID_COMPOSITE_SHA512"

   # Algorithms (sha256, sha384, sha512, sha3_256, sha3_384, sha3_512, shake128, shake256)
   # for HASH in sha256 sha384 sha512 sha3-256 sha3-384 sha3-512 shake128 shake256 ; do
   for HASH in sha256 sha384 sha512 ; do

      # Output Directory
      OUT_DIR=

      # Gets the right output directory for the hash/OID
      case "$HASH" in
         sha256)
            OUT_DIR=${OID_COMPOSITE_SHA256}
            ;;
         sha384)
            OUT_DIR=${OID_COMPOSITE_SHA384}
            ;;
         sha512)
            OUT_DIR=${OID_COMPOSITE_SHA512}
            ;;
         *)
            echo "Not Supported Hash - $HASH. Ignored."
            echo
            ;;
      esac

      # Generate 8.A - RSA (2048) + EC (P256)
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=RSA (2048) and ECDSA (P256)" \
         -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.A_comp_rsa2048_p256.key" -out "${CRYPTO_PREFIX}/${OUT_DIR}/8.A_comp_rsa2048_p256_$HASH.req" \
         -digest "$HASH"

      # Generate 8.B - DDilithium (Level 2) + RSA (2048)
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 2) and RSA (2048)" \
         -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.B_comp_dilithium2_rsa2048.key" -out "${CRYPTO_PREFIX}/${OUT_DIR}/8.B_comp_dilithium2_rsa2048_$HASH.req" \
         -digest "$HASH"

      # Generate 8.C - Dilithium (Level 3) + RSA (3072) CSR
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 3) + RSA (3072)" \
         -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.C_comp_dilithium3_rsa3072.key" -out "${CRYPTO_PREFIX}/${OUT_DIR}/8.C_comp_dilithium3_rsa3072_$HASH.req" \
         -digest "$HASH"

      # Generate 8.D - Dilithium (Level 3) + EC (P256)
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 3) and EC (P256)" \
         -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.D_comp_dilithium3_p256.key" -out "${CRYPTO_PREFIX}/${OUT_DIR}/8.D_comp_dilithium3_p256_$HASH.req" \
         -digest "SHA384"

      # Generate 8.E - Dilithium (Level 5) + RSA (4096)
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 5) and RSA (4096)" \
         -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.E_comp_dilithium5_rsa4096.key" -out "${CRYPTO_PREFIX}/${OUT_DIR}/8.E_comp_dilithium5_rsa4096_$HASH.req" \
         -digest "$HASH"

      # Generate 8.F - Dilithium (Level 5) + EC (P521)
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Dilithium (Level 5) and EC (P521)" \
         -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.F_comp_dilithium5_p521.key" -out "${CRYPTO_PREFIX}/${OUT_DIR}/8.F_comp_dilithium5_p521_$HASH.req" \
         -digest "$HASH"

      # Generate 8.G - Falcon (512) + RSA (2048) CSR
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Falcon (512) and RSA (2048)" \
         -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.G_comp_falcon512_rsa2048.key" -out "${CRYPTO_PREFIX}/${OUT_DIR}/8.G_comp_falcon512_rsa2048_$HASH.req" \
         -digest "$HASH"

      # Generate 8.H - Falcon (512) + RSA (3072) CSR
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Falcon (512) and RSA (3072)" \
         -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.H_comp_falcon512_rsa3072.key" -out "${CRYPTO_PREFIX}/${OUT_DIR}/8.H_comp_falcon512_rsa3072_$HASH.req" \
         -digest "$HASH"

      # Generate 8.I - Falcon (512) + EC (P256) CSR
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Falcon (512) and EC (P256)" \
         -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.I_comp_falcon512_p256.key" -out "${CRYPTO_PREFIX}/${OUT_DIR}/8.I_comp_falcon512_p256_$HASH.req" \
         -digest "$HASH"

      # Generate 8.J - Falcon (1024) + RSA (4096) CSR
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Falcon (1024) and RSA (4096)" \
         -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.J_comp_falcon1024_rsa4096.key" -out "${CRYPTO_PREFIX}/${OUT_DIR}/8.J_comp_falcon1024_rsa4096_$HASH.req" \
         -digest "$HASH"
      
      # Generate 8.K - Falcon (1024) + EC (P521) CSR
      pki-tool genreq -batch -subject "O=OpenCA, OU=PQC Tests, CN=Falcon (1024) and EC (P521)" \
         -signkey "${CRYPTO_PREFIX}/${OID_COMPOSITE_KEY}/3.K_comp_falcon1024_p521.key" -out "${CRYPTO_PREFIX}/${OUT_DIR}/8.K_comp_falcon1024_p521_$HASH.req" \
         -digest "$HASH"

      # Generate 8.L - Sphincs+ (No support, yet)

   done

   # All Digests Done
}

gen_dirs() {

   # Generates the internal directories
   # An argument is expected for the name of
   # the OID/Parent directory
   _BASE_DIR=$1

   # Creates the Main Dir
   [ -d "$_BASE_DIR" ] || mkdir -p "$_BASE_DIR"

   # Default folders
   SUBDIRS="ta ca ee crl ocsp"

   # Creates the Directory and the SubDirs
   for dir in ${SUBDIRS} ; do
      mkdir -p "${_BASE_DIR}/${dir}"
   done
}

gen_composite_key() {

   # The OpenCA's LibPKI tools do not allow for
   # direct generation of composite keys but their
   # aggregation from individual ones

   # Prefix for key material
   PREFIX=$1

   # Output file for the key
   OUT=$2

   # Algorithms for up to three different components
   ALGS=$3

   # Cycle through the algorithms and builds the key
   options=
   for algorithm in ${ALGS} ; do
      if ! [ "x$algorithm" = "x" ] ; then
         # Generate the first component
         pki-tool genkey -algor "$algorithm" -batch -out "${PREFIX}/comp_$algorithm.key"
         options+=" -addkey \"${PREFIX}/comp_$algorithm.key\" "
      fi
   done
   pki-tool genkey -batch -out "$OUT" -algor composite $options
}

gen() {

   # Function to generate the ta/, ca/, and ee/
   # directories and X.509 key + req + cert.
   #
   # Additionally it also creates the crl/ and
   # ocsp/ directories.
   ALGORITHM=$1
   BASE_DIR=$2
   HASH=$3

   # Components Algorithms
   KEY_COMP="$4 $5 $6"
   
   # Generates the directories
   gen_dirs "$BASE_DIR"

   # Change to the newly created directory
   cd "$BASE_DIR"

   # Root/TA:
   # ========

   # Generate key pair
   KEY_FILE="ta/ta_priv.pem"
   REQ_FILE="ta/ta_req.pem"
   CER_FILE="ta/ta.pem"
   DER_FILE="ta/ta.der"
   DIGEST="-digest ${HASH}"

   if ! [ "$HASH" = "null" ] ; then
      REQ_FILE="ta/ta_req_${HASH}.pem"
      CER_FILE="ta/ta_${HASH}.pem"
      DER_FILE="ta/ta_${HASH}.der"
      DIGEST=""
   fi

   if ! [ -f "${KEY_FILE}" ] ; then
      if [ "$1" = "composite" ] ; then
         gen_composite_key "ta" "${KEY_FILE}" "$KEY_COMP"
      else
         pki-tool genkey -algor "$1" -batch -out "${KEY_FILE}"
      fi
   fi

   # Fixes the Trust Anchor Files
   TA_CER_FILE=${CER_FILE}
   TA_KEY_FILE=${KEY_FILE}

   # Generate the request
   pki-tool genreq -batch -signkey "${KEY_FILE}" \
      -subject "CN=PQC Test" -out "${REQ_FILE}" ${DIGEST}

   # Generate the certificate
   pki-tool gencert -batch -signkey "${KEY_FILE}" \
      -config "../../../config" -profile "RootCA" -selfsign \
      -in "${REQ_FILE}" -out "${CER_FILE}" ${DIGEST}

   # Intermediate CA:
   # ================

   # Generate key pair
   KEY_FILE="ca/ca_priv.pem"
   REQ_FILE="ca/ca_req.pem"
   CER_FILE="ca/ca.pem"
   DER_FILE="ca/ca.der"
   DIGEST="-digest ${HASH}"

   if ! [ "$HASH" = "null" ] ; then
      REQ_FILE="ca/ca_req_${HASH}.pem"
      CER_FILE="ca/ca_${HASH}.pem"
      DER_FILE="ca/ca_${HASH}.der"
      DIGEST=
   fi

   if ! [ -f "${KEY_FILE}" ] ; then
      if [ "$1" = "composite" ] ; then
         gen_composite_key "${KEY_FILE}" "$1" "RSA" "ECDSA"
      else
         pki-tool genkey -algor "$1" -batch -out "${KEY_FILE}"
      fi
   fi

   # Fixes the Intermediate CA Files
   CA_CER_FILE=${CER_FILE}
   CA_KEY_FILE=${KEY_FILE}

   # Generates the key pair
   pki-tool genkey -batch -algor "$1" -out "${KEY_FILE}"
   # Converts the key into DER format

   # Generates the CA's PKCS#10 request
   pki-tool genreq -batch -signkey "${KEY_FILE}" \
      -subject "CN=Intermediate CA" -out "${REQ_FILE}" ${DIGEST}

   # Generates the CA's certificate via the Root CA
   pki-tool gencert -batch ${DIGEST} \
      -config "../../../config" -profile "IntermediateCA" \
      -signkey "${TA_KEY_FILE}" -signcert "${TA_CER_FILE}" \
      -in "${REQ_FILE}" -out "${CER_FILE}"

   # End Entity cert:
   # ================

   # Generate key pair
   KEY_FILE="ee/ee_priv.pem"
   REQ_FILE="ee/ee_req.pem"
   CER_FILE="ee/ee.pem"
   DER_FILE="ee/ee.der"
   DIGEST="-digest ${HASH}"

   if ! [ "$HASH" = "null" ] ; then
      REQ_FILE="ee/ee_req_${HASH}.pem"
      CER_FILE="ee/ee_${HASH}.pem"
      DER_FILE="ee/ee_${HASH}.der"
      DIGEST=
   fi

   if ! [ -f "${KEY_FILE}" ] ; then
      if [ "$1" = "composite" ] ; then
         gen_composite_key "${KEY_FILE}" "$1" "RSA" "ECDSA"
      else
         pki-tool genkey -algor "$1" -batch -out "${KEY_FILE}"
      fi
   fi

   # Fixes End Entity Files
   EE_CER_FILE=${CER_FILE}
   EE_KEY_FILE=${KEY_FILE}

   # Generates the key pair
   pki-tool genkey -batch -algor "$1" -out "${KEY_FILE}"

   # Generates the CA's PKCS#10 request
   pki-tool genreq -batch -signkey "${KEY_FILE}" \
      -subject "CN=End Entity" -out "${REQ_FILE}"  ${DIGEST}

   # Generates the EE certificate via the ICA
   pki-tool gencert -batch ${DIGEST}\
      -config "../../../config" -profile "EndEntity" \
      -signkey "${CA_KEY_FILE}" -signcert "${CA_CER_FILE}" \
      -in "${REQ_FILE}" -out "${CER_FILE}"

   # All Done
   cd ..
}

# Product Sub Directories
SUBDIRS=libpki

# New CRYPTO tests - focus on the generation of
# KEY and SIGNATURES without incurring into
# certificate validations (handled in the next
# sets of tests)
for dir in ${SUBDIRS} ; do 

   # Generates the LibPKI directory
   [ -d "${dir}" ] || mkdir -p "${dir}"
   [ -d "${dir}/artifacts" ] || mkdir -p "${dir}/artifacts"

   # Classical Key Generation
   echo "* Generating classic keys (RSA and EC)"
   result=$( crypto_test_group_1 )

   # PQC Key Generation
   echo "* Generating PQC Keys (Dilithium and Falcon)"
   result=$( crypto_test_group_2 )

   # Generic Composite Key Generation
   echo "* Generating Generic Composite Keys"
   result=$( crypto_test_group_3 )

   # Explicit Composite Key Generation
   echo "* Generating Explicit Composite Keys"
   result=$( crypto_test_group_4 )

   # Single Key PQC CSR Generation (direct signing)
   echo "* Generating Single Key PQC CSRs (direct signing)"
   result=$( crypto_test_group_5 )

   # Single Key PQC CSR Generation (Hash-n-Sign)
   echo "* Generating Single Key PQC CSRs (hash-n-sign)"
   result=$( crypto_test_group_6 )

   # Generic Composite CSR Generation (direct signing)
   echo "* Generating Generic Composite CSRs (direct signing)"
   result=$( crypto_test_group_7 )

   # Generic Composite CSR Generation (Hash-n-Sign)
   echo "* Generating Generic Composite CSRs (hash-n-sign)"
   result=$( crypto_test_group_8 )

done

# Now for the standard artifacts/ directory structure
for dir in ${ARTIFACTS_PREFIX} ; do 

   # Generates the LibPKI directory
   [ -d "${dir}" ] || mkdir -p "${dir}"

   # Cycle through generation of signed material
   # both in direct-sign and hash-n-sign paradigms
   for hash in null sha256 sha384 sha512 ; do

      # PQC Implementation: Dilithium
      result=$(cd ${dir} && gen dilithium2 1.3.6.1.4.1.2.267.7.4.4 ${hash})
      result=$(cd ${dir} && gen dilithium3 1.3.6.1.4.1.2.267.7.6.5 ${hash})
      result=$(cd ${dir} && gen dilithium5 1.3.6.1.4.1.2.267.7.8.7 ${hash})

      # PQC Implementation: Falcon
      result=$(cd ${dir} && gen falcon512 1.3.9999.3.1 ${hash})
      result=$(cd ${dir} && gen falcon1024 1.3.9999.3.4 ${hash})

      # Composite Implementation
      # result=$(cd ${dir} && gen composite 2.16.840.1.114027.80.4.1 ${hash} dilithium2 ec )

      # PQC Implementation: Sphincs+
      # result=$(cd ${dir}/artifacts && gen sphincssha256128frobust 1.3.9999.6.4.1)
   
   done

done

exit 0;