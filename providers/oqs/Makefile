# Makefile
#
# PQC Certificates Tests

DIRS := openssl111 oqsprovider

.PHONY: help

help:
	@echo ; \
	 echo "USAGE: make [ all, unzip, verify, cross_verify ] " ; \
	 echo && exit 1

all: unzip verify cross_verify

unzip:
	@for i in $(DIRS) ; do \
	   echo "$$i" ; \
	   if [ -f "$$i/artifacts.zip" ] ; then \
	     echo "Yes" ; \
	     cd "$$i" && unzip -q "artifacts.zip" ; \
	   fi ; \
	 done

verify:
	@echo && echo "* Verifying Artifacts:"
	@for i in $(DIRS) ; do \
	   echo "  -  $$i" && ./check.sh "$$i"; \
	 done

cross_verify:
	@for i in $(DIRS) ; do \
		cd $i ; \
		for j in $(DIRS) ; do \
			./check.sh ../$$j \
		done ; \
	 done

