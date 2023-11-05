# Overview

Use the RFC9480 parser from pyasn1-alt-modules to parse all the payloads collected in this repository and see if they're valid `PKIMessage` structures.

# Usage
`python validate.py work/pqc-certificates/cmp/oqs-openssl/artifacts`.


## How it works
- Go through all the directories and look for files that match the `*.pkimessage` name.
- Attempt to parse them as `RFC9480.PKIMessage`.
- If it fails, show the path to the problematic payload and the error message.

# Installation
Create a Python virtualenv and run:

- `pip install pyasn1`
- `pip install -e git+https://github.com/russhousley/pyasn1-alt-modules.git@master#egg=pyasn1-alt-modules`

Note that it uses the newest definition of PKIMessage from RFC9480, currently available only in the Github repository. Eventually it will become part of a `pyasn1-alt-modules` release, so you'd be able to install that right away.