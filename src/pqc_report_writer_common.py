import csv
import json
import operator
from os import SEEK_SET
import os.path
import re
import argparse
from typing import NamedTuple, Optional, Sequence, Mapping
from mdutils.mdutils import MdUtils

_FILENAME_REGEX = re.compile(r'^(?P<generator>[^_]+)_(?P<verifier>[^.]+)\.(?P<extension>(csv|json))$', re.IGNORECASE)
_OID_MAPPING_LINE_REGEX = re.compile(r'^\|\s*(?P<name>[^|]+)\s*\|\s*(~~)?(?P<oid>\d+(\.\d+)+)\*?(~~)?\s*\|.*$')
_HYBRID_FORMAT_NAME_REGEX = re.compile(r'(?P<hybrid_format>[^_]+)_(?P<oid1>[^_]+)_with_(?P<oid2>[^_]+)', re.IGNORECASE)


class SubmittedAlgorithmResult(NamedTuple):
    generator: str
    key_algorithm_oid: str

# set to automatically not add duplicates
_submittedAlgorithmResults = []
_submittedAlgsList = []

class AlgorithmVerificationResult(NamedTuple):
    generator: str
    verifier: str
    key_algorithm_oid: str
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

    relevant_avrs = [algorithmVerificationResult for algorithmVerificationResult in algorithmVerificationResults if algorithmVerificationResult.generator == generator and algorithmVerificationResult.key_algorithm_oid == oid]

    print("DEBUG: relevant_avrs for "+generator+", ("+oid+") is: "+str(relevant_avrs))
    
    for algorithmVerificationResult in relevant_avrs:
        if algorithmVerificationResult.test_result is None or algorithmVerificationResult.test_result is '':
            continue

        if algorithmVerificationResult.test_result is 'Y':
            passedOne = True
        else:
            failedOne = True

        if not passedOne and not failedOne:
            return -1
        elif not passedOne and failedOne:
            return 0
        elif passedOne and failedOne:
            return 1
        elif passedOne and not failedOne:
            return 2
    
def _parse_csv_file(
    generator, verifier, f, oid_name_mappings, include_all_oids
) -> Sequence[AlgorithmVerificationResult]:
    c = csv.DictReader(f)

    algorithmVerificationResults = []

    for row in c:
        try:
            key_algorithm_oid = row['key_algorithm_oid']
            if not include_all_oids and not key_algorithm_oid in oid_name_mappings:
                continue
            d = {
                'generator': generator,
                'verifier': verifier,
                'key_algorithm_oid': key_algorithm_oid,
                'test_result': row['test_result']
            }

            algorithmVerificationResults.append(AlgorithmVerificationResult(**d))

            if row['test_result'] != None and row['test_result'] != "":
                e = {
                    'generator': generator,
                    'key_algorithm_oid': key_algorithm_oid
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

    args = parser.parse_args()
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
                algorithmVerificationResults.extend(_parse_csv_file(generator, verifier, f, oid_name_mappings, args.include_all_oids))
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

    md_file = MdUtils(file_name=args.outfile, title=f'IETF PQC Hackathon {args.interop_type} Interoperability Results')

    md_file.new_paragraph(text="<style> table { border-collapse: collapse; } th, td { border: solid black 1px; padding: 0 1ex; } </style>")



    md_file.new_header(level=1, title=f'Algorithms Submitted')
    md_file.new_paragraph(text="✅ = passing all verifiers<br>◒ = passing some verifiers<br>⚪︎ = not passing any verifiers<br>")
    md_file.new_paragraph()
    _submittedAlgsList.sort()

    submittedAlgsCells = ['-'] + generators
    _submittedAlgorithmResults.sort(key=alg_oid_getter)
    sars_by_alg = {k: [] for k in _submittedAlgsList}
    for SubmittedAlgorithmResult in _submittedAlgorithmResults:
        sars_by_alg[SubmittedAlgorithmResult.key_algorithm_oid].append(SubmittedAlgorithmResult)


    for alg_oid, SubmittedAlgorithmResults in sars_by_alg.items():
        submittedAlgsCells.append(_get_alg_name_by_oid_str(oid_name_mappings, alg_oid))
        for generator in generators:
            """
            -1: no verifiers
            0: did not pass any verifiers
            1: passed some verifiers
            2: passed all verifiers
            """
            no = passedAllVerifiers(generator, alg_oid, algorithmVerificationResults)
            if (no == -1):
                submittedAlgsCells.append('')
            elif (no == 0):
                submittedAlgsCells.append('⚪︎')
            elif (no == 1):
                submittedAlgsCells.append('◒')
            else:
                submittedAlgsCells.append('✅')

    md_file.new_table(columns=len(generators) + 1, rows=len(_submittedAlgsList) + 1, text=submittedAlgsCells, text_align='left')



    for alg_oid, algorithmVerificationResults in avrs_by_alg.items():
        alg_name = _get_alg_name_by_oid_str(oid_name_mappings, alg_oid)

        md_file.new_header(level=1, title=f'{alg_name} ({alg_oid})')
        md_file.new_paragraph(text='Rows are producers. Columns are parsers.\n')

        cells = ['-'] + verifiers
        for generator in generators:
            cells.append(generator)

            for verifier in verifiers:
                relevant_avrs = [algorithmVerificationResult for algorithmVerificationResult in algorithmVerificationResults if algorithmVerificationResult.generator == generator and algorithmVerificationResult.verifier == verifier]

                if len(relevant_avrs) > 1:
                    raise ValueError(f'Multiple results for {alg_oid}: {generator}-{verifier}')

                if len(relevant_avrs) == 0:
                    # synthesize a result
                    relevant_avr = AlgorithmVerificationResult(generator, verifier, alg_oid, None)
                else:
                    relevant_avr = relevant_avrs[0]

                cells.append(_format_result_cell(relevant_avr))

        md_file.new_table(columns=len(verifiers) + 1, rows=len(generators) + 1, text=cells, text_align='left')

    md_file.create_md_file()


if __name__ == '__main__':
    main()
