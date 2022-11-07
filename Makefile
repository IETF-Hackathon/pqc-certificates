# Makefile
#
# PQC Certificates Tests

MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
CURR_PATH := $(dir $(MAKEFILE))

DIRS := \
	$(CURR_PATH)/providers/oqs            \
	$(CURR_PATH)/providers/openca


# $(CURR_PATH)/providers/oqs
# $(CURR_PATH)/providers/entrust        \
# $(CURR_PATH)/providers/openca         \
# $(CURR_PATH)/providers/kris           \
# $(CURR_PATH)/providers/carl_redhound

.PHONY: help

help:
	@echo ; \
	 echo "USAGE: make [ all, unzip, verify, cross_verify ] " ; \
	 echo && exit 1

all: unzip generate verify cross_verify
	@echo "All Done"

unzip generate verify cross_verify:
	@for dir in $(DIRS) ; do \
		cd=$(notdir $(shell pwd)) ; \
		echo "current dir: $(PWD)" ; \
		cd $$dir && make $@ && cd - ; \
	 done
