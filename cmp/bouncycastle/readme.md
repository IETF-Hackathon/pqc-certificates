# Overview
This directory contains a proof of concept Java program that takes CMP payloads, i.e., `PKIMessage` data structures
as input, then:
- generates a CMP response, and
- issues a certificate signed with a post-quantum crypto algorithm (hardcoded to Dilithium, but can be changed)

Both outputs are saved to files, located in the same directory as the given input file.

## Environment tested on
- `openjdk-18`
- Bouncy Castle 1.73


# Usage

Run `Main.java` with a command line argument that points to the directory where the OpenSSL-generated artifacts are.
For example, the files in `../oqs-openssl/artifacts` are suitable for this purpose.