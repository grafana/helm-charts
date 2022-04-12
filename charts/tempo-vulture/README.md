# tempo-vulture


![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.3.0](https://img.shields.io/badge/AppVersion-1.3.0-informational?style=flat-square) 

Grafana Tempo Vulture - A tool to monitor Tempo performance.

## Source Code

* <https://github.com/grafana/tempo>



## Chart Repo

Add the following repo to use the chart:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```

## Vulture

Vulture only works with Jaeger GRPC, so make sure 14250 is open on your distributor. You don't need to specify the port in the distributor url.

Example configuration:
```yaml
tempoAddress:
    push: http://tempo-tempo-distributed-distributor
    query: http://tempo-tempo-distributed-query-frontend:3100
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| annotations | object | `{}` |  |
| extraArgs | list | `[]` |  |
| extraEnv | list | `[]` |  |
| extraEnvFrom | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"docker.io/grafana/tempo-vulture"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| replicas | int | `1` | Number of replicas of Tempo Vulture |
| resources | object | `{}` |  |
| revisionHistoryLimit | int | `10` |  |
| serviceAccount.annotations | object | `{}` |  |
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
| tempoAddress.push | string | `nil` |  |
| tempoAddress.query | string | `nil` |  |
| tolerations | list | `[]` |  |