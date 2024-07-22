#!/bin/sh

printf "DEBUG pwd: %s\n" $(pwd)
printf "DEBUG ls: %s\n" $(ls)

mkdir /output
./providers/nist-acvts-tests/setup_acvts_env.sh
