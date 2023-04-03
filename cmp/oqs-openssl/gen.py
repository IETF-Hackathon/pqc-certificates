"""Proof of concept application that generates various CMP requests using OpenSSL and OpenQuantumSafe. This is not
production-ready code, we cut corners here and there, because this is only an experimental tool to produce the binary
payloads.

What it does, in pseudocode:
- get a list of signature algorithms supported by OpenSSL with OQS
    - for each algorithm
        - generate key-pair
        - generate a CSR
        - generate a CMP IR request
        - generate a CMP CR request
        - generate a CMP P10CR request
        # all of the above are saved to a file


NOTE: adjust OUTPUT_PATH and COMMAND_PREFIX before running the tool."""
import subprocess
import logging


LOG = logging.getLogger('pqcmp')

# this list is derived from the output of `openssl list -signature-algorithms -provider oqsprovider`
ALGORITHMS = '''dilithium2
p256_dilithium2
rsa3072_dilithium2
dilithium3
p384_dilithium3
dilithium5
p521_dilithium5
dilithium2_aes
p256_dilithium2_aes
rsa3072_dilithium2_aes
dilithium3_aes
p384_dilithium3_aes
dilithium5_aes
p521_dilithium5_aes
falcon512
p256_falcon512
rsa3072_falcon512
falcon1024
p521_falcon1024
sphincsharaka128frobust
p256_sphincsharaka128frobust
rsa3072_sphincsharaka128frobust
sphincsharaka128fsimple
p256_sphincsharaka128fsimple
rsa3072_sphincsharaka128fsimple
sphincssha256128frobust
p256_sphincssha256128frobust
rsa3072_sphincssha256128frobust
sphincssha256128ssimple
p256_sphincssha256128ssimple
rsa3072_sphincssha256128ssimple
sphincsshake256128fsimple
p256_sphincsshake256128fsimple
rsa3072_sphincsshake256128fsimple'''.splitlines(keepends=False)

OUTPUT_PATH = '/data/'

# Add this prefix in front of every command if you want to run OpenSSL/OQS from within docker, adjusting paths to your
# needs. If you run it directly on system, set this to an empty string.
COMMAND_PREFIX = 'docker run -it --rm --volume /home/debdeveu/code/pq-crypto-experiment/dockerdata:/data openquantumsafe/oqs-ossl3'


def run_command(command):
    LOG.info(f'Running: `{COMMAND_PREFIX} {command}`')
    command = f'{COMMAND_PREFIX} {command}'
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    process.wait()
    out, err = process.communicate()
    if err:
        LOG.info(f'Result: {err}')
    # OpenSSL will complain that it cannot connect to the target CA, but that's not an issue for us, because we only
    # need the payload it generated, we don't actually want to connect anywhere - so these messages will be ignored,
    # to reduce noise.
    if b"CMP error: Connection refused" in out:
        pass
    elif out:
        LOG.debug(out)
    return out, err


def command_generate_keypair(algorithm_name):
    command = f'openssl genpkey -algorithm {algorithm_name} -out {OUTPUT_PATH}key-{algorithm_name}.pem'
    return run_command(command)


def command_generate_csr(algorithm_name, subject="/CN=test subject"):
    command = f'openssl req -out {OUTPUT_PATH}csr-{algorithm_name}.pem -new ' \
              f'-key {OUTPUT_PATH}key-{algorithm_name}.pem ' \
              f'-nodes -subj "{subject}"'
    return run_command(command)


def command_generate_cmp_ir_unprotected(algorithm_name, server='127.17.0.2:8000/pkix', recipient='/CN=PQCA', reference='11111'):
    command = f'openssl cmp -cmd ir -server {server} -recipient "{recipient}" -ref {reference} ' \
              f'-csr {OUTPUT_PATH}csr-{algorithm_name}.pem ' \
              f'-certout {OUTPUT_PATH}cl_cert-{algorithm_name}.pem -newkey {OUTPUT_PATH}key-{algorithm_name}.pem ' \
              f'-unprotected_requests -reqout {OUTPUT_PATH}req-ir-{algorithm_name}-prot_none.pkimessage'
    return run_command(command)


def command_generate_cmp_ir_protectpass(algorithm_name, server='127.17.0.2:8000/pkix', recipient='/CN=PQCA', reference='11111', password="aaaaa"):
    command = f'openssl cmp -cmd ir -server {server} -recipient "{recipient}" -ref {reference} ' \
              f'-csr {OUTPUT_PATH}csr-{algorithm_name}.pem ' \
              f'-certout {OUTPUT_PATH}cl_cert-{algorithm_name}.pem -newkey {OUTPUT_PATH}key-{algorithm_name}.pem ' \
              f'-secret pass:{password} -reqout {OUTPUT_PATH}req-ir-{algorithm_name}-prot_pass.pkimessage'
    return run_command(command)


def command_generate_cmp_cr_unprotected(algorithm_name, server='127.17.0.2:8000/pkix', recipient='/CN=PQCA', reference='11111'):
    command = f'openssl cmp -cmd cr -server {server} -recipient "{recipient}" -ref {reference} ' \
              f'-csr {OUTPUT_PATH}csr-{algorithm_name}.pem ' \
              f'-certout {OUTPUT_PATH}cl_cert-{algorithm_name}.pem -newkey {OUTPUT_PATH}key-{algorithm_name}.pem ' \
              f'-unprotected_requests -reqout {OUTPUT_PATH}req-cr-{algorithm_name}-prot_none.pkimessage'
    return run_command(command)


def command_generate_cmp_cr_protectpass(algorithm_name, server='127.17.0.2:8000/pkix', recipient='/CN=PQCA', reference='11111', password="aaaaa"):
    command = f'openssl cmp -cmd cr -server {server} -recipient "{recipient}" -ref {reference} ' \
              f'-csr {OUTPUT_PATH}csr-{algorithm_name}.pem ' \
              f'-certout {OUTPUT_PATH}cl_cert-{algorithm_name}.pem -newkey {OUTPUT_PATH}key-{algorithm_name}.pem ' \
              f'-secret pass:{password} -reqout {OUTPUT_PATH}req-cr-{algorithm_name}-prot_pass.pkimessage'
    return run_command(command)


def command_generate_cmp_p10cr_unprotected(algorithm_name, server='127.17.0.2:8000/pkix', reference='11111'):
    command = f'openssl cmp -cmd p10cr -server {server} -unprotected_requests -ref {reference} ' \
              f'-csr {OUTPUT_PATH}csr-{algorithm_name}.pem ' \
              f'-reqout {OUTPUT_PATH}req-p10cr-{algorithm_name}-prot_none.pkimessage'
    return run_command(command)


def command_generate_cmp_p10cr_protpass(algorithm_name, server='127.17.0.2:8000/pkix', reference='11111', password="aaaaa"):
    command = f'openssl cmp -cmd p10cr -server {server} -secret pass:{password} -ref {reference} ' \
              f'-csr {OUTPUT_PATH}csr-{algorithm_name}.pem ' \
              f'-reqout {OUTPUT_PATH}req-p10cr-{algorithm_name}-prot_pass.pkimessage'
    return run_command(command)


if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(message)s')

    for algorithm in ALGORITHMS:
        LOG.info('Processing %s, generating key-pair', algorithm)
        output, status = command_generate_keypair(algorithm)
        if status:
            LOG.error('Failed, status %s: %s', status, output)
        LOG.info('Generating CSR')
        output, status = command_generate_csr(algorithm)
        if status:
            LOG.error('Failed, status %s, %s', status, output)

        LOG.info('Generating CMP IR, unprotected')
        output, status = command_generate_cmp_ir_unprotected(algorithm)
        if status:
            LOG.error('Failed, status %s %s', status, output)
        LOG.info('Generating CMP IR, password protection')
        output, status = command_generate_cmp_ir_protectpass(algorithm)
        if status:
            LOG.error('Failed, status %s %s', status, output)

        LOG.info('Generating CMP CR, unprotected')
        output, status = command_generate_cmp_cr_unprotected(algorithm)
        if status:
            LOG.error('Failed, status %s %s', status, output)
        LOG.info('Generating CMP CR, password protection')
        output, status = command_generate_cmp_cr_protectpass(algorithm)
        if status:
            LOG.error('Failed, status %s %s', status, output)

        LOG.info('Generating CMP P10CR, unprotected')
        output, status = command_generate_cmp_p10cr_unprotected(algorithm)
        if status:
            LOG.error('Failed, status %s %s', status, output)
        LOG.info('Generating CMP P10CR, password protection')
        output, status = command_generate_cmp_p10cr_protpass(algorithm)
        if status:
            LOG.error('Failed, status %s %s', status, output)
    LOG.info('Done')
