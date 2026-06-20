# providers/leancrypto/Makefile
PROVIDER ?= leancrypto
ARTIFACTS_CERTS_ZIP ?= artifacts_certs_r5.zip
ARTIFACTS_DIR ?= _leancrypto_unzipped

.PHONY: unzip generate verify cross_verify clean

unzip:
	@echo "[ $(PROVIDER) ] Unzipping $(ARTIFACTS_CERTS_ZIP) into $(ARTIFACTS_DIR)"
	@[ -f $(ARTIFACTS_CERTS_ZIP) ] && unzip -o "$(ARTIFACTS_CERTS_ZIP)" -d "$(ARTIFACTS_DIR)" || echo "No $(ARTIFACTS_CERTS_ZIP), skipping unzip."

generate:
	@echo "[ $(PROVIDER) ] No generator configured in this environment; using provided artifacts only."

verify:
	@echo "[ $(PROVIDER) ] Running generic check.sh to verify X.509 structures."
	@./check.sh

cross_verify:
	@echo "[ $(PROVIDER) ] cross_verify not implemented yet; skipping."

clean:
	@rm -rf "$(ARTIFACTS_DIR)"

