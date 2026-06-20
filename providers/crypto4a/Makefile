# providers/crypto4a/Makefile

PROVIDER ?= crypto4a
ARTIFACTS_CERTS_ZIP ?= artifacts_certs_r5.zip
ARTIFACTS_DIR ?= _crypto4a_unzipped

.PHONY: unzip generate verify cross_verify clean

unzip:
	@echo "[ $(PROVIDER) ] Unzipping $(ARTIFACTS_CERTS_ZIP) into $(ARTIFACTS_DIR)"
	@if [ -f "$(ARTIFACTS_CERTS_ZIP)" ]; then \
	  unzip -o "$(ARTIFACTS_CERTS_ZIP)" -d "$(ARTIFACTS_DIR)"; \
	else \
	  echo "[ $(PROVIDER) ] No $(ARTIFACTS_CERTS_ZIP), skipping unzip."; \
	fi

generate:
	@echo "[ $(PROVIDER) ] Using provided artifacts only; no generator configured in this harness."

verify:
	@echo "[ $(PROVIDER) ] No provider-specific checker wired yet; nothing to verify."
	@true

cross_verify:
	@echo "[ $(PROVIDER) ] cross_verify not implemented yet; skipping."

clean:
	@rm -rf "$(ARTIFACTS_DIR)"

