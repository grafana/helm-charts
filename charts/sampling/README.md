# Sampling Helm Chart

A Helm Chart for sampling OTLP Traces. This chart can be used to generate spanmetrics and servicegraph metric from OTLP traces, apply tail sampling policies, and forward the sampled Traces and generated Metrics to a Grafana Cloud stack.

## Usage

[Helm](https://helm.sh/) must be installed to use the chart. Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

#### Setup Grafana chart repository

```
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

### Install Chart

To install the chart with the release name my-release:

```
helm install my-release grafana/sampling
```
