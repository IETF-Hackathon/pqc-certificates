# Sanctum provider Makefile for IETF pqc-certificates
#
# Targets:
#   make all          - unzip (noop), generate artifacts + CSV, verify, optional cross_verify
#   make unzip        - placeholder (no artifacts_certs_r5.zip yet; nothing to unzip)
#   make generate     - run gen.sh to generate Sanctum PQC artifacts and compat matrix
#   make verify       - run check.sh to verify Sanctum artifacts and CSV
#   make cross_verify - run check.sh in "cross" mode using OTHER=<provider> (e.g., bc, oqs-provider)
#
# Usage:
#   make
#   make verify
#   make cross_verify OTHER=bc
#   make cross_verify OTHER=oqs-provider

PROVIDER ?= sanctum
OTHER    ?= oqs-provider

.PHONY: all unzip generate verify cross_verify clean

all: unzip generate verify
	@echo "$(PROVIDER): all done"

unzip:
	@echo "$(PROVIDER): no artifacts_certs_r5.zip yet; nothing to unzip."

generate:
	@echo "$(PROVIDER): generating Sanctum evidence and compat matrix."
	@./gen.sh all

verify:
	@echo "$(PROVIDER): verifying Sanctum evidence and compat matrix."
	@./check.sh

# Usage: make cross_verify OTHER=bc
#        make cross_verify OTHER=oqs-provider
cross_verify:
	@test -n "$(OTHER)" || (echo "Usage: make cross_verify OTHER=<provider_dir>"; exit 1)
	@echo "$(PROVIDER): cross-verify using artifacts from providers/$(OTHER)"
	@OTHER="$(OTHER)" ./check.sh

clean:
	@echo "$(PROVIDER): cleaning Sanctum artifacts and matrix."
	@./gen.sh clean
