# tempo

![Version: 1.24.1](https://img.shields.io/badge/Version-1.24.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.9.0](https://img.shields.io/badge/AppVersion-2.9.0-informational?style=flat-square)

Grafana Tempo Single Binary Mode

## Source Code

* <https://github.com/grafana/tempo>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity for pod assignment. See: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| annotations | object | `{}` | Annotations for the StatefulSet |
| config | string | Dynamically generated tempo configmap | Tempo configuration file contents |
| extraLabels | object | `{}` |  |
| extraVolumes | list | `[]` | Volumes to add |
| fullnameOverride | string | `""` | Overrides the chart's computed fullname |
| global.commonLabels | object | `{}` | Common labels for all object directly managed by this chart. |
| hostAliases | list | `[]` | hostAliases to add |
| labels | object | `{}` | labels for tempo |
| nameOverride | string | `""` | Overrides the chart's name |
| networkPolicy.allowExternal | bool | `true` |  |
| networkPolicy.egress.blockDNSResolution | bool | `false` |  |
| networkPolicy.egress.enabled | bool | `false` |  |
| networkPolicy.egress.ports | list | `[]` |  |
| networkPolicy.egress.to | list | `[]` |  |
| networkPolicy.enabled | bool | `false` |  |
| networkPolicy.explicitNamespacesSelector | object | `{}` |  |
| networkPolicy.ingress | bool | `true` |  |
| nodeSelector | object | `{}` | Node labels for pod assignment. See: https://kubernetes.io/docs/user-guide/node-selection/ |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.enableStatefulSetAutoDeletePVC | bool | `false` | Enable StatefulSetAutoDeletePVC feature |
| persistence.enabled | bool | `false` |  |
| persistence.size | string | `"10Gi"` |  |
| podAnnotations | object | `{}` | Pod Annotations |
| podLabels | object | `{}` | Pod (extra) Labels |
| priorityClassName | string | `nil` | The name of the PriorityClass |
| replicas | int | `1` | Define the amount of instances |
| securityContext | object | `{"fsGroup":10001,"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001}` | securityContext for container |
| service.annotations | object | `{}` |  |
| service.clusterIP | string | `""` |  |
| service.labels | object | `{}` |  |
| service.loadBalancerIP | string | `nil` | IP address, in case of 'type: LoadBalancer' |
| service.protocol | string | `"TCP"` | If service type is LoadBalancer, the exposed protocol can either be "UDP", "TCP" or "UDP,TCP" |
| service.targetPort | string | `""` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` | Annotations for the service account |
| serviceAccount.automountServiceAccountToken | bool | `true` |  |
| serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| serviceAccount.imagePullSecrets | list | `[]` | Image pull secrets for the service account |
| serviceAccount.labels | object | `{}` | Labels for the service account |
| serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor.additionalLabels | object | `{}` |  |
| serviceMonitor.annotations | object | `{}` |  |
| serviceMonitor.enabled | bool | `false` |  |
| serviceMonitor.interval | string | `""` |  |
| tempo.extraArgs | object | `{}` |  |
| tempo.extraEnv | list | `[]` | Environment variables to add |
| tempo.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the ingester pods |
| tempo.extraVolumeMounts | list | `[]` | Volume mounts to add |
| tempo.ingester | object | `{}` | Configuration options for the ingester. Refers to: https://grafana.com/docs/tempo/latest/configuration/#ingester |
| tempo.livenessProbe.failureThreshold | int | `3` |  |
| tempo.livenessProbe.httpGet.path | string | `"/ready"` |  |
| tempo.livenessProbe.httpGet.port | int | `3200` |  |
| tempo.livenessProbe.initialDelaySeconds | int | `30` |  |
| tempo.livenessProbe.periodSeconds | int | `10` |  |
| tempo.livenessProbe.successThreshold | int | `1` |  |
| tempo.livenessProbe.timeoutSeconds | int | `5` |  |
| tempo.memBallastSizeMbs | int | `1024` |  |
| tempo.metricsGenerator.enabled | bool | `false` | If true, enables Tempo's metrics generator (https://grafana.com/docs/tempo/next/metrics-generator/) |
| tempo.metricsGenerator.remoteWriteUrl | string | `"http://prometheus.monitoring:9090/api/v1/write"` |  |
| tempo.multitenancyEnabled | bool | `false` |  |
| tempo.overrides | object | `{"defaults":{},"per_tenant_override_config":"/conf/overrides.yaml"}` | The standard overrides configuration section. This can include a `defaults` object for applying to all tenants (not to be confused with the `global` property of the same name, which overrides `max_byte_per_trace` for all tenants). For an example on how to enable the metrics generator using the `overrides` object, see the 'Activate metrics generator' section below. Refer to [Standard overrides](https://grafana.com/docs/tempo/latest/configuration/#standard-overrides) for more details. |
| tempo.overrides.defaults | object | `{}` | Default config values for all tenants, can be overridden by per-tenant overrides. If a tenant's specific overrides are not found in the `per_tenant_overrides` block, the values in this `default` block will be used. Configs inside this block should follow the new overrides indentation format |
| tempo.overrides.per_tenant_override_config | string | `"/conf/overrides.yaml"` | Path to the per tenant override config file. The values of the `per_tenant_overrides` config below will be written to the default path `/conf/overrides.yaml`. Users can set tenant-specific overrides settings in a separate file and point per_tenant_override_config to it if not using the per_tenant_overrides block below. |
| tempo.per_tenant_overrides | object | `{}` | The `per tenant` aka `tenant-specific` runtime overrides. This allows overriding values set in the configuration on a per-tenant basis. Note that *all* values must be given for each per-tenant configuration block. Refer to [Runtime overrides](https://grafana.com/docs/tempo/latest/configuration/#runtime-overrides) and [Tenant-Specific overrides](https://grafana.com/docs/tempo/latest/configuration/#tenant-specific-overrides) documentation for more details. |
| tempo.pullPolicy | string | `"IfNotPresent"` |  |
| tempo.querier | object | `{}` | Configuration options for the querier. Refers to: https://grafana.com/docs/tempo/latest/configuration/#querier |
| tempo.queryFrontend | object | `{}` | Configuration options for the query-fronted. Refers to: https://grafana.com/docs/tempo/latest/configuration/#query-frontend |
| tempo.readinessProbe.failureThreshold | int | `3` |  |
| tempo.readinessProbe.httpGet.path | string | `"/ready"` |  |
| tempo.readinessProbe.httpGet.port | int | `3200` |  |
| tempo.readinessProbe.initialDelaySeconds | int | `20` |  |
| tempo.readinessProbe.periodSeconds | int | `10` |  |
| tempo.readinessProbe.successThreshold | int | `1` |  |
| tempo.readinessProbe.timeoutSeconds | int | `5` |  |
| tempo.receivers.jaeger.protocols.grpc.endpoint | string | `"0.0.0.0:14250"` |  |
| tempo.receivers.jaeger.protocols.thrift_binary.endpoint | string | `"0.0.0.0:6832"` |  |
| tempo.receivers.jaeger.protocols.thrift_compact.endpoint | string | `"0.0.0.0:6831"` |  |
| tempo.receivers.jaeger.protocols.thrift_http.endpoint | string | `"0.0.0.0:14268"` |  |
| tempo.receivers.opencensus | string | `nil` |  |
| tempo.receivers.otlp.protocols.grpc.endpoint | string | `"0.0.0.0:4317"` |  |
| tempo.receivers.otlp.protocols.http.endpoint | string | `"0.0.0.0:4318"` |  |
| tempo.registry | string | `"docker.io"` |  |
| tempo.reportingEnabled | bool | `true` | If true, Tempo will report anonymous usage data about the shape of a deployment to Grafana Labs |
| tempo.repository | string | `"grafana/tempo"` |  |
| tempo.resources | object | `{}` |  |
| tempo.retention | string | `"24h"` |  |
| tempo.securityContext | object | `{}` |  |
| tempo.server.http_listen_port | int | `3200` | HTTP server listen port |
| tempo.storage.trace.backend | string | `"local"` |  |
| tempo.storage.trace.local.path | string | `"/var/tempo/traces"` |  |
| tempo.storage.trace.wal.path | string | `"/var/tempo/wal"` |  |
| tempo.tag | string | `""` |  |
| tempo.updateStrategy | string | `"RollingUpdate"` |  |
| tempoQuery.enabled | bool | `false` | if False the tempo-query container is not deployed |
| tempoQuery.extraArgs | object | `{}` |  |
| tempoQuery.extraEnv | list | `[]` | Environment variables to add |
| tempoQuery.extraVolumeMounts | list | `[]` | Volume mounts to add |
| tempoQuery.ingress.annotations | object | `{}` |  |
| tempoQuery.ingress.enabled | bool | `false` |  |
| tempoQuery.ingress.extraPaths | list | `[]` |  |
| tempoQuery.ingress.hosts[0] | string | `"query.tempo.example.com"` |  |
| tempoQuery.ingress.labels | object | `{}` |  |
| tempoQuery.ingress.path | string | `"/"` |  |
| tempoQuery.ingress.pathType | string | `"Prefix"` |  |
| tempoQuery.ingress.tls | list | `[]` |  |
| tempoQuery.pullPolicy | string | `"IfNotPresent"` |  |
| tempoQuery.repository | string | `"grafana/tempo-query"` |  |
| tempoQuery.resources | object | `{}` |  |
| tempoQuery.securityContext | object | `{}` |  |
| tempoQuery.service.port | int | `16686` |  |
| tempoQuery.tag | string | `nil` |  |
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

### From Chart versions < 1.22.0
* Breaking Change *
Please be aware that we've updated the Tempo version to 2.8, which includes some breaking changes
We recommend reviewing the [release notes](https://grafana.com/docs/tempo/latest/release-notes/v2-8/) before upgrading.

### From Chart versions < 1.21.1
* Breaking Change *
In order to be consistent with other projects and documentations, the default port has been changed from 3100 to 3200.

### From Chart versions < 1.19.0
* Breaking Change *
In order to reduce confusion, the overrides configurations have been renamed as below.

`global_overrides` =>  `overrides` (this is where the defaults for every tenant is set)
`overrides` => `per_tenant_overrides` (this is where configurations for specific tenants can be set)

### From Chart versions < 1.17.0

Please be aware that we've updated the Tempo version to 2.7, which includes some breaking changes
We recommend reviewing the [release notes](https://grafana.com/docs/tempo/latest/release-notes/v2-7/) before upgrading.

### From Chart versions < 1.12.0

Upgrading to chart 1.12.0 will set the memberlist cluster_label config option. During rollout your cluster will temporarilly be split into two memberlist clusters until all components are rolled out.
This will interrupt reads and writes. This config option is set to prevent cross talk between Tempo and other memberlist clusters.

### From Chart versions < 1.2.0

Please be aware that we've updated the minor version to Tempo 2.1, which includes breaking changes.
We recommend reviewing the [release notes](https://github.com/grafana/tempo/releases/tag/v2.1.0/) before upgrading.

### From Chart versions < 1.0.0

Please note that we've incremented the major version when upgrading to Tempo 2.0. There were a large number of
changes in this release (breaking and otherwise). It is encouraged to review the [release notes](https://grafana.com/docs/tempo/latest/release-notes/v2-0/)
and [1.5 -> 2.0 upgrade guide](https://grafana.com/docs/tempo/latest/setup/upgrade/) before upgrading.

### From Chart versions < 0.7.0

Upgrading from pre 0.7.0 will, by default, move your trace storage from `/tmp/tempo/traces` to `/var/tempo/traces`.
This will cause Tempo to lose trace history. If you would like to retain history just copy the contents from the
old folder to the new.
