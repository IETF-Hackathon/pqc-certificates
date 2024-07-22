#!/bin/sh

printf "DEBUG %s\n" $(pwd)

mkdir /output
./providers/nist-acvts-tests/setup_acvts_env.sh
