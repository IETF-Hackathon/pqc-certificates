# Overview
This directory contains examples of CMP payloads generated using different tools.

# Naming conventions
The subdirectories in `cmp/` correspond to the tools (e.g., OpenSSL, BouncyCastle) used to generate the artifacts.

Each subdirectory contains
- The artifacts themselves
- Instructions for generating the artifacts
- Ideally, a script that automates the instructions
- Optionally, keys used by the artifacts


## Artifacts
Artifacts are stored in directories that follow the `oid-algorithm` pattern, e.g., `1.3.6.1.4.1.2.267.7.4.4-dilithium2`.
Each directory contains files like `req-p10cr-prot_pass-pop_sig.pkimessage`. The name contains multiple components separated by `-`, and each component can contain `_` to indicate additional information related to it. The structure is as follows:

- `req` or `rep`: indicates whether it is a request or a response
- message type, e.g. `cr`, `ir`, `p10cr` and so on
- `prot_` indicates the type of protection used, e.g., "none" or "password-based"
- `pop_` stands for "proof of possession", e.g. "signature-based"

Other files available for each algorithm are `key.pem`, `csr.pem` for the key and certificate-signing request respectively.

# Automation
If payloads can be generated automatically, add a script called `gen` (add file extension as necessary).
