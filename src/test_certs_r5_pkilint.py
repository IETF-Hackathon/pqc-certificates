#!/usr/bin/env python3
"""Lint the R5 certificates with pkilint, for the automated results.

Every pure ML-DSA, SLH-DSA and ML-KEM certificate in a providers/*/artifacts_certs_r5.zip
(<friendly>-<oid>_ta.der and <friendly>-<oid>_ee.der, in any folder of the zip; external_,
catalyst_ and chameleon_ files are skipped) is linted with pkilint's lint_pkix_cert. The
files are read from the zips; nothing is extracted.

Writes into output/certs/:
  <provider>_pkilint.csv  one `cert` row per OID, shown in the pkilint column of the automated
                          results: Y (no finding at the threshold or above), W (a WARNING or ERROR
                          finding at the threshold or above, shown as a warning sign) or N (a FATAL
                          finding: pkilint could not decode the certificate, shown as a cross).
                          The warning sign and the cross link to pkilint_certs.html.
  pkilint_certs.md        every finding at WARNING and above, per provider and certificate
                          (published as pkilint_certs.html)
  pkilint_certs.log       the same findings as plain text

Usage:
  python3 src/test_certs_r5_pkilint.py              # every providers/*/artifacts_certs_r5.zip
  python3 src/test_certs_r5_pkilint.py <zip> ...    # some zips (the provider is the folder name)
Needs pkilint (pip install pkilint). PKILINT_MIN_SEVERITY (WARNING, ERROR or FATAL, default
WARNING) is the lowest severity that gives W; a FATAL finding always gives N.
"""
import csv
import glob
import io
import os
import re
import subprocess
import sys
import zipfile
from datetime import datetime, timezone
from importlib.metadata import version

OUTPUT_DIR = "./output/certs"
LINT_PAGE = "pkilint_certs"
# id-ml-dsa-44..87 (3.17-3.19), id-slh-dsa-* (3.20-3.31), id-alg-ml-kem-512..1024 (4.1-4.3)
CERT_NAME = re.compile(r"-(2\.16\.840\.1\.101\.3\.4\.(?:3\.(?:1[7-9]|2[0-9]|3[01])|4\.[1-3]))_(ta|ee)\.der$")
HYBRID_PREFIXES = ("external_", "catalyst_", "chameleon_")
SEVERITY_ORDER = ["DEBUG", "INFO", "NOTICE", "WARNING", "ERROR", "FATAL"]
RESULT_ORDER = ["Y", "W", "N"]


def anchor(provider):
    """The id of a provider's section on the findings page (also used by the report writer)."""
    return re.sub(r"[^a-z0-9]+", "-", provider.lower()).strip("-")


def lint(der):
    """pkilint's findings at WARNING and above, as (node_path, validator, severity, code, message)."""
    p = subprocess.run(["lint_pkix_cert", "lint", "-s", "WARNING", "-f", "CSV", "--document-format", "DER", "-"],
                       input=der, capture_output=True)
    out = p.stdout.decode(errors="replace")
    # The exit status is the number of findings, so only a missing CSV header means a failed run.
    if not out.startswith("node_path,"):
        raise RuntimeError(f"lint_pkix_cert exited with {p.returncode}: {p.stderr.decode(errors='replace')}")
    rows = list(csv.reader(io.StringIO(out)))
    return [tuple(r[:5]) for r in rows[1:] if len(r) >= 5]


def md_cell(text):
    return str(text).replace("|", "\\|").replace("\n", " ")


def main():
    threshold = os.environ.get("PKILINT_MIN_SEVERITY", "WARNING").upper()
    if threshold not in ("WARNING", "ERROR", "FATAL"):
        sys.exit(f"PKILINT_MIN_SEVERITY must be WARNING, ERROR or FATAL, not {threshold}")
    zips = sys.argv[1:] or sorted(glob.glob("providers/*/artifacts_certs_r5.zip"))
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    findings = {}  # provider -> [(file, node_path, validator, severity, code, message)]
    certs = {}     # provider -> number of certificates linted
    for zip_path in zips:
        provider = os.path.basename(os.path.dirname(os.path.abspath(zip_path)))
        results = {}  # oid -> 'Y', 'W' or 'N'
        found = []
        with zipfile.ZipFile(zip_path) as zf:
            for name in sorted(zf.namelist()):
                base = os.path.basename(name)
                m = CERT_NAME.search(base)
                if not m or base.startswith(HYBRID_PREFIXES):
                    continue
                oid = m.group(1)
                rows = lint(zf.read(name))
                certs[provider] = certs.get(provider, 0) + 1
                found += [(base,) + r for r in rows]
                worst = max((SEVERITY_ORDER.index(r[2]) for r in rows if r[2] in SEVERITY_ORDER), default=-1)
                if worst == SEVERITY_ORDER.index("FATAL"):
                    result = "N"
                elif worst >= SEVERITY_ORDER.index(threshold):
                    result = "W"
                else:
                    result = "Y"
                prev = results.get(oid)  # several files for one OID: the worst result wins
                if prev is None or RESULT_ORDER.index(result) > RESULT_ORDER.index(prev):
                    results[oid] = result
        if not results:
            continue
        findings[provider] = found
        with open(os.path.join(OUTPUT_DIR, f"{provider}_pkilint.csv"), "w", newline="") as f:
            w = csv.writer(f, lineterminator="\n")
            w.writerow(["key_algorithm_oid", "type", "test_result"])
            for oid in sorted(results, key=lambda o: [int(x) for x in o.split(".")]):
                w.writerow([oid, "cert", results[oid]])

    when = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    pkilint_version = version("pkilint")
    total = sum(certs.values())
    with open(os.path.join(OUTPUT_DIR, f"{LINT_PAGE}.md"), "w") as md, \
         open(os.path.join(OUTPUT_DIR, f"{LINT_PAGE}.log"), "w") as log:
        md.write("# pkilint findings for the R5 certificates\n\n")
        # Same table style as the results pages.
        md.write("<style> table { border-collapse: collapse; width:auto !important; } th, td { border: solid black 1px; "
                 "padding: 0 1ex; } </style>\n\n")
        md.write(f"Generated: {when}. pkilint {pkilint_version} (`lint_pkix_cert`) on {total} pure ML-DSA, "
                 f"SLH-DSA and ML-KEM certificates from {len(findings)} providers; findings at WARNING and above.\n\n")
        warn = {"WARNING": "⚠️ = a WARNING or ERROR finding; ", "ERROR": "⚠️ = an ERROR finding; ", "FATAL": ""}[threshold]
        md.write("In the pkilint column of the automated results, which is separate from the verifiers' columns "
                 f"and not counted in the summary: ✅ = no finding at {threshold} or above; {warn}❌ = a FATAL "
                 "finding (pkilint could not decode the certificate, for example because it is not DER). "
                 "⚠️ and ❌ link to the provider's section below.\n\n")
        md.write("To check a zip before pushing it: `pip install pkilint`, then "
                 "`python3 src/test_certs_r5_pkilint.py providers/<name>/artifacts_certs_r5.zip`, or "
                 "`unzip -p <zip> <entry> | lint_pkix_cert lint --document-format DER -` for one certificate.\n\n")
        log.write(f"pkilint {pkilint_version}, {when}, W from {threshold}, N for FATAL\n")
        for provider in sorted(findings, key=str.lower):
            md.write(f"## {provider} {{#{anchor(provider)}}}\n\n")
            rows = findings[provider]
            if not rows:
                md.write(f"No findings at WARNING or above ({certs[provider]} certificates).\n\n")
                log.write(f"\n{provider}: no findings ({certs[provider]} certificates)\n")
                continue
            md.write("| Certificate | Field | Severity | Code | Message |\n|---|---|---|---|---|\n")
            log.write(f"\n{provider}:\n")
            for base, node, validator, severity, code, message in rows:
                md.write(f"| {md_cell(base)} | `{md_cell(node)}` | {severity} | `{md_cell(code)}` | {md_cell(message)} |\n")
                log.write(f"  {base}: {severity} {code} at {node}" + (f": {message}" if message else "") + "\n")
            md.write("\n")
    print(f"pkilint {pkilint_version}: {total} certificates from {len(findings)} providers, threshold {threshold}")


if __name__ == "__main__":
    main()
