MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# renovate: docker=helmunittest/helm-unittest
HELM_UNITTEST_TAG := 3.19.0-1.0.3

# Chart(s) to target (glob pattern, e.g. HELM_UNITTEST_CHART=loki)
HELM_UNITTEST_CHART ?= *
# Test file pattern within the chart (e.g. HELM_UNITTEST_FILE='tests/ingester/*_test.yaml')
HELM_UNITTEST_FILE  ?= tests/**/*.yaml

.PHONY: helm-unittest
helm-unittest:
	docker run --rm -v $(MAKEFILE_DIR):/apps helmunittest/helm-unittest:$(HELM_UNITTEST_TAG) --strict --file '$(HELM_UNITTEST_FILE)' charts/$(HELM_UNITTEST_CHART)
