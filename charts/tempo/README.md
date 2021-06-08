# tempo

![Version: 0.7.2](https://img.shields.io/badge/Version-0.7.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.0.0](https://img.shields.io/badge/AppVersion-v1.0.0-informational?style=flat-square)

Grafana Tempo Single Binary Mode

## Source Code

* <https://github.com/grafana/tempo>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| extraVolumes | list | `[]` | Volumes to add |
| fullnameOverride | string | `""` | Overrides the chart's computed fullname |
| nameOverride | string | `""` | Overrides the chart's name |
| nodeSelector | object | `{}` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.enabled | bool | `false` |  |
| persistence.size | string | `"10Gi"` |  |
| podAnnotations | list | `[]` |  |
| replicas | int | `1` |  |
| service.annotations | object | `{}` |  |
| service.labels | object | `{}` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` | Annotations for the service account |
| serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| serviceAccount.imagePullSecrets | list | `[]` | Image pull secrets for the service account |
| serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| tempo.authEnabled | bool | `false` |  |
| tempo.extraArgs | object | `{}` |  |
| tempo.extraEnv | list | `[]` | Environment variables to add |
| tempo.extraVolumeMounts | list | `[]` | Volume mounts to add |
| tempo.ingester | object | `{}` |  |
| tempo.memBallastSizeMbs | int | `1024` |  |
| tempo.pullPolicy | string | `"IfNotPresent"` |  |
| tempo.receivers.jaeger.protocols.grpc.endpoint | string | `"0.0.0.0:14250"` |  |
| tempo.receivers.jaeger.protocols.thrift_binary.endpoint | string | `"0.0.0.0:6832"` |  |
| tempo.receivers.jaeger.protocols.thrift_compact.endpoint | string | `"0.0.0.0:6831"` |  |
| tempo.receivers.jaeger.protocols.thrift_http.endpoint | string | `"0.0.0.0:14268"` |  |
| tempo.repository | string | `"grafana/tempo"` |  |
| tempo.resources | object | `{}` |  |
| tempo.retention | string | `"24h"` |  |
| tempo.server.httpListenPort | int | `3100` |  |
| tempo.storage.trace.backend | string | `"local"` |  |
| tempo.storage.trace.local.path | string | `"/var/tempo/traces"` |  |
| tempo.storage.trace.wal.path | string | `"/var/tempo/wal"` |  |
| tempo.tag | string | `"1.0.0"` |  |
| tempo.updateStrategy | string | `"RollingUpdate"` |  |
| tempoQuery.extraArgs | object | `{}` |  |
| tempoQuery.extraEnv | list | `[]` | Environment variables to add |
| tempoQuery.extraVolumeMounts | list | `[]` | Volume mounts to add |
| tempoQuery.pullPolicy | string | `"IfNotPresent"` |  |
| tempoQuery.repository | string | `"grafana/tempo-query"` |  |
| tempoQuery.tag | string | `"1.0.0"` |  |
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