import csv
import json
import operator
from os import SEEK_SET
import os.path
import re
import argparse
from typing import NamedTuple, Optional, Sequence, Mapping
from mdutils.mdutils import MdUtils
from mdutils.tools.Link import Inline
from datetime import datetime
import pytz

_FILENAME_REGEX = re.compile(r'^(?P<generator>[^_]+)_(?P<verifier>[^.]+)\.(?P<extension>(csv|json))$', re.IGNORECASE)
_OID_MAPPING_LINE_REGEX = re.compile(r'^\|\s*(?P<name>[^|]+)\s*\|\s*(~~)?(?P<oid>\d+(\.\d+)+)\*?(~~)?\s*\|.*$')
_HYBRID_FORMAT_NAME_REGEX = re.compile(r'(?P<hybrid_format>[^_]+)_(?P<oid1>[^_]+)_with_(?P<oid2>[^_]+)', re.IGNORECASE)
_OID_REGEX = re.compile(r'^\d+(\.\d+)+$')

# Columns that hold lint results rather than verification results, with the page that lists
# their findings. A 'W' result there is shown as a warning sign linking to the provider's section
# of that page, and these columns are not counted in the summary table.
_LINT_VERIFIERS = {'pkilint': 'pkilint_certs.html'}


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

def _parse_json_file(generator, verifier, f) -> Sequence[AlgorithmVerificationResult]:
    pass


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
    generator, verifier, f, oid_name_mappings, include_all_oids, is_on_page
) -> Sequence[AlgorithmVerificationResult]:
    c = csv.DictReader(f)

    algorithmVerificationResults = []

    for row in c:
        try:
            key_algorithm_oid = row['key_algorithm_oid']
            if not include_all_oids and not key_algorithm_oid in oid_name_mappings:
                continue
            if not is_on_page(key_algorithm_oid):
                continue
            friendly = _get_alg_name_by_oid_str(oid_name_mappings, key_algorithm_oid)
            if 'type' in row and row['type'] != None and row['type'] != "":
                friendly += "-" + row['type']
                key_algorithm_oid += "-" + row['type']
            d = {
                'generator': generator,
                'verifier': verifier,
                'key_algorithm_oid': key_algorithm_oid,
                'friendly': friendly,
                'test_result': row['test_result']
            }

            algorithmVerificationResults.append(AlgorithmVerificationResult(**d))

            if row['test_result'] != None and row['test_result'] != "":
                e = {
                    'generator': generator,
                    'key_algorithm_oid': key_algorithm_oid,
                    'friendly': friendly
                }

                # The algorithms Tested table should only contain tests with a pass or fail result
                if SubmittedAlgorithmResult(**e) not in _submittedAlgorithmResults:
                    _submittedAlgorithmResults.append(SubmittedAlgorithmResult(**e))

                if key_algorithm_oid not in _submittedAlgsList:
                    _submittedAlgsList.append( key_algorithm_oid )
        except Exception as e:
            print("Error reading "+ str(f.name))
            raise e

    return algorithmVerificationResults

def _format_result_cell(algorithmVerificationResult) -> str:
    result_lines = []

    r = getattr(algorithmVerificationResult, 'test_result')

    if r is None or r == "":
        display_result = '?'
    elif r == 'Y' or r == 'y':
        display_result = '✅'
    elif r == 'W' or r == 'w':
        page = _LINT_VERIFIERS.get(algorithmVerificationResult.verifier)
        if page:
            display_result = Inline.new_link(f'{page}#{_anchor(algorithmVerificationResult.generator)}', '⚠️')
        else:
            display_result = '⚠️'
    else:
        display_result = '❌'

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

    
    algorithmVerificationResults = []

    for file in args.files:
        m = _FILENAME_REGEX.match(os.path.basename(file))

        if m is None:
            raise ValueError(f'File name does not match naming convention: "{os.path.basename(file)}"')

        with open(file, 'r') as f:
            generator = m['generator']
            verifier = m['verifier']

            if m['extension'].casefold() == 'csv'.casefold():
                algorithmVerificationResults.extend(_parse_csv_file(generator, verifier, f, oid_name_mappings, args.include_all_oids, is_on_page))
            else:
                algorithmVerificationResults.extend(_parse_json_file(generator, verifier, f))

    generators = set()
    verifiers = set()
    for algorithmVerificationResult in algorithmVerificationResults:
        generators.add(algorithmVerificationResult.generator)
        verifiers.add(algorithmVerificationResult.verifier)

    generators = list(generators)
    generators.sort()
    verifiers = list (verifiers)
    verifiers.sort()

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

    md_file.new_paragraph()
    md_file.new_header(level=1, title=f'Algorithms Submitted')

    if not _submittedAlgsList:
        md_file.new_paragraph(text="No test results have been submitted for the algorithms on this page.")
        md_file.create_md_file()
        return

    md_file.new_paragraph(text="✅ = passing all verifiers<br>◒ = passing some verifiers<br>⚪︎ = not passing any verifiers<br>Columns represent producers who submitted artifacts. Verifiers are not listed in this table, but are listed in the broken-out tables below.<br>")
    if any(avr.verifier in _LINT_VERIFIERS for avr in algorithmVerificationResults):
        md_file.new_paragraph(text="⚠️ in a lint column (" + ", ".join(sorted(_LINT_VERIFIERS)) + ") = the certificate has lint findings; the sign links to them. Lint columns are not counted in this table.")
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
                submittedAlgsCells.append(f'⚪︎ {passCount}/{totalCount}')
            elif (no == 1):
                submittedAlgsCells.append(f'◒ {passCount}/{totalCount}')
            else:
                submittedAlgsCells.append(f'✅ {passCount}/{totalCount}')

    md_file.new_table(columns=len(generators) + 1, rows=len(_submittedAlgsList) + 1, text=submittedAlgsCells, text_align='left')



    for alg_oid, algorithmVerificationResults in avrs_by_alg.items():
        friendly = friendly_by_alg[alg_oid]

        md_file.new_header(level=1, title=f'{friendly} ({alg_oid})', header_id=friendly)
        md_file.new_paragraph(text='Rows are producers. Columns are parsers.\n')

        cells = ['-'] + verifiers
        for generator in generators:
            cells.append(generator)

            for verifier in verifiers:
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

        md_file.new_table(columns=len(verifiers) + 1, rows=len(generators) + 1, text=cells, text_align='left')

    md_file.create_md_file()


if __name__ == '__main__':
    main()
