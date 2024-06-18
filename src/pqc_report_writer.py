import csv
import json
import operator
from os import SEEK_SET
import os.path
import re
import argparse
from typing import NamedTuple, Optional, Sequence, Mapping
from mdutils.mdutils import MdUtils


_FILENAME_REGEX = re.compile('^(?P<generator>[^_]+)_(?P<verifier>[^.]+)\.(?P<extension>(csv|json))$', re.IGNORECASE)
_OID_MAPPING_LINE_REGEX = re.compile(r'^\|\s*(?P<name>[^|]+)\s*\|\s*(~~)?(?P<oid>\d+(\.\d+)+)\*?(~~)?\s*\|.*$')


class AlgorithmVerificationResult(NamedTuple):
    generator: str
    verifier: str
    key_algorithm_oid: str
    ta: Optional[bool]
    ca: Optional[bool]
    ee: Optional[bool]
    crl_ta: Optional[bool]
    crl_ca: Optional[bool]


_ARTIFACTS_UNDER_TEST = ['ta', 'ca', 'ee', 'crl_ta', 'crl_ca']


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
            **{k: _parse_cell(row[k]) for k in _ARTIFACTS_UNDER_TEST}
        }

        avrs.append(AlgorithmVerificationResult(**d))

    return avrs


def _format_result_cell(avr) -> str:
    result_lines = []

    for artifact_key in _ARTIFACTS_UNDER_TEST:
        r = getattr(avr, artifact_key)

        display_key = artifact_key.upper().replace('_', ' ')

        if r is None:
            display_result = '?'
        elif r:
            display_result = '✅'
        else:
            display_result = '❌'

        # if the result is '?', then do not pring the line
        if (display_result != '?'):
            result_lines.append(f'{display_key}: {display_result}')

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
    oids = re.split(r'[^0-9.]+', oid_str)

    return ' & '.join((oid_to_name_mappings.get(o, 'Unknown') for o in oids))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('oid_mapping_file', type=argparse.FileType('r'))
    parser.add_argument('files', nargs='+')

    args = parser.parse_args()

    oid_name_mappings = _parse_oid_name_mapping_file(args.oid_mapping_file)

    oids_json = _parse_oid_name_mapping_file(args.oid_mapping_file, stop_at_experimental=True)

    with open("oids.json", "w") as f:  
        json.dump(oids_json, f)

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

    md_file = MdUtils(file_name='pqc_hackathon_results.md', title='IETF PQC Hackathon Interoperability Results')

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
