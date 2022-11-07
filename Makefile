# Makefile
#
# PQC Certificates Tests

MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
CURR_PATH := $(dir $(MAKEFILE))

# DIRS := 
# 	$(CURR_PATH)/providers/oqs			  \
# 	$(CURR_PATH)/providers/entrust        \
# 	$(CURR_PATH)/providers/kris           \
# 	$(CURR_PATH)/providers/carl_redhound  \
# 	$(CURR_PATH)/providers/openca

DIRS := $(CURR_PATH)/providers/*

.PHONY: help

help:
	@echo ; \
	 echo "USAGE: make [ all, unzip, verify, cross_verify ] " ; \
	 echo && exit 1

all: unzip generate verify cross_verify
	@echo "All Done"

unzip generate verify cross_verify clean distclean:
	@for dir in $(DIRS) ; do \
		cd=$(notdir $(shell pwd)) ; \
		result=`cd $$dir && make $@` ; \
	 done
