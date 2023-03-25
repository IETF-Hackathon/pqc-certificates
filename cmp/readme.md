# Overview
This directory contains examples of CMP payloads generated using different tools.

# Naming conventions
The subdirectories in `cmp/` correspong to the tools (e.g., OpenSSL, BouncyCastle) used to generate the artifacts.

Each subdirectory contains
- The artifacts themselves
- Instructions for generating the artifacts
- Ideally, a script that automates the instructions
- Optionally, keys used by the artifacts


## Artifacts
An example of a file name is `req-cr-dilithium2-pop_none.bin`. The name contains multiple components separated by `-`, and each component can contain `_` to indicate additional information related to it. The structure is as follows:

- `req` or `rep`: indicates whether it is a request or a response
- message type, e.g. `cr`, `ir`, `p10cr` and so on
- algorithm name
- [Optional] additional elements, e.g., whether proof of possession is used (and if so, of what kind).

# Automation
If payloads can be generated automatically, add a script called `generate` (add file extension as necessary).
