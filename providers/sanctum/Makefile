# Sanctum provider Makefile for IETF pqc-certificates
#
# Targets:
#   make all          - unzip (if needed), generate artifacts, verify, cross_verify (default OTHER=oqs-provider)
#   make unzip        - placeholder (no artifacts_certs_r5.zip yet; nothing to unzip)
#   make generate     - run gen.sh to generate PQC artifacts
#   make verify       - run check.sh to verify Sanctum artifacts (writes oqs-provider_sanctum.csv by default)
#   make cross_verify - run check.sh in "cross" mode using OTHER=<provider> (e.g., bc, oqs-provider, cm-frodo)
#
# Usage:
#   make
#   make verify
#   make cross_verify OTHER=bc
#   make cross_verify OTHER=cm-frodo

PROVIDER ?= sanctum

.PHONY: all unzip generate verify cross_verify

all: unzip generate verify cross_verify
	@echo "$(PROVIDER): all done"

unzip:
	@echo "$(PROVIDER): no artifacts_certs_r5.zip yet; nothing to unzip."

generate:
	@echo "$(PROVIDER): running gen.sh to generate PQC artifacts."
	@./gen.sh

verify:
	@echo "$(PROVIDER): running check.sh to verify PQC artifacts."
	@./check.sh

# Usage: make cross_verify OTHER=bc
#        make cross_verify OTHER=oqs-provider
#        make cross_verify OTHER=cm-frodo
cross_verify:
	@test -n "$$OTHER" || (echo "Usage: make cross_verify OTHER=<provider_dir>"; exit 1)
	@echo "$(PROVIDER): cross-verify using artifacts from providers/$$OTHER"
	@OTHER="$$OTHER" ./check.sh

