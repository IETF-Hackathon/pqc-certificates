#!/usr/bin/env python3
"""
JOSE/COSE artifacts for ML-DSA, SLH-DSA and Composite ML-DSA+(ECDSA|Ed25519|Ed448).

Use dilithium-py (ML-DSA), slhdsa (SLH-DSA) and pyca/cryptography
(ECDSA, Ed25519, Ed448). Implements RFC 9964, draft-ietf-cose-sphincs-plus
and draft-ietf-jose-pq-composite-sigs.
"""

import base64
import hashlib
import json
import os
import shutil
import sys
import zipfile

import cbor2
from dilithium_py.ml_dsa import ML_DSA_44, ML_DSA_65, ML_DSA_87
import slhdsa
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives.asymmetric.utils import decode_dss_signature, encode_dss_signature
from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey, Ed25519PublicKey
from cryptography.hazmat.primitives.asymmetric.ed448 import Ed448PrivateKey, Ed448PublicKey
from cryptography.hazmat.primitives import hashes, serialization

PROVIDER = "pqc-jose-cose-py-ref"
ARTIFACT_DIR = "artifacts_jose_cose_v1"
PAYLOAD = b"This is a test of signature data"

MLDSA_IMPL = {44: ML_DSA_44, 65: ML_DSA_65, 87: ML_DSA_87}

SIMPLE_ALGS = {
    "ML-DSA-44": {"kind": "mldsa", "level": 44, "cose_alg": -48},
    "ML-DSA-65": {"kind": "mldsa", "level": 65, "cose_alg": -49},
    "ML-DSA-87": {"kind": "mldsa", "level": 87, "cose_alg": -50},
    "SLH-DSA-SHA2-128s": {"kind": "slhdsa", "params": slhdsa.sha2_128s, "cose_alg": -51},
    "SLH-DSA-SHAKE-128s": {"kind": "slhdsa", "params": slhdsa.shake_128s, "cose_alg": -52},
}

COMPOSITE_PREFIX = b"CompositeAlgorithmSignatures2025"

MLDSA_PUB_LEN = {44: 1312, 65: 1952, 87: 2592}
MLDSA_SIG_LEN = {44: 2420, 65: 3309, 87: 4627}

EC_CURVES = {"P256": ec.SECP256R1(), "P384": ec.SECP384R1()}
EC_HASHES = {"sha256": hashes.SHA256(), "sha384": hashes.SHA384(), "sha512": hashes.SHA512()}
EC_SCALAR_LEN = {"P256": 32, "P384": 48}

EC_ORDER = {
    "P256": 0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551,
    "P384": 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7634D81F4372DDF581A0DB248B0A77AECEC196ACCC52973,
}

COMPOSITE_ALGS = {
    "ML-DSA-44-ES256": {"mldsa_level": 44, "label": b"COMPSIG-MLDSA44-ECDSA-P256-SHA256", "cose_alg": -51,
                         "trad": "ecdsa", "curve": "P256", "trad_hash": "sha256", "prehash": "sha256"},
    "ML-DSA-65-ES256": {"mldsa_level": 65, "label": b"COMPSIG-MLDSA65-ECDSA-P256-SHA512", "cose_alg": -52,
                         "trad": "ecdsa", "curve": "P256", "trad_hash": "sha256", "prehash": "sha512"},
    "ML-DSA-87-ES384": {"mldsa_level": 87, "label": b"COMPSIG-MLDSA87-ECDSA-P384-SHA512", "cose_alg": -53,
                         "trad": "ecdsa", "curve": "P384", "trad_hash": "sha384", "prehash": "sha512"},
    "ML-DSA-44-Ed25519": {"mldsa_level": 44, "label": b"COMPSIG-MLDSA44-Ed25519-SHA512", "cose_alg": -54,
                           "trad": "ed25519", "prehash": "sha512"},
    "ML-DSA-65-Ed25519": {"mldsa_level": 65, "label": b"COMPSIG-MLDSA65-Ed25519-SHA512", "cose_alg": -55,
                           "trad": "ed25519", "prehash": "sha512"},
    "ML-DSA-87-Ed448": {"mldsa_level": 87, "label": b"COMPSIG-MLDSA87-Ed448-SHAKE256", "cose_alg": -56,
                         "trad": "ed448", "prehash": "shake256"},
}


def b64u(data):
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode("ascii")


def b64u_decode(s):
    pad = "=" * (-len(s) % 4)
    return base64.urlsafe_b64decode(s + pad)


def jwk_thumbprint(algid, pub):
    canonical = json.dumps({"alg": algid, "kty": "AKP", "pub": b64u(pub)},
                            separators=(",", ":"), sort_keys=True)
    return b64u(hashlib.sha256(canonical.encode()).digest())


def cose_thumbprint(cose_alg, pub):
    canonical = cbor2.dumps({1: 7, 3: cose_alg, -1: pub}, canonical=True)
    return hashlib.sha256(canonical).digest()


# --- pure algorithms ---

def keygen_simple(algid):
    info = SIMPLE_ALGS[algid]
    if info["kind"] == "mldsa":
        seed = os.urandom(32)
        pub, _ = MLDSA_IMPL[info["level"]].key_derive(seed)
        return pub, seed
    kp = slhdsa.KeyPair.gen(info["params"])
    pub = b"".join(kp.pub.key)
    priv = b"".join(kp.sec.key)
    return pub, priv


def sign_simple(algid, priv, message):
    info = SIMPLE_ALGS[algid]
    if info["kind"] == "mldsa":
        impl = MLDSA_IMPL[info["level"]]
        _, sk = impl.key_derive(priv)
        return impl.sign(sk, message, ctx=b"")
    sec = slhdsa.SecretKey.from_digest(priv, info["params"])
    return sec.sign_pure(message, ctx=b"")


def verify_simple(algid, pub, message, sig):
    info = SIMPLE_ALGS[algid]
    if info["kind"] == "mldsa":
        return MLDSA_IMPL[info["level"]].verify(pub, message, sig, ctx=b"")
    pk = slhdsa.PublicKey.from_digest(pub, info["params"])
    return pk.verify_pure(message, sig, ctx=b"")


# --- composite ML-DSA + (ECDSA | Ed25519 | Ed448) ---

def _prehash(name, data):
    if name == "sha256":
        return hashlib.sha256(data).digest()
    if name == "sha512":
        return hashlib.sha512(data).digest()
    if name == "shake256":
        return hashlib.shake_256(data).digest(64)
    raise ValueError(name)


def _trad_keygen(info):
    kind = info["trad"]
    if kind == "ecdsa":
        priv = ec.generate_private_key(EC_CURVES[info["curve"]])
        sec1 = priv.public_key().public_bytes(serialization.Encoding.X962, serialization.PublicFormat.UncompressedPoint)
        scalar_len = EC_SCALAR_LEN[info["curve"]]
        return sec1[1:], priv.private_numbers().private_value.to_bytes(scalar_len, "big")
    cls = Ed25519PrivateKey if kind == "ed25519" else Ed448PrivateKey
    priv = cls.generate()
    pub = priv.public_key().public_bytes(serialization.Encoding.Raw, serialization.PublicFormat.Raw)
    return pub, priv.private_bytes(serialization.Encoding.Raw, serialization.PrivateFormat.Raw,
                                    serialization.NoEncryption())


def _trad_sign(info, priv, data):
    kind = info["trad"]
    if kind == "ecdsa":
        scalar = int.from_bytes(priv, "big")
        ec_priv = ec.derive_private_key(scalar, EC_CURVES[info["curve"]])
        der_sig = ec_priv.sign(data, ec.ECDSA(EC_HASHES[info["trad_hash"]]))
        r, s = decode_dss_signature(der_sig)
        n = EC_ORDER[info["curve"]]
        if s > n // 2:
            s = n - s
        scalar_len = EC_SCALAR_LEN[info["curve"]]
        return r.to_bytes(scalar_len, "big") + s.to_bytes(scalar_len, "big")
    cls = Ed25519PrivateKey if kind == "ed25519" else Ed448PrivateKey
    return cls.from_private_bytes(priv).sign(data)


def _trad_verify(info, pub, data, sig):
    kind = info["trad"]
    try:
        if kind == "ecdsa":
            scalar_len = EC_SCALAR_LEN[info["curve"]]
            r = int.from_bytes(sig[:scalar_len], "big")
            s = int.from_bytes(sig[scalar_len:], "big")
            der_sig = encode_dss_signature(r, s)
            ec_pub = ec.EllipticCurvePublicKey.from_encoded_point(EC_CURVES[info["curve"]], b"\x04" + pub)
            ec_pub.verify(der_sig, data, ec.ECDSA(EC_HASHES[info["trad_hash"]]))
        else:
            cls = Ed25519PublicKey if kind == "ed25519" else Ed448PublicKey
            cls.from_public_bytes(pub).verify(sig, data)
        return True
    except Exception:
        return False


def keygen_composite(algid):
    info = COMPOSITE_ALGS[algid]
    mldsa_seed = os.urandom(32)
    mldsa_pub, _ = MLDSA_IMPL[info["mldsa_level"]].key_derive(mldsa_seed)
    trad_pub, trad_priv = _trad_keygen(info)
    return mldsa_pub + trad_pub, mldsa_seed + trad_priv


def _composite_message_repr(algid, msg_to_sign):
    info = COMPOSITE_ALGS[algid]
    ph = _prehash(info["prehash"], msg_to_sign)
    return COMPOSITE_PREFIX + info["label"] + b"\x00" + ph


def sign_composite(algid, priv, msg_to_sign):
    info = COMPOSITE_ALGS[algid]
    mldsa_seed, trad_priv = priv[:32], priv[32:]
    m_prime = _composite_message_repr(algid, msg_to_sign)

    _, mldsa_sk = MLDSA_IMPL[info["mldsa_level"]].key_derive(mldsa_seed)
    mldsa_sig = MLDSA_IMPL[info["mldsa_level"]].sign(mldsa_sk, m_prime, ctx=info["label"])
    trad_sig = _trad_sign(info, trad_priv, m_prime)

    return mldsa_sig + trad_sig


def verify_composite(algid, pub, msg_to_sign, sig):
    info = COMPOSITE_ALGS[algid]
    pub_split = MLDSA_PUB_LEN[info["mldsa_level"]]
    sig_split = MLDSA_SIG_LEN[info["mldsa_level"]]
    mldsa_pub, trad_pub = pub[:pub_split], pub[pub_split:]
    mldsa_sig, trad_sig = sig[:sig_split], sig[sig_split:]

    m_prime = _composite_message_repr(algid, msg_to_sign)

    if not MLDSA_IMPL[info["mldsa_level"]].verify(mldsa_pub, m_prime, mldsa_sig, ctx=info["label"]):
        return False
    return _trad_verify(info, trad_pub, m_prime, trad_sig)


# --- generic algorithm dispatch ---

def all_algids():
    return list(SIMPLE_ALGS) + list(COMPOSITE_ALGS)


def is_composite(algid):
    return algid in COMPOSITE_ALGS


def cose_alg_of(algid):
    return SIMPLE_ALGS[algid]["cose_alg"] if algid in SIMPLE_ALGS else COMPOSITE_ALGS[algid]["cose_alg"]


def keygen(algid):
    return keygen_composite(algid) if is_composite(algid) else keygen_simple(algid)


# --- JWS / JWK ---

def build_jwk(algid, pub, priv=None):
    kid = jwk_thumbprint(algid, pub)
    jwk = {"kid": kid, "kty": "AKP", "alg": algid, "pub": b64u(pub)}
    if priv is not None:
        jwk["priv"] = b64u(priv)
    return jwk, kid


def build_jws(algid, priv, kid, payload):
    header = {"alg": algid, "kid": kid}
    signing_input = b64u(json.dumps(header, separators=(",", ":")).encode()) + "." + b64u(payload)
    msg = signing_input.encode("ascii")
    if is_composite(algid):
        sig = sign_composite(algid, priv, msg)
    else:
        sig = sign_simple(algid, priv, msg)
    return signing_input + "." + b64u(sig)


# --- COSE_Key / COSE_Sign1 ---

def build_cose_key(algid, pub, priv=None):
    cose_alg = cose_alg_of(algid)
    kid = cose_thumbprint(cose_alg, pub)
    key = {2: kid, 1: 7, 3: cose_alg, -1: pub}
    if priv is not None:
        key[-2] = priv
    return cbor2.dumps(key, canonical=True), kid


def build_cose_sign1(algid, priv, kid, payload):
    cose_alg = cose_alg_of(algid)
    protected = cbor2.dumps({1: cose_alg, 4: kid}, canonical=True)
    sig_structure = cbor2.dumps(["Signature1", protected, b"", payload], canonical=True)
    if is_composite(algid):
        sig = sign_composite(algid, priv, sig_structure)
    else:
        sig = sign_simple(algid, priv, sig_structure)
    return cbor2.dumps(cbor2.CBORTag(18, [protected, {}, payload, sig]), canonical=True)


def parse_cose_sign1(data):
    tag = cbor2.loads(data)
    protected_bytes, unprotected, payload, sig = tag.value
    protected = cbor2.loads(protected_bytes)
    return protected, protected_bytes, payload, sig


# --- generate ---

def generate(out_dir):
    art_dir = os.path.join(out_dir, ARTIFACT_DIR)
    os.makedirs(art_dir, exist_ok=True)
    with open(os.path.join(art_dir, "payload.txt"), "wb") as f:
        f.write(PAYLOAD)

    for algid in all_algids():
        pub, priv = keygen(algid)

        jwk_pub, kid = build_jwk(algid, pub)
        jwk_priv, _ = build_jwk(algid, pub, priv)
        with open(os.path.join(art_dir, f"{algid}_jwk_pub.json"), "w") as f:
            json.dump(jwk_pub, f, indent=2)
        with open(os.path.join(art_dir, f"{algid}_jwk_priv.json"), "w") as f:
            json.dump(jwk_priv, f, indent=2)

        jws = build_jws(algid, priv, kid, PAYLOAD)
        with open(os.path.join(art_dir, f"{algid}_jws.txt"), "w") as f:
            f.write(jws)

        cose_pub, cose_kid = build_cose_key(algid, pub)
        cose_priv, _ = build_cose_key(algid, pub, priv)
        with open(os.path.join(art_dir, f"{algid}_cose_key_pub.cbor"), "wb") as f:
            f.write(cose_pub)
        with open(os.path.join(art_dir, f"{algid}_cose_key_priv.cbor"), "wb") as f:
            f.write(cose_priv)

        sign1 = build_cose_sign1(algid, priv, cose_kid, PAYLOAD)
        with open(os.path.join(art_dir, f"{algid}_cose_sign1.cbor"), "wb") as f:
            f.write(sign1)

    zip_path = os.path.join(out_dir, f"{ARTIFACT_DIR}.zip")
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as z:
        for name in os.listdir(art_dir):
            z.write(os.path.join(art_dir, name), arcname=f"{ARTIFACT_DIR}/{name}")
    shutil.rmtree(art_dir)
    print(f"wrote {zip_path}")


# --- verify (used both for self-check and cross_verify) ---

def verify_dir(art_dir, out_csv):
    if not os.path.isdir(art_dir):
        sys.exit(f"ERROR: {art_dir} doesn't exist"
                  f"(need to run 'make generate' and 'make unzip' for that provider first)")

    payload_path = os.path.join(art_dir, "payload.txt")
    payload = open(payload_path, "rb").read() if os.path.exists(payload_path) else PAYLOAD

    rows = [("key_algorithm_oid", "type", "test_result")]

    for algid in all_algids():
        jws_path = os.path.join(art_dir, f"{algid}_jws.txt")
        pub_path = os.path.join(art_dir, f"{algid}_jwk_pub.json")
        if os.path.exists(jws_path) and os.path.exists(pub_path):
            pub = b64u_decode(json.load(open(pub_path))["pub"])
            jws = open(jws_path).read().strip()
            header_b64, payload_b64, sig_b64 = jws.split(".")
            signing_input = (header_b64 + "." + payload_b64).encode("ascii")
            sig = b64u_decode(sig_b64)
            try:
                if is_composite(algid):
                    ok = verify_composite(algid, pub, signing_input, sig)
                else:
                    ok = verify_simple(algid, pub, signing_input, sig)
            except Exception:
                ok = False
            rows.append((algid, "jws", "Y" if ok else "N"))

        sign1_path = os.path.join(art_dir, f"{algid}_cose_sign1.cbor")
        cose_pub_path = os.path.join(art_dir, f"{algid}_cose_key_pub.cbor")
        if os.path.exists(sign1_path) and os.path.exists(cose_pub_path):
            pub = cbor2.loads(open(cose_pub_path, "rb").read())[-1]
            protected, protected_bytes, cose_payload, sig = parse_cose_sign1(open(sign1_path, "rb").read())
            sig_structure = cbor2.dumps(["Signature1", protected_bytes, b"", cose_payload], canonical=True)
            try:
                if is_composite(algid):
                    ok = verify_composite(algid, pub, sig_structure, sig)
                else:
                    ok = verify_simple(algid, pub, sig_structure, sig)
            except Exception:
                ok = False
            rows.append((algid, "cose", "Y" if ok else "N"))

    if len(rows) == 1:
        sys.exit(f"ERROR: no recognized artifacts found under {art_dir} "
                  f"(expected files like <algid>_jws.txt, <algid>_cose_sign1.cbor, ...)")

    with open(out_csv, "w") as f:
        for row in rows:
            f.write(",".join(row) + "\n")
    print(f"wrote {out_csv}")


if __name__ == "__main__":
    cmd = sys.argv[1]
    if cmd == "generate":
        generate(sys.argv[2] if len(sys.argv) > 2 else ".")
    elif cmd == "verify":
        verify_dir(sys.argv[2], sys.argv[3])
    else:
        sys.exit(f"unknown command: {cmd}")
