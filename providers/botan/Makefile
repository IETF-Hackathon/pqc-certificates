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
DIRS := "default/artifacts"

# Script for Generating the artifacts (if any)
GEN_SCRIPT := $(CURR_PATH)/gen.sh
GEN_LOGFILE := $(CURR_PATH)logs/generate_log.txt

# Script for Verifying the artifacts (if any)
VERIFY_SCRIPT := $(CURR_PATH)/check.sh
VERIFY_LOGPATH := $(CURR_PATH)/logs

ARTIFACTS="default/artifacts"

PROVIDERS= $(shell basename -a $(shell ls -A $(CURR_PATH)/..))

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
	@echo && echo "[ $(PROVIDER_NAME) ] Checking Requirements (Verify):"
	@echo "[ $(PROVIDER_NAME) ] Done (Ok)"
	

bc: ARTIFACTS="java-artifacts/artifacts"
entrust: ARTIFACTS="default"
kris: ARTIFACTS="default"
openca: ARTIFACTS="libpki/artifacts"
oqs: ARTIFACTS="openssl111/artifacts" "oqsprovider/artifacts"
oqs-gnutls: ARTIFACTS="default"



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
verify: requirements/verify
	@if [ -f "$(VERIFY_SCRIPT)" ] ; then \
		echo && echo "[ $(PROVIDER_NAME) ] Verifying Artifacts:" ; \
		echo "----- BEGIN PROVIDER $(PROVIDER_NAME) -----" > $(VERIFY_LOGPATH)/$(PROVIDER_NAME)_verify_log.txt; \
		echo "TEST RUN: $(NOW)" >> $(VERIFY_LOGPATH)/$(PROVIDER_NAME)_verify_log.txt; \
		for i in $(DIRS) ; do \
			echo "[ $(PROVIDER_NAME) ] Product: $$i" ; \
			echo "PRODUCT : $$i" >> "$(VERIFY_LOGPATH)/$(PROVIDER_NAME)_verify_log.txt" ; \
			echo "CURR DIR: $(PWD) " >> "$(VERIFY_LOGPATH)/$(PROVIDER_NAME)_verify_log.txt" ; \
			echo >> "$(VERIFY_LOGPATH)/$(PROVIDER_NAME)_verify_log.txt" ; \
			result=`$(VERIFY_SCRIPT) "$$i" 2>&1 >> "$(VERIFY_LOGPATH)/$(PROVIDER_NAME)_verify_log.txt" `; \
			echo $$result >> "$(VERIFY_LOGPATH)/$(PROVIDER_NAME)_verify_log.txt" ; \
			echo >> "$(VERIFY_LOGPATH)/$(PROVIDER_NAME)_verify_log.txt"; \
		done ; \
		echo "----- END PROVIDER $(PROVIDER_NAME) -----" >> $(VERIFY_LOGPATH)/$(PROVIDER_NAME)_verify_log.txt; \
		echo "[ $(PROVIDER_NAME) ] Done (Ok)." && echo ; \
	 fi

# Cross Verify Target, it invokes the same verify
# script but it uses the base directory of a different
# provider to make use of another provider's artifacts

$(PROVIDERS): requirements/verify
	@if [ -f "$(VERIFY_SCRIPT)" ] ; then \
		echo && echo "[ $(PROVIDER_NAME) ] Verifying Artifacts: $@" ; \
		echo $(PWD) ; \
		echo $(shell date --iso=seconds) > "$(VERIFY_LOGPATH)/$(PROVIDER_NAME)-$@_verify_log.txt" ; \
		echo >> "$(VERIFY_LOGPATH)/$(PROVIDER_NAME)-$@_verify_log.txt" ; \
		for i in $(ARTIFACTS) ; do \
			echo "[ $(PROVIDER_NAME) ] Product: $$i" ; \
			echo "PRODUCT : $@-$$i " >> "$(VERIFY_LOGPATH)/$(PROVIDER_NAME)-$@_verify_log.txt" ; \
			echo "CURR DIR: $(PWD) " >> "$(VERIFY_LOGPATH)/$(PROVIDER_NAME)-$@_verify_log.txt" ; \
			echo >> "$(VERIFY_LOGPATH)/$(PROVIDER_NAME)-$@_verify_log.txt" ; \
			result=`$(VERIFY_SCRIPT) "../$@/$$i" >> "$(VERIFY_LOGPATH)/$(PROVIDER_NAME)-$@_verify_log.txt" 2>&1 `; \
			echo $$result >> "$(VERIFY_LOGPATH)/$(PROVIDER_NAME)-$@_verify_log.txt" ; \
			echo >> "$(VERIFY_LOGPATH)/$(PROVIDER_NAME)-$@_verify_log.txt"; \
		done ; \
		echo "[ $(PROVIDER_NAME) ] Done (Ok)." && echo ; \
	 fi
	 
verify-all: $(PROVIDERS)

# Cross Verify Target, it invokes the same verify
# script but it uses the base directory of a different
# provider to make use of another provider's artifacts
cross_verify: requirements/verify
	@echo "[ $(PROVIDER_NAME) ] Cross Verifying Artifacts:"
	@if [ -f "$(VERIFY_SCRIPT)" ] ; then \
		echo && echo "[ $(PROVIDER_NAME) ] Cross Verifying Artifacts:" ; \
		echo > $(VERIFY_LOG) ; \
		for i in ../* ; do \
			echo "  -  $$i" ; \
			result=`cd "$$i" && make verify > "$(VERIFY_LOGFILE)" 2>&1` ; \
		done ; \
		echo "[ $(PROVIDER_NAME) ] Done (Ok)." && echo; \
	 fi

# Cleans up the provider's directories
clean:
	@rm -rf generate_log.txt verify_log.txt
	@for i in $(DIRS) ; do \
	   rm -rf $$i/1.3.* ; \
	   rm -rf $$i/artifacts ; \
	 done

distclean: clean
	@rm -rf logs
