# Makefile
#
# PQC Certificates Tests

# Name for this provider
PROVIDER_NAME := go-crypto

# Directories for (possibly) multiple products
# supported by the same provider
DIRS := .

# Script for Generating the artifacts (if any)
GEN_SCRIPT := ./gen.sh
GEN_LOGFILE := logs/generate_log.txt

# Script for Verifying the artifacts (if any)
VERIFY_SCRIPT := ./check.sh
VERIFY_LOGFILE := logs/verify_log.txt

# Findings from the cross verification (JSON lines)
CROSS_FINDINGS := logs/cross_verify_findings.jsonl

# Default Target
.PHONY: help all unzip generate verify cross_verify test clean distclean \
        requirements requirements/unzip requirements/generate requirements/verify

# Help / Redirect Target
help:
	@echo ; \
	 echo "USAGE: make [ all, unzip, generate, verify, cross_verify, test ] " ; \
	 echo && exit 1

# ====================
# Requirements Section
# ====================

requirements: requirements/unzip requirements/generate requirements/verify

# Decompress Requirements
requirements/unzip:
	@echo && echo "[ $(PROVIDER_NAME) ] Checking Requirements (Unzip):"
	@unzip=`which unzip` && [ -f "$$unzip" ] || exit 50
	@echo "[ $(PROVIDER_NAME) ] Done (Ok)"

# Generation Requirements
requirements/generate:
	@[ -d logs ] || mkdir -p "logs"
	@echo && echo "[ $(PROVIDER_NAME) ] Checking Requirements (Generate):"
	@go=`which go` && [ -f "$$go" ] || exit 50
	@echo "[ $(PROVIDER_NAME) ] Done (Ok)"

# Verification Requirements
requirements/verify:
	@[ -d logs ] || mkdir -p "logs"
	@echo && echo "[ $(PROVIDER_NAME) ] Checking Requirements (Verify):"
	@go=`which go` && [ -f "$$go" ] || exit 50
	@echo "[ $(PROVIDER_NAME) ] Done (Ok)"

# ==========================
# Functional targets Section
# ==========================

# Generic Target
all: unzip generate verify cross_verify

# Decompress Target
unzip: requirements/unzip
	@for i in $(DIRS) ; do \
	   echo && echo "[ $(PROVIDER_NAME) ] Uncompressing Artifacts for $$i:" ; \
	   if [ -f "$$i/artifacts_certs_r5.zip" ] ; then \
	     (cd "$$i" && unzip -q -o "artifacts_certs_r5.zip" -d artifacts_certs_r5) || exit 1 ; \
	   fi ; \
	   echo "[ $(PROVIDER_NAME) ] Done" ; \
	 done

# Generate Target: rewrites artifacts_certs_r5.zip
generate: requirements/generate
	@if [ -f "$(GEN_SCRIPT)" ] ; then \
		echo "[ $(PROVIDER_NAME) ] Generating Artifacts:" ; \
		if $(GEN_SCRIPT) > "$(GEN_LOGFILE)" 2>&1 ; then \
			echo "[ $(PROVIDER_NAME) ] Done (Ok)" ; \
		else \
			echo "[ $(PROVIDER_NAME) ] Done (Errors, see $(GEN_LOGFILE))" ; exit 1 ; \
		fi ; \
	 fi

# Verify Target: checks our own zip and writes
# compatMatrices/artifacts_certs_r5/go-crypto_go-crypto.csv
verify: requirements/verify
	@if [ -f "$(VERIFY_SCRIPT)" ] ; then \
		echo && echo "[ $(PROVIDER_NAME) ] Verifying Artifacts:" ; \
		echo "----- BEGIN PROVIDER $(PROVIDER_NAME) -----" > $(VERIFY_LOGFILE); \
		for i in $(DIRS) ; do \
			echo "[ $(PROVIDER_NAME) ] Product: $$i" ; \
			echo "PRODUCT : $$i" >> "$(VERIFY_LOGFILE)" ; \
			$(VERIFY_SCRIPT) "$$i" >> "$(VERIFY_LOGFILE)" 2>&1 || exit 1 ; \
		done ; \
		echo "----- END PROVIDER $(PROVIDER_NAME) -----" >> $(VERIFY_LOGFILE); \
		echo "[ $(PROVIDER_NAME) ] Done (Ok)." && echo ; \
	 fi

# Cross Verify Target: checks every other provider's artifacts_certs_r5.zip
# and writes compatMatrices/artifacts_certs_r5/<provider>_go-crypto.csv here.
# Nothing is written into the other providers' directories.
cross_verify: requirements/verify
	@echo && echo "[ $(PROVIDER_NAME) ] Cross Verifying Artifacts:"
	@cd src && go run ./cmd/crossverify -providers ../.. -me $(PROVIDER_NAME) \
		-findings ../$(CROSS_FINDINGS)
	@echo "[ $(PROVIDER_NAME) ] Done (Ok). Findings: $(CROSS_FINDINGS)" && echo

# Unit tests
test:
	@cd src && go test ./...

# Cleans up the provider's directories
clean:
	@rm -rf artifacts_certs_r5

distclean: clean
	@rm -rf logs
