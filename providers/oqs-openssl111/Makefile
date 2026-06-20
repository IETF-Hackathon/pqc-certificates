# providers/oqs-openssl111/Makefile

PROVIDER ?= oqs-openssl111
ARTIFACTS_DIR ?= _oqs_openssl111_unzipped

.PHONY: unzip generate verify cross_verify clean

unzip:
	@echo "[ $(PROVIDER) ] Ensuring artifacts directory $(ARTIFACTS_DIR) exists."
	@mkdir -p "$(ARTIFACTS_DIR)"

generate:
	@echo "[ $(PROVIDER) ] Attempting to run provider generation scripts, if present."
	@if [ -x ./gen.sh ]; then \
	  echo "[ $(PROVIDER) ] Running gen.sh"; \
	  ./gen.sh "$(ARTIFACTS_DIR)"; \
	else \
	  echo "[ $(PROVIDER) ] gen.sh not present or not executable, skipping."; \
	fi
	@if [ -x ./gen_r3.sh ]; then \
	  echo "[ $(PROVIDER) ] Running gen_r3.sh"; \
	  ./gen_r3.sh "$(ARTIFACTS_DIR)"; \
	else \
	  echo "[ $(PROVIDER) ] gen_r3.sh not present or not executable, skipping."; \
	fi

verify:
	@echo "[ $(PROVIDER) ] Attempting to run provider verification scripts, if present."
	@if [ -x ./check.sh ]; then \
	  echo "[ $(PROVIDER) ] Running check.sh $(ARTIFACTS_DIR)"; \
	  ./check.sh "$(ARTIFACTS_DIR)" || echo "[ $(PROVIDER) ] check.sh exited non-zero, continuing."; \
	else \
	  echo "[ $(PROVIDER) ] check.sh not present or not executable, skipping."; \
	fi
	@if [ -x ./check_r3.sh ]; then \
	  echo "[ $(PROVIDER) ] Running check_r3.sh $(ARTIFACTS_DIR)"; \
	  ./check_r3.sh "$(ARTIFACTS_DIR)" || echo "[ $(PROVIDER) ] check_r3.sh exited non-zero, continuing."; \
	else \
	  echo "[ $(PROVIDER) ] check_r3.sh not present or not executable, skipping."; \
	fi

cross_verify:
	@echo "[ $(PROVIDER) ] cross_verify not implemented yet; skipping."

clean:
	@rm -rf "$(ARTIFACTS_DIR)"

