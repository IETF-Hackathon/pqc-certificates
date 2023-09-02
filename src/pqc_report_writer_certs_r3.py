import csv
import operator
import os.path
import re
import argparse
from typing import NamedTuple, Optional, Sequence, Mapping
from mdutils.mdutils import MdUtils

OUTPUT_FILE = 'pqc_hackathon_results_certs_r3.md'

_FILENAME_REGEX = re.compile('^(?P<generator>[^_]+)_(?P<verifier>[^.]+)\.(?P<extension>(csv|json))$', re.IGNORECASE)
_OID_MAPPING_LINE_REGEX = re.compile(r'^\|\s*(?P<name>[^|]+)\s*\|\s*(~~)?(?P<oid>\d+(\.\d+)+)\*?(~~)?\s*\|.*$')

class SubmittedAlgorithmResult(NamedTuple):
    generator: str
    key_algorithm_oid: str

# set to automatically not add duplicates
_sars = []
_submittedAlgsList = []

class AlgorithmVerificationResult(NamedTuple):
    generator: str
    verifier: str
    key_algorithm_oid: str
    test_result: Optional[bool]

def _parse_json_file(generator, verifier, f) -> Sequence[AlgorithmVerificationResult]:
    pass


def _parse_csv_file(generator, verifier, f, oid_name_mappings) -> Sequence[AlgorithmVerificationResult]:
    c = csv.DictReader(f)

    avrs = []

    for row in c:
        key_algorithm_oid = row['key_algorithm_oid']
        d = {
            'generator': generator,
            'verifier': verifier,
            'key_algorithm_oid': key_algorithm_oid,
            'test_result': row['test_result']
        }

        avrs.append(AlgorithmVerificationResult(**d))

        e = {
            'generator': generator,
            'key_algorithm_oid': key_algorithm_oid
        }

        if SubmittedAlgorithmResult(**e) not in _sars:
            _sars.append(SubmittedAlgorithmResult(**e))

        if key_algorithm_oid not in _submittedAlgsList:
            _submittedAlgsList.append( key_algorithm_oid )

    return avrs

def _format_result_cell(avr) -> str:
    result_lines = []

    r = getattr(avr, 'test_result')

    if r is None:
        display_result = '?'
    elif r == 'Y':
        display_result = '✅'
    else:
        display_result = '❌'

    # if the result is '?', then do not print the line
    if (display_result != '?'):
        result_lines.append(f'{display_result}')

    return '<br>'.join(result_lines)


def _parse_oid_name_mapping_file(f) -> Mapping[str, str]:
    mappings = {}

    for line in f.readlines():
        line = line.strip()

        m = _OID_MAPPING_LINE_REGEX.match(line)

        if m is None:
            continue

        mappings[m.group('oid').strip()] = m.group('name').strip()

    return mappings


def _get_alg_name_by_oid_str(oid_to_name_mappings, oid_str):
    return oid_to_name_mappings.get(oid_str, oid_str)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('oid_mapping_file', type=argparse.FileType('r'))
    parser.add_argument('files', nargs='+')

    args = parser.parse_args()

    oid_name_mappings = _parse_oid_name_mapping_file(args.oid_mapping_file)

    avrs = []

    for file in args.files:
        m = _FILENAME_REGEX.match(os.path.basename(file))

        if m is None:
            raise ValueError(f'File name does not match naming convention: "{os.path.basename(file)}"')

        with open(file, 'r') as f:
            generator = m['generator']
            verifier = m['verifier']

            if m['extension'].casefold() == 'csv'.casefold():
                avrs.extend(_parse_csv_file(generator, verifier, f, oid_name_mappings))
            else:
                avrs.extend(_parse_json_file(generator, verifier, f))

    implementations = set()
    for avr in avrs:
        implementations.add(avr.generator)
        implementations.add(avr.verifier)

    implementations = list(implementations)
    implementations.sort()

    algorithms = list({avr.key_algorithm_oid for avr in avrs})
    algorithms.sort()

    alg_oid_getter = operator.attrgetter('key_algorithm_oid')
    avrs.sort(key=alg_oid_getter)

    avrs_by_alg = {k: [] for k in algorithms}
    for avr in avrs:
        avrs_by_alg[avr.key_algorithm_oid].append(avr)

    md_file = MdUtils(file_name=OUTPUT_FILE, title='IETF PQC Hackathon Interoperability Results')

    md_file.new_paragraph(text='In all tables below, Rows are producers. Columns are parsers.\n')


    md_file.new_header(level=1, title=f'Algorithms Tested')
    md_file.new_paragraph(text='To be in this table, an algorithm must have a test result in one of the tables below (pass or fail). Algorithms for which we have artifacts but no test results are not shown.\n')

    _submittedAlgsList.sort()
    submittedAlgNames = []
    for alg_oid in _submittedAlgsList:
        submittedAlgNames.append(_get_alg_name_by_oid_str(oid_name_mappings, alg_oid))

    submittedAlgsCells = ['-'] + submittedAlgNames
    _sars.sort(key=alg_oid_getter)
    sars_by_alg = {k: [] for k in _submittedAlgsList}
    for sar in _sars:
        sars_by_alg[sar.key_algorithm_oid].append(sar)


    for generator in implementations:
        submittedAlgsCells.append(generator)
        for alg_oid, sars in sars_by_alg.items():
            relevant_sars = [sar for sar in sars if sar.generator == generator ]

            if len(relevant_sars) > 1:
                raise ValueError(f'Multiple results for {generator}')

            if len(relevant_sars) == 1:
                submittedAlgsCells.append('✅')
            else:
                submittedAlgsCells.append('')

    
    md_file.new_table(columns=len(_submittedAlgsList) + 1, rows=len(implementations) + 1, text=submittedAlgsCells, text_align='left')

    for alg_oid, avrs in avrs_by_alg.items():
        alg_name = _get_alg_name_by_oid_str(oid_name_mappings, alg_oid)

        md_file.new_header(level=1, title=f'{alg_name} ({alg_oid})')

        cells = ['-'] + implementations
        for generator in implementations:
            cells.append(generator)

            for verifier in implementations:
                relevant_avrs = [avr for avr in avrs if avr.generator == generator and avr.verifier == verifier]

                if len(relevant_avrs) > 1:
                    raise ValueError(f'Multiple results for {alg_oid}: {generator}-{verifier}')

                if len(relevant_avrs) == 0:
                    # synthesize a result
                    relevant_avr = AlgorithmVerificationResult(generator, verifier, alg_oid, None)
                else:
                    relevant_avr = relevant_avrs[0]

                cells.append(_format_result_cell(relevant_avr))

        md_file.new_table(columns=len(implementations) + 1, rows=len(implementations) + 1, text=cells, text_align='left')

    md_file.new_table_of_contents(table_title='Algorithms', depth=1)
    md_file.create_md_file()


if __name__ == '__main__':
    main()