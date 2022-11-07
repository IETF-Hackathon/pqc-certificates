# Makefile
#
# PQC Certificates Tests

DIRS := libpki

.PHONY: help

help:
	@echo ; \
	 echo "USAGE: make [ all, unzip, verify, cross_verify ] " ; \
	 echo && exit 1

all: unzip verify cross_verify

unzip:
	@for i in $(DIRS) ; do \
	   if [ -f "$$i/artifacts.zip" ] ; then \
	     cd "$$i" && unzip -q "artifacts.zip" ; \
	   fi ; \
	 done

verify:
	@for i in $(DIRS) ; do \
	   echo "Validating Product: $$i" ; \
	   ./check.sh "$$i" 2>&1 ; \
	   if [ $$? -gt 0 ] ; then \
		  echo "  - ERROR: Cannot validate $$i, aborting" ; \
		  echo ; \
		  exit 1 ; \
		else \
		  echo "  - Completed (OK)." ; \
		fi ; \
		echo "$$result" ; \
	 done

cross_verify: 
	@for i in ../* ; do \
	   echo "* Cross-Validating Product: $$i" ; \
	   cd "$$i" && make verify && cd - ; \
	   if [ $$? -gt 0 ] ; then \
		  echo "  - ERROR: Cannot cross-validate $$i, aborting" ; \
		  echo ; \
		  exit 1 ; \
		else \
		  echo "  - Completed (Ok)." ; \
		fi ; \
	 done

