.ONESHELL:
.DELETE_ON_ERROR:
export SHELL     := bash
export SHELLOPTS := pipefail:errexit
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rule

# Adapted from https://suva.sh/posts/well-documented-makefiles/
.PHONY: help
help: ## Display this help
help:
	@awk 'BEGIN {FS = ": ##"; printf "Usage:\n  make <target>\n\nTargets:\n"} /^[a-zA-Z0-9_\.\-\/%]+: ##/ { printf "  %-45s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: dep-update
dep-update: ## Update chart dependencies
dep-update:
	helm dep update

.PHONY: exports
exports: ## Recreate exports directory using Tanka
exports: dep-update
	rm -rf -- exports/*
	tk export exports/default environments/default
	tk export exports/small environments/small
	tk export exports/large environments/large
