# tempo


![Version: 0.14.2](https://img.shields.io/badge/Version-0.14.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.3.2](https://img.shields.io/badge/AppVersion-1.3.2-informational?style=flat-square) 

Grafana Tempo Single Binary Mode

## Source Code

* <https://github.com/grafana/tempo>



## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| extraVolumes | list | `[]` | Volumes to add |
| fullnameOverride | string | `""` | Overrides the chart's computed fullname |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.enabled | bool | `false` |  |
| persistence.size | string | `"10Gi"` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| replicas | int | `1` |  |
| service.annotations | object | `{}` |  |
| service.labels | object | `{}` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.imagePullSecrets | list | `[]` |  |
| serviceAccount.name | string | `nil` |  |
| serviceMonitor.additionalLabels | object | `{}` |  |
| serviceMonitor.annotations | object | `{}` |  |
| serviceMonitor.enabled | bool | `false` |  |
| serviceMonitor.interval | string | `""` |  |
| tempo.extraArgs | object | `{}` |  |
| tempo.extraEnv | list | `[]` |  |
| tempo.extraVolumeMounts | list | `[]` |  |
| tempo.ingester | object | `{}` |  |
| tempo.memBallastSizeMbs | int | `1024` |  |
| tempo.multitenancyEnabled | bool | `false` |  |
| tempo.overrides | object | `{}` |  |
| tempo.pullPolicy | string | `"IfNotPresent"` |  |
| tempo.receivers.jaeger.protocols.grpc.endpoint | string | `"0.0.0.0:14250"` |  |
| tempo.receivers.jaeger.protocols.thrift_binary.endpoint | string | `"0.0.0.0:6832"` |  |
| tempo.receivers.jaeger.protocols.thrift_compact.endpoint | string | `"0.0.0.0:6831"` |  |
| tempo.receivers.jaeger.protocols.thrift_http.endpoint | string | `"0.0.0.0:14268"` |  |
| tempo.receivers.opencensus | string | `nil` |  |
| tempo.receivers.otlp.protocols.grpc.endpoint | string | `"0.0.0.0:4317"` |  |
| tempo.receivers.otlp.protocols.http.endpoint | string | `"0.0.0.0:4318"` |  |
| tempo.repository | string | `"grafana/tempo"` |  |
| tempo.resources | object | `{}` |  |
| tempo.retention | string | `"24h"` |  |
| tempo.searchEnabled | bool | `false` |  |
| tempo.server.http_listen_port | int | `3100` |  |
| tempo.storage.trace.backend | string | `"local"` |  |
| tempo.storage.trace.local.path | string | `"/var/tempo/traces"` |  |
| tempo.storage.trace.wal.path | string | `"/var/tempo/wal"` |  |
| tempo.tag | string | `"1.3.2"` |  |
| tempo.updateStrategy | string | `"RollingUpdate"` |  |
| tempoQuery.extraArgs | object | `{}` |  |
| tempoQuery.extraEnv | list | `[]` |  |
| tempoQuery.extraVolumeMounts | list | `[]` |  |
| tempoQuery.pullPolicy | string | `"IfNotPresent"` |  |
| tempoQuery.repository | string | `"grafana/tempo-query"` |  |
| tempoQuery.tag | string | `"1.0.1"` |  |
| tolerations | list | `[]` |  |

## Chart Repo

Add the following repo to use the chart:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```

## Upgrading

A major chart version change indicates that there is an incompatible breaking change needing manual actions.

### From Chart versions < 0.7.0

Upgrading from pre 0.7.0 will, by default, move your trace storage from `/tmp/tempo/traces` to `/var/tempo/traces`.
This will cause Tempo to lose trace history. If you would like to retain history just copy the contents from the 
old folder to the new.