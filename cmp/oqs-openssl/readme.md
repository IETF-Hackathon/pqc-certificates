
# Overview
This directory contains examples of CMP payloads generated with OpenSSL and the OpenQuantumSafe provider. See the comments inside `gen.py` for details.

# Usage examples
- `python3 gen.py data/`: run this if OpenSSLv3 and OQS are installed in your system. This will produce payloads for all the available algorithms and store them in `data/` under the current directory.
- `python3 gen.py --dry-run data/` - will only print the OpenSSL commands it will execute, without actually executing them.
- `python3 gen.py --dry-run --algorithm=dilithium2 data/` - as above, but it will only produce payloads for the algorithm identified as `dilithium2`.

If you use OpenSSL with OQS via docker, you can rely on the `--docker` parameter, e.g.: `python3 gen.py --docker="docker run -it --rm --volume /home/debdeveu/code/pq-crypto-experiment/dockerdata:/data openquantumsafe/oqs-ossl3" /data/`. It will mount the path `/home/debdeveu/code/pq-crypto-experiment/dockerdata` to `/data` inside the container, and store the output in `/data` (relative to the container).

## Using QSCKeys
A family of RFC drafts describes a way to encode keys. This alternative encoding can be enabled by setting specific environment variables in your system, or passing them to `docker`. The variables are stored in `qsckeys.env`, and an example docker command for it would be: `python3 gen.py --docker="docker run -it --rm --env-file qsckeys.env --volume /home/debdeveu/code/pq-crypto-experiment/dockerdata-qsc:/data-qsc openquantumsafe/oqs-ossl3" /data-qsc/`.

For details about this encoding, see https://github.com/open-quantum-safe/oqs-provider/blob/main/ALGORITHMS.md#key-encodings

# What it does
Essentially, it concatenates strings to build a command line for `openssl` and stores the outputs in files. Here is an example of such commands from the log, in case you want to run them by hand:

```commandline
09:02:47 - Running only for algorithm dilithium2
09:02:47 - Saving output to /data/
09:02:47 - Running under docker with `docker run -it --rm --volume /home/debdeveu/code/pq-crypto-experiment/dockerdata:/data openquantumsafe/oqs-ossl3`
09:02:47 - Processing dilithium2, creating output directory
09:02:47 - Running: `docker run -it --rm --volume /home/debdeveu/code/pq-crypto-experiment/dockerdata:/data openquantumsafe/oqs-ossl3 mkdir -p /data/1.3.6.1.4.1.2.267.7.4.4-dilithium2/`
09:02:48 - Generating key-pair: dilithium2
09:02:48 - Running: `docker run -it --rm --volume /home/debdeveu/code/pq-crypto-experiment/dockerdata:/data openquantumsafe/oqs-ossl3 openssl genpkey -algorithm dilithium2 -out /data/1.3.6.1.4.1.2.267.7.4.4-dili
thium2/key.pem`
09:02:49 - Generating CSR
09:02:49 - Running: `docker run -it --rm --volume /home/debdeveu/code/pq-crypto-experiment/dockerdata:/data openquantumsafe/oqs-ossl3 openssl req -out /data/1.3.6.1.4.1.2.267.7.4.4-dilithium2/csr.pem -new -key /
data/1.3.6.1.4.1.2.267.7.4.4-dilithium2/key.pem -nodes -subj "/CN=test subject"`
09:02:52 - --------------- Generating command_generate_cmp_p10cr
09:02:52 - Protection: password aaaa, Proof-of-possession: sig
09:02:52 - Running: `docker run -it --rm --volume /home/debdeveu/code/pq-crypto-experiment/dockerdata:/data openquantumsafe/oqs-ossl3 openssl cmp -cmd p10cr -server 127.17.0.2:8000/pkix -ref 11111 -csr /data/1.3
.6.1.4.1.2.267.7.4.4-dilithium2/csr.pem -popo 1 -secret pass:aaaa -reqout /data/1.3.6.1.4.1.2.267.7.4.4-dilithium2/req-p10cr-prot_pass-pop_sig.pkimessage`
09:02:55 - Done
```


# Note on OIDs
These are loaded from `algorithm_oids.py`. If you want to re-generate this file, use `extract_oid.py` (comments within explain how to run it).