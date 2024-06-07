# grafana-sampling

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.40.2](https://img.shields.io/badge/AppVersion-v0.40.2-informational?style=flat-square)

A Helm chart for a layered OTLP tail sampling and metrics generation pipeline.

This chart deploys the following architecture to your environment:
![Photo of sampling architecture](./sampling-architecture.png)

Note: by default, only OTLP traces are accepted at the load balancing layer.

## Chart Repo

Add the following repo to use the chart:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```
## Installing the Chart

Use the following command to install the chart with the release name `my-release`. Make sure to populate the required values.

```console
helm install my-release grafana/grafana-sampling --values - <<EOF | less
grafana-agent-statefulset:
  agent:
    extraEnv:
      - name: GRAFANA_CLOUD_API_KEY
        value: <REQUIRED>
      - name: GRAFANA_CLOUD_PROMETHEUS_URL
        value: <REQUIRED>
      - name: GRAFANA_CLOUD_PROMETHEUS_USERNAME
        value: <REQUIRED>
      - name: GRAFANA_CLOUD_TEMPO_ENDPOINT
        value: <REQUIRED>
      - name: GRAFANA_CLOUD_TEMPO_USERNAME
        value: <REQUIRED>
      # This is required for adaptive metric deduplication in Grafana Cloud
      - name: POD_UID
        valueFrom:
          fieldRef:
            apiVersion: v1
            fieldPath: metadata.uid
EOF
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Upgrading

A major chart version change indicates that there is an incompatible breaking change needing manual actions.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metricsGeneration.dimensions | list | `["service.namespace","service.version","deployment.environment","k8s.cluster.name"]` | Additional dimensions to add to generated metrics. |
| metricsGeneration.enabled | bool | `true` | Toggle generation of spanmetrics and servicegraph metrics. |
| sampling.decisionWait | string | `"15s"` | Wait time since the first span of a trace before making a sampling decision. |
| sampling.enabled | bool | `true` | Toggle tail sampling. |
| sampling.extraPolicies | string | A policy to sample long requests is added by default. | User-defined policies in river format. |
| sampling.failedRequests.percentage | int | `50` | Percentage of failed requests to sample. |
| sampling.failedRequests.sample | bool | `false` | Toggle sampling failed requests. |
| sampling.successfulRequests.percentage | int | `10` | Percentage of successful requests to sample. |
| sampling.successfulRequests.sample | bool | `true` | Toggle sampling successful requests. |

