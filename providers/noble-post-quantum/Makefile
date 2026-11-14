# SPDX-License-Identifier: Apache-2.0
#
# PQC Certificates Tests (R5): the noble-post-quantum provider
# (JavaScript, @noble/post-quantum). Targets follow the project readme and the
# root Makefile, which calls unzip, generate, verify, cross_verify, clean and
# distclean in every provider directory.

PROVIDER_NAME := noble-post-quantum
ZIP           := artifacts_certs_r5.zip
OUT           := compatMatrices/artifacts_certs_r5
LOGS          := logs
# Where cross_verify looks for the other providers' */$(ZIP) (default: the
# providers/ directory this one sits in).
PROVIDERS_DIR ?= ..

.PHONY: help all requirements install unzip generate verify cross_verify test clean distclean

help:
	@echo ; \
	 echo "USAGE: make [ all, install, unzip, generate, verify, cross_verify, test, clean ]" ; \
	 echo "  cross_verify reads $(PROVIDERS_DIR)/*/$(ZIP) (set PROVIDERS_DIR to change it)" ; \
	 echo && exit 1

all: unzip generate verify cross_verify

# Node.js >= 20.19 (tested with 22), npm, zip and unzip
requirements:
	@command -v node >/dev/null || { echo "[ $(PROVIDER_NAME) ] node is required" >&2; exit 50; }
	@command -v npm >/dev/null || { echo "[ $(PROVIDER_NAME) ] npm is required" >&2; exit 50; }
	@command -v unzip >/dev/null || { echo "[ $(PROVIDER_NAME) ] unzip is required" >&2; exit 50; }
	@command -v zip >/dev/null || { echo "[ $(PROVIDER_NAME) ] zip is required" >&2; exit 50; }

node_modules/.package-lock.json: package-lock.json
	npm ci --no-fund --no-audit -q

install: requirements node_modules/.package-lock.json

# Extracts our own zip into artifacts_certs_r5/ (ignored by git)
unzip:
	@if [ -f "$(ZIP)" ] ; then unzip -q -o "$(ZIP)" -d artifacts_certs_r5 ; fi

# Rewrites $(ZIP) with new keys
generate: install
	@mkdir -p $(LOGS)
	./gen.sh > $(LOGS)/generate_log.txt 2>&1 || { cat $(LOGS)/generate_log.txt >&2; exit 1; }

# Checks our own zip: $(OUT)/$(PROVIDER_NAME)_$(PROVIDER_NAME).csv
verify: install
	./check.sh .

# Checks every other provider's zip: $(OUT)/<provider>_$(PROVIDER_NAME).csv.
# A zip that cannot be read is skipped (see logs/); nothing is written into
# the other providers' directories.
cross_verify: install
	@for z in $(PROVIDERS_DIR)/*/$(ZIP) ; do \
	   p=$$(basename "$$(dirname "$$z")") ; \
	   [ "$$p" = "$(PROVIDER_NAME)" ] && continue ; \
	   ./check.sh "$$z" || echo "[ $(PROVIDER_NAME) ] skipped $$p (see $(LOGS)/$$p.log)" >&2 ; \
	 done

test: install
	node --test test/*.test.mjs

clean:
	@rm -rf artifacts_certs_r5

distclean: clean
	@rm -rf $(LOGS)
