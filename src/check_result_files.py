#!/usr/bin/env python3
"""Check manual result files (providers/<verifier>/compatMatrices/<format>/<producer>_<verifier>.csv) and the
producers' zips (providers/<producer>/<format>.zip) for the problems the result pages report, so they are caught
when the files are submitted.

Run from the repository root, in a clone with the full git history:

    src/check_result_files.py FILE...          check the given files
    src/check_result_files.py --base REF       check the result files and zips changed since REF (e.g. origin/master)
    src/check_result_files.py --all            check every result file and zip

Errors (the file's results, or the zip, would not be used at all) make it exit with 1; warnings (some rows are left
out, or a likely mistake) do not. In GitHub Actions the problems are also shown as annotations on the files.
"""
import argparse
import glob
import os
import re
import subprocess
import sys

import result_files
import verifier_scoreboard
from pqc_report_writer_common import _parse_oid_name_mapping_file

# The formats whose result pages carry the scoreboard
FORMATS = ('artifacts_certs_r5', 'artifacts_cms_v3')
# Any case, so that a .CSV file is reported as an invalid name rather than passed over
_RESULT = re.compile(r'providers/[^/]+/compatMatrices/(?P<format>[^/]+)/[^/]+\.csv', re.IGNORECASE)
_ZIP = re.compile(r'providers/(?P<producer>[^/]+)/(?P<format>[^/]+)\.zip')


def _changed_since(base):
    # -z: without it, git quotes names with unusual characters, which would then match nothing
    out = subprocess.run(['git', 'diff', '-z', '--name-only', '--diff-filter=AMR', f'{base}...HEAD', '--', 'providers'],
                         capture_output=True, text=True)
    if out.returncode != 0:
        sys.exit(f'git diff against {base}: {out.stderr.strip()}')
    return [p for p in out.stdout.split('\0') if p]


def _result_files(fmt):
    """Every result file of a format, as the page scripts find them (hidden ones included)."""
    return [p for pattern in ('*.csv', '.*.csv') for p in glob.glob(f'providers/*/compatMatrices/{fmt}/{pattern}')]


def _zip_problems(path, producer):
    """The problems with a producer's zip: a directory name that cannot be a producer, or a zip that cannot be
    read."""
    if not result_files.valid_producer(producer):
        return [(verifier_scoreboard.ERROR, 'the directory name is not a valid producer name (only letters, digits, '
                                            '`.` and `-`), so the zip is not used.')]
    why = verifier_scoreboard.zip_contents(path)[2]
    return [(verifier_scoreboard.ERROR, f'{why}; its algorithms cannot be checked or tested.')] if why else []


def _plain(text):
    """Markdown text as plain text, for the terminal and annotations."""
    return text.replace('`', '').replace('*', '')


def _report(severity, path, text):
    if os.environ.get('GITHUB_ACTIONS') == 'true':
        # annotation messages end at a newline; %, \r and \n must be escaped
        message = text.replace('%', '%25').replace('\r', '%0D').replace('\n', '%0A')
        print(f'::{severity} file={path}::{message}')
    else:
        print(f'{path}: {severity}: {text}')


def main():
    parser = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('files', nargs='*', default=[])
    group.add_argument('--base', help='check the result files changed since this git ref')
    group.add_argument('--all', action='store_true', help='check every result file')
    parser.add_argument('--oid-mapping', default='docs/oid_mapping.md')
    args = parser.parse_args()

    if args.all:
        paths = ([p for fmt in FORMATS for p in _result_files(fmt)]
                 + [p for fmt in FORMATS for p in glob.glob(f'providers/*/{fmt}.zip')])
    elif args.base:
        paths = _changed_since(args.base)
    else:
        paths = args.files
        if not paths:
            parser.error('give files to check, --base or --all')
    by_format, zips = {}, []
    for path in paths:
        path = os.path.normpath(path).replace(os.sep, '/')
        m, z = _RESULT.fullmatch(path), _ZIP.fullmatch(path)
        if m and m['format'] in FORMATS and os.path.isfile(path):
            by_format.setdefault(m['format'], []).append(path)
        elif z and z['format'] in FORMATS and os.path.isfile(path):
            zips.append((path, z['producer']))
    if not by_format and not zips:
        print('No result files or zips to check.')
        return 0

    with open(args.oid_mapping) as f:
        # as the pages read it: the OIDs after "# Experimental and Historical OIDs" are not on them
        names = _parse_oid_name_mapping_file(f, stop_at_experimental=True)

    def alg_name(oid):
        return f'{names[oid]} ({oid})' if oid in names else oid

    counts = {verifier_scoreboard.ERROR: 0, verifier_scoreboard.WARNING: 0}

    def report(path, problems):
        for severity, text in problems:
            _report(severity, path, _plain(text))
            counts[severity] += 1

    for path, producer in sorted(zips):
        report(path, _zip_problems(path, producer))
    for fmt, checked in sorted(by_format.items()):
        # The whole format is read, so that each file is checked against the current zips and the other files
        everything = sorted(set(_result_files(fmt)) | set(checked))
        board = verifier_scoreboard.build(everything)
        files = {f.path: f for f in board.files}
        for path in sorted(checked):
            f = files.get(os.path.normpath(path))
            if f is None:
                report(path, [(verifier_scoreboard.ERROR,
                               'the name must be <producer>_<verifier>.csv, with a lower-case .csv and only letters, '
                               'digits, `.`, `-` and (in the verifier) `_`; the file is not used.')])
                continue
            problems = verifier_scoreboard.file_problems(board, f, alg_name)
            unknown = sorted({t[0] for t in board.results[f.path]} - set(names))
            if unknown:
                problems.append((verifier_scoreboard.WARNING,
                                 f'algorithms that are not in {args.oid_mapping}, so not shown on any page: '
                                 + ', '.join(unknown) + '.'))
            report(path, problems)
    errors, warnings = counts[verifier_scoreboard.ERROR], counts[verifier_scoreboard.WARNING]
    n, z = sum(map(len, by_format.values())), len(zips)
    print(f'Checked {n} result file{"s" if n != 1 else ""} and {z} zip{"s" if z != 1 else ""}: '
          f'{errors} error{"s" if errors != 1 else ""}, {warnings} warning{"s" if warnings != 1 else ""}.')
    return 1 if errors else 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except verifier_scoreboard.FreshnessError as e:
        sys.exit(f'error: {e}')
