#!/usr/bin/env python3
"""Check that the R5 certificate and CMS v3 artifacts conform to their zip formats and the RFCs.

The verifiers check that signatures verify, keys decapsulate and messages decrypt, which they can
do even when an artifact is wrong: a key identified by the wrong OID, a private key file holding
two keys, or two different certificates for one OID. This checks the artifacts themselves against
the zip formats (readme.md, "Zip Format (R5)" and "CMS -- artifacts_cms_v3.zip") and the algorithm
identifier rules. Key formats and sizes are left to the verifiers, which fail keys they cannot
load (the OpenSSL verifier restricts each CHOICE key to the format its name says). The files are
read from the zips; nothing is extracted.

Results go in two columns of the automated results, counted like the verifiers': r5-conformance
(artifacts_certs_r5.zip) and cms-v3-conformance (artifacts_cms_v3.zip). Only failures are reported
(N): passing these checks shows that an artifact is well formed, not that it interoperates, so a
compliant artifact has no result. Each failure links to a findings page, which also lists the
warnings: things that are unusual or that leave an artifact untestable, but do not make it wrong.

An artifact is a file named <friendlyname>-<oid>_<role>.<ext>, in any folder of the zip. Hybrid
formats (external_, catalyst_ and chameleon_ files, and <format>_<oid1>_with_<oid2>_ta.der) are
skipped.

Failures (N), in the row of the artifact they are found in (artifacts_certs_r5.zip: cert, seed,
expandedkey, both, priv or consistent; artifacts_cms_v3.zip: one row per OID):
  certificates (_ta, _ee):
  - not DER:        not a single DER Certificate
  - signature algs: signatureAlgorithm differs from tbsCertificate.signature (RFC 5280, 4.1.1.2)
  - name OID:       the OID in the file name differs from the public key algorithm
  - self-signed:    a _ta certificate signed with an algorithm other than its public key's: the
                    same OID identifies a key and its signature algorithm (RFC 9881, Section 2;
                    RFC 9909, Section 8; RFC 10073, Section 5)
  - parameters:     AlgorithmIdentifier parameters present
  private keys (_seed_priv, _expandedkey_priv, _both_priv, _priv):
  - not DER:        not a single DER OneAsymmetricKey
  - parameters:     privateKeyAlgorithm parameters present
  - consistent:     a private key whose algorithm differs from its certificate's public key
  CMS messages (_kemri_*, _signed_attrs; also _kemri_<kdf>_ukm and _kemri_auth_<kdf>_ukm, which are
  not in the readme but are tested by the verifiers like the others; the private keys of
  artifacts_cms_v3.zip may also have the CHOICE names, which the OpenSSL verifier's *<oid>*_priv.der
  pattern matches, and are checked like _priv.der):
  - not DER:        not a single DER ContentInfo of the type its name says (EnvelopedData or
                    AuthEnvelopedData for _kemri_*, SignedData for _signed_attrs)
  - KEMRI:          no KEMRecipientInfo (RFC 9629); its KEM algorithm differs from the file name's
                    OID or has parameters
  - signer:         a SignerInfo signature algorithm that differs from the file name's OID
  every row of the OID:
  - duplicate:      the same OID and role in more than one file
The identifier rules are those of the PQC algorithms (ML-DSA, SLH-DSA, ML-KEM and their
composites) and are applied to every algorithm, which is expected to follow the same conventions;
no algorithm OIDs are built in.

As in the OpenSSL verifier, the private keys in the artifacts_certs_r5.zip table are the CHOICE
formats for the algorithms in docs/choice_oids.txt and _priv for the others; the other private key files
are checked, and their findings listed, but not in the table.

Warnings, on the findings page only:
  - unexpected:     a file that is not an artifact of the zip format, with the likely intended
                    name when it looks like a misnamed one
  - incomplete:     an artifact that cannot be tested because a file it needs is missing (a KEM
                    certificate's ciphertext, shared secret or private key, a private key's
                    certificate, ...); a CMS KEM OID with CHOICE-named private keys but no _priv.der
  - key name:       an R5 private key named for the other format: _priv.der for an algorithm in
                    docs/choice_oids.txt, or a CHOICE name for one that is not (its results are not
                    in the table)
  - OID mapping:    an OID that is not in docs/oid_mapping.md, or is struck through there; a
                    friendly name that is the name of a different OID
  - certificate:    a _ta that is not self-issued; a KEM _ee whose issuer is not a trust anchor in
                    the zip
  - CMS:            a _kemri_ukm without UKM or another _kemri_ with one; a _signed_attrs without
                    signed attributes or without attached content
  - packaging:      artifacts in more than one folder, or outside artifacts_cms_v3/; an artifact
                    that is not .der (.bin for ciphertext and ss), e.g. PEM

Writes, for each zip type (certs: output/certs/, r5-conformance; cms: output/cms/, cms-v3-conformance):
  <provider>_<column>.csv     the failures, in that column of the automated results
  <column page>.md            every finding, per provider (r5_conformance_certs, cms_v3_conformance)
  <column page>.log           the same findings as plain text

Usage:
  python3 src/test_artifacts_conformance.py                   # every provider's two zips
  python3 src/test_artifacts_conformance.py <zip> ...         # some zips (provider = folder name)
  python3 src/test_artifacts_conformance.py --output-dir DIR  # write under DIR instead of ./output
Needs pyasn1 and pyasn1-alt-modules. The checks of the names and layout are in src/artifact_names.py, which
src/check_result_files.py also runs on the zips a pull request changes.
"""
import argparse
import csv
import glob
import os
import re
import zipfile
import zlib
from datetime import datetime, timezone

from pyasn1.codec.ber.decoder import decode as ber_decode
from pyasn1.codec.der.decoder import decode as der_decode
from pyasn1.codec.der.encoder import encode as der_encode
from pyasn1.error import PyAsn1Error
from pyasn1_alt_modules import rfc5083, rfc5280, rfc5652, rfc5958, rfc9629

from artifact_names import (CERTS, CMS, FORMATS, KEY_ROLES, REPO, check_names, in_table, load_oid_mapping,
                            row_type)

FAIL, WARNING = "fail", "warning"
# What a damaged zip or zip entry raises
ZIP_ERRORS = (zipfile.BadZipFile, zipfile.LargeZipFile, NotImplementedError, RuntimeError, EOFError, OSError,
              zlib.error)


# --- DER and keys -----------------------------------------------------------------------------

def short_error(e):
    """A pyasn1 error without the schema it prints."""
    text = str(e)
    if " not in asn1Spec" in text:
        return "an unexpected ASN.1 tag"
    return text if len(text) <= 120 else text[:117] + "..."


def decode_der(data, spec, what, **options):
    """Decodes one DER structure, which must re-encode to the same bytes. Returns (value, error)."""
    try:
        value, rest = der_decode(data, asn1Spec=spec, **options)
    except PyAsn1Error as e:
        return None, f"not a {what}: {short_error(e)}"
    if rest:
        return None, f"{len(rest)} bytes after the {what}"
    try:
        if der_encode(value) != data:
            return None, f"the {what} is not DER (it re-encodes differently)"
    except PyAsn1Error as e:
        return None, f"the {what} could not be re-encoded: {short_error(e)}"
    return value, None


def _length(n):
    if n < 0x80:
        return bytes([n])
    size = n.to_bytes((n.bit_length() + 7) // 8, "big")
    return bytes([0x80 | len(size)]) + size


def _value(tlv):
    """The value of a definite-length, low-tag-number TLV."""
    first = tlv[1]
    header = 2 + (first & 0x7F if first & 0x80 else 0)
    return tlv[header:]


MAX_BER_DEPTH = 64   # far deeper than any CMS message nests


def definite(data, pos=0, depth=0):
    """Re-encodes one BER TLV at data[pos] with definite lengths, and constructed OCTET STRINGs and BIT
    STRINGs as primitive ones (pyasn1 cannot decode indefinite lengths inside open types).
    Returns (encoding, position after the TLV). Raises PyAsn1Error or IndexError on malformed BER."""
    if depth > MAX_BER_DEPTH:
        raise PyAsn1Error(f"nested more than {MAX_BER_DEPTH} levels deep")
    start = pos
    tag = data[pos]
    pos += 1
    if tag & 0x1F == 0x1F:                       # high tag number
        while data[pos] & 0x80:
            pos += 1
        pos += 1
    tag_bytes = data[start:pos]
    first = data[pos]
    pos += 1
    if first == 0x80:                            # indefinite: children up to end-of-contents
        length = None
    elif first & 0x80:
        size = first & 0x7F
        length = int.from_bytes(data[pos:pos + size], "big")
        pos += size
    else:
        length = first
    if length is not None and pos + length > len(data):
        raise PyAsn1Error("a length runs past the end of the data")
    if not tag & 0x20:                           # primitive
        if length is None:
            raise PyAsn1Error("an indefinite length on a primitive value")
        return tag_bytes + _length(length) + data[pos:pos + length], pos + length
    children = []
    end = None if length is None else pos + length
    while (end is None and data[pos:pos + 2] != b"\x00\x00") or (end is not None and pos < end):
        child, pos = definite(data, pos, depth + 1)
        children.append(child)
    if end is None:
        pos += 2
    elif pos != end:
        raise PyAsn1Error("a value runs past the end of the value that contains it")
    if tag in (0x24, 0x23):                      # constructed OCTET STRING / BIT STRING
        segments = [_value(child) for child in children]
        if tag == 0x23:                          # each segment starts with its unused-bits count
            value = (segments[-1][:1] if segments else b"\x00") + b"".join(s[1:] for s in segments)
        else:
            value = b"".join(segments)
        return bytes([tag & ~0x20]) + _length(len(value)) + value, pos
    content = b"".join(children)
    return tag_bytes + _length(len(content)) + content, pos


def decode_ber(data, spec, what, **options):
    """Decodes one structure that may be BER (CMS allows it, RFC 5652). Returns (value, is DER, error)."""
    value, error = decode_der(data, spec, what, **options)
    if not error:
        return value, True, None
    try:
        transcoded, end = definite(data)
        if end != len(data):
            return None, False, f"{len(data) - end} bytes after the {what}"
        value, rest = ber_decode(transcoded, asn1Spec=spec, **options)
    except (PyAsn1Error, IndexError) as e:
        return None, False, f"not a {what}: {short_error(e)}"
    if rest:
        return None, False, f"{len(rest)} bytes after the {what}"
    return value, False, None


# --- Certificates -----------------------------------------------------------------------------

def check_cert(der, oid, role):
    """Findings for one certificate: ([(severity, message)], cert or None)."""
    cert, error = decode_der(der, rfc5280.Certificate(), "Certificate")
    if error:
        return [(FAIL, error)], None
    findings = []
    tbs = cert["tbsCertificate"]
    sig_alg, tbs_sig_alg = cert["signatureAlgorithm"], tbs["signature"]
    spki = tbs["subjectPublicKeyInfo"]
    spki_alg = spki["algorithm"]
    sig_oid, spki_oid = str(sig_alg["algorithm"]), str(spki_alg["algorithm"])

    if der_encode(sig_alg) != der_encode(tbs_sig_alg):
        findings.append((FAIL, f"signatureAlgorithm ({sig_oid}) differs from tbsCertificate.signature "
                               f"({tbs_sig_alg['algorithm']}) (RFC 5280, Section 4.1.1.2)"))
    if spki_oid != oid:
        findings.append((FAIL, f"the file name's OID differs from the public key algorithm {spki_oid}"))
    if role == "ta" and sig_oid != spki_oid:
        findings.append((FAIL, f"self-signed with {sig_oid}, but the public key algorithm is {spki_oid}: "
                               "the same OID identifies a key and its signature algorithm "
                               "(RFC 9881, Section 2; RFC 9909, Section 8; RFC 10073, Section 5)"))
    for name, alg in (("subjectPublicKeyInfo algorithm", spki_alg), ("signatureAlgorithm", sig_alg)):
        if alg["parameters"].isValue:
            findings.append((FAIL, f"{name} {alg['algorithm']} has parameters; they MUST be absent"))

    if role == "ta" and der_encode(tbs["issuer"]) != der_encode(tbs["subject"]):
        findings.append((WARNING, "the trust anchor is not self-issued (issuer differs from subject)"))
    return findings, cert


# --- CMS --------------------------------------------------------------------------------------

def check_cms_message(der, oid, role):
    """Findings for one CMS message. CMS may be BER (RFC 5652), which is only a warning."""
    findings = []
    # Decoded in one pass, open types included: an indefinite-length content cannot be decoded again
    # from its Any on its own.
    info, is_der, error = decode_ber(der, rfc5652.ContentInfo(), "ContentInfo", decodeOpenTypes=True)
    if error:
        return [(FAIL, error)]
    if not is_der:
        findings.append((WARNING, "BER, not DER (valid CMS, but the format asks for DER)"))
    content_type = str(info["contentType"])
    content = info["content"]
    if role == "signed_attrs":
        if content_type != str(rfc5652.id_signedData):
            return findings + [(FAIL, f"the ContentInfo is {content_type}, not SignedData")]
        if not isinstance(content, rfc5652.SignedData):
            return findings + [(FAIL, "the content is not a SignedData")]
        signed = content
        if not signed["encapContentInfo"]["eContent"].isValue:
            findings.append((WARNING, "the content is not attached"))
        for si in signed["signerInfos"]:
            alg = str(si["signatureAlgorithm"]["algorithm"])
            if alg != oid:
                findings.append((FAIL, f"the SignerInfo's signature algorithm {alg} differs from the file name's OID"))
            if not si["signedAttrs"].isValue:
                findings.append((WARNING, "a SignerInfo has no signed attributes"))
        return findings

    envelopes = {str(rfc5652.id_envelopedData): rfc5652.EnvelopedData,
                 str(rfc5083.id_ct_authEnvelopedData): rfc5083.AuthEnvelopedData}
    if content_type not in envelopes:
        return findings + [(FAIL, f"the ContentInfo is {content_type}, not EnvelopedData or AuthEnvelopedData")]
    if not isinstance(content, envelopes[content_type]):
        return findings + [(FAIL, f"the content is not an {envelopes[content_type].__name__}")]
    env = content
    kemris = []
    others = []
    for ri in env["recipientInfos"]:
        if ri.getName() == "ori" and ri["ori"]["oriType"] == rfc9629.id_ori_kem:
            kemri = ri["ori"]["oriValue"]
            if isinstance(kemri, rfc9629.KEMRecipientInfo):
                kemris.append(kemri)
            else:
                findings.append((FAIL, "the KEMRecipientInfo could not be decoded"))
        elif ri.getName() == "ktri":
            others.append(f"a KeyTransRecipientInfo with key encryption algorithm "
                          f"{ri['ktri']['keyEncryptionAlgorithm']['algorithm']}")
        else:
            others.append(f"a {ri.getName()} RecipientInfo")
    if not kemris and not any(f[0] == FAIL for f in findings):
        findings.append((FAIL, "no KEMRecipientInfo (RFC 9629)" + (f", only {'; '.join(others)}" if others else "")))
    with_ukm = role.endswith("_ukm")
    for kemri in kemris:
        kem = kemri["kem"]
        if str(kem["algorithm"]) != oid:
            findings.append((FAIL, f"the KEMRecipientInfo's KEM algorithm {kem['algorithm']} differs from the "
                                   "file name's OID"))
        if kem["parameters"].isValue:
            findings.append((FAIL, f"the KEMRecipientInfo's KEM algorithm {kem['algorithm']} has parameters; "
                                   "they MUST be absent"))
        has_ukm = kemri["ukm"].isValue
        if with_ukm and not has_ukm:
            findings.append((WARNING, "a _ukm artifact without UKM"))
        elif not with_ukm and has_ukm:
            findings.append((WARNING, "UKM in an artifact the format says is without UKM"))
    return findings


# --- A zip ------------------------------------------------------------------------------------

def read_member(zf, name):
    """(the contents of a zip entry, None), or (None, why it cannot be read)."""
    try:
        return zf.read(name), None
    except ZIP_ERRORS as e:
        return None, f"cannot be read from the zip: {e}"


def check_zip(zip_path, fmt, mapping):
    """Returns ({failed row}, [(file, oid, row, severity, message)], number of artifacts).

    A row is (oid, row type) for artifacts_certs_r5.zip and (oid, None) for artifacts_cms_v3.zip."""
    with zipfile.ZipFile(zip_path) as zf:
        artifacts, named, duplicated = check_names(zf.namelist(), fmt, mapping)
        findings = [f[:5] for f in named]

        # The artifacts: certificates first, so that the private keys can be compared with them
        failed = set()
        table_rows = set()
        certs = {}
        ta_subjects = set()
        if fmt is CMS and "ta.der" in {os.path.basename(n) for n in zf.namelist()}:
            ta_name = next(n for n in zf.namelist() if os.path.basename(n) == "ta.der")
            data, error = read_member(zf, ta_name)
            if not error:
                ta, error = decode_der(data, rfc5280.Certificate(), "Certificate")
            if error:
                findings.append((ta_name, None, None, WARNING, f"the trust anchor: {error}"))
            else:
                ta_subjects.add(der_encode(ta["tbsCertificate"]["subject"]))
        order = {"ta": 0, "ee": 1}
        # (the verifiers test _ciphertext.bin and _ss.bin)
        checked = sorted((a for a in artifacts if a[4] == "der"), key=lambda a: order.get(a[3], 2))
        for name, base, oid, role, ext in checked:
            row = (oid, row_type(role) if fmt is CERTS else None)
            shown = in_table(oid, role) if fmt is CERTS else True
            rows = [row]          # the rows a failure of this file goes in
            file_findings = []    # (severity, message, rows)
            data, error = read_member(zf, name)
            if error:
                file_findings.append((FAIL, error, rows))
            elif role in ("ta", "ee"):
                found, cert = check_cert(data, oid, role)
                file_findings += [(sev, msg, rows) for sev, msg in found]
                if cert is not None:
                    certs.setdefault(oid, cert)
                    if role == "ta":
                        ta_subjects.add(der_encode(cert["tbsCertificate"]["subject"]))
            elif role in KEY_ROLES:
                key, error = decode_der(data, rfc5958.OneAsymmetricKey(), "OneAsymmetricKey")
                if error:
                    file_findings.append((FAIL, error, rows))
                else:
                    alg = key["privateKeyAlgorithm"]
                    key_oid = str(alg["algorithm"])
                    if alg["parameters"].isValue:
                        file_findings.append((FAIL, f"privateKeyAlgorithm {key_oid} has parameters; they MUST "
                                                    "be absent", rows))
                    cert = certs.get(oid)
                    cert_oid = str(cert["tbsCertificate"]["subjectPublicKeyInfo"]["algorithm"]["algorithm"]) \
                        if cert is not None else None
                    if cert_oid is not None and key_oid != cert_oid:
                        consistent = [(oid, "consistent")] if fmt is CERTS else rows
                        file_findings.append((FAIL, f"privateKeyAlgorithm {key_oid} differs from the certificate's "
                                                    f"public key algorithm {cert_oid}", consistent))
            else:
                file_findings += [(sev, msg, rows) for sev, msg in check_cms_message(data, oid, role)]

            if shown:
                table_rows.add(row)
            for sev, msg, msg_rows in file_findings:
                label = (msg_rows[0][1] if msg_rows and msg_rows[0][1] else None) if fmt is CERTS else None
                if fmt is CERTS and not shown:
                    label = f"{row[1]}, not in the table"
                findings.append((name, oid, label, sev, msg))
                if sev == FAIL and shown:
                    failed.update(msg_rows)

        # A KEM certificate's issuer should be a trust anchor in the zip
        for name, base, oid, role, ext in checked:
            if role == "ee" and oid in certs and ta_subjects and \
                    der_encode(certs[oid]["tbsCertificate"]["issuer"]) not in ta_subjects:
                findings.append((name, oid, row_type(role) if fmt is CERTS else None, WARNING,
                                 "the certificate's issuer is not a trust anchor in the zip"))

    failed |= {row for row in table_rows if row[0] in duplicated}
    return failed, findings, len(artifacts)


# --- Output -----------------------------------------------------------------------------------

def anchor(provider):
    """The id of a provider's section on the findings page (same rule as the report writer)."""
    return re.sub(r"[^a-z0-9]+", "-", provider.lower()).strip("-")


def oid_key(oid):
    return [int(x) for x in oid.split(".")]


def md_cell(text):
    return str(text).replace("|", "\\|").replace("\n", " ")


def write_results(fmt, report, output_dir):
    out = os.path.join(output_dir, fmt.output)
    os.makedirs(out, exist_ok=True)
    for provider, (failed, _, _) in report.items():
        with open(os.path.join(out, f"{provider}_{fmt.column}.csv"), "w", newline="") as f:
            w = csv.writer(f, lineterminator="\n")
            if fmt is CERTS:
                w.writerow(["key_algorithm_oid", "type", "test_result"])
                for oid, rtype in sorted(failed, key=lambda k: (oid_key(k[0]), k[1])):
                    w.writerow([oid, rtype, "N"])
            else:
                w.writerow(["key_algorithm_oid", "test_result"])
                for oid in sorted({oid for oid, _ in failed}, key=oid_key):
                    w.writerow([oid, "N"])

    when = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    with open(os.path.join(out, f"{fmt.page}.md"), "w") as md, open(os.path.join(out, f"{fmt.page}.log"), "w") as log:
        md.write(f"# {fmt.name} conformance findings\n\n")
        # Same table style as the results pages.
        md.write("<style> table { border-collapse: collapse; width:auto !important; } th, td { border: solid black 1px; "
                 "padding: 0 1ex; } </style>\n\n")
        md.write(f"Generated: {when}, for the {fmt.zip_name} of {len(report)} providers. The {fmt.column} column of the "
                 "automated results checks what the verifiers do not, because a signature can still verify and a key "
                 "decapsulate when an artifact is wrong: the zip format "
                 f"([readme]({fmt.readme})) and the rules on algorithm "
                 "identifiers. The checks are listed at the top of "
                 "`src/test_artifacts_conformance.py`. Only failures are shown in the table, as ❌ that link to the "
                 "provider's section below: passing these checks shows that an artifact is well formed, not that it "
                 "interoperates. Warnings are listed here but not in the table.")
        if fmt is CERTS:
            md.write(" So are the failures of private key files that are not in their algorithm's format (a CHOICE "
                     "format for the algorithms in docs/choice_oids.txt, _priv for the others, as in the OpenSSL verifier).")
        md.write("\n\nTo check a zip before pushing it: `pip install pyasn1 pyasn1-alt-modules`, then "
                 f"`python3 src/test_artifacts_conformance.py providers/<name>/{fmt.zip_name}`.\n\n")
        log.write(f"{fmt.column}, {when}\n")
        for provider in sorted(report, key=str.lower):
            _, findings, count = report[provider]
            md.write(f"## {provider} {{#{anchor(provider)}}}\n\n")
            log.write(f"\n{provider}:\n")
            if findings:
                md.write("| File | Row | Severity | Finding |\n|---|---|---|---|\n")
                for name, oid, row, severity, message in findings:
                    row = row or (("every row" if fmt is CERTS else oid) if severity == FAIL and oid else "-")
                    md.write(f"| {md_cell(name)} | {md_cell(row)} | {severity} | {md_cell(message)} |\n")
                    log.write(f"  {name}: {severity} ({row}): {message}\n")
                md.write("\n")
            else:
                md.write(f"No findings ({count} artifacts).\n\n")
                log.write(f"  no findings ({count} artifacts)\n")
    fails = sum(1 for r in report.values() for f in r[1] if f[3] == FAIL)
    warnings = sum(1 for r in report.values() for f in r[1] if f[3] == WARNING)
    print(f"{fmt.column}: {len(report)} providers, {fails} failures, {warnings} warnings")


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("zips", nargs="*", help="zips to check (default: every provider's two zips)")
    parser.add_argument("--output-dir", default="./output", help="where to write the results (default ./output)")
    args = parser.parse_args()

    mapping = load_oid_mapping()
    for fmt in FORMATS:
        zips = [z for z in args.zips if os.path.basename(z) == fmt.zip_name] if args.zips \
            else sorted(glob.glob(os.path.join(REPO, "providers", "*", fmt.zip_name)))
        report = {}
        for zip_path in zips:
            provider = os.path.basename(os.path.dirname(os.path.abspath(zip_path)))
            try:
                failed, findings, count = check_zip(zip_path, fmt, mapping)
            except ZIP_ERRORS as e:
                failed, findings, count = set(), [(fmt.zip_name, None, None, FAIL, f"not a readable zip: {e}")], 0
            if count or findings:
                report[provider] = (failed, findings, count)
        if report or not args.zips:
            write_results(fmt, report, args.output_dir)


if __name__ == "__main__":
    main()
