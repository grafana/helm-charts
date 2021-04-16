# Agent Helm Chart - Traces

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![AppVersion: v0.13.0](https://img.shields.io/badge/AppVersion-v0.13.0-informational?style=flat-square)

This Helm chart allows to deploy only the Traces part of the Grafana Agent.


## Prerequisites

Make sure you have Helm [installed](https://helm.sh/docs/using_helm/#installing-helm).


## Get Repo Info

```shell
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._


## Deploy Agent

This kind of deployment uses configuration specified at the time of deployment.

```shell
cat <<END | helm upgrade --create-namespace --namespace grafana --values - --install agent grafana/agent-traces
# Keep the reserce names simple
fullnameOverride: agent-traces

# Configure Grafana Cloud credentials (username and password)
accessConfig:
  username: 12345
secret:
  data:
    password: cdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZZYXWVUTSRQPONMLKJIHGFEDCBAzyxwvutsrqponmlkjihgfedc
END
```


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Jiri Tyr | jiri.tyr(at)gmail.com | [https://github.com/jtyr](https://github.com/jtyr) |


## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| accessConfig.password_file | string | `"/var/run/secrets/grafana.com/agent/password"` | Location of the file holding the password used to authenticate to Tempo. |
| accessConfig.url | string | `"tempo-us-central1.grafana.net:443"` | URL where to push the metrics. |
| accessConfig.username | string | `""` | Username used to authenticate to Tempo. |
| affinity | object | `{}` | Pod affinity. |
| annotations | object | `{}` | DaemonSet annotations. |
| config.agent | string | See the value in the `values.yaml` file. | Agent configuration template. |
| config.strategies | string | See the value in the `values.yaml` file. | Sampling strategies configuration template. |
| enabled | bool | `true` | Whether this chart is enabled. Useful when this chart is used as a dependency from another chart. |
| env | list | `[]` | Environment variables for the Agent container. |
| extraArgs | list | `[]` | Additional command arguments for the Agent container. |
| extraConfig | object | `{}` | Extra top level Agent configuration. |
| extraDefaultConfigConfig | list | `[]` | Extra config on the default configuration level. |
| extraDefaultScrapeConfig | list | `[]` | Extra scrape config on the default configuration level. |
| extraServiceConfig | list | `[]` | Extra Agent configuration on the service level. |
| extraVolumeMounts | list | `[]` | Additional volume mounts for the Agent container. |
| extraVolumes | list | `[]` | Additional volumes for the Pod. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| image.repository | string | `"grafana/agent"` | Image repository and name. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| livenessProbe.httpGet.path | string | `"/-/healthy"` | URL path used by the Agent container liveness probe. |
| livenessProbe.httpGet.port | string | `"http-metrics"` | Container port used by the Agent container liveness probe. |
| nodeSelector | object | `{}` | Pod node selector. |
| podAnnotations."prometheus.io/port" | string | `"http-metrics"` | Annotation indicated which port to scrape. |
| podAnnotations."prometheus.io/scrape" | string | `"true"` | Annotation indicating whether the metrics should be scraped from this Pod. |
| rbac.create | bool | `true` | Whether to create Cluster Role and Cluster Role Binding. |
| readinessProbe.httpGet.path | string | `"/-/ready"` | URL path used by the Agent container readiness probe. |
| readinessProbe.httpGet.port | string | `"http-metrics"` | Container port used by the Agent container readiness probe. |
| resources | object | `{}` | Resources for the Agent container. |
| secret.annotations | object | `{}` | Secret annotations. |
| secret.create | bool | `true` | Whether the Secret should be created. |
| secret.data.password | string | `""` | Password used to authenticate with Tempo. |
| secret.mount | bool | `true` | Whether to mount the secret inside the Agent container. |
| securityContext | object | `{}` | Security context for the Agent container. |
| service.annotations | object | `{}` | Service annotations. |
| serviceAccount.annotations | object | `{}` | Service Account annotations. |
| serviceAccount.create | bool | `true` | Whether the Service Account should be created. |
| serviceAccount.name | string | `""` | Service Account name. |
| tolerations[0].effect | string | `"NoSchedule"` | Pod toleration effect. |
| tolerations[0].operator | string | `"Exists"` | Pod toleration operator. |
