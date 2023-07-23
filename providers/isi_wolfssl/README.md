# WolfSSL compatibility check


This the the folder that checks WolfSSL's PQ version against the artifacts that are provided in this repository.

The the automated process uses the `check.sh` bash script that in turn uses the `verify_certs.c` program to unzip, check and create the according csv files against the artifacts from each of the rest of the provider. The csv files are in the accord format to be automaticaly processed by the python parser and produce results in the Compatibility Matrix.

** NOTE ** : WolfSSL is not really a provider, meaning that it does not offer artifacts but only checks the existing artifacts from the other providers.


## How to compile the C program

To be written...

## How to run the script 

To be written...