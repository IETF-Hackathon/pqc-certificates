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


class AlgorithmVerificationResult(NamedTuple):
    generator: str
    verifier: str
    key_algorithm_oid: str
    test_result: Optional[bool]


_ARTIFACTS_UNDER_TEST = ['test_result']


def _parse_cell(value: str) -> Optional[bool]:
    if not value:
        return None

    return value.casefold() == 'y'.casefold()


def _parse_json_file(generator, verifier, f) -> Sequence[AlgorithmVerificationResult]:
    pass


def _parse_csv_file(generator, verifier, f) -> Sequence[AlgorithmVerificationResult]:
    c = csv.DictReader(f)

    avrs = []

    for row in c:
        d = {
            'generator': generator,
            'verifier': verifier,
            'key_algorithm_oid': row['key_algorithm_oid'],
            'test_result': row['test_result']
        }

        avrs.append(AlgorithmVerificationResult(**d))

    return avrs


def _format_result_cell(avr) -> str:
    result_lines = []

    r = getattr(avr, 'test_result')

    if r is None:
        display_result = '?'
    elif r:
        display_result = '✅'
    else:
        display_result = '❌'

    # if the result is '?', then do not pring the line
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
    oids = re.split(r'[^0-9.]+', oid_str)

    return ' & '.join((oid_to_name_mappings.get(o, 'Unknown') for o in oids))


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
                avrs.extend(_parse_csv_file(generator, verifier, f))
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

    md_file.new_paragraph(text='Rows are producers. Columns are parsers.\n')

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
                    relevant_avr = AlgorithmVerificationResult(generator, verifier, alg_oid, None, None, None, None, None)
                else:
                    relevant_avr = relevant_avrs[0]

                cells.append(_format_result_cell(relevant_avr))

        md_file.new_table(columns=len(implementations) + 1, rows=len(implementations) + 1, text=cells, text_align='left')

    md_file.new_table_of_contents(table_title='Algorithms', depth=1)
    md_file.create_md_file()


if __name__ == '__main__':
    main()
