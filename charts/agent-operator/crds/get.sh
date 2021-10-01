#!/bin/bash

BASE_DIR=$(dirname "$0")

VERSION=$(grep -Po '(?<=^appVersion: )(v\d+.\d+\.\d+)' "$BASE_DIR/../Chart.yaml")

if [[ -z $VERSION ]]; then
    VERSION=$(grep -Po '(?<=^appVersion: main-)([a-f0-9]{7})' "$BASE_DIR/../Chart.yaml")
fi

if [[ -z $VERSION ]]; then
    echo 'ERROR: Cannot get version!'
    exit 1
fi

CRDS='
monitoring.coreos.com_podmonitors.yaml
monitoring.coreos.com_probes.yaml
monitoring.coreos.com_servicemonitors.yaml
monitoring.grafana.com_grafanaagents.yaml
monitoring.grafana.com_logsinstances.yaml
monitoring.grafana.com_metricsinstances.yaml
monitoring.grafana.com_podlogs.yaml
'

for CRD in $CRDS; do
    curl -o "$BASE_DIR/$CRD" "https://raw.githubusercontent.com/grafana/agent/$VERSION/production/operator/crds/$CRD"
done
