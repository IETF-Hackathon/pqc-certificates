#!/usr/bin/env python3
import subprocess
import sys
from dataclasses import dataclass
import functools

@dataclass(frozen=True)
class Algorithm:
    name: str
    oid: str

ML_DSA_ALGS = [
    Algorithm("ML-DSA-44", "2.16.840.1.101.3.4.3.17"),
    Algorithm("ML-DSA-65", "2.16.840.1.101.3.4.3.18"),
    Algorithm("ML-DSA-87", "2.16.840.1.101.3.4.3.19"),
]

# Aurora supports only a subset of SLH-DSA-SHAKE
SLH_DSA_ALGS = [
    # Algorithm("SLH-DSA-SHA2-128s", "2.16.840.1.101.3.4.3.20"),
    # Algorithm("SLH-DSA-SHA2-128f", "2.16.840.1.101.3.4.3.21"),
    # Algorithm("SLH-DSA-SHA2-192s", "2.16.840.1.101.3.4.3.22"),
    # Algorithm("SLH-DSA-SHA2-192f", "2.16.840.1.101.3.4.3.23"),
    # Algorithm("SLH-DSA-SHA2-256s", "2.16.840.1.101.3.4.3.24"),
    # Algorithm("SLH-DSA-SHA2-256f", "2.16.840.1.101.3.4.3.25"),

    # Algorithm("SLH-DSA-SHAKE-128s", "2.16.840.1.101.3.4.3.26"),
    Algorithm("SLH-DSA-SHAKE-128f", "2.16.840.1.101.3.4.3.27"),
    # Algorithm("SLH-DSA-SHAKE-192s", "2.16.840.1.101.3.4.3.28"),
    Algorithm("SLH-DSA-SHAKE-192f", "2.16.840.1.101.3.4.3.29"),
    Algorithm("SLH-DSA-SHAKE-256s", "2.16.840.1.101.3.4.3.30"),
    # Algorithm("SLH-DSA-SHAKE-256f", "2.16.840.1.101.3.4.3.31"),
]

# Aurora supports only a subset of the ML-DSA Composite sigs
COMPOSITE_ML_DSA_ALGS = [
    Algorithm("id-MLDSA44-Ed25519-SHA512", "1.3.6.1.5.5.7.6.39"),
    Algorithm("id-MLDSA65-Ed25519-SHA512", "1.3.6.1.5.5.7.6.48"),
    # Algorithm("id-MLDSA87-Ed448-SHAKE256", "1.3.6.1.5.5.7.6.51"),
]

ALGORITHMS = ML_DSA_ALGS + SLH_DSA_ALGS + COMPOSITE_ML_DSA_ALGS

# The lru annotation ensures this function only runs only once
@functools.lru_cache(maxsize=1)
def _aurora_algs():
    cmd = [
        "openssl",
         "list",
         "--signature-algorithms",
         #"--kem-algorithms",
         "--propquery", "provider=aurora",
    ]

    try:
        return subprocess.run(cmd,
            check=True, capture_output=True, text=True,
        ).stdout
    except (FileNotFoundError, subprocess.CalledProcessError):
        print(f"error: command not found: {cmd[0]}", file=sys.stderr)
        sys.exit(1)

def check_aurora_is_loaded():
    cmd = [
        "openssl",
         "list",
         "--providers",
    ]

    try:
        out = subprocess.run(cmd, check=True, capture_output=True, text=True).stdout
    except (FileNotFoundError, subprocess.CalledProcessError):
        print(f"error: command not found: {cmd[0]}", file=sys.stderr)
        sys.exit(1)

    return "aurora" in out

def is_supported(algo):
    """True if OpenSSL lists the algorithm's OID among its supported algorithms."""
    return f" {algo.oid}," in _aurora_algs()

def gen_cert(algo, out_dir="artifacts_certs_r5"):
    """Generate a certificate for the given algorithm using openssl."""
    import os
    os.makedirs(out_dir, exist_ok=True)

    key_path = os.path.join(out_dir, f"{algo.name}-{algo.oid}_priv.der.do_not_submit")
    cert_path = os.path.join(out_dir, f"{algo.name}-{algo.oid}_ta.der")

    cn_str = f"QUBIP-aurora {algo.name} TA certificate"

    propquery = ["-propquery", "?provider=aurora",]
    keygen_cmd = [
        "openssl", "genpkey",
        "-algorithm", algo.name,
        "-out", key_path,
        "-outform", "DER",
    ] + propquery
    certgen_cmd = [
        "openssl", "req", "-x509", "-new",
        "-key", key_path,
        "-out", cert_path,
        "-outform", "DER",
        "-days", "3650",
        "-nodes",
        "-subj", f"/CN={cn_str}",
    ] + propquery

    for step, cmd in (("keygen", keygen_cmd), ("certgen", certgen_cmd)):
        try:
            print(f"***** INFO: [{algo.name}] {step} *****", file=sys.stderr)
            subprocess.run(cmd, check=True, capture_output=True, text=True)
        except FileNotFoundError:
            print(f"[{algo.name}] error: command not found: {cmd[0]}", file=sys.stderr)
            return False
        except subprocess.CalledProcessError as e:
            print(f"[{algo.name}] {step} failed (exit {e.returncode}):\n{e.stderr}",
                  file=sys.stderr)
            return False

    print(f"[{algo.name}] oid={algo.oid} -> {cert_path}")
    return True

def main(argv=None):
    argv = argv if argv is not None else sys.argv[1:]

    # Check if the aurora provider is loaded
    if not check_aurora_is_loaded():
        print(f"error: aurora provider is not loaded", file=sys.stderr)
        return 1

    # Optional: filter to specific algorithm names passed on the command line.
    if argv:
        selected = [a for a in ALGORITHMS if a.name in set(argv)]
        unknown = set(argv) - {a.name for a in ALGORITHMS}
        for name in sorted(unknown):
            print(f"warning: unknown algorithm '{name}'", file=sys.stderr)
    else:
        selected = ALGORITHMS

    if not selected:
        print("no algorithms selected", file=sys.stderr)
        return 1

    ret = 0
    skipped = 0
    failures = 0
    generated = 0
    for algo in selected:
        if not is_supported(algo):
            print(f"[{algo.name}] skipped: oid {algo.oid} not supported",
                  file=sys.stderr)
            skipped += 1
            continue
        if not gen_cert(algo):
            failures += 1
        else:
            generated += 1

    if skipped:
        print(f"\n{skipped} of {len(selected)} skipped", file=sys.stderr)

    if failures:
        print(f"\n{failures} of {len(selected)} failed", file=sys.stderr)
        ret = 1

    print(f"\n{generated} of {len(selected)} certificates generated")
    return ret

if __name__ == "__main__":
    sys.exit(main())
