# loki-canary


![Version: 0.8.0](https://img.shields.io/badge/Version-0.8.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.5.0](https://img.shields.io/badge/AppVersion-2.5.0-informational?style=flat-square) 

Helm chart for Grafana Loki Canary

## Source Code

* <https://github.com/grafana/loki>
* <https://grafana.com/oss/loki/>
* <https://grafana.com/docs/loki/latest/>



## Chart Repo

Add the following repo to use the chart:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| basicAuth.enabled | bool | `false` |  |
| basicAuth.existingSecret | string | `nil` |  |
| basicAuth.password | string | `nil` |  |
| basicAuth.username | string | `nil` |  |
| extraArgs | list | `["-labelname=pod","-labelvalue=$(POD_NAME)"]` | Additional CLI args for the canary |
| extraEnv | list | `[]` |  |
| extraEnvFrom | list | `[]` |  |
| fullnameOverride | string | `""` | Overrides the chart's computed fullname |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"docker.io/grafana/loki-canary"` |  |
| image.tag | string | `nil` |  |
| imagePullSecrets | list | `[]` | Image pull secrets for Docker images |
| lokiAddress | string | `nil` | The Loki server URL:Port, e.g. loki:3100 |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` | Common annotations for all pods |
| priorityClassName | string | `nil` | The name of the PriorityClass for pods |
| resources | object | `{}` |  |
| revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain to allow rollback |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.imagePullSecrets | list | `[]` |  |
| serviceAccount.name | string | `nil` |  |
| serviceMonitor.annotations | object | `{}` |  |
| serviceMonitor.enabled | bool | `false` |  |
| serviceMonitor.interval | string | `nil` |  |
| serviceMonitor.labels | object | `{}` |  |
| serviceMonitor.namespace | string | `nil` |  |
| serviceMonitor.namespaceSelector | object | `{}` |  |
| serviceMonitor.scrapeTimeout | string | `nil` |  |
| tolerations | list | `[]` |  |
