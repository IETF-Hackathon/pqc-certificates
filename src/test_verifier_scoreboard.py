"""Tests for verifier_scoreboard.py and check_result_files.py (result_files.py has its own).

Run from the repository root: python3 -m pytest src/test_verifier_scoreboard.py

Each test builds a small git repository of providers, zips and result files, so that freshness is judged from
real commits.
"""
import os
import pathlib
import re
import subprocess
import sys
import zipfile

import pytest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import result_files as rf  # noqa: E402
import verifier_scoreboard as vs  # noqa: E402

R5 = 'artifacts_certs_r5'
CMS = 'artifacts_cms_v3'
A, B, C = '2.16.840.1.101.3.4.3.17', '2.16.840.1.101.3.4.3.18', '2.16.840.1.101.3.4.4.1'
NAMES = {A: 'ML-DSA-44', B: 'ML-DSA-65', C: 'ML-KEM-512'}
SRC = os.path.dirname(os.path.abspath(__file__))
CHECKER = os.path.join(SRC, 'check_result_files.py')
WRITER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'pqc_report_writer_common.py')


def _git(*args):
    subprocess.run(['git', *args], check=True, capture_output=True)


class Repo:
    """A git repository in the current directory, with helpers to add zips and result files."""

    def __init__(self):
        self.day = 0

    def zip(self, producer, oids, fmt=R5, extra=()):
        """A zip with a certificate for each OID, and any extra file names."""
        path = f'providers/{producer}/{fmt}.zip'
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with zipfile.ZipFile(path, 'w') as z:
            for oid in oids:
                z.writestr(f'{fmt}/{NAMES.get(oid, "alg")}-{oid}_ta.der', b'cert')
            for name in extra:
                z.writestr(f'{fmt}/{name}', b'copy')
        return path

    def csv(self, producer, verifier, rows, fmt=R5, header=None):
        """A result file; rows are (OID, type, result) for R5 and (OID, result) for CMS, or raw lines."""
        if header is None:
            header = 'key_algorithm_oid,type,test_result' if fmt == R5 else 'key_algorithm_oid,test_result'
        path = f'providers/{verifier}/compatMatrices/{fmt}/{producer}_{verifier}.csv'
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, 'w') as f:
            f.write(header + '\n')
            for row in rows:
                f.write((row if isinstance(row, str) else ','.join(row)) + '\n')
        return path

    def commit(self, message='commit'):
        """Commit everything, a day after the previous commit."""
        self.day += 1
        date = f'2026-01-{self.day:02d}T12:00:00'
        _git('add', '-A')
        subprocess.run(['git', 'commit', '-q', '-m', message], check=True, capture_output=True,
                       env={**os.environ, 'GIT_AUTHOR_DATE': date, 'GIT_COMMITTER_DATE': date})
        return f'2026-01-{self.day:02d}'


@pytest.fixture
def repo(tmp_path, monkeypatch):
    monkeypatch.chdir(tmp_path)
    for key, value in {'GIT_AUTHOR_NAME': 'test', 'GIT_AUTHOR_EMAIL': 'test@example.com',
                       'GIT_COMMITTER_NAME': 'test', 'GIT_COMMITTER_EMAIL': 'test@example.com',
                       'GIT_CONFIG_GLOBAL': os.devnull, 'GIT_CONFIG_NOSYSTEM': '1'}.items():
        monkeypatch.setenv(key, value)
    _git('init', '-q')
    return Repo()


def _files(fmt=R5):
    return sorted(str(p) for p in pathlib.Path('providers').glob(f'*/compatMatrices/{fmt}/*.csv'))


def _file(board, path):
    return next(f for f in board.files if f.path == path)


def _alg_name(oid):
    return NAMES.get(oid, oid)


# Freshness

def test_results_committed_after_the_zip_are_current(repo):
    repo.zip('p', [A])
    repo.commit()
    path = repo.csv('p', 'v', [(A, 'cert', 'Y')])
    repo.commit()
    board = vs.build(_files())
    assert _file(board, path).current
    assert board.current_paths == [path]


def test_results_committed_with_the_zip_are_current(repo):
    """Self-results committed together with the artifacts count, like any other."""
    repo.zip('p', [A])
    path = repo.csv('p', 'p', [(A, 'cert', 'Y')])
    repo.commit()
    assert _file(vs.build(_files()), path).current


def test_results_for_an_older_zip_are_stale(repo):
    repo.zip('p', [A])
    repo.commit()
    path = repo.csv('p', 'v', [(A, 'cert', 'Y')])
    results_date = repo.commit()
    repo.zip('p', [A, B])
    zip_date = repo.commit()
    board = vs.build(_files())
    f = _file(board, path)
    assert not f.current
    assert f.reason == f'zip {zip_date}, results {results_date}'
    assert board.stale_on_page == [f]
    assert board.current_paths == []


def test_freshness_follows_ancestry_not_dates(repo):
    """Results committed on a branch that does not contain the latest zip are stale, whatever their date."""
    repo.zip('p', [A])
    repo.commit()
    _git('checkout', '-q', '-b', 'results')
    path = repo.csv('p', 'v', [(A, 'cert', 'Y')])
    repo.commit()
    _git('checkout', '-q', '-')
    repo.zip('p', [A, B])
    repo.commit()
    _git('merge', '-q', '--no-edit', 'results')
    assert not _file(vs.build(_files()), path).current


def test_uncommitted_results_are_current(repo):
    repo.zip('p', [A])
    repo.commit()
    path = repo.csv('p', 'v', [(A, 'cert', 'Y')])
    f = _file(vs.build(_files()), path)
    assert f.current
    assert f.date is None


def test_an_uncommitted_zip_makes_committed_results_stale(repo):
    repo.zip('p', [A])
    repo.commit()
    path = repo.csv('p', 'v', [(A, 'cert', 'Y')])
    repo.commit()
    repo.zip('p', [A, B])
    f = _file(vs.build(_files()), path)
    assert not f.current
    assert f.reason == 'the zip has uncommitted changes'


def test_a_shallow_clone_is_refused(repo, tmp_path, monkeypatch):
    repo.zip('p', [A])
    repo.csv('p', 'v', [(A, 'cert', 'Y')])
    repo.commit()
    _git('commit', '-q', '--allow-empty', '-m', 'second')
    clone = tmp_path / 'clone'
    _git('clone', '-q', '--depth', '1', f'file://{tmp_path}', str(clone))
    monkeypatch.chdir(clone)
    with pytest.raises(vs.FreshnessError, match='shallow'):
        vs.build(_files())


# Names, columns and rows

def test_results_for_an_unknown_producer_are_left_out_with_a_suggestion(repo):
    repo.zip('carl-redhound', [A])
    repo.zip('v', [A])
    path = repo.csv('redhound', 'v', [(A, 'cert', 'Y')])
    repo.csv('carl-redhound', 'v', [(A, 'cert', 'Y')])
    repo.commit()
    board = vs.build(_files())
    f = _file(board, path)
    assert not f.current
    assert board.unknown_on_page == [f]
    [(severity, text)] = vs.file_problems(board, f, _alg_name)
    assert severity == vs.ERROR
    assert 'no producer named *redhound*' in text and '*carl-redhound*' in text


def test_invalid_file_names_are_listed_and_not_used(repo):
    repo.zip('p', [A])
    repo.csv('p', 'v', [(A, 'cert', 'Y')])
    bad = 'providers/v/compatMatrices/artifacts_certs_r5/p+q_v.csv'
    with open(bad, 'w') as f:
        f.write('key_algorithm_oid,type,test_result\n')
    repo.commit()
    board = vs.build(_files())
    assert board.invalid_names == ['providers/v/compatMatrices/artifacts_certs_r5/p?q_v.csv']
    assert [f.path for f in board.files] == ['providers/v/compatMatrices/artifacts_certs_r5/p_v.csv']
    assert not rf.valid_name(bad)


@pytest.mark.parametrize('header, rows, reason', [
    ('key_algorithm_oid,test_result', [f'{A},cert,Y'], 'the header has no `type` column'),
    ('key_algorithm_oid,type,test_result', [f'{A},cert,Y,extra'], '1 row (the first on line 2) has a different'),
    ('key_algorithm_oid,type,test_result', [f'{A},cert,Y', f'{A},Y'], '1 row (the first on line 3) has a different'),
])
def test_a_file_whose_rows_do_not_match_the_format_is_not_read(repo, header, rows, reason):
    repo.zip('p', [A])
    path = repo.csv('p', 'v', rows, header=header)
    repo.commit()
    board = vs.build(_files())
    assert reason in board.malformed[path]
    assert board.results[path] == {}
    assert board.current_paths == []
    [(severity, _)] = vs.file_problems(board, _file(board, path), _alg_name)
    assert severity == vs.ERROR


def test_blank_lines_are_ignored(repo):
    repo.zip('p', [A])
    path = repo.csv('p', 'v', [(A, 'cert', 'Y'), '', (A, 'priv', 'N'), ''])
    repo.commit()
    board = vs.build(_files())
    assert path not in board.malformed
    assert board.results[path] == {(A, 'cert'): 'Y', (A, 'priv'): 'N'}


def test_a_cms_file_needs_no_type_column(repo):
    repo.zip('p', [A], fmt=CMS)
    path = repo.csv('p', 'v', [(A, 'Y')], fmt=CMS)
    repo.commit()
    board = vs.build(_files(CMS))
    assert path not in board.malformed
    assert board.results[path] == {(A, ''): 'Y'}


def test_rows_with_an_invalid_type_are_left_out(repo):
    repo.zip('p', [A])
    path = repo.csv('p', 'v', [(A, 'cert', 'Y'), (A, 'ce<b>rt', 'Y')])
    repo.commit()
    board = vs.build(_files())
    assert board.results[path] == {(A, 'cert'): 'Y'}
    assert board.invalid_types[path] == {(A, 'ce?b?rt')}
    [(severity, text)] = vs.file_problems(board, _file(board, path), _alg_name)
    assert severity == vs.WARNING and 'ce?b?rt' in text


def test_rows_without_a_result_are_ignored(repo):
    repo.zip('p', [A])
    path = repo.csv('p', 'v', [(A, 'cert', 'Y'), (A, 'priv', '')])
    repo.commit()
    assert vs.build(_files()).results[path] == {(A, 'cert'): 'Y'}


def test_duplicate_rows_are_reported_and_blamed_on_the_zip_when_it_has_copies(repo):
    repo.zip('p', [A, B], extra=[f'ML-DSA-65-copy-{B}_ta.der'])
    path = repo.csv('p', 'v', [(A, 'cert', 'Y'), (A, 'cert', 'N'), (B, 'cert', 'Y'), (B, 'cert', 'Y')])
    repo.commit()
    board = vs.build(_files())
    assert board.duplicates[path] == {(A, 'cert'), (B, 'cert')}
    assert board.zip_duplicates['p'] == {B}
    texts = [text for _, text in vs.file_problems(board, _file(board, path), _alg_name)]
    assert any(t.startswith('reported more than once (the worst result is used): ML-DSA-44') for t in texts)
    assert board.results[path][(A, 'cert')] == 'N'
    assert any("because p's zip has more than one copy" in t and 'ML-DSA-65' in t for t in texts)


def test_results_for_algorithms_not_in_the_zip_are_not_expected_and_are_reported(repo):
    repo.zip('p', [A])
    path = repo.csv('p', 'v', [(A, 'cert', 'Y'), (B, 'cert', 'N')])
    repo.commit()
    board = vs.build(_files())
    assert board.expected['p'] == {(A, 'cert')}
    [(severity, text)] = vs.file_problems(board, _file(board, path), _alg_name)
    assert severity == vs.WARNING
    assert text == "results for algorithms that are not in p's zip: ML-DSA-65."


def test_in_scope_limits_the_algorithms_on_the_page(repo):
    repo.zip('p', [A, B])
    path = repo.csv('p', 'v', [(A, 'cert', 'Y'), (B, 'cert', 'Y')])
    repo.commit()
    board = vs.build(_files(), in_scope=lambda oid: oid == A)
    assert board.results[path] == {(A, 'cert'): 'Y'}
    assert board.page_oids == {A}


# Scoring

def test_a_verifier_is_scored_on_every_test_of_its_implemented_algorithms(repo):
    """Leaving out a type of test costs, as does a producer it has not tested; algorithms it does not implement
    count only towards all algorithms."""
    repo.zip('v', [A])
    repo.zip('p', [A, B])
    repo.zip('q', [A])
    repo.csv('p', 'w', [(A, 'cert', 'Y'), (A, 'consistent', 'Y'), (B, 'cert', 'Y')])
    repo.csv('q', 'w', [(A, 'cert', 'Y')])
    repo.csv('v', 'w', [(A, 'cert', 'Y')])
    repo.csv('p', 'v', [(A, 'cert', 'Y')])
    repo.commit()
    board = vs.build(_files())
    v = next(s for s in board.scores if s.verifier == 'v')
    assert board.scope['v'] == {A}
    # A from p: cert and consistent; A from q: cert; A from v: cert. It has only p's cert.
    assert v.mine == vs.Counts(current=1, stale=0, untested=3)
    assert v.all == vs.Counts(current=1, stale=0, untested=4)
    assert v.algorithms == 1


def test_implemented_algorithms_include_ones_it_verifies_but_does_not_produce(repo):
    repo.zip('p', [A, B])
    repo.csv('p', 'v', [(B, 'cert', 'Y')])
    repo.commit()
    assert vs.build(_files()).scope['v'] == {B}


def test_stale_tests_are_counted_as_stale(repo):
    repo.zip('p', [A])
    repo.commit()
    repo.csv('p', 'v', [(A, 'cert', 'Y')])
    repo.commit()
    repo.zip('p', [A, B])
    repo.csv('p', 'w', [(A, 'cert', 'Y'), (B, 'cert', 'Y')])
    repo.commit()
    v = next(s for s in vs.build(_files()).scores if s.verifier == 'v')
    assert v.mine == vs.Counts(current=0, stale=1, untested=0)
    assert v.all == vs.Counts(current=0, stale=1, untested=1)


def test_verifiers_are_ranked_by_their_share_of_implemented_algorithms(repo):
    repo.zip('p', [A, B])
    repo.csv('p', 'small', [(A, 'cert', 'Y')])
    repo.csv('p', 'big', [(A, 'cert', 'Y'), (B, 'cert', 'Y'), (B, 'priv', 'Y')])
    repo.csv('p', 'half', [(A, 'cert', 'Y'), (B, 'cert', 'Y')])
    repo.commit()
    assert [s.verifier for s in vs.build(_files()).scores] == ['big', 'small', 'half']


# Pages

def test_every_link_on_the_page_has_a_target(repo):
    repo.zip('p', [A, B])
    repo.zip('v', [A])
    repo.zip('unverified', [C])
    repo.commit()
    repo.csv('p', 'v', [(A, 'cert', 'Y'), (A, 'priv', 'N'), (B, 'cert', 'Y')])
    repo.csv('p', 'w', [(A, 'cert', 'N'), (B, 'cert', 'Y')])
    repo.csv('v', 'w', [(A, 'cert', 'Y')])
    repo.csv('v', 'v', [(A, 'cert', 'Y')])
    repo.csv('redhound', 'w', [(A, 'cert', 'Y')])
    repo.commit()
    board = vs.build(_files())
    page = '\n'.join([vs.markdown(board), vs.producer_markdown(board), vs.summaries(board, _alg_name)])
    targets = set(re.findall(r'\{#([^}]+)\}', page))
    links = set(re.findall(r'\]\(#([^)]+)\)', page))
    # the results section is the page writer's
    assert links and links - targets == {'results-by-algorithm'}
    for name in ('v', 'w'):
        assert f'verifier-{name}' in targets
    for name in ('p', 'v', 'unverified'):
        assert f'producer-{name}' in targets


def test_the_page_is_the_same_on_every_run(repo):
    repo.zip('p', [A, B])
    repo.zip('q', [A, B])
    repo.csv('p', 'v', [(A, 'cert', 'Y')])
    repo.csv('q', 'v', [(B, 'cert', 'Y')])
    repo.commit()
    script = ('import sys; sys.path.insert(0, sys.argv[1]); import verifier_scoreboard as vs, glob; '
              'b = vs.build(sorted(glob.glob("providers/*/compatMatrices/*/*.csv"))); '
              'print(vs.markdown(b), vs.producer_markdown(b), vs.summaries(b, str))')
    pages = {subprocess.run([sys.executable, '-c', script, SRC], capture_output=True,
                            text=True, check=True, env={**os.environ, 'PYTHONHASHSEED': str(seed)}).stdout
             for seed in (1, 2, 3)}
    assert len(pages) == 1


# check_result_files.py

def _mapping():
    os.makedirs('docs', exist_ok=True)
    with open('docs/oid_mapping.md', 'w') as f:
        f.write('| Name | OID |\n|---|---|\n' + ''.join(f'| {n} | {o} |\n' for o, n in NAMES.items()))


def _check(*args):
    _mapping()
    env = {k: v for k, v in os.environ.items() if k != 'GITHUB_ACTIONS'}
    return subprocess.run([sys.executable, CHECKER, *args], capture_output=True, text=True, env=env)


def test_the_check_fails_on_errors(repo):
    repo.zip('p', [A])
    repo.csv('p', 'v', [f'{A},cert,Y'], header='key_algorithm_oid,test_result')
    repo.commit()
    out = _check('--all')
    assert out.returncode == 1
    assert 'p_v.csv: error: not read, because the header has no type column' in out.stdout


def test_the_check_passes_with_warnings(repo):
    repo.zip('p', [A])
    repo.csv('p', 'v', [(A, 'cert', 'Y'), (B, 'cert', 'Y'), ('1.2.3', 'cert', 'Y')])
    repo.commit()
    out = _check('--all')
    assert out.returncode == 0, out.stdout + out.stderr
    assert f"results for algorithms that are not in p's zip: 1.2.3, ML-DSA-65 ({B})." in out.stdout
    assert 'not in docs/oid_mapping.md, so not shown on any page: 1.2.3.' in out.stdout
    assert '0 errors, 2 warnings' in out.stdout


def test_the_check_covers_only_files_changed_since_the_base(repo):
    repo.zip('p', [A])
    repo.csv('old', 'v', [(A, 'cert', 'Y')])
    repo.commit()
    _git('tag', 'base')
    repo.csv('p', 'v', [(A, 'cert', 'Y')])
    repo.commit()
    out = _check('--base', 'base')
    assert out.returncode == 0, out.stdout + out.stderr
    assert 'Checked 1 result file and 0 zips: 0 errors, 0 warnings.' in out.stdout
    assert _check('--all').returncode == 1


def test_the_check_writes_annotations_in_github_actions(repo):
    repo.zip('p', [A])
    repo.csv('redhound', 'v', [(A, 'cert', 'Y')])
    repo.commit()
    _mapping()
    out = subprocess.run([sys.executable, CHECKER, '--all'], capture_output=True, text=True,
                         env={**os.environ, 'GITHUB_ACTIONS': 'true'})
    assert out.stdout.startswith('::error file=providers/v/compatMatrices/artifacts_certs_r5/redhound_v.csv::'
                                 'there is no producer named redhound')


# Conformance

def _conformance(producer, rows, fmt=R5):
    folder, column, _ = vs._CONFORMANCE[fmt]
    os.makedirs(f'output/{folder}', exist_ok=True)
    header = 'key_algorithm_oid,type,test_result' if fmt == R5 else 'key_algorithm_oid,test_result'
    with open(f'output/{folder}/{producer}_{column}.csv', 'w') as f:
        f.write(header + '\n' + ''.join(','.join(r) + '\n' for r in rows))


def test_conformance_is_read_from_the_checkers_output(repo):
    _conformance('p', [(A, 'both', 'N'), (B, 'cert', 'N')])
    _conformance('q', [])
    conformance = vs.load_conformance(R5, in_scope=lambda oid: oid == A)
    assert conformance.page == 'r5_conformance_certs.html'
    assert conformance.failures == {'p': {(A, 'both')}, 'q': set()}
    assert vs.load_conformance(CMS) is None


def test_conformance_is_shown_for_producers_and_their_failing_tests(repo):
    repo.zip('p', [A])
    repo.zip('q', [A])
    repo.csv('p', 'v', [(A, 'both', 'N'), (A, 'cert', 'Y')])
    repo.csv('q', 'v', [(A, 'cert', 'Y')])
    repo.commit()
    _conformance('p', [(A, 'both', 'N')])
    _conformance('q', [])
    board = vs.build(_files())
    conformance = vs.load_conformance(R5)
    table = vs.producer_markdown(board, conformance)
    assert '[❌ 1](r5_conformance_certs.html#p)' in table and '[✅](r5_conformance_certs.html#q)' in table
    page = vs.summaries(board, _alg_name, conformance)
    assert '- ML-DSA-44 `both` 📋: ❌ v' in page
    assert '**Conformance:** ✅ no artifact fails the conformance checks' in page
    assert 'Conformance' not in vs.producer_markdown(board)


# One reading of result files, shared by the scoreboard and the result tables



def test_a_byte_order_mark_is_allowed_and_other_encodings_are_not(repo):
    repo.zip('p', [A])
    bom = repo.csv('p', 'v', [(A, 'cert', 'Y')])
    with open(bom, 'rb') as f:
        data = f.read()
    with open(bom, 'wb') as f:
        f.write(b'\xef\xbb\xbf' + data)
    latin1 = repo.csv('p', 'w', [(A, 'cert', 'Y')])
    with open(latin1, 'ab') as f:
        f.write(b'1.2.3,caf\xe9,Y\n')
    repo.commit()
    board = vs.build(_files())
    assert board.results[bom] == {(A, 'cert'): 'Y'}
    assert board.malformed[latin1] == 'it is not UTF-8 text'


def test_rows_with_characters_not_allowed_in_the_algorithm_are_left_out(repo):
    repo.zip('p', [A])
    path = repo.csv('p', 'v', [(A, 'cert', 'Y'), ('<b>x</b>', 'cert', 'Y')])
    repo.commit()
    board = vs.build(_files())
    assert board.results[path] == {(A, 'cert'): 'Y'}
    assert board.invalid_types[path] == {('?b?x?/b?', 'cert')}


def test_a_result_file_must_be_in_its_verifiers_directory(repo):
    repo.zip('p', [A])
    os.makedirs('providers/other/compatMatrices/artifacts_certs_r5')
    path = 'providers/other/compatMatrices/artifacts_certs_r5/p_v.csv'
    with open(path, 'w') as f:
        f.write(f'key_algorithm_oid,type,test_result\n{A},cert,Y\n')
    repo.commit()
    board = vs.build(_files())
    assert 'it is in providers/other/, but its name says the verifier is v' in board.malformed[path]
    assert board.current_paths == []




def test_a_zip_in_a_directory_with_an_invalid_name_is_not_used(repo):
    repo.zip('p', [A])
    repo.zip('bad<img src=x>', [A])
    repo.csv('p', 'v', [(A, 'cert', 'Y')])
    repo.commit()
    board = vs.build(_files())
    assert 'bad<img src=x>' not in board.zips
    assert board.invalid_producers == ['bad?img src?x?']
    page = '\n'.join([vs.markdown(board), vs.producer_markdown(board), vs.summaries(board, _alg_name)])
    assert '<img' not in page
    out = _check('--all')
    assert out.returncode == 1
    assert 'bad<img src=x>/artifacts_certs_r5.zip: error: the directory name is not a valid producer name' in out.stdout


def test_an_unreadable_zip_is_reported(repo):
    repo.zip('p', [A])
    with open('providers/p/artifacts_certs_r5.zip', 'wb') as f:
        f.write(b'not a zip')
    path = repo.csv('p', 'v', [(A, 'cert', 'Y')])
    repo.commit()
    board = vs.build(_files())
    assert 'cannot be read as a zip' in board.zip_errors['p']
    assert '**Zips that cannot be read:** [p](#producer-p)' in vs.markdown(board)
    assert '- Your zip cannot be read: it cannot be read as a zip' in vs.summaries(board, _alg_name)
    assert any("p's zip cannot be read" in t for _, t in vs.file_problems(board, _file(board, path), _alg_name))
    out = _check('--all')
    assert out.returncode == 1
    assert 'providers/p/artifacts_certs_r5.zip: error: it cannot be read as a zip' in out.stdout


def test_the_check_reports_upper_case_and_hidden_result_files(repo):
    repo.zip('p', [A])
    repo.csv('p', 'v', [(A, 'cert', 'Y')])
    repo.commit()
    _git('tag', 'base')
    os.rename(repo.csv('p', 'w', [(A, 'cert', 'Y')]), 'providers/w/compatMatrices/artifacts_certs_r5/p_w.CSV')
    repo.csv('.p', 'x', [(A, 'cert', 'Y')])
    repo.commit()
    out = _check('--base', 'base')
    assert 'p_w.CSV: error: the name must be <producer>_<verifier>.csv, with a lower-case .csv' in out.stdout
    assert 'Traceback' not in out.stderr
    assert '.p_x.csv: error: there is no producer named .p' in out.stdout


def test_the_check_reads_names_that_git_would_quote(repo):
    repo.zip('p', [A])
    repo.commit()
    _git('tag', 'base')
    repo.csv('p', 'vé', [(A, 'cert', 'Y')])
    repo.commit()
    out = _check('--base', 'base')
    assert out.returncode == 1
    assert 'p_vé.csv: error: the name must be' in out.stdout


# The result pages

def test_the_result_tables_agree_with_the_scoreboard(repo):
    """Run the page writer: stale and unreadable results are left out of the tables, and every other file is
    read as the scoreboard reads it."""
    repo.zip('p', [A])
    repo.commit()
    repo.csv('p', 'stale', [(A, 'cert', 'N')])
    repo.commit()
    repo.zip('p', [A, B])
    repo.commit()
    repo.csv('p', 'v', [(A, 'cert', 'Y')])
    repo.csv('p', 'my.v', [(A, 'cert', 'Y')])
    repo.csv('p', 'spaces', [f'{A}, cert, y'], header='key_algorithm_oid, type, test_result')
    repo.csv('p', 'dup', [(A, 'cert', 'Y'), (A, 'cert', 'N')])
    repo.csv('p', 'bad', [f'{A},cert,N'], header='key_algorithm_oid,test_result')
    repo.commit()
    _mapping()
    out = subprocess.run([sys.executable, WRITER, 'docs/oid_mapping.md', 'page.md', 'Certificate', *_files()],
                         capture_output=True, text=True)
    assert out.returncode == 0, out.stderr
    page = open('page.md').read()
    # v, my.v and spaces pass; dup's worst result fails; stale and bad are not counted
    assert '⚠️ 3/4' in page
    assert '/5' not in page and '/6' not in page
    assert 'p_dup.csv: 1 tests reported more than once; the worst result of each is used' in out.stderr
    board = vs.build(_files())
    current = {f.verifier: board.results[f.path] for f in board.files if f.path in board.current_paths}
    assert current == {'v': {(A, 'cert'): 'Y'}, 'my.v': {(A, 'cert'): 'Y'}, 'spaces': {(A, 'cert'): 'Y'},
                       'dup': {(A, 'cert'): 'N'}}


def test_the_check_reads_the_mapping_as_the_pages_do(repo):
    """An algorithm listed after the experimental heading of docs/oid_mapping.md is not on the pages."""
    repo.zip('p', [A, C])
    repo.csv('p', 'v', [(A, 'cert', 'Y'), (C, 'cert', 'Y')])
    repo.commit()
    _mapping()
    with open('docs/oid_mapping.md') as f:
        lines = [line for line in f if C not in line]
    with open('docs/oid_mapping.md', 'w') as f:
        f.write(''.join(lines) + f'\n# Experimental and Historical OIDs\n\n| Name | OID |\n|---|---|\n'
                f'| {NAMES[C]} | {C} |\n')
    env = {k: v for k, v in os.environ.items() if k != 'GITHUB_ACTIONS'}
    out = subprocess.run([sys.executable, CHECKER, '--all'], capture_output=True, text=True, env=env)
    assert f'not in docs/oid_mapping.md, so not shown on any page: {C}.' in out.stdout


def test_a_git_error_in_the_ancestry_check_is_not_taken_for_a_stale_result(repo):
    repo.zip('p', [A])
    repo.commit()
    with pytest.raises(vs.FreshnessError, match='merge-base'):
        vs._is_ancestor('0' * 40, 'HEAD')


def test_a_producer_with_only_its_own_results_is_not_verified(repo):
    repo.zip('p', [A])
    repo.zip('q', [A])
    repo.csv('p', 'p', [(A, 'cert', 'Y')])
    repo.csv('q', 'p', [(A, 'cert', 'Y')])
    repo.commit()
    board = vs.build(_files())
    assert board.unverified == ['p']
    assert 'Producers with no current results from any other verifier: p.' in vs.markdown(board)


def test_producers_link_to_the_automated_results(repo):
    repo.zip('p', [A])
    repo.csv('p', 'v', [(A, 'cert', 'Y')])
    repo.commit()
    board = vs.build(_files())
    page = 'pqc_hackathon_results_certs_r5_automated_tests_standardized.html'
    assert f'[automated results page]({page})' in vs.producer_markdown(board, automated_page=page)
    assert f'[automated results page]({page}#producer-p)' in vs.summaries(board, _alg_name, automated_page=page)
    assert 'automated results page' not in vs.producer_markdown(board) + vs.summaries(board, _alg_name)



# The automated results: the CI verifiers' results for every producer's current zip

def _automated(producer, verifier, rows, folder='certs'):
    path = f'output/{folder}/{producer}_{verifier}.csv'
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write('key_algorithm_oid,type,test_result\n' + ''.join(','.join(r) + '\n' for r in rows))
    return path


def test_the_automated_results_have_a_producer_board(repo):
    """Every file is current; lint and conformance columns are not verifiers; a CI verifier's results for the zip
    of the producer with the same name count."""
    repo.zip('bc', [A])
    repo.zip('p', [A, B])
    repo.commit()
    paths = [_automated('bc', 'bc', [(A, 'cert', 'Y')]), _automated('p', 'bc', [(A, 'cert', 'N')]),
             _automated('p', 'openssl', [(A, 'cert', 'N'), (B, 'cert', 'Y')]),
             _automated('p', 'pkilint', [(A, 'cert', 'W')]), _automated('p', 'r5-conformance', [(A, 'cert', 'N')])]
    assert vs.automated_format(paths) == R5
    board = vs.build_automated(paths, R5, excluded={'pkilint', 'r5-conformance'})
    assert board.automated
    assert {f.verifier for f in board.files} == {'bc', 'openssl'}
    assert all(f.current for f in board.files)
    table = vs.producer_markdown(board)
    assert '# Producers {#producers}' in table and 'Rank' not in table and 'Awaiting' not in table
    assert '[bc](#producer-bc)' in table
    page = vs.summaries(board, _alg_name)
    assert '# Producer Summaries' in page and 'As a verifier' not in page and 'Implementation' not in page
    assert '## p {#producer-p}' in page and '## bc {#producer-bc}' in page
    assert '- ML-DSA-44 `cert`: ❌ all 2: bc, openssl' in page
    assert '**Verified by:** bc.' in page            # bc's own zip, tested by the bc verifier


def test_the_automated_page_keeps_every_column_and_adds_the_producers(repo):
    repo.zip('p', [A])
    repo.commit()
    _mapping()
    paths = [_automated('p', 'bc', [(A, 'cert', 'Y')]), _automated('p', 'pkilint', [(A, 'cert', 'W')])]
    out = subprocess.run([sys.executable, WRITER, 'docs/oid_mapping.md', 'auto.md', 'Certificate Automated Verification',
                          *paths], capture_output=True, text=True)
    assert out.returncode == 0, out.stderr
    page = open('auto.md').read()
    assert '# Producers {#producers}' in page and '# Producer Summaries' in page
    assert '# Verifier Scoreboard' not in page
    assert '|bc|pkilint|' in page                    # the lint column is still in the algorithm's table


def test_producers_are_listed_by_name_not_ranked(repo):
    repo.zip('a', [A])
    repo.zip('b', [A])
    repo.csv('a', 'v', [(A, 'cert', 'Y')])
    repo.csv('b', 'v', [(A, 'cert', 'Y')])
    repo.csv('b', 'w', [(A, 'cert', 'Y')])
    repo.commit()
    table = vs.producer_markdown(vs.build(_files()))
    assert '# Producers {#producers}' in table and 'Rank' not in table
    assert not any(medal in table for medal in vs._MEDALS)
    assert table.index('[a](#producer-a)') < table.index('[b](#producer-b)')     # b has more verifiers
