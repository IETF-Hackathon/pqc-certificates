#!/usr/bin/env python3
"""Sanctum PQC extension encoders (DER) — SanctumAttestation + SanctumPQCProfile."""
import hashlib, datetime
from pyasn1.type import univ, char, namedtype, useful
from pyasn1.codec.der.encoder import encode as der_encode

PEN = "1.3.6.1.4.1.65953"
OID_ATTEST  = univ.ObjectIdentifier(f"{PEN}.1.1.1")
OID_PROFILE = univ.ObjectIdentifier(f"{PEN}.1.1.2")

SRC  = {"software":0, "yubikey-piv":1, "pkcs11-hsm":2, "tpm-ek":3}
KIND = {"classical":0, "hybrid":1, "pqc-native":2, "hedge":3}
BAND = {"low":0, "medium":1, "high":2, "critical":3}

def _gtime():
    return useful.GeneralizedTime(datetime.datetime.now(datetime.timezone.utc).strftime("%Y%m%d%H%M%SZ"))

class SanctumAttestation(univ.Sequence):
    componentType = namedtype.NamedTypes(
        namedtype.DefaultedNamedType("version", univ.Integer(1)),
        namedtype.NamedType("profileOID", univ.ObjectIdentifier()),
        namedtype.NamedType("compositeAlgOID", univ.ObjectIdentifier()),
        namedtype.NamedType("attestationSource", univ.Enumerated()),
        namedtype.NamedType("keyBindingHash", univ.OctetString()),
        namedtype.NamedType("signingMechanism", char.UTF8String()),
        namedtype.NamedType("buildProvenance", char.UTF8String()),
        namedtype.OptionalNamedType("tokenLabel", char.UTF8String()),
        namedtype.OptionalNamedType("tokenSerial", char.UTF8String()),
        namedtype.NamedType("producedAt", useful.GeneralizedTime()),
    )

class SanctumPQCProfile(univ.Sequence):
    componentType = namedtype.NamedTypes(
        namedtype.DefaultedNamedType("version", univ.Integer(1)),
        namedtype.NamedType("profileOID", univ.ObjectIdentifier()),
        namedtype.NamedType("profileKind", univ.Enumerated()),
        namedtype.NamedType("componentAlgs", univ.SequenceOf(componentType=univ.ObjectIdentifier())),
        namedtype.NamedType("nistPQCLevel", univ.Integer()),
        namedtype.NamedType("harvestRiskBand", univ.Enumerated()),
        namedtype.NamedType("migrationPhase", char.UTF8String()),
        namedtype.OptionalNamedType("relyingPartyReadiness", univ.Integer()),
    )

def build_attestation(profile_oid, composite_oid, spki_der, source="yubikey-piv",
                      mechanism="CKM_SHA512_RSA_PKCS_PSS", build_provenance="oqs-real",
                      token_label=None, token_serial=None):
    a = SanctumAttestation()
    a["version"] = 1
    a["profileOID"] = univ.ObjectIdentifier(profile_oid)
    a["compositeAlgOID"] = univ.ObjectIdentifier(composite_oid)
    a["attestationSource"] = SRC[source]
    a["keyBindingHash"] = univ.OctetString(hashlib.sha512(spki_der).digest())
    a["signingMechanism"] = mechanism
    a["buildProvenance"] = build_provenance
    if token_label:  a["tokenLabel"] = token_label
    if token_serial: a["tokenSerial"] = token_serial
    a["producedAt"] = _gtime()
    return der_encode(a)

def build_profile(profile_oid, kind, component_oids, nist_level, risk_band,
                  migration_phase, rp_readiness=None):
    p = SanctumPQCProfile()
    p["version"] = 1
    p["profileOID"] = univ.ObjectIdentifier(profile_oid)
    p["profileKind"] = KIND[kind]
    algs = univ.SequenceOf(componentType=univ.ObjectIdentifier())
    for i, o in enumerate(component_oids):
        algs.setComponentByPosition(i, univ.ObjectIdentifier(o))
    p["componentAlgs"] = algs
    p["nistPQCLevel"] = nist_level
    p["harvestRiskBand"] = BAND[risk_band]
    p["migrationPhase"] = migration_phase
    if rp_readiness is not None:
        p["relyingPartyReadiness"] = rp_readiness
    return der_encode(p)

if __name__ == "__main__":
    dummy_spki = b"\x30\x82\x01\x22" + b"\x00"*290
    att = build_attestation(f"{PEN}.1.2.1", "2.16.840.1.114027.80.8.1.22", dummy_spki,
                            token_label="YubiKey PIV #12345678", token_serial="12345678")
    prof = build_profile(f"{PEN}.1.2.1", "hybrid",
                         ["2.16.840.1.101.3.4.3.18", "1.2.840.10045.4.3.2"],
                         3, "high", "cnsa2-tls-2029", rp_readiness=42)
    print("SanctumAttestation DER bytes:", len(att), att[:16].hex())
    print("SanctumPQCProfile  DER bytes:", len(prof), prof[:16].hex())
