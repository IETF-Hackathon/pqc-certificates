# Sanctum PQC Certificates

This directory contains 95 certificates for the OIDs in `../sanctum_meta.json`, honestly tiered by whether a real cryptographic implementation exists.

## Tier summary

| Tier | Count | Meaning |
|------|-------|---------|
| real-pqc | 9 | Genuine PQC key; cert verifies with `openssl verify` |
| experimental-sanctum | 3 | Sanctum PEN 1.3.6.1.4.1.65953 arc; placeholder key, flagged in subject |
| experimental-placeholder | 83 | OID with no current implementation; placeholder key, flagged in subject |

## Real PQC certificates (verifiable)

| OID | Kind | Algorithm | Cert | Verify |
|-----|------|-----------|------|--------|
| 2.16.840.1.101.3.4.3.19 | sig | ML-DSA-87 | `ee_2_16_840_1_101_3_4_3_19.crt` | OK |
| 2.16.840.1.101.3.4.3.20 | sig | SLH-DSA-SHA2-128s | `ee_2_16_840_1_101_3_4_3_20.crt` | OK |
| 2.16.840.1.101.3.4.3.21 | sig | SLH-DSA-SHA2-128f | `ee_2_16_840_1_101_3_4_3_21.crt` | OK |
| 2.16.840.1.101.3.4.3.22 | sig | SLH-DSA-SHA2-192s | `ee_2_16_840_1_101_3_4_3_22.crt` | OK |
| 2.16.840.1.101.3.4.3.23 | sig | SLH-DSA-SHA2-192f | `ee_2_16_840_1_101_3_4_3_23.crt` | OK |
| 2.16.840.1.101.3.4.3.24 | sig | SLH-DSA-SHA2-256s | `ee_2_16_840_1_101_3_4_3_24.crt` | OK |
| 2.16.840.1.101.3.4.4.1 | kem | ML-KEM-512 | `ee_2_16_840_1_101_3_4_4_1.crt` | OK |
| 2.16.840.1.101.3.4.4.2 | kem | ML-KEM-768 | `ee_2_16_840_1_101_3_4_4_2.crt` | OK |
| 2.16.840.1.101.3.4.4.3 | kem | ML-KEM-1024 | `ee_2_16_840_1_101_3_4_4_3.crt` | OK |

## Experimental / placeholder certificates

These carry `PLACEHOLDER` in the subject DN and must **not** be treated as working implementations. ISO Classic McEliece / FrodoKEM (`1.0.18033.*`) and the Sanctum experimental arc have no implementation yet.

| OID | Kind | Tier | Cert |
|-----|------|------|------|
| 1.0.18033.2.2.6.1 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_1.crt` |
| 1.0.18033.2.2.6.10 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_10.crt` |
| 1.0.18033.2.2.6.11 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_11.crt` |
| 1.0.18033.2.2.6.12 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_12.crt` |
| 1.0.18033.2.2.6.13 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_13.crt` |
| 1.0.18033.2.2.6.14 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_14.crt` |
| 1.0.18033.2.2.6.15 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_15.crt` |
| 1.0.18033.2.2.6.16 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_16.crt` |
| 1.0.18033.2.2.6.2 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_2.crt` |
| 1.0.18033.2.2.6.3 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_3.crt` |
| 1.0.18033.2.2.6.4 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_4.crt` |
| 1.0.18033.2.2.6.5 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_5.crt` |
| 1.0.18033.2.2.6.6 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_6.crt` |
| 1.0.18033.2.2.6.7 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_7.crt` |
| 1.0.18033.2.2.6.8 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_8.crt` |
| 1.0.18033.2.2.6.9 | kem | experimental-placeholder | `ee_1_0_18033_2_2_6_9.crt` |
| 1.0.18033.2.2.7.1 | kem | experimental-placeholder | `ee_1_0_18033_2_2_7_1.crt` |
| 1.0.18033.2.2.7.2 | kem | experimental-placeholder | `ee_1_0_18033_2_2_7_2.crt` |
| 1.0.18033.2.2.7.3 | kem | experimental-placeholder | `ee_1_0_18033_2_2_7_3.crt` |
| 1.0.18033.2.2.7.4 | kem | experimental-placeholder | `ee_1_0_18033_2_2_7_4.crt` |
| 1.0.18033.2.2.7.5 | kem | experimental-placeholder | `ee_1_0_18033_2_2_7_5.crt` |
| 1.0.18033.2.2.7.6 | kem | experimental-placeholder | `ee_1_0_18033_2_2_7_6.crt` |
| 1.0.18033.2.2.7.7 | kem | experimental-placeholder | `ee_1_0_18033_2_2_7_7.crt` |
| 1.0.18033.2.2.7.8 | kem | experimental-placeholder | `ee_1_0_18033_2_2_7_8.crt` |
| 1.3.6.1.4.1.22554.5.5.1 | kem | experimental-placeholder | `ee_1_3_6_1_4_1_22554_5_5_1.crt` |
| 1.3.6.1.4.1.22554.5.5.2 | kem | experimental-placeholder | `ee_1_3_6_1_4_1_22554_5_5_2.crt` |
| 1.3.6.1.4.1.22554.5.5.3 | kem | experimental-placeholder | `ee_1_3_6_1_4_1_22554_5_5_3.crt` |
| 1.3.6.1.4.1.22554.5.5.4 | kem | experimental-placeholder | `ee_1_3_6_1_4_1_22554_5_5_4.crt` |
| 1.3.6.1.4.1.22554.5.5.5 | kem | experimental-placeholder | `ee_1_3_6_1_4_1_22554_5_5_5.crt` |
| 1.3.6.1.4.1.22554.5.5.6 | kem | experimental-placeholder | `ee_1_3_6_1_4_1_22554_5_5_6.crt` |
| 1.3.6.1.4.1.65953.1.1.1 | sig | experimental-sanctum | `ee_1_3_6_1_4_1_65953_1_1_1.crt` |
| 1.3.6.1.4.1.65953.1.100.1 | sig | experimental-sanctum | `ee_1_3_6_1_4_1_65953_1_100_1.crt` |
| 1.3.6.1.4.1.65953.1.2.1 | kem | experimental-sanctum | `ee_1_3_6_1_4_1_65953_1_2_1.crt` |
| 1.3.6.1.5.5.7.6.37 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_37.crt` |
| 1.3.6.1.5.5.7.6.38 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_38.crt` |
| 1.3.6.1.5.5.7.6.39 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_39.crt` |
| 1.3.6.1.5.5.7.6.40 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_40.crt` |
| 1.3.6.1.5.5.7.6.41 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_41.crt` |
| 1.3.6.1.5.5.7.6.42 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_42.crt` |
| 1.3.6.1.5.5.7.6.43 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_43.crt` |
| 1.3.6.1.5.5.7.6.44 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_44.crt` |
| 1.3.6.1.5.5.7.6.45 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_45.crt` |
| 1.3.6.1.5.5.7.6.46 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_46.crt` |
| 1.3.6.1.5.5.7.6.47 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_47.crt` |
| 1.3.6.1.5.5.7.6.48 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_48.crt` |
| 1.3.6.1.5.5.7.6.49 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_49.crt` |
| 1.3.6.1.5.5.7.6.50 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_50.crt` |
| 1.3.6.1.5.5.7.6.51 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_51.crt` |
| 1.3.6.1.5.5.7.6.52 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_52.crt` |
| 1.3.6.1.5.5.7.6.53 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_53.crt` |
| 1.3.6.1.5.5.7.6.54 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_54.crt` |
| 1.3.6.1.5.5.7.6.55 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_55.crt` |
| 1.3.6.1.5.5.7.6.56 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_56.crt` |
| 1.3.6.1.5.5.7.6.57 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_57.crt` |
| 1.3.6.1.5.5.7.6.58 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_58.crt` |
| 1.3.6.1.5.5.7.6.59 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_59.crt` |
| 1.3.6.1.5.5.7.6.60 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_60.crt` |
| 1.3.6.1.5.5.7.6.61 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_61.crt` |
| 1.3.6.1.5.5.7.6.62 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_62.crt` |
| 1.3.6.1.5.5.7.6.63 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_63.crt` |
| 1.3.6.1.5.5.7.6.64 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_64.crt` |
| 1.3.6.1.5.5.7.6.65 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_65.crt` |
| 1.3.6.1.5.5.7.6.66 | sig | experimental-placeholder | `ee_1_3_6_1_5_5_7_6_66.crt` |
| 1.3.9999 | sig | experimental-placeholder | `ee_1_3_9999.crt` |
| 2.16.840.1.101.3.4.3.25 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_25.crt` |
| 2.16.840.1.101.3.4.3.26 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_26.crt` |
| 2.16.840.1.101.3.4.3.27 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_27.crt` |
| 2.16.840.1.101.3.4.3.28 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_28.crt` |
| 2.16.840.1.101.3.4.3.29 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_29.crt` |
| 2.16.840.1.101.3.4.3.30 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_30.crt` |
| 2.16.840.1.101.3.4.3.31 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_31.crt` |
| 2.16.840.1.101.3.4.3.32 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_32.crt` |
| 2.16.840.1.101.3.4.3.33 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_33.crt` |
| 2.16.840.1.101.3.4.3.34 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_34.crt` |
| 2.16.840.1.101.3.4.3.35 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_35.crt` |
| 2.16.840.1.101.3.4.3.36 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_36.crt` |
| 2.16.840.1.101.3.4.3.37 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_37.crt` |
| 2.16.840.1.101.3.4.3.38 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_38.crt` |
| 2.16.840.1.101.3.4.3.39 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_39.crt` |
| 2.16.840.1.101.3.4.3.40 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_40.crt` |
| 2.16.840.1.101.3.4.3.41 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_41.crt` |
| 2.16.840.1.101.3.4.3.42 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_42.crt` |
| 2.16.840.1.101.3.4.3.43 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_43.crt` |
| 2.16.840.1.101.3.4.3.44 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_44.crt` |
| 2.16.840.1.101.3.4.3.45 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_45.crt` |
| 2.16.840.1.101.3.4.3.46 | sig | experimental-placeholder | `ee_2_16_840_1_101_3_4_3_46.crt` |

## Notes on honesty

- Private keys (`*.key`) are excluded via `.gitignore`; only public certs are committed.

- KEM certs (ML-KEM) carry a real KEM public key signed by an ML-DSA-65 TA, since KEM keys cannot self-sign.

- Evidence JSON in `../hw_artifacts/all_checks/` uses `attestation_source: software` for all PQC operations; no PQC artifact claims hardware attestation.
