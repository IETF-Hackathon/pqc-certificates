"""Freshness of the manual results, and a scoreboard of the verifiers who submit them.

A manual result file, providers/<verifier>/compatMatrices/<format>/<producer>_<verifier>.csv, is current
if the commit that last changed it already contains the producer's zip as it is now: the commit that last
changed the zip is the CSV's commit or one of its ancestors. Otherwise the producer has updated its zip since
the results were made (or the CSV was made on a branch that did not have the update yet), and the results
are stale. Results for a producer's own zip are treated like any other. Locally, a CSV with uncommitted
changes is current, and a committed one is stale if the zip has uncommitted changes.

A test is an (OID, type) row with a result. The tests of a producer are the rows that any verifier has
reported, current or stale, for an OID in its current zip. Each verifier's share of every producer's tests
is either current, stale (it has only stale results for it) or untested.
"""
import csv
import difflib
import glob
import os
import re
import subprocess
import zipfile
from collections import defaultdict
from typing import NamedTuple, Optional

from result_files import columns, parse_name, printable as _printable, read_results, valid_producer

# Locates a manual result file; whether its name is valid is result_files.parse_name's to say
_MANUAL_RESULT = re.compile(r'(?P<providers>(?:.*/)?providers)/(?P<owner>[^/]+)/compatMatrices/(?P<format>[^/]+)/'
                            r'(?P<name>[^/]+\.csv)', re.IGNORECASE)
# The conformance checker's results (src/test_artifacts_conformance.py), by format: the folder of output/ and the
# column it writes them to, and its findings page, which is published next to the result pages
_CONFORMANCE = {'artifacts_certs_r5': ('certs', 'r5-conformance', 'r5_conformance_certs.html'),
                'artifacts_cms_v3': ('cms', 'cms-v3-conformance', 'cms_v3_conformance.html')}
_ARTIFACT_OID = re.compile(r'-(?P<oid>\d+(?:\.\d+)+)_[^/]*$')
_ARTIFACT = re.compile(r'-(?P<oid>\d+(?:\.\d+)+)_(?P<role>[A-Za-z0-9_-]+?)\.(?P<ext>der|pem|bin)$')
_MEDALS = ['🥇', '🥈', '🥉']
# Makes the collapsible sections stand out: a button-like heading with a blue arrow and a show/hide hint.
# Each implementation's summary is a card, so one ends visibly before the next begins.
_DETAILS_STYLE = (
    '<style> '
    'details { margin: 0.5em 0; } '
    'details > summary { cursor: pointer; display: list-item; width: fit-content; padding: 0.15em 0.6em; '
    'background: #eaf2fb; border: 1px solid #9bbde3; border-radius: 4px; font-weight: 600; } '
    'details > summary:hover { background: #d6e7f8; } '
    'details > summary::marker { color: #1565c0; font-size: 1.15em; } '
    'details > summary::after { content: " show"; font-weight: normal; color: #555; font-size: 0.9em; } '
    'details[open] > summary::after { content: " hide"; } '
    'details[open] > summary { margin-bottom: 0.5em; } '
    'details details { margin-left: 1.5em; } '
    '.implementation { border: 1px solid #c5d3e3; border-left: 6px solid #1565c0; border-radius: 6px; '
    'background: #f7faff; padding: 0 16px 8px; margin: 1.5em 0; } '
    '.implementation > h2 { margin: 0 -16px 0.5em; padding: 0.3em 12px; background: #1565c0; color: white; '
    'border-radius: 0 5px 0 0; } '
    '.implementation h3 { border-bottom: 1px solid #c5d3e3; padding-bottom: 0.15em; } '
    '</style>')
_REPO_URL = 'https://github.com/IETF-Hackathon/pqc-certificates/blob/master/'


class FreshnessError(Exception):
    pass


class ResultFile(NamedTuple):
    path: str
    generator: str
    verifier: str
    current: bool
    reason: str            # why it is stale, '' if current
    date: Optional[str]    # date of the commit that last changed it, None if uncommitted


class Counts(NamedTuple):
    current: int
    stale: int
    untested: int

    @property
    def total(self):
        return self.current + self.stale + self.untested

    @property
    def share(self):
        return self.current / self.total if self.total else 0


class VerifierScore(NamedTuple):
    verifier: str
    mine: Counts            # the tests of its algorithms, on which it is scored
    all: Counts             # every test on the page
    algorithms: int         # the number of its algorithms on the page
    last: Optional[str]


class Conformance(NamedTuple):
    page: str                   # the findings page, with a section per producer
    failures: dict              # producer -> {test} whose artifact fails; every producer checked has an entry


class Scoreboard(NamedTuple):
    format: str
    files: list                 # every ResultFile
    scores: list                # VerifierScore, best first
    producers: list             # producers with tests on this page
    stale_on_page: list         # the stale ResultFiles with results on this page
    unknown_on_page: list       # the ResultFiles for producers with no zip, with results on this page
    invalid_names: list         # result files with characters not allowed in their names, made printable
    invalid_types: dict         # path -> {(OID, printable type)} of rows left out for an invalid type
    malformed: dict             # path -> why the file was not read: its columns do not match the format
    unverified: list            # producers no verifier has current results for
    not_verifying: list         # producers that submit no results
    expected: dict              # producer -> its tests on this page
    results: dict               # path -> {test: result} on this page
    duplicates: dict            # path -> tests reported more than once
    zip_oids: dict              # producer -> OIDs in its zip, or None
    zip_duplicates: dict        # producer -> OIDs its zip has more than one file of an artifact for
    zip_dates: dict             # producer -> date of its zip's last commit
    zip_errors: dict            # producer -> why its zip cannot be read (its algorithms are then not checked)
    invalid_producers: list     # directories with a zip whose names are not valid producer names, made printable
    scope: dict                 # verifier -> its algorithms on this page: its zip's, and any it has results for
    page_oids: set              # the algorithms with tests on this page
    zip_unreported: dict        # producer -> OIDs on this page in its zip that no verifier has reported on
    zips: dict                  # producer -> path of its zip
    automated: bool             # built from the CI verifiers' results (build_automated), not the manual ones

    @property
    def current_paths(self):
        return [f.path for f in self.files if f.current and f.path not in self.malformed]


def _match(path):
    return _MANUAL_RESULT.fullmatch(os.path.normpath(path).replace(os.sep, '/'))


def manual_format(paths):
    """The format of a list of manual result files, or None if they are not manual results."""
    formats = {m['format'] if m else None for m in map(_match, paths)}
    if len(formats) > 1:
        raise FreshnessError(f'cannot mix manual results of different formats or with other results: {formats}')
    return formats.pop() if formats else None


def _git(*args):
    out = subprocess.run(['git', *args], capture_output=True, text=True)
    if out.returncode != 0:
        raise FreshnessError(f'git {" ".join(args)}: {out.stderr.strip()}')
    # only trailing whitespace: a porcelain status line starts with a space for an unstaged change
    return out.stdout.rstrip()


def _check_history():
    try:
        shallow = _git('rev-parse', '--is-shallow-repository')
    except (FreshnessError, OSError) as e:
        raise FreshnessError(f'cannot tell which results are stale without the git history: {e}')
    if shallow == 'true':
        raise FreshnessError('cannot tell which results are stale in a shallow clone: fetch the full history '
                             '(actions/checkout with fetch-depth: 0)')


def _dirty_paths(providers_dir):
    """Paths under providers_dir with uncommitted changes, untracked ones included."""
    prefix = _git('rev-parse', '--show-prefix')
    out = _git('status', '--porcelain', '--untracked-files=all', '--', providers_dir)
    paths = set()
    for line in out.splitlines():
        path = line[3:].split(' -> ')[-1].strip('"')
        paths.add(os.path.normpath(os.path.relpath(path, prefix or '.')))
    return paths


def _last_commit(path):
    """(hash, date) of the commit that last changed path, or (None, None)."""
    out = _git('log', '-1', '--format=%H %cs', '--', path).split()
    return (out[0], out[1]) if out else (None, None)


def _is_ancestor(older, newer):
    """Whether commit older is an ancestor of (or is) newer. git answers 0 or 1; anything else is an error, which
    must not pass for a stale result."""
    out = subprocess.run(['git', 'merge-base', '--is-ancestor', older, newer], capture_output=True, text=True)
    if out.returncode not in (0, 1):
        raise FreshnessError(f'git merge-base --is-ancestor {older} {newer}: {out.stderr.strip()}')
    return out.returncode == 0


def zip_contents(path):
    """(the OIDs a zip has artifacts for, the OIDs it has more than one file of an artifact for, ''), or
    (None, set(), why) if it cannot be read."""
    try:
        with zipfile.ZipFile(path) as zf:
            names = zf.namelist()
    except (zipfile.BadZipFile, zipfile.LargeZipFile, OSError) as e:
        return None, set(), f'it cannot be read as a zip ({_printable(str(e))})'
    copies = defaultdict(int)
    for m in map(_ARTIFACT.search, names):
        if m:
            copies[(m['oid'], m['role'], m['ext'])] += 1
    return ({m['oid'] for m in map(_ARTIFACT_OID.search, names) if m},
            {oid for (oid, _, _), n in copies.items() if n > 1}, '')


def load_conformance(format_dir, output_dir='output', in_scope=lambda oid: True):
    """The conformance checker's failures for a format, from the CSVs it writes to output_dir, or None if there are
    none (it runs in CI, before the pages are built). in_scope(oid) says whether an algorithm is on the page."""
    if format_dir not in _CONFORMANCE:
        return None
    folder, column, page = _CONFORMANCE[format_dir]
    suffix = f'_{column}.csv'
    paths = glob.glob(os.path.join(output_dir, folder, '*' + suffix))
    if not paths:
        return None
    failures = {}
    for path in paths:
        rows = read_results(path, columns(format_dir)).results
        failures[os.path.basename(path)[:-len(suffix)]] = {t for t, r in rows.items() if r != 'Y' and in_scope(t[0])}
    return Conformance(page, failures)


def build(paths, in_scope=lambda oid: True):
    """The scoreboard for a list of manual result files of one format.

    in_scope(oid) says whether an algorithm is on the page: only its tests are counted.
    """
    format_dir = manual_format(paths)
    if format_dir is None:
        raise FreshnessError('not manual result files')
    # every path is located (manual_format), so providers/ is known even if no name is valid
    providers_dir = _match(paths[0])['providers']
    invalid_names = sorted(_printable(os.path.normpath(p)) for p in paths if not parse_name(_match(p)['name']))
    paths = [p for p in paths if parse_name(_match(p)['name'])]
    _check_history()
    zip_name = f'{format_dir}.zip'
    dirty = _dirty_paths(providers_dir)

    zips, invalid_producers = _producer_zips(providers_dir, zip_name)
    zip_commits = {p: (None, None) if path in dirty else _last_commit(path) for p, path in zips.items()}

    files, tests, results, duplicates, invalid_types, malformed = [], {}, {}, {}, {}, {}
    required = columns(format_dir)
    for path in sorted(paths):
        generator, verifier = parse_name(_match(path)['name'])
        commit, date = (None, None) if os.path.normpath(path) in dirty else _last_commit(path)
        if generator not in zips:
            current, reason = False, 'no zip by that name'
        elif commit is None:
            current, reason = True, ''
        elif zip_commits[generator][0] is None:
            current, reason = False, 'the zip has uncommitted changes'
        elif _is_ancestor(zip_commits[generator][0], commit):
            current, reason = True, ''
        else:
            current, reason = False, f'zip {zip_commits[generator][1]}, results {date}'
        files.append(ResultFile(path, generator, verifier, current, reason, date))
        owner = _match(path)['owner']
        if owner != verifier:
            # credited to the verifier its name gives, a copy in another directory would count as its results
            rows, dups, invalid, why = {}, set(), set(), (
                f'it is in providers/{_printable(owner)}/, but its name says the verifier is {verifier}; a result '
                f'file goes in the directory of its verifier')
        else:
            rows, dups, invalid, why = read_results(path, required)
        if why:
            malformed[path] = why
        results[path] = {t: r for t, r in rows.items() if in_scope(t[0])}
        duplicates[path] = {t for t in dups if in_scope(t[0])}
        invalid_types[path] = {t for t in invalid if in_scope(t[0])}

    return _assemble(format_dir, files, results, duplicates, invalid_types, malformed, invalid_names, zips,
                     invalid_producers, zip_commits, in_scope, automated=False)


def _producer_zips(providers_dir, zip_name):
    """({producer: path of its zip}, the directories with a zip whose names are not valid producer names). Producer
    names go on the page, so a zip in a directory whose name is not a valid producer name is not used."""
    zips, invalid_producers = {}, []
    for producer in sorted(os.listdir(providers_dir)):
        path = os.path.normpath(os.path.join(providers_dir, producer, zip_name))
        if os.path.isfile(path):
            if valid_producer(producer):
                zips[producer] = path
            else:
                invalid_producers.append(_printable(producer))
    return zips, invalid_producers


def _assemble(format_dir, files, results, duplicates, invalid_types, malformed, invalid_names, zips,
              invalid_producers, zip_commits, in_scope, automated):
    """The scoreboard from the result files read by build() or build_automated()."""
    tests = {path: set(r) for path, r in results.items()}

    # the tests of each producer: the rows any verifier has reported for an OID in its current zip
    expected = defaultdict(set)
    for f in files:
        if f.generator in zips:
            expected[f.generator] |= tests[f.path]
    contents = {p: zip_contents(path) for p, path in zips.items()}
    zip_oids = {p: c[0] for p, c in contents.items()}
    for producer in list(expected):
        oids = zip_oids[producer]
        if oids is not None:
            expected[producer] = {t for t in expected[producer] if t[0] in oids}
    producers = sorted(p for p in expected if expected[p])

    by_verifier = defaultdict(list)
    for f in files:
        by_verifier[f.verifier].append(f)

    # A verifier is scored on its algorithms: the ones in its own zip, and any others it has reported results
    # for. Every test of those algorithms counts, from every producer, so leaving out a type of test (checking
    # certificates but not key consistency, say) still costs.
    page_oids = {t[0] for p in producers for t in expected[p]}
    scores, scope = [], {}
    for verifier, vfiles in by_verifier.items():
        own = (zip_oids.get(verifier) or set()) & page_oids
        reported = {t[0] for f in vfiles for t in tests[f.path]} & page_oids
        scope[verifier] = own | reported
        counts = {'mine': [0, 0, 0], 'all': [0, 0, 0]}
        for producer in producers:
            done = set().union(*(tests[f.path] for f in vfiles if f.generator == producer and f.current))
            old = set().union(*(tests[f.path] for f in vfiles if f.generator == producer and not f.current))
            exp = expected[producer]
            for key, e in (('all', exp), ('mine', {t for t in exp if t[0] in scope[verifier]})):
                c = counts[key]
                c[0] += len(e & done)
                c[1] += len((e & old) - done)
                c[2] += len(e - done - old)
        dates = [f.date for f in vfiles if f.date]
        scores.append(VerifierScore(verifier, Counts(*counts['mine']), Counts(*counts['all']), len(scope[verifier]),
                                    max(dates) if dates else None))
    scores.sort(key=lambda s: (not s.mine.total, -s.mine.share, -s.all.current, s.verifier))

    reported_oids = defaultdict(set)
    for f in files:
        reported_oids[f.generator] |= {t[0] for t in tests[f.path]}
    # as in the producer table, a producer's own results for its zip do not count
    verified = {f.generator for f in files
                if f.current and f.verifier != f.generator and tests[f.path] & expected.get(f.generator, set())}
    return Scoreboard(
        format=format_dir,
        files=files,
        scores=scores,
        producers=producers,
        stale_on_page=[f for f in files if not f.current and f.generator in zips and tests[f.path]],
        unknown_on_page=[f for f in files if f.generator not in zips and tests[f.path]],
        invalid_names=invalid_names,
        invalid_types=invalid_types,
        malformed=malformed,
        unverified=[p for p in producers if p not in verified],
        not_verifying=[p for p in producers if p not in by_verifier],
        expected=dict(expected),
        results=results,
        duplicates=duplicates,
        zip_oids=zip_oids,
        zip_duplicates={p: {o for o in c[1] if in_scope(o)} for p, c in contents.items()},
        zip_errors={p: c[2] for p, c in contents.items() if c[2]},
        invalid_producers=invalid_producers,
        zip_dates={p: c[1] for p, c in zip_commits.items()},
        scope=scope,
        page_oids=page_oids,
        zip_unreported={p: sorted(o for o in (oids or ()) if in_scope(o) and o not in reported_oids[p])
                        for p, oids in zip_oids.items()},
        zips=zips,
        automated=automated)


# The CI verifiers write their results for each zip format to a folder of output/
_AUTOMATED = re.compile(r'(?:.*/)?output/(?P<folder>[^/]+)/(?:.*/)?[^/]+\.csv')
_AUTOMATED_FORMATS = {'certs': 'artifacts_certs_r5', 'cms': 'artifacts_cms_v3'}


def automated_format(paths):
    """The zip format of a list of the CI verifiers' result files (output/certs/..., output/cms/...), or None."""
    folders = {m['folder'] if m else None
               for m in (_AUTOMATED.fullmatch(os.path.normpath(p).replace(os.sep, '/')) for p in paths)}
    return _AUTOMATED_FORMATS.get(folders.pop()) if len(folders) == 1 else None


def build_automated(paths, format_dir, in_scope=lambda oid: True, excluded=(), providers_dir='providers'):
    """The board of the CI verifiers' results for every producer's current zip: only its producer parts are shown,
    since the same verifiers run on every zip on each build, so their results are never stale and there is nothing
    to rank them by. The verifiers in excluded (lint and conformance columns) are not counted."""
    zips, invalid_producers = _producer_zips(providers_dir, f'{format_dir}.zip')
    zip_commits = {p: _last_commit(path) for p, path in zips.items()}
    files, results, duplicates, invalid_types, malformed = [], {}, {}, {}, {}
    for path in sorted(paths):
        names = parse_name(os.path.basename(path))
        if names is None or names[1] in excluded:
            continue
        rows = read_results(path)
        files.append(ResultFile(path, names[0], names[1], True, '', None))
        if rows.malformed:
            malformed[path] = rows.malformed
        results[path] = {t: r for t, r in rows.results.items() if in_scope(t[0])}
        duplicates[path] = {t for t in rows.duplicates if in_scope(t[0])}
        invalid_types[path] = {t for t in rows.invalid if in_scope(t[0])}
    return _assemble(format_dir, files, results, duplicates, invalid_types, malformed, [], zips, invalid_producers,
                     zip_commits, in_scope, automated=True)


# Blue for good and warm colours for what needs attention, apart for colour-blind readers too
_COLORS = {'current': '#1f6fb2', 'stale': '#e69f00', 'untested': '#e6e6e6'}


def _swatch(kind, colors=None):
    color = (colors or _COLORS)[kind]
    return (f'<span style="display:inline-block;width:0.8em;height:0.8em;background:{color};'
            f'border:1px solid #999;vertical-align:middle"></span> {kind}')


def _bar(score):
    """An HTML bar of the current, stale and untested shares of some Counts, with the counts as its tooltip."""
    if not score.total:
        return 'none on this page'
    parts = ''.join(f'<span style="width:{n / score.total * 100:.2f}%;background:{_COLORS[kind]}"></span>'
                    for kind, n in (('current', score.current), ('stale', score.stale)) if n)
    title = f'{score.current} current, {score.stale} stale, {score.untested} untested'
    return (f'<span style="white-space:nowrap" title="{title}">'
            f'<span style="display:inline-flex;width:8em;height:0.9em;background:{_COLORS["untested"]};'
            f'border:1px solid #999;vertical-align:middle">{parts}</span> '
            f'{score.current / score.total:.0%}</span>')


def markdown(board):
    """The scoreboard section, as markdown."""
    lines = [_DETAILS_STYLE, '', '# Verifier Scoreboard {#verifier-scoreboard}', '']
    if not board.producers:
        return '\n'.join(lines + ['No results have been submitted for the algorithms on this page yet.', ''])

    active = [s for s in board.scores if s.all.current or s.all.stale]
    up_to_date = sum(1 for s in active if s.all.stale == 0)
    total = board.scores[0].all.total
    stale_files = len(board.stale_on_page)
    if len(active) == 1:
        headline = (f'**The one verifier with results on this page is {"" if up_to_date else "not "}up to date.**')
    else:
        headline = (f'**{up_to_date} of the {len(active)} verifiers with results on this page '
                    f'{"is" if up_to_date == 1 else "are"} up to date.**')
    if stale_files:
        headline += (f' {stale_files} result file{"s are" if stale_files != 1 else " is"} stale and '
                     f'{"are" if stale_files != 1 else "is"} left out of the [results by algorithm](#results-by-algorithm).')
    lines += [
        headline, '',
        f'There are {total} tests of the algorithms on this page, across {len(board.producers)} producers: '
        f'the rows that any verifier has reported for an algorithm in a producer\'s current `{board.format}.zip`. '
        f'A test is *current* if the verifier\'s results were committed with or after that zip, and *stale* '
        f'if the producer has updated its zip since. Stale results count here, but are left out of the '
        f'[results by algorithm](#results-by-algorithm).', '',
        'Each verifier is scored on its *implemented algorithms*: the ones in its own zip, and any others it has '
        'reported results for. Every test of those algorithms counts, from every producer, so a verifier that checks '
        'certificates but not key consistency, say, still has those tests to do. *Algorithms* and *All algorithms* '
        'show how broad each verifier is: a verifier of a few algorithms can top the ranking, but covers less of the '
        'page. *All algorithms* has the same bar over all tests on the page.',
        '',
        f'To move up, verify the current zips, your own included, and commit the results to '
        f'`providers/<you>/compatMatrices/{board.format}/<producer>_<you>.csv`.', '',
        ' '.join(_swatch(k) for k in _COLORS), '',
        '| Rank | Verifier | Implemented algorithms | Algorithms | Current tests | Stale tests | Untested | '
        f'All algorithms ({total} tests) | Last results |',
        '|---|---|---|---|---|---|---|---|---|',
    ]
    for rank, s in enumerate(board.scores, start=1):
        medal = _MEDALS[rank - 1] + ' ' if rank <= len(_MEDALS) and s.mine.current else ''
        stale = f'⚠️ {s.mine.stale}' if s.mine.stale else '0'
        lines.append(f'| {rank} | {medal}[{s.verifier}](#{_anchor(s.verifier)}) | {_bar(s.mine)} | {s.algorithms} | '
                     f'{s.mine.current} of {s.mine.total} | {stale} | {s.mine.untested} | '
                     f'{_bar(s.all)} | {s.last or "uncommitted"} |')
    lines.append('')

    lines += ['Click a verifier for its summary, at the bottom of the page: what it has left to test, its '
              'failures, and problems with its result files.', '']

    if board.stale_on_page:
        by_verifier = defaultdict(list)
        for f in board.stale_on_page:
            by_verifier[f.verifier].append(f)
        lines += ['<details>', f'<summary>The {stale_files} stale result files, by verifier</summary>', '']
        for verifier in sorted(by_verifier):
            items = ', '.join(f'{f.generator} ({f.reason})' for f in sorted(by_verifier[verifier]))
            lines.append(f'- **{verifier}**: {items}')
        lines += ['', '</details>', '']

    if board.unknown_on_page:
        items = ', '.join(f'`{os.path.basename(f.path)}`' for f in board.unknown_on_page)
        lines += [f'⚠️ **Results for producers with no `{board.format}.zip`, not shown:** {items}. The producer in '
                  f'a result file\'s name must be its directory name under `providers/`; the verifier\'s summary '
                  f'suggests the likely name.', '']
    if board.malformed:
        items = ', '.join(f'`{os.path.basename(p)}`' for p in sorted(board.malformed))
        lines += [f'⚠️ **Result files that could not be read, not used:** {items}. Their columns do not match the '
                  f'format; the verifier\'s summary says why.', '']
    if board.invalid_names:
        items = ', '.join(f'`{n}`' for n in board.invalid_names)
        lines += [f'⚠️ **Result files with invalid names, not used:** {items}. Name them '
                  f'`<producer>_<verifier>.csv`, with a lower-case `.csv` and only letters, digits, `.`, `-` and (in the '
                  f'verifier) `_`.', '']

    if board.zip_errors:
        items = ', '.join(f'[{p}](#{_producer_anchor(p)})' for p in sorted(board.zip_errors))
        lines += [f'⚠️ **Zips that cannot be read:** {items}. Their algorithms are not checked, and verifiers cannot '
                  'test them.', '']
    if board.invalid_producers:
        items = ', '.join(f'`{n}`' for n in board.invalid_producers)
        lines += [f'⚠️ **Zips in directories whose names are not valid producer names, not used:** {items}. A '
                  'producer name may use only letters, digits, `.` and `-`.', '']
    if board.unverified:
        lines += ['Producers with no current results from any other verifier: ' + ', '.join(board.unverified) + '.', '']
    if board.not_verifying:
        lines += ['Producers that have not submitted results yet: ' + ', '.join(board.not_verifying)
                  + '. Your results would show up here too.', '']
    return '\n'.join(lines)


_RESULT_COLORS = {'pass': '#1f6fb2', 'fail': '#d55e00'}


def _pass_bar(passes, fails):
    """An HTML bar of the passing and failing shares of some results, with the counts as its tooltip."""
    total = passes + fails
    if not total:
        return '-'
    parts = ''.join(f'<span style="width:{n / total * 100:.2f}%;background:{_RESULT_COLORS[kind]}"></span>'
                    for kind, n in (('pass', passes), ('fail', fails)) if n)
    return (f'<span style="white-space:nowrap" title="{passes} pass, {fails} fail">'
            f'<span style="display:inline-flex;width:6em;height:0.9em;border:1px solid #999;'
            f'vertical-align:middle">{parts}</span> {passes / total:.0%}</span>')


def _nowrap(text):
    """text kept on one line, so that a long cell elsewhere in the row does not squeeze it."""
    return f'<span style="white-space:nowrap">{text}</span>'


def _conformance_cell(conformance, p):
    """A producer's conformance result, linked to its section of the findings page; '-' if it was not checked."""
    if conformance is None or p not in conformance.failures:
        return '-'
    n = len(conformance.failures[p])
    return f'[{f"❌ {n}" if n else "✅"}]({conformance.page}#{_slug(p)})'


def producer_markdown(board, conformance=None, automated_page=None):
    """The producer table, as markdown: how widely, and how well, other verifiers verify each producer's current
    zip. It is not a ranking: how many verifiers test a zip is not up to its producer, and correctness hardly
    separates them; what a producer can act on is in its summary."""
    lines = ['# Producers {#producers}', '']
    if not board.producers:
        return '\n'.join(lines + ['No results have been submitted for the algorithms on this page yet.', ''])

    rows = []
    for p in board.producers:
        exp = board.expected[p]
        current_by, stale_by = defaultdict(dict), set()
        for f in board.files:
            # results for your own zip do not count, except a CI verifier's, which runs on every zip
            if f.generator != p or (f.verifier == p and not board.automated):
                continue
            mine = {t: r for t, r in board.results[f.path].items() if t in exp}
            if not mine:
                continue
            if f.current:
                current_by[f.verifier].update(mine)
            else:
                stale_by.add(f.verifier)
        stale_by -= set(current_by)
        passes = sum(1 for results in current_by.values() for r in results.values() if r == 'Y')
        fails = sum(1 for results in current_by.values() for r in results.values() if r != 'Y')
        passed = {t for results in current_by.values() for t, r in results.items() if r == 'Y'}
        rows.append((p, len(current_by), sorted(stale_by), passes, fails, len(passed & exp), len(exp)))
    rows.sort(key=lambda r: r[0].lower())
    if board.automated:
        return _automated_producer_table(board, rows, conformance)

    lines += [
        'How widely and how well the other implementations verify each producer\'s current '
        f'`{board.format}.zip`, for the algorithms on this page; results for your own zip are not counted. When a '
        'producer updates its '
        'zip, earlier results for it become stale, and the verifiers that have yet to verify the new zip are '
        'listed as *awaiting*: they are behind, not the producer.', '',
        ' '.join(_swatch(k, _RESULT_COLORS) for k in _RESULT_COLORS), '',
        '| Producer | Verified by | Results | Tests passed by someone | Awaiting re-verification | Zip |'
        + (' Conformance |' if conformance else ''),
        '|---|---|---|---|---|---|' + ('---|' if conformance else ''),
    ]
    for p, n_current, stale_by, passes, fails, passed, total in rows:
        awaiting = (f'⏳ {len(stale_by)}: ' + ', '.join(stale_by)) if stale_by else '0'
        lines.append(f'| {_nowrap(f"[{p}](#{_producer_anchor(p)})")} | '
                     f'{_nowrap(_plural(n_current, "verifier"))} | {_pass_bar(passes, fails)} | {passed} of {total} | '
                     f'{awaiting} | {_nowrap(board.zip_dates.get(p) or "uncommitted")} |'
                     + (f' {_conformance_cell(conformance, p)} |' if conformance else ''))
    if conformance:
        lines += ['', f'*Conformance:* the artifacts that fail the conformance checks of the zip format and the '
                      f'algorithm identifier rules, which a signature can pass even when an artifact is wrong; it '
                      f'links to the [findings]({conformance.page}).']
    lines += ['', 'Click a producer for its summary, at the bottom of the page: which of its tests fail and for '
              'whom, what no other verifier has tested yet, and problems with its zip.', '']
    if automated_page:
        lines += [f'The CI verifiers test every producer\'s current zip on each build; their results are on the '
                  f'[automated results page]({automated_page}).', '']
    return '\n'.join(lines)


def _automated_producer_table(board, rows, conformance):
    """The producer table of the automated results: as on the manual results' page, but with no stale results."""
    lines = ['# Producers {#producers}', '',
             'How the CI verifiers fare with each producer\'s current '
             f'`{board.format}.zip`, for the algorithms on this page. CI runs them on every zip on each build, so their '
             'results are always current. The lint and conformance columns are not counted here.', '',
             ' '.join(_swatch(k, _RESULT_COLORS) for k in _RESULT_COLORS), '',
             '| Producer | Tested by | Results | Tests passed by at least one | Zip |' + (' Conformance |' if conformance else ''),
             '|---|---|---|---|---|' + ('---|' if conformance else '')]
    for p, n_current, _, passes, fails, passed, total in rows:
        lines.append(f'| {_nowrap(f"[{p}](#{_producer_anchor(p)})")} | {_nowrap(_plural(n_current, "verifier"))} | '
                     f'{_pass_bar(passes, fails)} | {passed} of {total} | '
                     f'{_nowrap(board.zip_dates.get(p) or "uncommitted")} |'
                     + (f' {_conformance_cell(conformance, p)} |' if conformance else ''))
    if conformance:
        lines += ['', f'*Conformance:* the artifacts that fail the conformance checks of the zip format and the '
                      f'algorithm identifier rules, which a signature can pass even when an artifact is wrong; it '
                      f'links to the [findings]({conformance.page}).']
    lines += ['', 'Click a producer for its summary, at the bottom of the page: which of its tests fail and for '
              'which CI verifiers, the algorithms in its zip that no CI verifier tests, and problems with its zip.', '']
    return '\n'.join(lines)


def _slug(name):
    return re.sub(r'[^a-z0-9]+', '-', name.lower()).strip('-')


def _anchor(verifier):
    return 'verifier-' + _slug(verifier)


def _producer_anchor(producer):
    return 'producer-' + _slug(producer)


def _plural(n, word, plural=None):
    return f'{n} {word if n == 1 else (plural or word + "s")}'


def _details(summary, body_lines, open_=False):
    return ([f'<details{" open" if open_ else ""}>', f'<summary>{summary}</summary>', ''] + body_lines
            + ['', '</details>', ''])


def _test_name(alg_name, test):
    oid, kind = test
    return f'{alg_name(oid)}' + (f' `{kind}`' if kind else '')


def _kinds(kinds):
    """Test types for a table cell. A test with no type (a format with one test per algorithm) is shown by its
    algorithm alone, so it adds nothing here."""
    return ', '.join(f'`{k}`' for k in sorted(kinds) if k) or '—'


def _untested_table(missing, alg_name):
    """A table of untested tests ({producer: tests}): a row per algorithm and set of producers, with the tests
    they share."""
    by_test = defaultdict(list)
    for p, m in missing.items():
        for test in m:
            by_test[test].append(p)
    if not by_test:
        return []
    rows = defaultdict(list)
    for (oid, kind), ps in by_test.items():
        rows[(oid, tuple(sorted(ps)))].append(kind)
    lines = ['| Algorithm | Tests | Untested for |', '|---|---|---|']
    for (oid, ps), kinds in sorted(rows.items(), key=lambda i: (alg_name(i[0][0]), -len(i[0][1]), i[0][1])):
        lines.append(f'| {alg_name(oid)} | {_kinds(kinds)} | {", ".join(ps)} |')
    return lines


def _verifier_summary(board, score, current_results, alg_name):
    """The verifier part of an implementation's summary, as markdown lines."""
    v = score.verifier
    vfiles = [f for f in board.files if f.verifier == v]
    lines = [f'### As a verifier {{#{_anchor(v)}}}', '']
    scope = board.scope[v]
    lines += [f'**Implemented algorithms ({len(scope)}):** {_bar(score.mine)} &nbsp; {score.mine.current} current, '
              f'{score.mine.stale} stale, {score.mine.untested} untested of {score.mine.total} tests.', '',
              f'**All algorithms on this page ({len(board.page_oids)}):** {_bar(score.all)} &nbsp; '
              f'{score.all.current} current, {score.all.stale} stale, {score.all.untested} untested of '
              f'{score.all.total} tests.', '',
              '[Back to the verifier scoreboard](#verifier-scoreboard)', '']

    # 1 + 2. per producer
    rows = ['| Producer | Current | Stale | Untested | Zip | Results | File |', '|---|---|---|---|---|---|---|']
    stale_producers, untested_producers = [], []
    done_by_producer, old_by_producer = {}, {}
    for p in board.producers:
        pfiles = [f for f in vfiles if f.generator == p]
        done = set().union(*(set(board.results[f.path]) for f in pfiles if f.current))
        old = set().union(*(set(board.results[f.path]) for f in pfiles if not f.current))
        exp = {t for t in board.expected[p] if t[0] in scope}
        cur, st, un = len(exp & done), len((exp & old) - done), len(exp - done - old)
        done_by_producer[p], old_by_producer[p] = done, old
        if not pfiles:
            untested_producers.append(p)
        elif st:
            stale_producers.append(p)
        res_date = max((f.date or 'uncommitted' for f in pfiles), default='')
        links = ', '.join(f'[csv]({_REPO_URL}{f.path})' for f in pfiles)
        flag = '⚠️ ' if st else ''
        rows.append(f'| {p} | {cur} | {flag}{st} | {un} | {board.zip_dates.get(p) or "uncommitted"} | '
                    f'{res_date or "-"} | {links or "not tested"} |')
    lines += _details(f'Results by producer, implemented algorithms ({len(board.producers)} producers)', rows)
    if stale_producers:
        who = (stale_producers[0] + ' updated its zip' if len(stale_producers) == 1 else
               ', '.join(stale_producers[:-1]) + ' and ' + stale_producers[-1] + ' updated their zips')
        lines += [f'⚠️ **Stale:** {who} after your results. '
                  'Verify again to get these results back on the page.', '']

    # 3. untested: tests with no result at all (stale ones are covered above), for its algorithms (scored)
    # and for the other algorithms on the page (not scored)
    missing = {p: board.expected[p] - done_by_producer[p] - old_by_producer[p] for p in board.producers}
    mine = {p: {t for t in m if t[0] in scope} for p, m in missing.items()}
    other = {p: m - mine[p] for p, m in missing.items()}
    n_mine, n_other = sum(map(len, mine.values())), sum(map(len, other.values()))
    if n_mine:
        body = []
        whole = [p for p in untested_producers if mine[p]]
        if whole:
            body += ['**Not tested at all:** ' + ', '.join(
                f'{p} ({_plural(len(mine[p]), "test")})' for p in whole) + '.', '']
        body += _untested_table({p: m for p, m in mine.items() if p not in whole}, alg_name)
        lines += _details(f'Not yet tested, implemented algorithms ({_plural(n_mine, "test")})', body)
    if n_other:
        lines += _details(f'Not yet tested, other algorithms on this page ({_plural(n_other, "test")}, '
                          'not scored)', _untested_table(other, alg_name))

    # 4. failures and disagreements
    groups = {'fail_alone': [], 'fail_shared': [], 'fail_only': [], 'pass_alone': []}
    for p in board.producers:
        for test in sorted(board.expected[p]):
            own_result = current_results.get((p, test), {}).get(v)
            if own_result is None:
                continue
            others = {o: r for o, r in current_results[(p, test)].items() if o != v}
            passes = sum(1 for r in others.values() if r == 'Y')
            fails = len(others) - passes
            item = (f'- {_test_name(alg_name, test)} from {p}: others {passes} ✅'
                    + (f', {fails} ❌' if fails else ''))
            if own_result != 'Y':
                if not others:
                    groups['fail_only'].append(item)
                elif fails == 0:
                    groups['fail_alone'].append(item)
                else:
                    groups['fail_shared'].append(item)
            elif others and passes == 0:
                groups['pass_alone'].append(item)
    titles = {
        'fail_alone': 'You fail, every other verifier passes: a likely problem in your verifier',
        'pass_alone': 'You pass, every other verifier fails: check that your verifier rejects bad artifacts',
        'fail_shared': 'You fail, and so does at least one other verifier: a likely problem in the artifact',
        'fail_only': 'You fail, and no other verifier has a current result',
    }
    if any(groups.values()):
        body = []
        for key in ('fail_alone', 'pass_alone', 'fail_shared', 'fail_only'):
            if groups[key]:
                body += _details(f'{titles[key]} ({len(groups[key])})', groups[key])
        n_fail = len(groups['fail_alone']) + len(groups['fail_shared']) + len(groups['fail_only'])
        lines += _details(f'Failures and disagreements ({_plural(n_fail, "failure")}, '
                          f'{len(groups["fail_alone"]) + len(groups["pass_alone"])} disagreeing with everyone else)',
                          body)

    # 5. problems in the result files
    problems = [f'- `{os.path.basename(f.path)}`: {text}'
                for f in vfiles for _, text in file_problems(board, f, alg_name)]
    if problems:
        lines += [f'**Problems with your result files ({len(problems)}):**', ''] + problems + ['']

    return lines


ERROR, WARNING = 'error', 'warning'


def file_problems(board, f, alg_name):
    """The problems with a result file, as (severity, markdown text). An ERROR keeps all of the file's results
    off the page; a WARNING means some rows are left out, or points at a likely mistake."""
    if f.path in board.malformed:
        return [(ERROR, f'not read, because {board.malformed[f.path]}. Its results are not shown or counted '
                        'until it is fixed.')]
    if f.generator not in board.zips:
        if not board.results[f.path]:
            return []
        matches = difflib.get_close_matches(f.generator, list(board.zips), n=3, cutoff=0.6)
        hint = ''
        if len(matches) == 1:
            hint = f' Did you mean *{matches[0]}* (`{matches[0]}_{f.verifier}.csv`)?'
        elif matches:
            hint = ' Did you mean one of ' + ', '.join(f'*{m}*' for m in matches) + '?'
        return [(ERROR, f'there is no producer named *{f.generator}*; these results are not shown.{hint}')]
    problems = []
    if f.generator in board.zip_errors:
        problems.append((WARNING, f'{f.generator}\'s zip cannot be read, so these results cannot be checked against '
                                  f'its artifacts ({board.zip_errors[f.generator]}).'))
    oids = board.zip_oids.get(f.generator)
    if f.current and oids is not None:
        gone = sorted({t[0] for t in board.results[f.path] if t[0] not in oids}, key=alg_name)
        if gone:
            problems.append((WARNING, f'results for algorithms that are not in {f.generator}\'s zip: '
                                      + ', '.join(alg_name(o) for o in gone) + '.'))
    if board.invalid_types.get(f.path):
        problems.append((WARNING, 'rows left out because their algorithm has characters other than letters, digits, '
                                  '`.`, `_` and `-`, or their type other than letters, digits, `_` and `-` '
                                  '(shown as ?): ' + ', '.join(f'{alg_name(oid)} `{kind}`' for oid, kind
                                                              in sorted(board.invalid_types[f.path])) + '.'))
    dups = board.duplicates.get(f.path, set())
    in_zip = {t for t in dups if t[0] in board.zip_duplicates.get(f.generator, set())}
    if dups - in_zip:
        problems.append((WARNING, 'reported more than once (the worst result is used): '
                                  + ', '.join(_test_name(alg_name, t) for t in sorted(dups - in_zip)) + '.'))
    if in_zip:
        problems.append((WARNING, f'reported more than once, because {f.generator}\'s zip has more than one copy '
                                  f'of these artifacts (a problem for {f.generator} to fix): '
                                  + ', '.join(_test_name(alg_name, t) for t in sorted(in_zip)) + '.'))
    return problems


def _producer_summary(board, p, current_results, alg_name, conformance=None, automated_page=None):
    """The producer part of an implementation's summary, as markdown lines: how the other verifiers fare with
    its current zip. Its own results for its zip are left out, as in the producer table; on the automated
    results, where the verifiers are the CI's, nothing is left out and the summary is the producer's whole card."""
    ci = board.automated
    lines = [] if ci else [f'### As a producer {{#{_producer_anchor(p)}}}', '']
    exp = board.expected.get(p, set())
    others = {t: {v: r for v, r in current_results.get((p, t), {}).items() if ci or v != p} for t in exp}
    passes = sum(1 for rs in others.values() for r in rs.values() if r == 'Y')
    fails = sum(1 for rs in others.values() for r in rs.values() if r != 'Y')
    passed = sum(1 for rs in others.values() if 'Y' in rs.values())

    current_by, stale_by = set(), set()
    for f in board.files:
        if f.generator == p and (ci or f.verifier != p) and set(board.results[f.path]) & exp:
            (current_by if f.current else stale_by).add(f.verifier)
    stale_by -= current_by
    active = {s.verifier for s in board.scores if s.all.current or s.all.stale}
    not_by = sorted(active - current_by - stale_by - (set() if ci else {p}))
    whose = 'the CI verifiers' if ci else 'other verifiers'

    zip_date = board.zip_dates.get(p) or 'uncommitted'
    if passes + fails:
        lines += [f'**Results from {whose}:** {_pass_bar(passes, fails)} &nbsp; {passes} pass, {fails} fail; '
                  f'{passed} of {len(exp)} tests passed by at least one. Zip: {zip_date}.', '']
    else:
        lines += [f'**Results from {whose}:** none yet. Zip: {zip_date}.', '']
    who = ('**Verified by:** ' + (', '.join(sorted(current_by)) if current_by else
                                  'no CI verifier' if ci else 'no other verifier yet') + '.')
    if stale_by:
        who += (f' ⏳ **Awaiting re-verification** (they verified an earlier zip): {", ".join(sorted(stale_by))}.')
    if not_by:
        who += f' **Not tested by:** {", ".join(not_by)}.'
    lines += [who, '']
    if automated_page:
        lines += [f'The CI verifiers\' results for your current zip are on the [automated results page]'
                  f'({automated_page}#{_producer_anchor(p)}).', '']
    nonconforming = set()
    if conformance is not None and p in conformance.failures:
        nonconforming = conformance.failures[p]
        link = f'[findings]({conformance.page}#{_slug(p)})'
        if nonconforming:
            lines += [f'**Conformance:** ❌ {_plural(len(nonconforming), "test")} of artifacts that fail the '
                      f'conformance checks ({link}); marked 📋 below.', '']
        else:
            lines += [f'**Conformance:** ✅ no artifact fails the conformance checks ({link}).', '']
    lines += ['[Back to the producers](#producers)', '']

    def key(t):
        return (alg_name(t[0]), t[1])

    # failures, by who fails
    groups = {'all_fail': [], 'single': [], 'mixed': []}
    for t in sorted(exp, key=key):
        rs = others[t]
        bad = sorted(v for v, r in rs.items() if r != 'Y')
        if not bad:
            continue
        good = len(rs) - len(bad)
        name = _test_name(alg_name, t) + (' 📋' if t in nonconforming else '')
        if len(rs) == 1:
            groups['single'].append(f'- {name}: ❌ {bad[0]}')
        elif not good:
            groups['all_fail'].append(f'- {name}: ❌ all {len(bad)}: {", ".join(bad)}')
        else:
            groups['mixed'].append(f'- {name}: ❌ {", ".join(bad)}; ✅ {good} other' + ('s' if good != 1 else ''))
    titles = {
        'all_fail': 'Every verifier that tests it fails: a likely problem in your artifact',
        'single': 'The only verifier that tests it fails',
        'mixed': 'Some verifiers fail, others pass: a problem in your artifact or in the failing verifiers',
    }
    n_fail = sum(map(len, groups.values()))
    if n_fail:
        body = []
        for k in ('all_fail', 'single', 'mixed'):
            if groups[k]:
                body += _details(f'{titles[k]} ({len(groups[k])})', groups[k])
        lines += _details(f'Failing tests ({n_fail} of {len(exp)})', body)
    if nonconforming:
        by_oid = defaultdict(list)
        for oid, kind in nonconforming:
            by_oid[oid].append(kind)
        body = ['| Algorithm | Tests |', '|---|---|'] + [f'| {alg_name(oid)} | {_kinds(by_oid[oid])} |'
                                                     for oid in sorted(by_oid, key=alg_name)]
        lines += _details(f'Artifacts that fail the conformance checks ({_plural(len(nonconforming), "test")})', body)

    # tests no other verifier has a current result for
    untested = defaultdict(list)
    for t in exp:
        if not others[t]:
            untested[t[0]].append(t[1])
    if untested:
        body = ['| Algorithm | Tests |', '|---|---|']
        for oid in sorted(untested, key=alg_name):
            kinds = untested[oid]
            body.append(f'| {alg_name(oid)} | {_kinds(kinds)} |')
        n = sum(map(len, untested.values()))
        lines += _details(f'No current result from another verifier ({_plural(n, "test")}, '
                          f'{_plural(len(untested), "algorithm")})', body)
    unreported = board.zip_unreported.get(p) or []
    if unreported:
        lines += [f'**In your zip, but no {"CI " if ci else ""}verifier has reported on them** '
                  f'({_plural(len(unreported), "algorithm")}): '
                  + ', '.join(alg_name(o) for o in unreported) + '.', '']

    # problems with the zip
    problems = []
    if p in board.zip_errors:
        problems.append(f'- Your zip cannot be read: {board.zip_errors[p]}. Its algorithms are not checked, and '
                        'verifiers cannot test it.')
    if board.zip_duplicates.get(p):
        problems.append('- More than one file for the same artifact: '
                        + ', '.join(alg_name(o) for o in sorted(board.zip_duplicates[p], key=alg_name))
                        + '. Verifiers may test either copy.')
    oids = board.zip_oids.get(p)
    if oids is not None:
        gone = defaultdict(set)
        for f in board.files:
            if f.generator == p and f.current:
                for t in board.results[f.path]:
                    if t[0] not in oids:
                        gone[t[0]].add(f.verifier)
        for oid in sorted(gone, key=alg_name):
            problems.append(f'- {alg_name(oid)} is not in your zip, but {", ".join(sorted(gone[oid]))} '
                            f'reported results for it.')
    if problems:
        lines += [f'**Problems with your zip ({len(problems)}):**', ''] + problems + ['']
    return lines


def summaries(board, alg_name, conformance=None, automated_page=None):
    """One section per implementation, as markdown: as a verifier, and as a producer. alg_name(oid) gives an
    algorithm's name; conformance, the conformance checker's failures, if it ran; automated_page, the page of the
    automated results to link each producer to."""
    if not board.producers:
        return ''
    if board.automated:
        return _automated_summaries(board, alg_name, conformance)
    lines = ['# Implementation Summaries {#implementation-summaries}', '',
             'For each implementation, the algorithms on this page only. *As a verifier:* what it has left to '
             'test, its failures, and problems with its result files. *As a producer:* which of its tests fail and '
             'for whom, what no other verifier has tested yet, and problems with its zip.', '']

    current_results = _current_results(board)
    scores = {s.verifier: s for s in board.scores}
    producers = (set(board.producers) | {p for p, oids in board.zip_unreported.items() if oids}
                 | set(board.zip_errors))
    for name in sorted(set(scores) | producers, key=str.lower):
        lines += ['<div class="implementation">', '', f'## {name} {{#implementation-{_slug(name)}}}', '']
        if name in scores:
            lines += _verifier_summary(board, scores[name], current_results, alg_name)
        if name in producers:
            lines += _producer_summary(board, name, current_results, alg_name, conformance=conformance,
                                       automated_page=automated_page)
        lines += ['', '</div>', '']
    return '\n'.join(lines)


def _current_results(board):
    """(producer, test) -> {verifier: result}, from the current result files only."""
    current_results = defaultdict(dict)
    for f in board.files:
        if f.current:
            for test, result in board.results[f.path].items():
                current_results[(f.generator, test)][f.verifier] = result
    return current_results


def _automated_summaries(board, alg_name, conformance):
    """The automated results' summaries: one card per producer, since the verifiers are the CI's."""
    lines = ['# Producer Summaries {#producer-summaries}', '',
             'For each producer, the algorithms on this page only: which of its tests fail and for which CI '
             'verifiers, the algorithms in its zip that no CI verifier tests, and problems with its zip.', '']
    current_results = _current_results(board)
    producers = (set(board.producers) | {p for p, oids in board.zip_unreported.items() if oids}
                 | set(board.zip_errors))
    for p in sorted(producers, key=str.lower):
        lines += ['<div class="implementation">', '', f'## {p} {{#{_producer_anchor(p)}}}', '']
        lines += _producer_summary(board, p, current_results, alg_name, conformance=conformance)
        lines += ['', '</div>', '']
    return '\n'.join(lines)
