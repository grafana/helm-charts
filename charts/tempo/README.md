# tempo

![Version: 0.16.6](https://img.shields.io/badge/Version-0.16.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.5.0](https://img.shields.io/badge/AppVersion-1.5.0-informational?style=flat-square)

Grafana Tempo Single Binary Mode

## Source Code

* <https://github.com/grafana/tempo>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity for pod assignment. See: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| config | string | Dynamically generated tempo configmap | Tempo configuration file contents |
| extraVolumes | list | `[]` | Volumes to add |
| fullnameOverride | string | `""` | Overrides the chart's computed fullname |
| nameOverride | string | `""` | Overrides the chart's name |
| nodeSelector | object | `{}` | Node labels for pod assignment. See: https://kubernetes.io/docs/user-guide/node-selection/ |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.enabled | bool | `false` |  |
| persistence.size | string | `"10Gi"` |  |
| podAnnotations | object | `{}` | Pod Annotations |
| podLabels | object | `{}` | Pod (extra) Labels |
| priorityClassName | string | `nil` | The name of the PriorityClass |
| replicas | int | `1` |  |
| securityContext | object | `{}` | securityContext for container |
| service.annotations | object | `{}` |  |
| service.labels | object | `{}` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` | Annotations for the service account |
| serviceAccount.automountServiceAccountToken | bool | `true` |  |
| serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| serviceAccount.imagePullSecrets | list | `[]` | Image pull secrets for the service account |
| serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor.additionalLabels | object | `{}` |  |
| serviceMonitor.annotations | object | `{}` |  |
| serviceMonitor.enabled | bool | `false` |  |
| serviceMonitor.interval | string | `""` |  |
| tempo.extraArgs | object | `{}` |  |
| tempo.extraEnv | list | `[]` | Environment variables to add |
| tempo.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the ingester pods |
| tempo.extraVolumeMounts | list | `[]` | Volume mounts to add |
| tempo.global_overrides.per_tenant_override_config | string | `"/conf/overrides.yaml"` |  |
| tempo.ingester | object | `{}` | Configuration options for the ingester |
| tempo.memBallastSizeMbs | int | `1024` |  |
| tempo.metricsGenerator.enabled | bool | `false` | If true, enables Tempo's metrics generator (https://grafana.com/docs/tempo/next/metrics-generator/) |
| tempo.metricsGenerator.remoteWriteUrl | string | `"http://prometheus.monitoring:9090/api/v1/write"` |  |
| tempo.multitenancyEnabled | bool | `false` |  |
| tempo.overrides | object | `{}` |  |
| tempo.pullPolicy | string | `"IfNotPresent"` |  |
| tempo.querier | object | `{}` | Configuration options for the querier |
| tempo.queryFrontend | object | `{}` | Configuration options for the query-fronted |
| tempo.receivers.jaeger.protocols.grpc.endpoint | string | `"0.0.0.0:14250"` |  |
| tempo.receivers.jaeger.protocols.thrift_binary.endpoint | string | `"0.0.0.0:6832"` |  |
| tempo.receivers.jaeger.protocols.thrift_compact.endpoint | string | `"0.0.0.0:6831"` |  |
| tempo.receivers.jaeger.protocols.thrift_http.endpoint | string | `"0.0.0.0:14268"` |  |
| tempo.receivers.opencensus | string | `nil` |  |
| tempo.receivers.otlp.protocols.grpc.endpoint | string | `"0.0.0.0:4317"` |  |
| tempo.receivers.otlp.protocols.http.endpoint | string | `"0.0.0.0:4318"` |  |
| tempo.reportingEnabled | bool | `true` | If true, Tempo will report anonymous usage data about the shape of a deployment to Grafana Labs |
| tempo.repository | string | `"grafana/tempo"` |  |
| tempo.resources | object | `{}` |  |
| tempo.retention | string | `"24h"` |  |
| tempo.searchEnabled | bool | `false` | If true, enables Tempo's native search |
| tempo.securityContext | object | `{}` |  |
| tempo.server.http_listen_port | int | `3100` | HTTP server listen port |
| tempo.storage.trace.backend | string | `"local"` |  |
| tempo.storage.trace.local.path | string | `"/var/tempo/traces"` |  |
| tempo.storage.trace.wal.path | string | `"/var/tempo/wal"` |  |
| tempo.tag | string | `"1.5.0"` |  |
| tempo.updateStrategy | string | `"RollingUpdate"` |  |
| tempoQuery.enabled | bool | `true` | if False the tempo-query container is not deployed |
| tempoQuery.extraArgs | object | `{}` |  |
| tempoQuery.extraEnv | list | `[]` | Environment variables to add |
| tempoQuery.extraVolumeMounts | list | `[]` | Volume mounts to add |
| tempoQuery.pullPolicy | string | `"IfNotPresent"` |  |
| tempoQuery.repository | string | `"grafana/tempo-query"` |  |
| tempoQuery.securityContext | object | `{}` |  |
| tempoQuery.tag | string | `"1.5.0"` |  |
| tolerations | list | `[]` | Tolerations for pod assignment. See: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |

## Chart Repo

Add the following repo to use the chart:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release grafana/tempo
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Upgrading

A major chart version change indicates that there is an incompatible breaking change needing manual actions.

### From Chart versions < 0.7.0

Upgrading from pre 0.7.0 will, by default, move your trace storage from `/tmp/tempo/traces` to `/var/tempo/traces`.
This will cause Tempo to lose trace history. If you would like to retain history just copy the contents from the
old folder to the new.