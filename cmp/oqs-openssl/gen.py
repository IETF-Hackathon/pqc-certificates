"""Proof of concept application that generates various CMP requests using OpenSSL and OpenQuantumSafe. This is not
production-ready code, we cut corners here and there, because this is only an experimental tool to produce the binary
payloads.

What it does, in pseudocode:
- get a list of signature algorithms supported by OpenSSL with OQS
    - for each algorithm
        - generate key-pair
        - generate a CSR
        - generate a CMP IR, CR, P10CR request, with all possible combinations of protection and proof of possession
        # all of the above are saved to a file


NOTE: adjust OUTPUT_PATH and COMMAND_PREFIX before running the tool."""
import subprocess
import logging
from itertools import product
import argparse

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

# will be overridden by the mandatory `output` command line argument
OUTPUT_PATH = '/data/'

# Add this prefix in front of every command if you want to run OpenSSL/OQS from within docker, adjusting paths to your
# needs. If you run it directly on system, set this to an empty string.
# This will be set by the --docker command line argument, an example value might be this one
# COMMAND_PREFIX = 'docker run -it --rm --volume /home/debdeveu/code/pq-crypto-experiment/dockerdata:/data openquantumsafe/oqs-ossl3'
COMMAND_PREFIX = ''

# Different types of proof of possession, see `-popo` in https://www.openssl.org/docs/manmaster/man1/openssl-cmp.html
POP_NONE = -1
POP_RA_VERIFIED = 0
POP_SIG = 1
POP_KEY_ENC = 2

# for now the only form of "proof of possession" that is relevant is signature based, so we disable other modes
POP = {
    # 'none': POP_NONE,
    # 'raverified': POP_RA_VERIFIED,
    'sig': POP_SIG,
    # 'keyenc': POP_KEY_ENC
}
POP_INVERTED = {v: k for k, v in POP.items()}


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


def command_generate_cmp_ir(algorithm_name, server='127.17.0.2:8000/pkix', recipient='/CN=PQCA', reference='11111', password=None, popo=POP_SIG, cr=False):
    features = 'prot_pass' if password else 'prot_none'
    features += f'-pop_{POP_INVERTED[popo]}'

    # since these request types are virtually identical, we only need to change this string in one place
    ir_or_cr = {"ir" if not cr else "cr"}

    resulting_file = f'{OUTPUT_PATH}req-{ir_or_cr}-{algorithm_name}-{features}.pkimessage'
    protection = f'-secret pass:{password}' if password else '-unprotected_requests'

    command = f'openssl cmp -cmd {ir_or_cr} -server {server} -recipient "{recipient}" -ref {reference} ' \
              f'-csr {OUTPUT_PATH}csr-{algorithm_name}.pem ' \
              f'-certout {OUTPUT_PATH}cl_cert-{algorithm_name}.pem -newkey {OUTPUT_PATH}key-{algorithm_name}.pem ' \
              f'-popo {popo} {protection} ' \
              f'-reqout {resulting_file}'
    return run_command(command)


def command_generate_cmp_cr(algorithm_name, server='127.17.0.2:8000/pkix', recipient='/CN=PQCA', reference='11111', password=None, popo=POP_SIG):
    return command_generate_cmp_ir(algorithm_name, server, recipient, reference, password, popo, cr=True)


def command_generate_cmp_p10cr(algorithm_name, server='127.17.0.2:8000/pkix', reference='11111', password=None, popo=POP_SIG):
    features = 'prot_pass' if password else 'prot_none'
    features += f'-pop_{POP_INVERTED[popo]}'

    resulting_file = f'{OUTPUT_PATH}req-p10cr-{algorithm_name}-{features}.pkimessage'
    protection = f'-secret pass:{password}' if password else '-unprotected_requests'

    command = f'openssl cmp -cmd p10cr -server {server} -ref {reference} ' \
              f'-csr {OUTPUT_PATH}csr-{algorithm_name}.pem ' \
              f'-popo {popo} {protection} ' \
              f'-reqout {resulting_file}'
    return run_command(command)


if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(message)s', datefmt='%H:%M:%S')

    parser = argparse.ArgumentParser()
    parser.add_argument("output", help="Output directory", type=str)
    parser.add_argument("--algorithm", help="Generate payloads for specific algorithm", choices=ALGORITHMS, default="")
    parser.add_argument("--docker", help="Use this prefix to run the commands inside a docker container", default="")

    args = parser.parse_args()

    if args.algorithm:
        LOG.info("Running only for algorithm %s", args.algorithm)
        ALGORITHMS = [args.algorithm]

    OUTPUT_PATH = args.output
    if not OUTPUT_PATH.endswith('/'):
        # always add a trailing slash to the end, so we can concatenate it "as is" when building command line strings
        OUTPUT_PATH += '/'
    LOG.info("Saving output to %s", OUTPUT_PATH)

    if args.docker:
        LOG.info("Running under docker with `%s`", args.docker)
        COMMAND_PREFIX = args.docker
    else:
        LOG.info("Running directly in your system, OpenSSL with the OQS provider must be installed")


    passwords = ['aaaa', None]
    popos = POP.values()

    # command_generate_cmp_cr is left out, because it is the same as ir under the hood, if you really want it,
    # add it to the list below
    functions = [command_generate_cmp_ir, command_generate_cmp_p10cr]

    for algorithm in ALGORITHMS:
        LOG.info('Processing %s, generating key-pair', algorithm)
        output, status = command_generate_keypair(algorithm)
        if status:
            LOG.error('Failed, status %s: %s', status, output)
        LOG.info('Generating CSR')
        output, status = command_generate_csr(algorithm)
        if status:
            LOG.error('Failed, status %s, %s', status, output)

        for function in functions:
            LOG.info('--------------- Generating %s', function.__name__)
            for password, popo in product(passwords, popos):
                LOG.info(f'Protection: {f"password {password}" if password else "none"}, Proof-of-possession: {POP_INVERTED[popo]}')
                output, status = function(algorithm, password=password, popo=popo)
                if status:
                    LOG.error('Failed, status %s %s', status, output)

    LOG.info('Done')
