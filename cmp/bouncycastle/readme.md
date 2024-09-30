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

## As a CMP server

An alternative entry point is `MainCmpHttp.java` - this is a simple HTTP server that wraps the CMP logic, which you
can use as a CA that will issue certificates signed with post-quantum algorithms.

Once the server is started, you can send one of the pre-generated payloads (e.g., from oqs-openssl/artifacts) to give
it a try: `curl -X POST --data-binary @req-ir-prot_none-pop_sig.pkimessage http://127.0.0.1:8000/pkix --header "Content-Type:application/pkixcmp" -o response.bin`
