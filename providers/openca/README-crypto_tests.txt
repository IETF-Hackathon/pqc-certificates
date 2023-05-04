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

