# Makefile
#
# PQC Certificates Tests

# Name for this provider
PROVIDER_NAME := OQS

.PHONY: help all unzip generate verify cross_verify clean distclean

help:
	@echo ; \
	 echo "USAGE: make [ all, generate, verify ]" ; \
	 echo && exit 1

all: generate verify

# Regenerate artifacts_certs_r5.zip.
generate:
	@echo "[ $(PROVIDER_NAME) ] Generating Artifacts:"
	./gen_r5.sh

# Verify EVERY provider's artifacts_certs_r5.zip (including this one) with OpenSSL + oqsprovider. 
# Results are written to output/certs/ at the repo root.
verify:
	@echo "[ $(PROVIDER_NAME) ] Verifying Artifacts:"
	./gen_r5.sh --verify

cross_verify: verify

# Nothing to do here
# test_certs_r5.sh does its own unzipping, and gen_r5.sh cleans itself up
unzip clean distclean:
	@:
