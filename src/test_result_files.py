"""Tests for result_files.py, the one way the result pages read result files.

Run from the repository root: python3 -m pytest src/test_result_files.py
"""
import os
import subprocess
import sys

import pytest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import result_files as rf  # noqa: E402

A = '2.16.840.1.101.3.4.3.17'
R5 = ('key_algorithm_oid', 'type', 'test_result')
WRITER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'pqc_report_writer_common.py')


def _write(tmp_path, text, name='p_v.csv', mode='w'):
    path = tmp_path / name
    if mode == 'wb':
        path.write_bytes(text)
    else:
        path.write_text(text)
    return str(path)


def test_header_and_values_are_stripped_and_results_upper_cased(tmp_path):
    path = _write(tmp_path, f'key_algorithm_oid, type, test_result\n {A} , cert , y\n{A},priv, n \n')
    rows = rf.read_results(path, R5)
    assert rows.malformed == ''
    assert rows.results == {(A, 'cert'): 'Y', (A, 'priv'): 'N'}


def test_blank_lines_and_rows_without_a_result_are_skipped(tmp_path):
    path = _write(tmp_path, f'key_algorithm_oid,type,test_result\n\n{A},cert,Y\n  \n{A},priv,\n')
    assert rf.read_results(path, R5).results == {(A, 'cert'): 'Y'}


def test_a_file_without_a_type_column_has_untyped_tests(tmp_path):
    path = _write(tmp_path, f'key_algorithm_oid,test_result\n{A},Y\n')
    assert rf.read_results(path).results == {(A, ''): 'Y'}


@pytest.mark.parametrize('text, reason', [
    (f'key_algorithm_oid,test_result\n{A},cert,Y\n', 'the header has no `type` column'),
    (f'key_algorithm_oid,type,test_result\n{A},cert,Y,extra\n', '1 row (the first on line 2) has a different'),
    (f'key_algorithm_oid,type,test_result\n{A},cert,Y\n{A},Y\n', '1 row (the first on line 3) has a different'),
    ('', 'the file is empty'),
])
def test_a_file_whose_rows_do_not_match_its_columns_is_not_read(tmp_path, text, reason):
    rows = rf.read_results(_write(tmp_path, text), R5)
    assert reason in rows.malformed
    assert rows.results == {}


def test_a_byte_order_mark_is_allowed_and_other_encodings_are_not(tmp_path):
    bom = _write(tmp_path, b'\xef\xbb\xbfkey_algorithm_oid,type,test_result\n' + f'{A},cert,Y\n'.encode(), mode='wb')
    assert rf.read_results(bom, R5).results == {(A, 'cert'): 'Y'}
    latin1 = _write(tmp_path, b'key_algorithm_oid,type,test_result\n1.2.3,caf\xe9,Y\n', name='q_v.csv', mode='wb')
    assert rf.read_results(latin1, R5).malformed == 'it is not UTF-8 text'


def test_rows_with_characters_not_allowed_in_the_algorithm_or_type_are_left_out(tmp_path):
    path = _write(tmp_path, f'key_algorithm_oid,type,test_result\n{A},cert,Y\n<b>x</b>,cert,Y\n{A},ce<b>rt,Y\n')
    rows = rf.read_results(path, R5)
    assert rows.results == {(A, 'cert'): 'Y'}
    assert rows.invalid == {('?b?x?/b?', 'cert'), (A, 'ce?b?rt')}


@pytest.mark.parametrize('results', [['Y', 'W', 'N'], ['N', 'W', 'Y'], ['W', 'Y'], ['Y', 'Y']])
def test_the_worst_of_several_rows_is_used(tmp_path, results):
    """An automated verifier writes a row per artifact, and a zip can hold several copies of one: if any copy fails,
    the test fails, whatever the order of the rows."""
    path = _write(tmp_path, 'key_algorithm_oid,type,test_result\n' + ''.join(f'{A},cert,{r}\n' for r in results))
    rows = rf.read_results(path, R5)
    assert rows.results[(A, 'cert')] == ('N' if 'N' in results else 'W' if 'W' in results else 'Y')
    assert rows.duplicates == {(A, 'cert')}


def test_names():
    assert rf.parse_name('p_my.verifier.csv') == ('p', 'my.verifier')
    assert rf.parse_name('seventhsense.ai_v_x.csv') == ('seventhsense.ai', 'v_x')
    assert rf.parse_name('p_v.CSV') is None
    assert rf.parse_name('p_v.csv\n') is None
    assert rf.parse_name('p+q_v.csv') is None
    assert not rf.valid_type('cert\n')
    assert rf.valid_producer('seventhsense.ai') and not rf.valid_producer('bad<img>')


def test_the_tables_count_each_verifier_once_per_test(tmp_path, monkeypatch):
    """Issue #366: a verifier that reports one test more than once (one row per copy of an artifact) is one verifier
    in both the summary table and the algorithm's table, with the worst of its results."""
    monkeypatch.chdir(tmp_path)
    (tmp_path / 'oid_mapping.md').write_text(f'| Name | OID |\n|---|---|\n| ML-DSA-44 | {A} |\n')
    out = tmp_path / 'output'
    out.mkdir()
    (out / 'p_v.csv').write_text(f'key_algorithm_oid,type,test_result\n{A},cert,Y\n{A},cert,Y\n{A},priv,N\n'
                                 f'{A},priv,Y\n')
    (out / 'p_w.csv').write_text(f'key_algorithm_oid,type,test_result\n{A},cert,Y\n{A},priv,Y\n')
    result = subprocess.run([sys.executable, WRITER, 'oid_mapping.md', 'page.md', 'Certificate',
                             str(out / 'p_v.csv'), str(out / 'p_w.csv')], capture_output=True, text=True)
    assert result.returncode == 0, result.stderr
    page = (tmp_path / 'page.md').read_text()
    assert '✅ 2/2' in page            # cert: v once, and w
    assert '◒ 1/2' in page             # priv: v's worst result fails, w passes
    assert 'p_v.csv: 2 tests reported more than once; the worst result of each is used' in result.stderr
