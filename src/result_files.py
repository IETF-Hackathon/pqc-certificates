"""Reading result files: the one way that the result tables, the scoreboard and src/check_result_files.py all read
them, so that they agree on every row, and the rules for the names, algorithms and types that go on the pages.

A result file, <producer>_<verifier>.csv, has a row per test: key_algorithm_oid, test_result and, in the formats
that have one, type, then zip_sha256, the SHA-256 of the producer's zip that was verified (the same in every row).
zip_sha256 is optional while the result files submitted before it was added remain: src/check_result_files.py
requires it of new and changed files. Names, algorithm ids and types are restricted to characters that are plain
text in markdown and HTML, because they go into the pages.
"""
import csv
import os
import re
from typing import NamedTuple, Optional

# The names, ids and types that go on the page, restricted to characters that are plain text in markdown and HTML.
# Every pattern is used with fullmatch. A result file is <producer>_<verifier>.csv, with a lower-case extension as
# the page scripts find; a producer is the name of its directory under providers/.
_PRODUCER = re.compile(r'[A-Za-z0-9.-]+')
_FILE_NAME = re.compile(r'(?P<generator>[A-Za-z0-9.-]+)_(?P<verifier>[A-Za-z0-9._-]+)\.csv')
_ID = re.compile(r'[A-Za-z0-9._-]+')
# The columns a result file must have, by format; formats not listed need only these two
_COLUMNS = {'artifacts_certs_r5': ('key_algorithm_oid', 'type', 'test_result')}
_DEFAULT_COLUMNS = ('key_algorithm_oid', 'test_result')
_TYPE = re.compile(r'[A-Za-z0-9_-]*')
# The last column: the SHA-256 of the producer's zip, in hex
SHA256_COLUMN = 'zip_sha256'
_SHA256 = re.compile(r'[0-9A-Fa-f]{64}')


def valid_type(kind):
    """Whether a CSV's type value is allowed: letters, digits, '_' and '-' only (or empty)."""
    return _TYPE.fullmatch(kind) is not None


def valid_producer(name):
    """Whether a directory name under providers/ can be a producer: letters, digits, '.' and '-' only."""
    return _PRODUCER.fullmatch(name) is not None


def parse_name(name):
    """(producer, verifier) of a result file name <producer>_<verifier>.csv, or None if the name is not valid."""
    m = _FILE_NAME.fullmatch(name)
    return (m['generator'], m['verifier']) if m else None


def printable(text):
    """text with every character that is not plain text in markdown and HTML replaced, for a warning."""
    return re.sub(r'[^A-Za-z0-9._/ -]', '?', text)


def valid_name(path):
    """Whether a result file's name is <producer>_<verifier>.csv, with only the characters allowed in each."""
    return parse_name(os.path.basename(path)) is not None


def _badness(result):
    """How bad a result is: a pass, then a warning (W, from a lint), then anything else, a failure."""
    return {'Y': 0, 'W': 1}.get(result, 2)


class ResultRows(NamedTuple):
    results: dict       # (OID, type) -> result, upper case; the worst of a test's rows that have a result
    duplicates: set     # tests reported in more than one row
    invalid: set        # (OID, type), made printable, of the rows left out for characters not allowed in either
    malformed: str      # why the file was not read at all, or ''
    zip_sha256: Optional[str] = None    # the zip's SHA-256 (either case, kept lower); None without it
    header: tuple = ()  # the column names, stripped


def columns(format_dir):
    """The columns a result file of a format must have to be read."""
    return _COLUMNS.get(format_dir, _DEFAULT_COLUMNS)


def submission_columns(format_dir):
    """The header of a new result file of a format: its columns, then zip_sha256."""
    return columns(format_dir) + (SHA256_COLUMN,)


def read_results(path, required=_DEFAULT_COLUMNS):
    """The rows of a result file, read the one way that both the scoreboard and the result tables use: UTF-8 (a
    byte order mark is allowed), header names and values stripped, results in upper case, rows without a result
    skipped, and the worst result of a test used if it has several rows (an automated verifier writes a row per
    artifact, and a zip can hold several copies of one: if any copy fails, the test fails). A file whose header
    lacks a required column,
    or with a row that has a different number of values than the header has columns, is not read: taking one
    column for another (a type for the result, say) would misreport every row. Nor is a file with a zip_sha256
    column whose rows do not all give the same SHA-256: it says which zip the results are for."""
    try:
        with open(path, newline='', encoding='utf-8-sig') as f:
            rows = list(csv.reader(f))
    except UnicodeDecodeError:
        return ResultRows({}, set(), set(), 'it is not UTF-8 text')
    except csv.Error as e:
        return ResultRows({}, set(), set(), f'it is not a valid CSV file ({printable(str(e))})')
    # a blank line is no row
    rows = [(n, [c.strip() for c in row]) for n, row in enumerate(rows, start=1) if any(c.strip() for c in row)]
    if not rows:
        return ResultRows({}, set(), set(), 'the file is empty')
    header = rows[0][1]
    expected = f'the header must be `{",".join(required)}`'
    missing = [c for c in required if c not in header]
    if missing:
        return ResultRows({}, set(), set(), f'the header has no {" or ".join(f"`{c}`" for c in missing)} column; '
                                            f'{expected}')
    uneven = [n for n, row in rows[1:] if len(row) != len(header)]
    if uneven:
        return ResultRows({}, set(), set(), f'{(f"{len(uneven)} row" + ("s" if len(uneven) != 1 else ""))} (the first on line {uneven[0]}) '
                                            f'{"has" if len(uneven) == 1 else "have"} a different number of values '
                                            f'than the header has columns; {expected}')
    zip_sha256 = None
    if SHA256_COLUMN in header:
        hashes = [(n, row[header.index(SHA256_COLUMN)]) for n, row in rows[1:]]
        bad = [n for n, h in hashes if not _SHA256.fullmatch(h)]
        if bad:
            return ResultRows({}, set(), set(), f'the `{SHA256_COLUMN}` on line {bad[0]} is not a SHA-256 (64 hex '
                                                f'digits)', header=tuple(header))
        distinct = {h.lower() for _, h in hashes}
        if len(distinct) > 1:
            return ResultRows({}, set(), set(), f'its rows give {len(distinct)} different `{SHA256_COLUMN}` values; '
                                                'a result file has the results for one zip', header=tuple(header))
        zip_sha256 = distinct.pop() if distinct else None
    index = {name: header.index(name) for name in ('key_algorithm_oid', 'type', 'test_result') if name in header}
    results, duplicates, invalid = {}, set(), set()
    for _, row in rows[1:]:
        oid = row[index['key_algorithm_oid']]
        kind = row[index['type']] if 'type' in index else ''
        result = row[index['test_result']].upper()
        if not oid or not result:
            continue
        if not _ID.fullmatch(oid) or not valid_type(kind):
            invalid.add((printable(oid), printable(kind)))
            continue
        test = (oid, kind)
        if test in results:
            duplicates.add(test)
            if _badness(result) <= _badness(results[test]):
                continue
        results[test] = result
    return ResultRows(results, duplicates, invalid, '', zip_sha256, tuple(header))
