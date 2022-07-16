# tempo

![Version: 0.15.6](https://img.shields.io/badge/Version-0.15.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.4.1](https://img.shields.io/badge/AppVersion-1.4.1-informational?style=flat-square)

Grafana Tempo Single Binary Mode

## Source Code

* <https://github.com/grafana/tempo>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| config | string | `"multitenancy_enabled: {{ .Values.tempo.multitenancyEnabled }}\nsearch_enabled: {{ .Values.tempo.searchEnabled }}\ncompactor:\n  compaction:\n    compacted_block_retention: {{ .Values.tempo.retention }}\ndistributor:\n  receivers:\n    {{- toYaml .Values.tempo.receivers | nindent 8 }}\ningester:\n  {{- toYaml .Values.tempo.ingester | nindent 6 }}\nserver:\n  {{- toYaml .Values.tempo.server | nindent 6 }}\nstorage:\n  {{- toYaml .Values.tempo.storage | nindent 6 }}\noverrides:\n  {{- toYaml .Values.tempo.global_overrides | nindent 6 }}\n"` | Tempo configuration file contents |
| extraVolumes | list | `[]` | Volumes to add |
| fullnameOverride | string | `""` | Overrides the chart's computed fullname |
| nameOverride | string | `""` | Overrides the chart's name |
| nodeSelector | object | `{}` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.enabled | bool | `false` |  |
| persistence.size | string | `"10Gi"` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| replicas | int | `1` |  |
| securityContext | object | `{}` |  |
| service.annotations | object | `{}` |  |
| service.labels | object | `{}` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` | Annotations for the service account |
| serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| serviceAccount.imagePullSecrets | list | `[]` | Image pull secrets for the service account |
| serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor.additionalLabels | object | `{}` |  |
| serviceMonitor.annotations | object | `{}` |  |
| serviceMonitor.enabled | bool | `false` |  |
| serviceMonitor.interval | string | `""` |  |
| tempo.extraArgs | object | `{}` |  |
| tempo.extraEnv | list | `[]` | Environment variables to add |
| tempo.extraVolumeMounts | list | `[]` | Volume mounts to add |
| tempo.global_overrides.per_tenant_override_config | string | `"/conf/overrides.yaml"` |  |
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
| tempo.searchEnabled | bool | `false` | If true, enables Tempo's native search |
| tempo.securityContext | object | `{}` |  |
| tempo.server.http_listen_port | int | `3100` | HTTP server listen port |
| tempo.storage.trace.backend | string | `"local"` |  |
| tempo.storage.trace.local.path | string | `"/var/tempo/traces"` |  |
| tempo.storage.trace.wal.path | string | `"/var/tempo/wal"` |  |
| tempo.tag | string | `"1.4.1"` |  |
| tempo.updateStrategy | string | `"RollingUpdate"` |  |
| tempoQuery.enabled | bool | `true` | if False the tempo-query container is not deployed |
| tempoQuery.extraArgs | object | `{}` |  |
| tempoQuery.extraEnv | list | `[]` | Environment variables to add |
| tempoQuery.extraVolumeMounts | list | `[]` | Volume mounts to add |
| tempoQuery.pullPolicy | string | `"IfNotPresent"` |  |
| tempoQuery.repository | string | `"grafana/tempo-query"` |  |
| tempoQuery.securityContext | object | `{}` |  |
| tempoQuery.tag | string | `"1.4.1"` |  |
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