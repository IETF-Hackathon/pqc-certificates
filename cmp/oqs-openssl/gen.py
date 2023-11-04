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
from enum import Enum, auto

from algorithm_oids import ALG_OID

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

# If True, the commands will not be executed, but only printed to stdout
DRY_RUN = False

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

# path to pre-generated keys and certificates needed when "signature-based protection" is required.
DIR_PROTECTION_DATA = '/protection-data/'


def run_command(command):
    LOG.info(f'Running: `{COMMAND_PREFIX} {command}`')
    if DRY_RUN:
        # Don't do anything
        return '', None

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
    extended_algorithm_name = f'{ALG_OID[algorithm_name]}-{algorithm_name}'
    extended_path = f'{OUTPUT_PATH}{extended_algorithm_name}/'

    command = f'openssl genpkey -algorithm {algorithm_name} -out {extended_path}key.pem'
    return run_command(command)


def command_generate_csr(algorithm_name, subject="/CN=test subject"):
    extended_algorithm_name = f'{ALG_OID[algorithm_name]}-{algorithm_name}'
    extended_path = f'{OUTPUT_PATH}{extended_algorithm_name}/'

    command = f'openssl req -out {extended_path}csr.pem -new ' \
              f'-key {extended_path}key.pem ' \
              f'-nodes -subj "{subject}"'
    return run_command(command)


def command_generate_cmp_ir(algorithm_name, server='127.17.0.2:8000/pkix', recipient='/CN=PQCA', reference='11111', prot_password=None, prot_sig=False, popo=POP_SIG, cr=False):
    """Generate a CMP IR or CR request

    :param algorithm_name: str, an algorithm identifier, see ALGORITHMS list
    :param server: optional str, URL to use for sending the CMP request
    :param recipient: optional str, x509 DN of the recipient of the CMP request, formatted in accordance with the
                      OpenSSL syntax, see `-subject name` in manpages
    :param reference: optional str, request reference number to put in the payload
    :param prot_password: optional str, if set, password protection will be used for this request
    :param prot_sig: optional bool, if set, will use signature-based protection, overriding the password-based one above
    :param popo: optional enum, proof of possession, see POP_SIG definition above
    :param cr: optional bool, if set, will create a CR request instead of IR
    :return: nothing, but will write the resulting CMP request payload to a file if all is well
    """
    features = 'prot_sig' if prot_sig else 'prot_pass' if prot_password else 'prot_none'
    features += f'-pop_{POP_INVERTED[popo]}'

    # since these request types are virtually identical, we only need to change this string in one place
    ir_or_cr = "ir" if not cr else "cr"

    extended_algorithm_name = f'{ALG_OID[algorithm_name]}-{algorithm_name}'
    extended_path = f'{OUTPUT_PATH}{extended_algorithm_name}/'

    resulting_file = f'{extended_path}req-{ir_or_cr}-{features}.pkimessage'

    protection = f'-secret pass:{prot_password}' if prot_password else '-unprotected_requests'
    # override the above if we use signature protection (so it is the same as the logic in `features`
    if prot_sig:
        protection = f'-cert {DIR_PROTECTION_DATA}ee.crt -key {DIR_PROTECTION_DATA}eekey.pem'

    # NOTE: you can also specify the subject directly via a command line, this way there is no need to generate a CSR
    #       beforehand, e.g., `-subject "/CN=xxxxxxxxxxEnd Entity demo"`. However, the code is more reusable with CSR,
    #       since we can use it for P10CR with fewer changes

    command = f'openssl cmp -cmd {ir_or_cr} -server {server} -recipient "{recipient}" -ref {reference} ' \
              f'-csr {extended_path}csr.pem ' \
              f'-certout {extended_path}cl_cert.pem -newkey {extended_path}key.pem ' \
              f'-popo {popo} {protection} ' \
              f'-reqout {resulting_file}'
    return run_command(command)


def command_generate_cmp_cr(algorithm_name, server='127.17.0.2:8000/pkix', recipient='/CN=PQCA', reference='11111', prot_password=None, prot_sig=False, popo=POP_SIG):
    return command_generate_cmp_ir(algorithm_name, server, recipient, reference, prot_password, prot_sig, popo, cr=True)


def command_generate_cmp_p10cr(algorithm_name, server='127.17.0.2:8000/pkix', reference='11111', prot_password=None, prot_sig=False, popo=POP_SIG):
    features = 'prot_sig' if prot_sig else 'prot_pass' if prot_password else 'prot_none'
    features += f'-pop_{POP_INVERTED[popo]}'

    extended_algorithm_name = f'{ALG_OID[algorithm_name]}-{algorithm_name}'
    extended_path = f'{OUTPUT_PATH}{extended_algorithm_name}/'

    resulting_file = f'{extended_path}req-p10cr-{features}.pkimessage'
    protection = f'-secret pass:{prot_password}' if prot_password else '-unprotected_requests'
    # override the above if we use signature protection (so it is the same as the logic in `features`
    if prot_sig:
        protection = f'-cert {DIR_PROTECTION_DATA}ee.crt -key {DIR_PROTECTION_DATA}eekey.pem'

    command = f'openssl cmp -cmd p10cr -server {server} -ref {reference} ' \
              f'-csr {extended_path}csr.pem ' \
              f'-popo {popo} {protection} ' \
              f'-reqout {resulting_file}'
    return run_command(command)


if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(message)s', datefmt='%H:%M:%S')

    parser = argparse.ArgumentParser()
    parser.add_argument("output", help="Output directory", type=str)
    parser.add_argument("--algorithm", help="Generate payloads for specific algorithm", choices=ALGORITHMS, default="")
    parser.add_argument("--docker", help="Use this prefix to run the commands inside a docker container", default="")
    parser.add_argument("--dryrun", help="Only print the commands, rather than run them", default=False, action="store_true")

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

    DRY_RUN = args.dryrun
    if DRY_RUN:
        LOG.info("This is a dry run, commands will be printed, but not executed")


    passwords = ['aaaa', None]
    popos = POP.values()

    # command_generate_cmp_cr is left out, because it is the same as ir under the hood, if you really want it,
    # add it to the list below
    functions = [command_generate_cmp_ir, command_generate_cmp_p10cr]

    for algorithm in ALGORITHMS:
        LOG.info('Processing %s, creating output directory', algorithm)

        try:
            extended_algorithm_name = f'{ALG_OID[algorithm]}-{algorithm}'
        except KeyError as err:
            LOG.error("OID for `%s` unknown, skipping", algorithm)
            continue
        else:
            extended_path = f'{OUTPUT_PATH}{extended_algorithm_name}/'
            # note that we create them with bash, rather than Python, such that it plays nicely with the scenario when
            # this runs under docker
            run_command(f"mkdir -p {extended_path}")

        LOG.info('Generating key-pair: %s', algorithm)
        output, status = command_generate_keypair(algorithm)
        if status:
            LOG.error('Failed, status %s: %s', status, output)
        LOG.info('Generating CSR')
        output, status = command_generate_csr(algorithm)
        if status:
            LOG.error('Failed, status %s, %s', status, output)

        for function in functions:
            LOG.info('--------------- Generating %s', function.__name__)
            output, status = function(algorithm, prot_password='11111')
            if status:
                LOG.error('Failed, status %s %s', status, output)
            output, status = function(algorithm, prot_sig=True)
            if status:
                LOG.error('Failed, status %s %s', status, output)
            output, status = function(algorithm) # no protection
            if status:
                LOG.error('Failed, status %s %s', status, output)

    LOG.info('Done')
