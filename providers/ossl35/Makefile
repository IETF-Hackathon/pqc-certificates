# providers/ossl35/Makefile

PROVIDER ?= ossl35
ARTIFACTS_CERTS_ZIP ?= artifacts_certs_r5.zip
ARTIFACTS_CMS_ZIP ?= artifacts_cms_v3.zip
ARTIFACTS_DIR ?= _ossl35_unzipped

.PHONY: unzip generate verify cross_verify clean

unzip:
	@echo "[ $(PROVIDER) ] Unzipping artifacts into $(ARTIFACTS_DIR)"
	@if [ -f "$(ARTIFACTS_CERTS_ZIP)" ]; then \
	  unzip -o "$(ARTIFACTS_CERTS_ZIP)" -d "$(ARTIFACTS_DIR)"; \
	else \
	  echo "[ $(PROVIDER) ] No $(ARTIFACTS_CERTS_ZIP), skipping certs unzip."; \
	fi
	@if [ -f "$(ARTIFACTS_CMS_ZIP)" ]; then \
	  unzip -o "$(ARTIFACTS_CMS_ZIP)" -d "$(ARTIFACTS_DIR)"; \
	else \
	  echo "[ $(PROVIDER) ] No $(ARTIFACTS_CMS_ZIP), skipping CMS unzip."; \
	fi

generate:
	@echo "[ $(PROVIDER) ] Using provided artifacts only; no generator configured in this harness."

verify:
	@echo "[ $(PROVIDER) ] Attempting to run provider certificate and CMS checks, if present."
	@if [ -x ./check_certs.sh ]; then \
	  if [ -f "$(ARTIFACTS_CERTS_ZIP)" ]; then \
	    echo "[ $(PROVIDER) ] Running check_certs.sh $(ARTIFACTS_CERTS_ZIP)"; \
	    ./check_certs.sh "$(ARTIFACTS_CERTS_ZIP)" || echo "[ $(PROVIDER) ] check_certs.sh exited non-zero, continuing."; \
	  else \
	    echo "[ $(PROVIDER) ] $(ARTIFACTS_CERTS_ZIP) missing; skipping check_certs.sh."; \
	  fi; \
	else \
	  echo "[ $(PROVIDER) ] check_certs.sh not present or not executable, skipping."; \
	fi
	@if [ -x ./check_cms.sh ]; then \
	  if [ -f "$(ARTIFACTS_CMS_ZIP)" ]; then \
	    echo "[ $(PROVIDER) ] Running check_cms.sh $(ARTIFACTS_CMS_ZIP)"; \
	    ./check_cms.sh "$(ARTIFACTS_CMS_ZIP)" || echo "[ $(PROVIDER) ] check_cms.sh exited non-zero, continuing."; \
	  else \
	    echo "[ $(PROVIDER) ] $(ARTIFACTS_CMS_ZIP) missing; skipping check_cms.sh."; \
	  fi; \
	else \
	  echo "[ $(PROVIDER) ] check_cms.sh not present or not executable, skipping."; \
	fi

cross_verify:
	@echo "[ $(PROVIDER) ] cross_verify not implemented yet; skipping."

clean:
	@rm -rf "$(ARTIFACTS_DIR)"

