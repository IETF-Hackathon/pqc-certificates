"""The names and layout of the artifacts in a zip: the rules of the zip formats that can be checked from the file
names alone, without reading the artifacts. Shared by the conformance checker (src/test_artifacts_conformance.py),
which also checks the artifacts' contents, and src/check_result_files.py, which checks the zips a pull request
changes. Needs nothing beyond the standard library.

An artifact is a file named <friendlyname>-<oid>_<role>.<ext>, in any folder of the zip. Hybrid formats
(external_, catalyst_ and chameleon_ files, and <format>_<oid1>_with_<oid2>_ta.der) are skipped.
"""
import os
import re
from collections import defaultdict

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OID_MAPPING = "docs/oid_mapping.md"
CHOICE_OIDS_FILE = "docs/choice_oids.txt"
HYBRID_NAME = re.compile(r"^(external|catalyst|chameleon)_|_with_")
OID = r"(?P<oid>\d+(?:\.\d+)+)"

FAIL, WARNING = "fail", "warning"

# The kinds of naming and layout finding, for a caller that weighs them differently than FAIL and WARNING do
UNEXPECTED = "unexpected"      # a file that is not an artifact of the format
MISNAMED = "misnamed"          # ... that looks like a misnamed artifact
EXTENSION = "extension"        # an artifact that is not .der (.bin for ciphertext and ss)
DUPLICATE = "duplicate"        # the same OID and role in more than one file
FOLDER = "folder"              # an artifact outside the folder the format requires
FOLDERS = "folders"            # artifacts in more than one folder, where the format is a flat folder
MAPPING = "mapping"            # an OID that is not in docs/oid_mapping.md, or a friendly name of another OID
INCOMPLETE = "incomplete"      # an artifact that cannot be tested because a file it needs is missing
KEY_NAME = "key-name"          # a private key named for the other kind of algorithm (CHOICE or not)


def load_oid_list(path):
    """A set of OIDs from a file of one OID per line, where '#' starts a comment."""
    with open(path, encoding="utf-8") as f:
        return {line.split("#", 1)[0].strip() for line in f} - {""}


# Algorithms whose private keys use the CHOICE of seed, expandedKey or both (shared with
# src/test_certs_r5_openssl.sh)
CHOICE_OIDS = load_oid_list(os.path.join(REPO, CHOICE_OIDS_FILE))


# --- Zip formats ------------------------------------------------------------------------------

class ZipFormat:
    def __init__(self, name, zip_name, column, page, output, readme, artifact, fixed, roles, folder):
        self.name, self.zip_name, self.column, self.page, self.output = name, zip_name, column, page, output
        self.readme = readme                   # the readme.md section of the format
        self.artifact = re.compile(artifact)   # with groups oid, role, ext
        self.fixed = fixed                     # other expected file names (base names)
        self.roles = roles
        self.folder = folder                   # the folder the format requires, or None


CERTS = ZipFormat(
    "R5 certificates", "artifacts_certs_r5.zip", "r5-conformance", "r5_conformance_certs", "certs",
    "https://github.com/IETF-Hackathon/pqc-certificates#zip-format-r5",
    rf"^.*-{OID}_(?P<role>ta|ee|seed_priv|expandedkey_priv|both_priv|priv|ciphertext|ss)\.(?P<ext>der\.pem|der|pem|bin)$",
    set(), ("ta", "ee", "seed_priv", "expandedkey_priv", "both_priv", "priv", "ciphertext", "ss"), None)
CMS = ZipFormat(
    "CMS v3", "artifacts_cms_v3.zip", "cms-v3-conformance", "cms_v3_conformance", "cms",
    "https://github.com/IETF-Hackathon/pqc-certificates#cms----artifacts_cms_v3zip",
    # Not in the readme, but tested like the others: kemri_<kdf>_ukm and kemri_auth_<kdf>_ukm, and the
    # R5 CHOICE key names, which the OpenSSL verifier's *<oid>*_priv.der pattern also matches
    rf"^.*-{OID}_(?P<role>ee|seed_priv|expandedkey_priv|both_priv|priv|signed_attrs|kemri_ukm|kemri_auth(?:_[A-Za-z0-9-]+(?:_ukm)?)?"
    rf"|kemri_[A-Za-z0-9-]+(?:_ukm)?)\.(?P<ext>der\.pem|der|pem)$",
    {"expected_plaintext.txt", "ta.der"}, None, "artifacts_cms_v3")
FORMATS = (CERTS, CMS)
BY_ZIP_NAME = {fmt.zip_name: fmt for fmt in FORMATS}
KEY_ROLES = ("seed_priv", "expandedkey_priv", "both_priv", "priv")
_MISNAMED = re.compile(rf"-{OID}_(?P<role>seed|expandedkey|expanded|both|priv(?:ate)?(?:key)?|key|sk)\.der$")


def suggestion(base):
    """The likely intended name of a misnamed private key file, or None."""
    m = _MISNAMED.search(base)
    if not m:
        return None
    role = {"expanded": "expandedkey"}.get(m["role"], m["role"])
    new_role = f"{role}_priv" if role in ("seed", "expandedkey", "both") else "priv"
    return base[:m.start("role")] + new_role + ".der"


def row_type(role):
    """The artifacts_certs_r5.zip results row of an artifact."""
    if role in ("ta", "ee"):
        return "cert"
    return role[:-len("_priv")] if role != "priv" else "priv"


def in_table(oid, role):
    """Whether an artifacts_certs_r5.zip private key's results go in the table."""
    if role not in KEY_ROLES:
        return True
    return (role != "priv") == (oid in CHOICE_OIDS)


# --- OID mapping ------------------------------------------------------------------------------

_MAPPING_LINE = re.compile(r"^\|\s*(?P<name>[^|]+?)\s*\|\s*(?P<struck>~~)?\s*(?P<oid>\d+(?:\.\d+)+)\s*(~~)?\s*\|")


def normalize(name):
    return re.sub(r"^id", "", re.sub(r"[^a-z0-9]", "", name.lower()))


def load_oid_mapping(path=os.path.join(REPO, OID_MAPPING)):
    """{oid: (name, struck through)} from docs/oid_mapping.md, or None if it is missing."""
    if not os.path.isfile(path):
        return None
    mapping = {}
    with open(path) as f:
        for line in f:
            m = _MAPPING_LINE.match(line)
            if m:
                mapping.setdefault(m["oid"], (m["name"], bool(m["struck"])))
    return mapping


def oid_mapping_findings(oid, friendly, mapping):
    if mapping is None:
        return []
    if oid not in mapping:
        return [f"{oid} is not in {OID_MAPPING}"]
    findings = []
    if mapping[oid][1]:
        findings.append(f"{oid} ({mapping[oid][0]}) is struck through in {OID_MAPPING}")
    own = normalize(mapping[oid][0])
    if normalize(friendly) != own:
        others = [o for o, (n, _) in mapping.items() if o != oid and normalize(n) == normalize(friendly)]
        if others:
            findings.append(f"the friendly name '{friendly}' is the name of {others[0]} in {OID_MAPPING}, "
                            f"not of {oid} ({mapping[oid][0]})")
    return findings


# --- Names and layout -------------------------------------------------------------------------

def check_names(names, fmt, mapping):
    """Checks the names and layout of the files of a zip (its namelist). Returns (artifacts, findings, duplicated):
    the artifacts as (name, base, oid, role, ext); the findings as (name, oid, label, severity, message, kind),
    where kind is one of UNEXPECTED ... KEY_NAME; and the OIDs whose table rows fail for a duplicate artifact."""
    findings = []
    artifacts = []
    for name in sorted(n for n in names if not n.endswith("/")):
        base = os.path.basename(name)
        if HYBRID_NAME.search(base):
            continue
        m = fmt.artifact.match(base)
        if m:
            artifacts.append((name, base, m["oid"], m["role"], m["ext"]))
        elif base not in fmt.fixed:
            hint = suggestion(base)
            findings.append((name, None, None, WARNING, f"not an artifact of the {fmt.name} format"
                             + (f"; did you mean {hint}?" if hint else "; the verifiers may not test it"),
                             MISNAMED if hint else UNEXPECTED))

    # Packaging
    by_oid_role = defaultdict(list)
    tested = defaultdict(list)    # the files the verifiers test, in the format's extension
    for name, base, oid, role, ext in artifacts:
        by_oid_role[(oid, role)].append(name)
        expected = "bin" if role in ("ciphertext", "ss") else "der"
        if ext != expected:
            findings.append((name, oid, None, WARNING, f"a .{ext} file; artifacts are .{expected} (DER)", EXTENSION))
        else:
            tested[(oid, role)].append(name)
    duplicated = set()            # OIDs whose table rows fail
    for (oid, role), files in tested.items():
        if len(files) > 1:
            shown = in_table(oid, role) if fmt is CERTS else True
            if shown:
                duplicated.add(oid)
            label = None if shown else f"{row_type(role)}, not in the table"
            for name in files:
                findings.append((name, oid, label, FAIL, f"duplicate: {len(files)} files are the {role} of {oid} "
                                                         f"({', '.join(files)})", DUPLICATE))
    folders = defaultdict(int)
    for name, *_ in artifacts:
        folders[os.path.dirname(name)] += 1
    if fmt.folder:
        for name, base, oid, *_ in artifacts:
            if os.path.dirname(name) != fmt.folder:
                findings.append((name, oid, None, WARNING, f"not in {fmt.folder}/, the format's folder", FOLDER))
    elif len(folders) > 1:
        main_folder = max(folders, key=folders.get)
        for name, base, oid, *_ in artifacts:
            if os.path.dirname(name) != main_folder:
                findings.append((name, oid, None, WARNING, f"in folder '{os.path.dirname(name)}/', the other "
                                 f"artifacts are in '{main_folder or '(the top level)'}'; the format is a flat folder",
                                 FOLDERS))

    # OID mapping, once per OID
    seen = set()
    for name, base, oid, *_ in artifacts:
        if oid not in seen:
            seen.add(oid)
            friendly = base[:base.index(f"-{oid}_")]
            findings += [(name, oid, None, WARNING, msg, MAPPING) for msg in oid_mapping_findings(oid, friendly, mapping)]

    # Completeness
    roles = defaultdict(set)
    for (oid, role) in by_oid_role:
        roles[oid].add(role)
    for oid, present in roles.items():
        missing = []
        if fmt is CERTS:
            if "ee" in present:
                missing += [f"_{r}.bin" for r in ("ciphertext", "ss") if r not in present]
                if not present & set(KEY_ROLES):
                    missing.append("a private key")
            elif ("ciphertext" in present) != ("ss" in present):
                missing.append("_ss.bin" if "ciphertext" in present else "_ciphertext.bin")
            if not present & {"ta", "ee"} and present & (set(KEY_ROLES) | {"ciphertext", "ss"}):
                missing.append("a certificate (_ta.der or _ee.der)")
            # The table shows the private key rows of the algorithm's format only (in_table)
            if oid in CHOICE_OIDS and "priv" in present:
                findings.append((by_oid_role[(oid, "priv")][0], oid, None, WARNING,
                                 f"{oid} has CHOICE private keys ({CHOICE_OIDS_FILE}): name them _seed_priv.der, "
                                 "_expandedkey_priv.der or _both_priv.der, not _priv.der; results for "
                                 "_priv.der are not in the table", KEY_NAME))
            wrong = sorted(r for r in present if r in KEY_ROLES and r != "priv")
            if oid not in CHOICE_OIDS and wrong:
                findings.append((by_oid_role[(oid, wrong[0])][0], oid, None, WARNING,
                                 f"{oid} has no CHOICE private keys ({CHOICE_OIDS_FILE}): name the key _priv.der, "
                                 f"not _{'.der, _'.join(wrong)}.der; results for those are not in the table",
                                 KEY_NAME))
        else:
            kemri = {r for r in present if r.startswith("kemri_")}
            if kemri and "ee" not in present:
                missing.append("_ee.der")
            choice_keys = sorted(r for r in present if r in KEY_ROLES and r != "priv")
            if kemri and not choice_keys and "priv" not in present:
                missing.append("_priv.der")
            if choice_keys and "priv" not in present:
                which = (f"; the OpenSSL verifier decrypts with whichever of the "
                         f"_{'.der, _'.join(choice_keys)}.der files find returns first"
                         if kemri and len(choice_keys) > 1 else "")
                findings.append((by_oid_role[(oid, choice_keys[0])][0], oid, None, WARNING,
                                 f"no _priv.der, the CMS v3 name of the private key{which}", KEY_NAME))
        if missing:
            findings.append((by_oid_role[(oid, sorted(present)[0])][0], oid, None, WARNING,
                             f"incomplete: {oid} has no {', '.join(missing)}, so not every artifact can be tested",
                             INCOMPLETE))
    return artifacts, findings, duplicated
