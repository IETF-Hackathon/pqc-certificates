#!/bin/bash
set -e
cd "$(dirname "$0")"

pip install -r requirements.txt --break-system-packages -q

python3 bin/pqc_jose_cose.py generate .
