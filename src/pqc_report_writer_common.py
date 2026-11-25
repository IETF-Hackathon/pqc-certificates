import json
import operator
from os import SEEK_SET
import os.path
import re
import argparse
import sys
from typing import NamedTuple, Optional, Sequence, Mapping
from mdutils.mdutils import MdUtils
from mdutils.tools.Link import Inline
from datetime import datetime
import pytz

import result_files
import verifier_scoreboard

_OID_MAPPING_LINE_REGEX = re.compile(r'^\|\s*(?P<name>[^|]+)\s*\|\s*(~~)?(?P<oid>\d+(\.\d+)+)\*?(~~)?\s*\|.*$')
_HYBRID_FORMAT_NAME_REGEX = re.compile(r'(?P<hybrid_format>[^_]+)_(?P<oid1>[^_]+)_with_(?P<oid2>[^_]+)', re.IGNORECASE)
_OID_REGEX = re.compile(r'^\d+(\.\d+)+$')

# Columns that hold lint results rather than verification results, with the page that lists
# their findings. They come after the verifiers' columns and are not counted in the summary table.
# A 'W' result there is shown as a warning sign and an 'N' (a FATAL finding) as a cross, both
# linking to the provider's section of that page.
_LINT_VERIFIERS = {'pkilint': 'pkilint_certs.html'}

# Verifiers whose crosses link to a page that explains them (the provider's section of that page).
# Unlike the lint columns, they are counted in the summary table like any other verifier.
# The conformance columns (src/test_artifacts_conformance.py) report failures only.
_CONFORMANCE_VERIFIERS = {'r5-conformance': 'r5_conformance_certs.html', 'cms-v3-conformance': 'cms_v3_conformance.html'}
_FINDINGS_PAGES = {**_LINT_VERIFIERS, **_CONFORMANCE_VERIFIERS}


def _anchor(name):
    """Section id of a provider on a lint page (same rule as src/test_certs_r5_pkilint.py)."""
    return re.sub(r'[^a-z0-9]+', '-', name.lower()).strip('-')

_PAGE_STANDARDIZED = 'standardized'
_PAGE_PRESTANDARD = 'prestandard'
_PAGE_TITLES = {
    _PAGE_STANDARDIZED: 'Standardized Algorithms',
    _PAGE_PRESTANDARD: 'Pre-standard Algorithms',
}


class SubmittedAlgorithmResult(NamedTuple):
    generator: str
    key_algorithm_oid: str
    friendly: str

# set to automatically not add duplicates
_submittedAlgorithmResults = []
_submittedAlgsList = []

class AlgorithmVerificationResult(NamedTuple):
    generator: str
    verifier: str
    key_algorithm_oid: str
    friendly: str
    test_result: Optional[bool]

def passedAllVerifiers(generator, oid, algorithmVerificationResults) -> int:
    """
    -1: no verifiers
    0: did not pass any verifiers
    1: passed some verifiers
    2: passed all verifiers
    """
    passedOne = False
    failedOne = False
    passCount = 0
    totalCount = 0

    relevant_avrs = [algorithmVerificationResult for algorithmVerificationResult in algorithmVerificationResults if algorithmVerificationResult.generator == generator and algorithmVerificationResult.key_algorithm_oid == oid]
    
    for algorithmVerificationResult in relevant_avrs:
        if algorithmVerificationResult.test_result == None or algorithmVerificationResult.test_result == '':
            continue
        if algorithmVerificationResult.verifier in _LINT_VERIFIERS:
            continue

        totalCount += 1
        if algorithmVerificationResult.test_result == 'Y':
            passedOne = True
            passCount += 1
        else:
            failedOne = True

    if not passedOne and not failedOne:
        return (-1, passCount, totalCount)
    elif not passedOne and failedOne:
        return (0, passCount, totalCount)
    elif passedOne and failedOne:
        return (1, passCount, totalCount)
    elif passedOne and not failedOne:
        return (2, passCount, totalCount)
    
def _parse_csv_file(
    generator, verifier, path, required, oid_name_mappings, include_all_oids, is_on_page
) -> Sequence[AlgorithmVerificationResult]:
    # The one way of reading result files, so that the tables and the scoreboard agree on every row
    rows = result_files.read_results(path, required)
    if rows.malformed:
        print(f'{path}: not read, because {rows.malformed}', file=sys.stderr)
        return []
    if rows.duplicates:
        print(f'{path}: {len(rows.duplicates)} tests reported more than once; the worst result of each is used',
              file=sys.stderr)
    for oid, kind in sorted(rows.invalid):
        print(f'{path}: skipping a row of {oid} with characters that are not allowed in its algorithm or type '
              f'"{kind}"', file=sys.stderr)

    algorithmVerificationResults = []
    for (key_algorithm_oid, kind), test_result in rows.results.items():
        if not include_all_oids and not key_algorithm_oid in oid_name_mappings:
            continue
        if not is_on_page(key_algorithm_oid):
            continue
        friendly = _get_alg_name_by_oid_str(oid_name_mappings, key_algorithm_oid)
        if kind:
            friendly += "-" + kind
            key_algorithm_oid += "-" + kind
        algorithmVerificationResults.append(AlgorithmVerificationResult(generator, verifier, key_algorithm_oid,
                                                                        friendly, test_result))

        # The algorithms Tested table should only contain tests with a pass or fail result
        submitted = SubmittedAlgorithmResult(generator, key_algorithm_oid, friendly)
        if submitted not in _submittedAlgorithmResults:
            _submittedAlgorithmResults.append(submitted)
        if key_algorithm_oid not in _submittedAlgsList:
            _submittedAlgsList.append(key_algorithm_oid)

    return algorithmVerificationResults

def _format_result_cell(algorithmVerificationResult) -> str:
    result_lines = []

    r = getattr(algorithmVerificationResult, 'test_result')

    if r is None or r == "":
        display_result = '?'
    elif r == 'Y' or r == 'y':
        display_result = '✅'
    else:
        display_result = '⚠️' if r == 'W' or r == 'w' else '❌'
        page = _FINDINGS_PAGES.get(algorithmVerificationResult.verifier)
        if page:
            display_result = Inline.new_link(f'{page}#{_anchor(algorithmVerificationResult.generator)}', display_result)

    # if the result is '?', then do not print the line
    if (display_result != '?'):
        result_lines.append(f'{display_result}')

    return '<br>'.join(result_lines)


def _parse_oid_name_mapping_file(f, stop_at_experimental=False) -> Mapping[str, str]:
    mappings = {}

    # set iterator to the start of the file in case this function is called repeatedly
    f.seek(0, SEEK_SET)

    for line in f.readlines():
        line = line.strip()

        if stop_at_experimental and line == "# Experimental and Historical OIDs":
            break

        m = _OID_MAPPING_LINE_REGEX.match(line)

        if m is None:
            continue

        mappings[m.group('oid').strip()] = m.group('name').strip()

    return mappings


def _parse_standardized_oids_file(f) -> set:
    """Read the list of standardized OIDs: one OID per line, '#' starts a comment."""
    oids = set()

    for line_number, line in enumerate(f, start=1):
        oid = line.split('#', 1)[0].strip()

        if not oid:
            continue

        if _OID_REGEX.match(oid) is None:
            raise ValueError(f'{f.name}:{line_number}: not a valid OID: "{oid}"')

        oids.add(oid)

    return oids


def _get_alg_name_by_oid_str(oid_to_name_mappings, oid_str):

    # If the oid_str represents a hybrid cert type,
    # then the oid_str will be in the format
    # <hybrid_format>_<oid1>_with_<oid2>
    m = _HYBRID_FORMAT_NAME_REGEX.match(oid_str)

    if m is not None:
        # Display only the hybrid format, not the OIDs.
        return m['hybrid_format']

    # else it is a simple OID.
    return oid_to_name_mappings.get(oid_str, oid_str)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('oid_mapping_file', type=argparse.FileType('r'))
    parser.add_argument('outfile')
    parser.add_argument('interop_type')
    parser.add_argument('files', nargs='+')
    parser.add_argument("--include-all-oids", action="store_true",
                        help="also include historical and experimental OIDs")
    parser.add_argument("--standardized-oids", type=argparse.FileType('r'),
                        help="file listing the OIDs of standardized algorithms (required with --page)")
    parser.add_argument("--page", choices=list(_PAGE_TITLES),
                        help="only report standardized or pre-standard algorithms (default: all)")
    parser.add_argument("--other-page",
                        help="link to the report page for the other set of algorithms")
    parser.add_argument("--automated-page",
                        help="link each producer of the manual results to this page of the automated results")

    args = parser.parse_args()

    if (args.page is None) != (args.standardized_oids is None):
        parser.error("--page and --standardized-oids must be used together")

    if args.page is None:
        is_on_page = lambda oid: True
    else:
        standardized_oids = _parse_standardized_oids_file(args.standardized_oids)
        want_standardized = args.page == _PAGE_STANDARDIZED
        # OIDs not in the list (including hybrid "<format>_<oid>_with_<oid>" keys) are pre-standard.
        is_on_page = lambda oid: (oid in standardized_oids) == want_standardized
    if args.include_all_oids:
        print("Including historical and experimental OIDs.  Only to this for your own fun times, don't commit the result")

    oid_name_mappings = _parse_oid_name_mapping_file(args.oid_mapping_file, stop_at_experimental=not args.include_all_oids)

    oids_json = _parse_oid_name_mapping_file(args.oid_mapping_file, stop_at_experimental=True)

    with open("oids.json", "w") as f:  
        json.dump(oids_json, f)

    
    # Manual results (providers/<verifier>/compatMatrices/<format>/*.csv): leave out the stale ones, and add the
    # verifier scoreboard, the producer table and the implementation summaries, for the algorithms on this page
    board = conformance_failures = None
    files = args.files

    def in_scope(oid):
        """Whether an algorithm is on this page."""
        return (args.include_all_oids or oid in oid_name_mappings) and is_on_page(oid)

    try:
        if verifier_scoreboard.manual_format(files) is not None:
            board = verifier_scoreboard.build(files, in_scope=in_scope)
        elif verifier_scoreboard.automated_format(files) is not None:
            # the CI verifiers' results: the producer table and summaries only; the lint and conformance columns
            # are not verifiers
            board = verifier_scoreboard.build_automated(files, verifier_scoreboard.automated_format(files),
                                                        in_scope=in_scope, excluded=set(_FINDINGS_PAGES))
        if board is not None:
            # the conformance checker's failures, from the CI job that runs before the pages are built
            conformance_failures = verifier_scoreboard.load_conformance(board.format, in_scope=in_scope)
    except verifier_scoreboard.FreshnessError as e:
        parser.error(str(e))

    def summaries():
        """The implementation summaries, at the end of the page."""
        return verifier_scoreboard.summaries(board, lambda oid: _get_alg_name_by_oid_str(oid_name_mappings, oid),
                                             conformance=conformance_failures, automated_page=args.automated_page)

    if board is not None and not board.automated:
        current = {os.path.normpath(p) for p in board.current_paths}
        files = [f for f in files if os.path.normpath(f) in current]

    algorithmVerificationResults = []

    # the columns the manual results of this format must have; the automated results need only the default ones
    required = result_files.columns(board.format if board is not None and not board.automated else None)
    for file in files:
        # the one name rule for result files, as everywhere that reads them
        names = result_files.parse_name(os.path.basename(file))
        if names is None:
            raise ValueError(f'File name does not match naming convention: "{os.path.basename(file)}"')
        generator, verifier = names
        algorithmVerificationResults.extend(_parse_csv_file(generator, verifier, file, required, oid_name_mappings,
                                                            args.include_all_oids, is_on_page))

    generators = set()
    verifiers = set()
    for algorithmVerificationResult in algorithmVerificationResults:
        generators.add(algorithmVerificationResult.generator)
        verifiers.add(algorithmVerificationResult.verifier)

    generators = list(generators)
    generators.sort()
    verifiers = list (verifiers)
    verifiers.sort(key=lambda v: (v in _LINT_VERIFIERS, v))  # lint columns last

    algorithms = list({algorithmVerificationResult.key_algorithm_oid for algorithmVerificationResult in algorithmVerificationResults})
    algorithms.sort()

    alg_oid_getter = operator.attrgetter('key_algorithm_oid')
    algorithmVerificationResults.sort(key=alg_oid_getter)

    avrs_by_alg = {k: [] for k in algorithms}
    for algorithmVerificationResult in algorithmVerificationResults:
        avrs_by_alg[algorithmVerificationResult.key_algorithm_oid].append(algorithmVerificationResult)

    friendly_by_alg = {k: [] for k in algorithms}
    for algorithmVerificationResult in algorithmVerificationResults:
        friendly_by_alg[algorithmVerificationResult.key_algorithm_oid] = algorithmVerificationResult.friendly

    title = f'IETF PQC Hackathon {args.interop_type} Interoperability Results'
    if args.page is not None:
        title += f': {_PAGE_TITLES[args.page]}'

    md_file = MdUtils(file_name=args.outfile, title=title)

    md_file.new_paragraph(text="<style> table { border-collapse: collapse; width:auto !important; } thead th { position: sticky; top: 0; z-index: 1; background: white; } th, td { border: solid black 1px; padding: 0 1ex; } col { width: auto !important; } </style>")

    md_file.new_paragraph(text="Generated: "+str(datetime.now(tz=pytz.utc).strftime('%Y-%m-%d %H:%M %Z')))

    if args.page is not None and args.other_page:
        other_page = _PAGE_PRESTANDARD if args.page == _PAGE_STANDARDIZED else _PAGE_STANDARDIZED
        md_file.new_paragraph(text="See also: " + Inline.new_link(args.other_page, _PAGE_TITLES[other_page]))

    if board is not None:
        if not board.automated:
            md_file.write('\n\n' + verifier_scoreboard.markdown(board))
        md_file.write('\n\n' + verifier_scoreboard.producer_markdown(board, conformance=conformance_failures,
                                                                    automated_page=args.automated_page))

    md_file.new_paragraph()
    md_file.new_header(level=1, title='Results by Algorithm')

    if not _submittedAlgsList:
        md_file.new_paragraph(text="No test results have been submitted for the algorithms on this page.")
        if board is not None:
            md_file.write('\n\n' + summaries())
        md_file.create_md_file()
        return

    md_file.new_paragraph(text="Each cell is the number of verifiers that pass the producer's artifacts for the algorithm, of those that tested them: ✅ = passing all verifiers; ⚠️ = failing some verifiers; ❌ = failing every verifier.<br>Columns represent producers who submitted artifacts. Verifiers are not listed in this table, but are listed in the broken-out tables below.<br>")
    for conformance in sorted({avr.verifier for avr in algorithmVerificationResults if avr.verifier in _CONFORMANCE_VERIFIERS}):
        md_file.new_paragraph(text=f"{conformance} checks the artifacts against their zip format and the rules on algorithm identifiers, which a signature can still verify without (for example, a key identified by its algorithm's own OID). It reports failures only, as ❌ that link to the reason: a compliant artifact has no {conformance} result.")
    lint_columns = sorted({avr.verifier for avr in algorithmVerificationResults if avr.verifier in _LINT_VERIFIERS})
    if lint_columns:
        md_file.new_paragraph(text="Lint (" + ", ".join(lint_columns) + ", the last column of the broken-out tables): ✅ = no lint findings; ⚠️ = WARNING or ERROR findings; ❌ = a FATAL finding (the certificate could not be decoded, for example because it is not DER). ⚠️ and ❌ link to the findings. Lint columns are not counted in this table, and the verifiers' ✅ / ❌ do not depend on them.")
    md_file.new_paragraph()
    _submittedAlgsList.sort()

    submittedAlgsCells = ['-'] + generators
    _submittedAlgorithmResults.sort(key=alg_oid_getter)
    sars_by_alg = {k: [] for k in _submittedAlgsList}
    for SubmittedAlgorithmResult in _submittedAlgorithmResults:
        sars_by_alg[SubmittedAlgorithmResult.key_algorithm_oid].append(SubmittedAlgorithmResult)


    for alg_oid, SubmittedAlgorithmResults in sars_by_alg.items():
        friendly = friendly_by_alg[alg_oid]
        submittedAlgsCells.append(Inline.new_link('#'+friendly, friendly))
        for generator in generators:
            """
            -1: no verifiers
            0: did not pass any verifiers
            1: passed some verifiers
            2: passed all verifiers
            """
            (no, passCount, totalCount) = passedAllVerifiers(generator, alg_oid, algorithmVerificationResults)
            if (no == -1):
                submittedAlgsCells.append('')
            elif (no == 0):
                submittedAlgsCells.append(f'❌ {passCount}/{totalCount}')
            elif (no == 1):
                submittedAlgsCells.append(f'⚠️ {passCount}/{totalCount}')
            else:
                submittedAlgsCells.append(f'✅ {passCount}/{totalCount}')

    md_file.new_table(columns=len(generators) + 1, rows=len(_submittedAlgsList) + 1, text=submittedAlgsCells, text_align='left')



    for alg_oid, algorithmVerificationResults in avrs_by_alg.items():
        friendly = friendly_by_alg[alg_oid]

        md_file.new_header(level=2, title=f'{friendly} ({alg_oid})', header_id=friendly)
        table_lint = sorted({avr.verifier for avr in algorithmVerificationResults if avr.verifier in _LINT_VERIFIERS})
        lint_note = f' The last column, {", ".join(table_lint)}, is a lint, not a parser: ⚠️ and ❌ link to its findings.' if table_lint else ''
        md_file.new_paragraph(text='Rows are producers. Columns are parsers.' + lint_note + '\n')

        # a lint column only in the tables it has results for (the key tables have none)
        table_verifiers = [v for v in verifiers if v not in _LINT_VERIFIERS or v in table_lint]
        cells = ['-'] + table_verifiers
        for generator in generators:
            cells.append(generator)

            for verifier in table_verifiers:
                relevant_avrs = [algorithmVerificationResult for algorithmVerificationResult in algorithmVerificationResults if algorithmVerificationResult.generator == generator and algorithmVerificationResult.verifier == verifier]

                if len(relevant_avrs) > 1:
                    print(f'Multiple results for {alg_oid}: {generator}-{verifier}, skipping duplicate entry.')
                    # just use the first one
                    relevant_avr = relevant_avrs[0]
                elif len(relevant_avrs) == 0:
                    # synthesize a result
                    relevant_avr = AlgorithmVerificationResult(generator, verifier, alg_oid, friendly, None)
                else:
                    relevant_avr = relevant_avrs[0]

                cells.append(_format_result_cell(relevant_avr))

        md_file.new_table(columns=len(table_verifiers) + 1, rows=len(generators) + 1, text=cells, text_align='left')

    if board is not None:
        md_file.write('\n\n' + summaries())

    md_file.create_md_file()


if __name__ == '__main__':
    main()
