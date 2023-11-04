# WolfSSL compatibility check


This the the folder that checks WolfSSL's PQ version against the artifacts that are provided in this repository.

The the automated process uses the `check.sh` bash script that in turn uses the `verify_certs.c` program to unzip, check and create the according `.csv` files against the artifacts from each of the rest of the provider. The `.csv` files are in the accord format to be automatically processed by the python parser and produce results in the Compatibility Matrix.

** **NOTE** ** : WolfSSL is not really a provider, meaning that it does not offer artifacts but only checks the existing artifacts from the other providers.


## How to compile the C program

To be able to use wolfSSL with PQ algorithms you have to follow an experimental setup documented in:

https://github.com/wolfSSL/wolfssl/blob/master/INSTALL
 
Item 15 (Building with liboqs for TLS 1.3 [EXPERIMENTAL]) has instructions on how to configure and build the required libraries. 

We provide the excerpt of the instructions here but for a more complete setup we urge the reader to visit the above link:

```
15. Building with liboqs for TLS 1.3 [EXPERIMENTAL]

In order be able to use liboqs, you must have it built and installed on your
system. We support liboqs at a specific git commit.

NOTE: Even if you have already installed liboqs, you need to follow these
      steps to install liboqs again as we support sphincs variants that are
      disabled by default in OQS's fork of OpenSSL.

Here are instructions for obtaining and building liboqs:

mkdir ~/oqs
cd ~/oqs
git clone --single-branch https://github.com/open-quantum-safe/liboqs.git
cd liboqs/
git checkout af76ca3b1f2fbc1f4f0967595f3bb07692fb3d82
mkdir build
cd build
cmake -DOQS_USE_OPENSSL=0 ..
make all
sudo make install

And then for building wolfssl, the following is sufficient:

cd wolfssl
./autogen.sh (Might not be necessary)
./configure --with-liboqs
make all


```


Now we are ready to compile our own program `verify_certs.c`. Simply run:

```
make
```

in the ``providers/isi-wolfssl` directory.

## How to run the script 

Now we are ready to run the script that checks PQ wolfSSL build (using the built-in WolfSSLCertManager tool) against all the artifacts of the rest of the providers and produces the corresponding `.csv`.

Simply run:

```
./check.sh
```

in the ``providers/isi-wolfssl` directory.

## Author

Files written and edited by George Tasopoulos from the Industrial Systems Institute (ISI) in Patras, Greece for the IETF 117 "PQ in X.509, Signatures, KEMs and protocols" Hackathon.