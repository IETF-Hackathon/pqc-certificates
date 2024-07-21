# OQS

The scripts in this setup can be executed if [oqsprovider](https://github.com/open-quantum-safe/oqs-provider) is run with the latest [openssl](https://github.com/openssl/openssl).

A docker image is available to facilitate that: [openquantumsafe/oqs-ossl3:interop](https://hub.docker.com/repository/docker/openquantumsafe/oqs-ossl3/general) contains the latest, complete set of QSC algorithms available for this testing.

## Sample execution

    docker run -v `pwd`:/opt/ietf -it openquantumsafe/oqs-ossl3:interop bash

opens a shell in which the `gen.sh` and `check.sh` scripts can be run with the `oqsprovider`+`liboqs`+`openssl` setup described above active.

### Creating artifacts

    cd /opt/ietf/providers/oqs && ./gen.sh 

(or `make generate`) creates the data as required for interop testing in the "oqsprovider/artifacts" directory.

### Checking artifacts

    cd /opt/ietf/providers/oqs && ./check.sh oqsprovider

(or `make verify`) checks the data generating a CSV report for correctness/verify-ability of the artifacts created with the command above.

### Cross-checking artifacts

In order to check other implementation's artifacts, run `make cross_verify` (after suitably uncompressing the artifacts as documented, i.e., using `make unzip` in their respective directories) -- or run `./check.sh` passing the directory of the artifacts to be tested as a parameter, e.g.

    ./check.sh ../bc/java-artifacts/

