# Makefile
#
# PQC Certificates Tests

MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
CURR_PATH := $(dir $(MAKEFILE))

# Name for this provider
PROVIDER_NAME := botan

# Directories for (possibly) multiple products
# supported by the same provider
# DIRS := <product_1> <product_2> ...
DIRS := "default"

# Script for Generating the artifacts (if any)
GEN_SCRIPT := $(CURR_PATH)/gen.sh
GEN_LOGFILE := $(CURR_PATH)logs/generate_log.txt

VERIFY_LOGPATH := $(CURR_PATH)/logs

VERIFY_LOG = "$(VERIFY_LOGPATH)/$(PROVIDER_NAME)-$@_verify_log.txt"

ARTIFACTS="$@/default/artifacts"
MATRIX_PATH="$(CURR_PATH)/comptMatrices/$@_$(PROVIDER_NAME).csv"

PROVIDERS := bc botan carlredhound coreydigicert cryptonext entrust kris openca oqsgnutls oqsopenssl111 oqsprovider

bc: ARTIFACTS="$@/java-artifacts/artifacts"
# botan: ARTIFACTS="$@/default/artifacts"
carlredhound: ARTIFACTS="carl_redhound/default/artifacts"
coreydigicert: ARTIFACTS="corey_digicert/default/artifacts"
# cryptonext: ARTIFACTS="$@/default/artifacts"
entrust: ARTIFACTS="$@/default"
kris: ARTIFACTS="$@/default"
openca: ARTIFACTS="$@/libpki/artifacts"
oqsgnutls: ARTIFACTS="oqs-gnutls/default"
oqsopenssl111: ARTIFACTS="oqs/openssl111/artifacts"
oqsprovider: ARTIFACTS="oqs/oqsprovider/artifacts"

# Time
NOW := `date +%Y%m%d`

# Default Target
.PHONY: help

# Help / Redirect Target
help:
	@echo ; \
	 echo "USAGE: make [ all, unzip, verify, cross_verify ] " ; \
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
	@echo "[ $(PROVIDER_NAME) ] Done (Ok)"

# Verification Requirements
requirements/verify:
	@[ -d logs ] || mkdir -p "logs"
	@[ -d comptMatrices ] || mkdir -p "comptMatrices"
	@echo && echo "[ $(PROVIDER_NAME) ] Checking Requirements (Verify):"
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
	   if [ -f "$$i/artifacts.zip" ] ; then \
	     result=`cd "$$i" && unzip -q "artifacts.zip"` ; \
	   fi ; \
	   if [ -f "$$i/crypto_tests.zip" ] ; then \
	     result=`cd "$$i" && unzip -q "crypto_tests.zip"` ; \
	   fi ; \
	   echo "[ $(PROVIDER_NAME) ] Done" ; \
	 done

# Generate Target, only executed if the
# `gen.sh` script is present in the provider
generate: requirements/generate
	@if [ -f "$(GEN_SCRIPT)" ] ; then \
		echo "[ $(PROVIDER_NAME) ] Generating Artifacts:" ; \
		result=`$(GEN_SCRIPT) 2>&1 > "$(GEN_LOGFILE)"` ; \
		echo "$$result" >> "$(GEN_LOGFILE)" ; \
		if [ $$? -gt 0 ] ; then \
			echo "[ $(PROVIDER_NAME) ] Done (Errors)" ; \
		else \
			echo "[ $(PROVIDER_NAME) ] Done (Ok)" ; \
		fi ; \
	 fi

# Verify Target, only executed if the
# `check.sh` script is present in the provider
verify: requirements/verify botan

# Cross Verify Target, it invokes the same verify
# script but it uses the base directory of a different
# provider to make use of another provider's artifacts

TA_PATH="$$i/ta"
CA_PATH="$$i/ca"
EE_PATH="$$i/ee"
	

$(PROVIDERS): requirements/verify 
	@echo && echo "[ $(PROVIDER_NAME) ] Verifying Artifacts of $@:"
	@echo $(shell date --iso=seconds) > $(VERIFY_LOG)
	@echo >> $(VERIFY_LOG)
	@echo "[ $(PROVIDER_NAME) ] Product: $(ARTIFACTS)"
	@echo "PRODUCT : $@ " >> $(VERIFY_LOG)
	@echo "CURR DIR: $(PWD) " >> $(VERIFY_LOG)
	@echo >> $(VERIFY_LOG)
	@echo '"key_algorithm_oid","ta","ca","ee","crl_ta","crl_ca"' > $(MATRIX_PATH)
	@# result=`$(VERIFY_SCRIPT) "../$(ARTIFACTS)" >> $(VERIFY_LOG) 2>&1 `
	@for i in ../$(ARTIFACTS)/*/ ; do \
		echo $$i >> $(VERIFY_LOG) ; \
		if [ -f $(TA_PATH)/ta.pem ] ; then \
			cert_format="pem" ; \
		else \
			cert_format="der" ; \
		fi ; \
		if [ -f $(EE_PATH)/ee.$$cert_format ] ; then \
			ee_file="ee" ; \
		else \
			ee_file="cert" ; \
		fi ; \
		botan cert_verify $(EE_PATH)/$$ee_file.$$cert_format $(CA_PATH)/ca.$$cert_format $(TA_PATH)/ta.$$cert_format >> $(VERIFY_LOG) 2>&1 ; \
		result=$$? ; \
		[ $$result -eq 0 ] && x='"Y"' || x='"N"' ; \
		oid=$$(basename $$i) ; \
		echo '"'$$oid'"',$$x,$$x,$$x,'""','""' ; \
		echo '"'$$oid'"',$$x,$$x,$$x,'""','""' >> $(MATRIX_PATH) ; \
		echo $$result >> $(VERIFY_LOG) ; \
		echo >> $(VERIFY_LOG) ; \
	done
	@echo "[ $(PROVIDER_NAME) ] Done (Ok)." && echo
	 
cross-verify: $(PROVIDERS)

# Cleans up the provider's directories
clean:
	@rm -rf generate_log.txt verify_log.txt
	@for i in $(DIRS) ; do \
	   rm -rf $$i/artifacts ; \
	 done

distclean: clean
	@rm -rf logs comptMatrices
