# Grafana Metrics Enterprise Helm Chart

Helm chart for deploying [Grafana Metrics Enterprise](https://grafana.com/products/metrics-enterprise/) to Kubernetes. Originally forked from the [Cortex Helm Chart](https://github.com/cortexproject/cortex-helm-chart)

## Dependencies

## Grafana Metrics Enterprise license file bootstrapping

In order to use the enterprise features of Grafana Metrics Enterprise, you need to provide a license file to a bootstrap job.
For more information, see the [Getting Started](https://grafana.com/docs/metrics-enterprise/latest/getting-started/#get-a-license) documentation.

This Helm chart expects the license to be embedded in a Kubernetes secret with the name `{{ template "metrics_enterprise.fullname" . }}-license`.

To create the secret from a local `license.jwt` file:

```console
$ kubectl create secret generic <cluster name>-metrics-enterprise-license --from-file=license.jwt --dry-run=client -o yaml | kubectl apply -f -
```

### Key-Value store

Grafana Metrics Enterprise requires an externally provided key-value store, such as [etcd](https://etcd.io/) or [Consul](https://www.consul.io/).

Both services can be installed alongside Grafana Metrics Enterprise, for example using helm charts available [here](https://github.com/bitnami/charts/tree/master/bitnami/etcd) and [here](https://github.com/helm/charts/tree/master/stable/consul).

For convenient first time set up, consul is deployed in the default configuration.

### Storage

Grafana Metrics Enterprise requires an object storage backend to store metrics and indexes.

The default chart values will deploy [Minio](https://min.io) for initial set up. Production deployments should use a separately deployed object store.
See [cortex documentation](https://cortexmetrics.io/docs/) for details on storage types and documentation.

## Installation

To deploy the default configuration with enterprise features:

```console
$ # Add the repository
$ helm repo add metrics-enterprise https://grafana.github.io/metrics-enterprise-helm-chart
$ # Run bootstrapping job
$ helm install <cluster name> metrics-enterprise/metrics-enterprise --set bootstrap=true
$ # Deploy cluster components
$ helm upgrade <cluster name> metrics-enterprise/metrics-enterprise --set bootstrap=false
```

Or if you do not wish to run with enterprise features:

```console
$ # Add the repository
$ helm repo add metrics-enterprise https://grafana.github.io/metrics-enterprise-helm-chart
$ # Deploy the cluster
$ helm install <cluster name> metrics-enterprise/metrics-enterprise
```

As part of this chart many different pods and services are installed which all
have varying resource requirements. Please make sure that you have sufficient
resources (CPU/memory) available in your cluster before installing Grafana Metrics Enterprise Helm
chart.

## Upgrades

To upgrade Grafana Metrics Enterprise use the following command:

```console
$ helm upgrade <cluster name>  metrics-enterprise/metrics-enterprise -f <values.yaml file>
```

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://kubernetes-charts.storage.googleapis.com/ | memcached | 3.2.3 |
| https://kubernetes-charts.storage.googleapis.com/ | memcached | 3.2.3 |
| https://kubernetes-charts.storage.googleapis.com/ | memcached | 3.2.3 |
| https://helm.min.io/ | minio | 8.0.0 |
| https://helm.releases.hashicorp.com | consul | 0.25.0 |

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| admin\_api.affinity | object | `{}` |  |
| admin\_api.annotations | object | `{}` |  |
| admin\_api.extraArgs | list | `{}` |  |
| admin\_api.extraContainers | list | `[]` |  |
| admin\_api.extraVolumes | list | `[]` |  |
| admin\_api.initContainers | list | `[]` |  |
| admin\_api.livenessProbe.httpGet.path | string | `"/ready"` |  |
| admin\_api.livenessProbe.httpGet.port | string | `"http-metrics"` |  |
| admin\_api.livenessProbe.initialDelaySeconds | int | `45` |  |
| admin\_api.nodeSelector | object | `{}` |  |
| admin\_api.persistence.subPath | string | `nil` |  |
| admin\_api.podAnnotations."prometheus.io/port" | string | `"http-metrics"` |  |
| admin\_api.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| admin\_api.podLabels | object | {} |  |
| admin\_api.readinessProbe.httpGet.path | string | `"/ready"` |  |
| admin\_api.readinessProbe.httpGet.port | string | `"http-metrics"` |  |
| admin\_api.readinessProbe.initialDelaySeconds | int | `45` |  |
| admin\_api.replicas | int | `1` |  |
| admin\_api.resources.limits.cpu | string | `"200m"` |  |
| admin\_api.resources.limits.memory | string | `"256Mi"` |  |
| admin\_api.resources.requests.cpu | string | `"10m"` |  |
| admin\_api.resources.requests.memory | string | `"32Mi"` |  |
| admin\_api.securityContext | object | `{}` |  |
| admin\_api.service.annotations | object | `{}` |  |
| admin\_api.service.labels | object | `{}` |  |
| admin\_api.strategy.type | string | `"RollingUpdate"` |  |
| admin\_api.strategy.rollingUpdate.maxSurge | int | `0` |  |
| admin\_api.strategy.rollingUpdate.maxUnavailable | int | `1` |  |
| admin\_api.terminationGracePeriodSeconds | int | `60` |  |
| admin\_api.tolerations | list | `[]` |  |
| alertmanager.affinity | object | `{}` |  |
| alertmanager.annotations | object | `{}` |  |
| alertmanager.env | list | `[]` |  |
| alertmanager.extraArgs | object | `{}` |  |
| alertmanager.extraContainers | list | `[]` |  |
| alertmanager.extraPorts | list | `[]` |  |
| alertmanager.extraVolumeMounts | list | `[]` |  |
| alertmanager.extraVolumes | list | `[]` |  |
| alertmanager.initContainers | list | `[]` |  |
| alertmanager.livenessProbe.httpGet.path | string | `"/ready"` |  |
| alertmanager.livenessProbe.httpGet.port | string | `"http-metrics"` |  |
| alertmanager.livenessProbe.initialDelaySeconds | int | `45` |  |
| alertmanager.nodeSelector | object | `{}` |  |
| alertmanager.persistence.subPath | string | `nil` |  |
| alertmanager.persistentVolume.accessModes[0] | string | `"ReadWriteOnce"` |  |
| alertmanager.persistentVolume.annotations | object | `{}` |  |
| alertmanager.persistentVolume.enabled | bool | `true` |  |
| alertmanager.persistentVolume.size | string | `"2Gi"` |  |
| alertmanager.persistentVolume.subPath | string | `""` |  |
| alertmanager.podAnnotations."prometheus.io/port" | string | `"http-metrics"` |  |
| alertmanager.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| alertmanager.podDisruptionBudget | object | `{}` |  |
| alertmanager.podLabels | object | `{}` |  |
| alertmanager.readinessProbe.httpGet.path | string | `"/ready"` |  |
| alertmanager.readinessProbe.httpGet.port | string | `"http-metrics"` |  |
| alertmanager.readinessProbe.initialDelaySeconds | int | `45` |  |
| alertmanager.replicas | int | `1` |  |
| alertmanager.resources.limits.cpu | string | `"200m"` |  |
| alertmanager.resources.limits.memory | string | `"256Mi"` |  |
| alertmanager.resources.requests.cpu | string | `"10m"` |  |
| alertmanager.resources.requests.memory | string | `"32Mi"` |  |
| alertmanager.securityContext | object | `{}` |  |
| alertmanager.service.annotations | object | `{}` |  |
| alertmanager.service.labels | object | `{}` |  |
| alertmanager.statefulSet.enabled | bool | `false` |  |
| alertmanager.statefulStrategy.type | string | `"RollingUpdate"` |  |
| alertmanager.strategy.rollingUpdate.maxSurge | int | `0` |  |
| alertmanager.strategy.rollingUpdate.maxUnavailable | int | `1` |  |
| alertmanager.strategy.type | string | `"RollingUpdate"` |  |
| alertmanager.terminationGracePeriodSeconds | int | `60` |  |
| alertmanager.tolerations | list | `[]` |  |
| bootstrap | bool | `false` | Perform bootstrapping process instead of deploying cluster |
| bootstrapJob.annotations | object | `{}` |  |
| bootstrapJob.env | list | `[]` |  |
| bootstrapJob.extraArgs | object | {} |  |
| compactor.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].key | string | `"target"` |  |
| compactor.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].operator | string | `"In"` |  |
| compactor.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].values[0] | string | `"compactor"` |  |
| compactor.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.topologyKey | string | `"kubernetes.io/hostname"` |  |
| compactor.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight | int | `100` |  |
| compactor.annotations | object | `{}` |  |
| compactor.enabled | bool | `true` |  |
| compactor.env | list | `[]` |  |
| compactor.extraArgs | object | `{}` |  |
| compactor.extraContainers | list | `[]` |  |
| compactor.extraPorts | list | `[]` |  |
| compactor.extraVolumeMounts | list | `[]` |  |
| compactor.extraVolumes | list | `[]` |  |
| compactor.initContainers | list | `[]` |  |
| compactor.livenessProbe.failureThreshold | int | `20` |  |
| compactor.livenessProbe.httpGet.path | string | `"/ready"` |  |
| compactor.livenessProbe.httpGet.port | string | `"http-metrics"` |  |
| compactor.livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| compactor.livenessProbe.initialDelaySeconds | int | `180` |  |
| compactor.livenessProbe.periodSeconds | int | `30` |  |
| compactor.livenessProbe.successThreshold | int | `1` |  |
| compactor.livenessProbe.timeoutSeconds | int | `1` |  |
| compactor.nodeSelector | object | `{}` |  |
| compactor.persistentVolume.accessModes[0] | string | `"ReadWriteOnce"` |  |
| compactor.persistentVolume.annotations | object | `{}` |  |
| compactor.persistentVolume.enabled | bool | `true` |  |
| compactor.persistentVolume.size | string | `"2Gi"` |  |
| compactor.persistentVolume.subPath | string | `""` |  |
| compactor.podAnnotations."prometheus.io/port" | string | `"http-metrics"` |  |
| compactor.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| compactor.podDisruptionBudget | object | `{}` |  |
| compactor.podLabels | object | `{}` |  |
| compactor.readinessProbe.httpGet.path | string | `"/ready"` |  |
| compactor.readinessProbe.httpGet.port | string | `"http-metrics"` |  |
| compactor.readinessProbe.initialDelaySeconds | int | `60` |  |
| compactor.replicas | int | `1` |  |
| compactor.resources.limits.cpu | int | `1` |  |
| compactor.resources.limits.memory | string | `"1Gi"` |  |
| compactor.resources.requests.cpu | string | `"100m"` |  |
| compactor.resources.requests.memory | string | `"512Mi"` |  |
| compactor.securityContext | object | `{}` |  |
| compactor.service.annotations | object | `{}` |  |
| compactor.service.labels | object | `{}` |  |
| compactor.strategy.type | string | `"RollingUpdate"` |  |
| compactor.terminationGracePeriodSeconds | int | `240` |  |
| compactor.tolerations | list | `[]` |  |
| config.alertmanager.external\_url | string | `"/api/prom/alertmanager"` |  |
| config.auth\_enabled | bool | `false` |  |
| config.chunk\_store.chunk\_cache\_config.memcached.expiration | string | `"1h"` |  |
| config.chunk\_store.chunk\_cache\_config.memcached\_client.timeout | string | `"1s"` |  |
| config.chunk\_store.max\_look\_back\_period | string | `"0s"` |  |
| config.distributor.pool.health\_check\_ingesters | bool | `true` |  |
| config.distributor.shard\_by\_all\_labels | bool | `true` |  |
| config.frontend.compress\_responses | bool | `true` |  |
| config.frontend.log\_queries\_longer\_than | string | `"10s"` |  |
| config.ingester.lifecycler.final\_sleep | string | `"0s"` |  |
| config.ingester.lifecycler.join\_after | string | `"0s"` |  |
| config.ingester.lifecycler.num\_tokens | int | `512` |  |
| config.ingester.lifecycler.ring.kvstore.consul.consistent\_reads | bool | `true` |  |
| config.ingester.lifecycler.ring.kvstore.consul.host | string | `"consul:8500"` |  |
| config.ingester.lifecycler.ring.kvstore.consul.http\_client\_timeout | string | `"20s"` |  |
| config.ingester.lifecycler.ring.kvstore.prefix | string | `"collectors/"` |  |
| config.ingester.lifecycler.ring.kvstore.store | string | `"consul"` |  |
| config.ingester.lifecycler.ring.replication\_factor | int | `1` |  |
| config.ingester.max\_transfer\_retries | int | `0` |  |
| config.ingester\_client.grpc\_client\_config.max\_recv\_msg\_size | int | `104857600` |  |
| config.ingester\_client.grpc\_client\_config.max\_send\_msg\_size | int | `104857600` |  |
| config.ingester\_client.grpc\_client\_config.use\_gzip\_compression | bool | `true` |  |
| config.limits.enforce\_metric\_name | bool | `false` |  |
| config.limits.reject\_old\_samples | bool | `true` |  |
| config.limits.reject\_old\_samples\_max\_age | string | `"168h"` |  |
| config.querier.active\_query\_tracker\_dir | string | `"/data/metrics-enterprise/querier"` |  |
| config.querier.query\_ingesters\_within | string | `"12h"` |  |
| config.query\_range.align\_queries\_with\_step | bool | `true` |  |
| config.query\_range.cache\_results | bool | `true` |  |
| config.query\_range.results\_cache.cache.memcached.expiration | string | `"1h"` |  |
| config.query\_range.results\_cache.cache.memcached\_client.timeout | string | `"1s"` |  |
| config.query\_range.split\_queries\_by\_interval | string | `"24h"` |  |
| config.ruler.enable\_alertmanager\_discovery | bool | `false` |  |
| config.schema.configs[0].from | string | `"2019-07-29"` |  |
| config.schema.configs[0].index.period | string | `"168h"` |  |
| config.schema.configs[0].index.prefix | string | `"index\_"` |  |
| config.schema.configs[0].object\_store | string | `"cassandra"` |  |
| config.schema.configs[0].schema | string | `"v10"` |  |
| config.schema.configs[0].store | string | `"cassandra"` |  |
| config.server.grpc\_listen\_port | int | `9095` |  |
| config.server.grpc\_server\_max\_concurrent\_streams | int | `1000` |  |
| config.server.grpc\_server\_max\_recv\_msg\_size | int | `104857600` |  |
| config.server.grpc\_server\_max\_send\_msg\_size | int | `104857600` |  |
| config.server.http\_listen\_port | int | `8080` |  |
| config.storage.azure.account\_key | string | `nil` |  |
| config.storage.azure.account\_name | string | `nil` |  |
| config.storage.azure.container\_name | string | `nil` |  |
| config.storage.cassandra.addresses | string | `nil` |  |
| config.storage.cassandra.auth | bool | `true` |  |
| config.storage.cassandra.keyspace | string | `"metrics-enterprise"` |  |
| config.storage.cassandra.password | string | `nil` |  |
| config.storage.cassandra.username | string | `nil` |  |
| config.storage.engine | string | `"chunks"` |  |
| config.storage.index\_queries\_cache\_config.memcached.expiration | string | `"1h"` |  |
| config.storage.index\_queries\_cache\_config.memcached\_client.timeout | string | `"1s"` |  |
| config.table\_manager.retention\_deletes\_enabled | bool | `false` |  |
| config.table\_manager.retention\_period | string | `"0s"` |  |
| distributor.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].key | string | `"target"` |  |
| distributor.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].operator | string | `"In"` |  |
| distributor.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].values[0] | string | `"distributor"` |  |
| distributor.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.topologyKey | string | `"kubernetes.io/hostname"` |  |
| distributor.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight | int | `100` |  |
| distributor.annotations | object | `{}` |  |
| distributor.env | list | `[]` |  |
| distributor.extraArgs | object | `{}` |  |
| distributor.extraContainers | list | `[]` |  |
| distributor.extraPorts | list | `[]` |  |
| distributor.extraVolumeMounts | list | `[]` |  |
| distributor.extraVolumes | list | `[]` |  |
| distributor.initContainers | list | `[]` |  |
| distributor.livenessProbe.httpGet.path | string | `"/ready"` |  |
| distributor.livenessProbe.httpGet.port | string | `"http-metrics"` |  |
| distributor.livenessProbe.initialDelaySeconds | int | `45` |  |
| distributor.nodeSelector | object | `{}` |  |
| distributor.persistence.subPath | string | `nil` |  |
| distributor.podAnnotations."prometheus.io/port" | string | `"http-metrics"` |  |
| distributor.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| distributor.podDisruptionBudget | object | `{}` |  |
| distributor.podLabels | object | `{}` |  |
| distributor.readinessProbe.httpGet.path | string | `"/ready"` |  |
| distributor.readinessProbe.httpGet.port | string | `"http-metrics"` |  |
| distributor.readinessProbe.initialDelaySeconds | int | `45` |  |
| distributor.replicas | int | `2` |  |
| distributor.resources.limits.cpu | int | `1` |  |
| distributor.resources.limits.memory | string | `"1Gi"` |  |
| distributor.resources.requests.cpu | string | `"100m"` |  |
| distributor.resources.requests.memory | string | `"512Mi"` |  |
| distributor.securityContext | object | `{}` |  |
| distributor.service.annotations | object | `{}` |  |
| distributor.service.labels | object | `{}` |  |
| distributor.strategy.rollingUpdate.maxSurge | int | `0` |  |
| distributor.strategy.rollingUpdate.maxUnavailable | int | `1` |  |
| distributor.strategy.type | string | `"RollingUpdate"` |  |
| distributor.terminationGracePeriodSeconds | int | `60` |  |
| distributor.tolerations | list | `[]` |  |
| externalConfigSecretName | string | `"secret-with-config.yaml"` |  |
| externalConfigVersion | string | `"0"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"grafana/metrics-enterprise"` |  |
| image.tag | string | `"v1.1.0"` |  |
| ingester.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].key | string | `"target"` |  |
| ingester.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].operator | string | `"In"` |  |
| ingester.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].values[0] | string | `"ingester"` |  |
| ingester.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.topologyKey | string | `"kubernetes.io/hostname"` |  |
| ingester.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight | int | `100` |  |
| ingester.annotations | object | `{}` |  |
| ingester.env | list | `[]` |  |
| ingester.extraArgs | object | `{}` |  |
| ingester.extraContainers | list | `[]` |  |
| ingester.extraPorts | list | `[]` |  |
| ingester.extraVolumeMounts | list | `[]` |  |
| ingester.extraVolumes | list | `[]` |  |
| ingester.initContainers | list | `[]` |  |
| ingester.livenessProbe.failureThreshold | int | `20` |  |
| ingester.livenessProbe.httpGet.path | string | `"/ready"` |  |
| ingester.livenessProbe.httpGet.port | string | `"http-metrics"` |  |
| ingester.livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| ingester.livenessProbe.initialDelaySeconds | int | `180` |  |
| ingester.livenessProbe.periodSeconds | int | `30` |  |
| ingester.livenessProbe.successThreshold | int | `1` |  |
| ingester.livenessProbe.timeoutSeconds | int | `1` |  |
| ingester.nodeSelector | object | `{}` |  |
| ingester.persistence.subPath | string | `nil` |  |
| ingester.persistentVolume.accessModes[0] | string | `"ReadWriteOnce"` |  |
| ingester.persistentVolume.annotations | object | `{}` |  |
| ingester.persistentVolume.enabled | bool | `true` |  |
| ingester.persistentVolume.size | string | `"2Gi"` |  |
| ingester.persistentVolume.subPath | string | `""` |  |
| ingester.podAnnotations."prometheus.io/port" | string | `"http-metrics"` |  |
| ingester.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| ingester.podDisruptionBudget | object | `{}` |  |
| ingester.podLabels | object | `{}` |  |
| ingester.readinessProbe.httpGet.path | string | `"/ready"` |  |
| ingester.readinessProbe.httpGet.port | string | `"http-metrics"` |  |
| ingester.readinessProbe.initialDelaySeconds | int | `60` |  |
| ingester.replicas | int | `3` |  |
| ingester.resources.limits.cpu | int | `1` |  |
| ingester.resources.limits.memory | string | `"1Gi"` |  |
| ingester.resources.requests.cpu | string | `"100m"` |  |
| ingester.resources.requests.memory | string | `"512Mi"` |  |
| ingester.securityContext | object | `{}` |  |
| ingester.service.annotations | object | `{}` |  |
| ingester.service.labels | object | `{}` |  |
| ingester.statefulSet.enabled | bool | `false` |  |
| ingester.statefulStrategy.type | string | `"RollingUpdate"` |  |
| ingester.strategy.rollingUpdate.maxSurge | int | `0` |  |
| ingester.strategy.rollingUpdate.maxUnavailable | int | `1` |  |
| ingester.strategy.type | string | `"RollingUpdate"` |  |
| ingester.terminationGracePeriodSeconds | int | `240` |  |
| ingester.tolerations | list | `[]` |  |
| ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0] | string | `"/"` |  |
| ingress.tls | list | `[]` |  |
| memcached-index-read.enabled | bool | `false` |  |
| memcached-index-read.memcached.extraArgs[0] | string | `"-I 32m"` |  |
| memcached-index-read.memcached.maxItemMemory | int | `3840` |  |
| memcached-index-read.memcached.threads | int | `32` |  |
| memcached-index-read.metrics.enabled | bool | `true` |  |
| memcached-index-read.replicaCount | int | `2` |  |
| memcached-index-read.resources.limits.cpu | int | `1` |  |
| memcached-index-read.resources.limits.memory | string | `"4Gi"` |  |
| memcached-index-read.resources.requests.cpu | string | `"10m"` |  |
| memcached-index-read.resources.requests.memory | string | `"1Gi"` |  |
| memcached-index-write.enabled | bool | `false` |  |
| memcached-index-write.memcached.extraArgs[0] | string | `"-I 32m"` |  |
| memcached-index-write.memcached.maxItemMemory | int | `3840` |  |
| memcached-index-write.memcached.threads | int | `32` |  |
| memcached-index-write.metrics.enabled | bool | `true` |  |
| memcached-index-write.replicaCount | int | `2` |  |
| memcached-index-write.resources.limits.cpu | int | `1` |  |
| memcached-index-write.resources.limits.memory | string | `"4Gi"` |  |
| memcached-index-write.resources.requests.cpu | string | `"10m"` |  |
| memcached-index-write.resources.requests.memory | string | `"1Gi"` |  |
| memcached.enabled | bool | `false` |  |
| memcached.memcached.extraArgs[0] | string | `"-I 32m"` |  |
| memcached.memcached.maxItemMemory | int | `3840` |  |
| memcached.memcached.threads | int | `32` |  |
| memcached.metrics.enabled | bool | `true` |  |
| memcached.pdbMinAvailable | int | `1` |  |
| memcached.replicaCount | int | `2` |  |
| memcached.resources.limits.cpu | int | `1` |  |
| memcached.resources.limits.memory | string | `"4Gi"` |  |
| memcached.resources.requests.cpu | string | `"10m"` |  |
| memcached.resources.requests.memory | string | `"1Gi"` |  |
| nginx.affinity | object | `{}` |  |
| nginx.annotations | object | `{}` |  |
| nginx.config.dnsResolver | string | `"kube-dns.kube-system.svc.cluster.local"` |  |
| nginx.enabled | bool | `true` |  |
| nginx.env | list | `[]` |  |
| nginx.extraArgs | object | `{}` |  |
| nginx.extraContainers | list | `[]` |  |
| nginx.extraPorts | list | `[]` |  |
| nginx.extraVolumeMounts | list | `[]` |  |
| nginx.extraVolumes | list | `[]` |  |
| nginx.http\_listen\_port | int | `80` |  |
| nginx.image.pullPolicy | string | `"IfNotPresent"` |  |
| nginx.image.repository | string | `"nginx"` |  |
| nginx.image.tag | float | `1.17` |  |
| nginx.initContainers | list | `[]` |  |
| nginx.livenessProbe.httpGet.path | string | `"/healthz"` |  |
| nginx.livenessProbe.httpGet.port | string | `"http-metrics"` |  |
| nginx.livenessProbe.initialDelaySeconds | int | `10` |  |
| nginx.nodeSelector | object | `{}` |  |
| nginx.persistence.subPath | string | `nil` |  |
| nginx.podAnnotations."prometheus.io/port" | string | `"http-metrics"` |  |
| nginx.podAnnotations."prometheus.io/scrape" | string | `""` |  |
| nginx.podDisruptionBudget | object | `{}` |  |
| nginx.podLabels | object | `{}` |  |
| nginx.readinessProbe.httpGet.path | string | `"/healthz"` |  |
| nginx.readinessProbe.httpGet.port | string | `"http-metrics"` |  |
| nginx.readinessProbe.initialDelaySeconds | int | `10` |  |
| nginx.replicas | int | `2` |  |
| nginx.resources.limits.cpu | string | `"100m"` |  |
| nginx.resources.limits.memory | string | `"128Mi"` |  |
| nginx.resources.requests.cpu | string | `"10m"` |  |
| nginx.resources.requests.memory | string | `"16Mi"` |  |
| nginx.securityContext | object | `{}` |  |
| nginx.service.annotations | object | `{}` |  |
| nginx.service.labels | object | `{}` |  |
| nginx.strategy.rollingUpdate.maxSurge | int | `0` |  |
| nginx.strategy.rollingUpdate.maxUnavailable | int | `1` |  |
| nginx.strategy.type | string | `"RollingUpdate"` |  |
| nginx.terminationGracePeriodSeconds | int | `10` |  |
| nginx.tolerations | list | `[]` |  |
| querier.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].key | string | `"target"` |  |
| querier.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].operator | string | `"In"` |  |
| querier.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].values[0] | string | `"querier"` |  |
| querier.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.topologyKey | string | `"kubernetes.io/hostname"` |  |
| querier.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight | int | `100` |  |
| querier.annotations | object | `{}` |  |
| querier.env | list | `[]` |  |
| querier.extraArgs | object | `{}` |  |
| querier.extraContainers | list | `[]` |  |
| querier.extraPorts | list | `[]` |  |
| querier.extraVolumeMounts | list | `[]` |  |
| querier.extraVolumes | list | `[]` |  |
| querier.initContainers | list | `[]` |  |
| querier.livenessProbe.httpGet.path | string | `"/ready"` |  |
| querier.livenessProbe.httpGet.port | string | `"http-metrics"` |  |
| querier.livenessProbe.initialDelaySeconds | int | `45` |  |
| querier.nodeSelector | object | `{}` |  |
| querier.persistence.subPath | string | `nil` |  |
| querier.podAnnotations."prometheus.io/port" | string | `"http-metrics"` |  |
| querier.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| querier.podDisruptionBudget | object | `{}` |  |
| querier.podLabels | object | `{}` |  |
| querier.readinessProbe.httpGet.path | string | `"/ready"` |  |
| querier.readinessProbe.httpGet.port | string | `"http-metrics"` |  |
| querier.readinessProbe.initialDelaySeconds | int | `45` |  |
| querier.replicas | int | `2` |  |
| querier.resources.limits.cpu | int | `1` |  |
| querier.resources.limits.memory | string | `"1Gi"` |  |
| querier.resources.requests.cpu | string | `"50m"` |  |
| querier.resources.requests.memory | string | `"128Mi"` |  |
| querier.securityContext | object | `{}` |  |
| querier.service.annotations | object | `{}` |  |
| querier.service.labels | object | `{}` |  |
| querier.strategy.rollingUpdate.maxSurge | int | `0` |  |
| querier.strategy.rollingUpdate.maxUnavailable | int | `1` |  |
| querier.strategy.type | string | `"RollingUpdate"` |  |
| querier.terminationGracePeriodSeconds | int | `180` |  |
| querier.tolerations | list | `[]` |  |
| query\_frontend.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].key | string | `"target"` |  |
| query\_frontend.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].operator | string | `"In"` |  |
| query\_frontend.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].values[0] | string | `"query-frontend"` |  |
| query\_frontend.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.topologyKey | string | `"kubernetes.io/hostname"` |  |
| query\_frontend.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight | int | `100` |  |
| query\_frontend.annotations | object | `{}` |  |
| query\_frontend.env | list | `[]` |  |
| query\_frontend.extraArgs | object | `{}` |  |
| query\_frontend.extraContainers | list | `[]` |  |
| query\_frontend.extraPorts | list | `[]` |  |
| query\_frontend.extraVolumeMounts | list | `[]` |  |
| query\_frontend.extraVolumes | list | `[]` |  |
| query\_frontend.initContainers | list | `[]` |  |
| query\_frontend.livenessProbe.httpGet.path | string | `"/ready"` |  |
| query\_frontend.livenessProbe.httpGet.port | string | `"http-metrics"` |  |
| query\_frontend.livenessProbe.initialDelaySeconds | int | `45` |  |
| query\_frontend.nodeSelector | object | `{}` |  |
| query\_frontend.persistence.subPath | string | `nil` |  |
| query\_frontend.podAnnotations."prometheus.io/port" | string | `"http-metrics"` |  |
| query\_frontend.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| query\_frontend.podDisruptionBudget | object | `{}` |  |
| query\_frontend.podLabels | object | `{}` |  |
| query\_frontend.readinessProbe.httpGet.path | string | `"/ready"` |  |
| query\_frontend.readinessProbe.httpGet.port | string | `"http-metrics"` |  |
| query\_frontend.readinessProbe.initialDelaySeconds | int | `45` |  |
| query\_frontend.replicas | int | `2` |  |
| query\_frontend.resources.limits.cpu | int | `1` |  |
| query\_frontend.resources.limits.memory | string | `"256Mi"` |  |
| query\_frontend.resources.requests.cpu | string | `"10m"` |  |
| query\_frontend.resources.requests.memory | string | `"32Mi"` |  |
| query\_frontend.securityContext | object | `{}` |  |
| query\_frontend.service.annotations | object | `{}` |  |
| query\_frontend.service.labels | object | `{}` |  |
| query\_frontend.strategy.rollingUpdate.maxSurge | int | `0` |  |
| query\_frontend.strategy.rollingUpdate.maxUnavailable | int | `1` |  |
| query\_frontend.strategy.type | string | `"RollingUpdate"` |  |
| query\_frontend.terminationGracePeriodSeconds | int | `180` |  |
| query\_frontend.tolerations | list | `[]` |  |
| rbac.create | bool | `true` |  |
| rbac.pspEnabled | bool | `true` |  |
| ruler.affinity | object | `{}` |  |
| ruler.annotations | object | `{}` |  |
| ruler.env | list | `[]` |  |
| ruler.extraArgs | object | `{}` |  |
| ruler.extraContainers | list | `[]` |  |
| ruler.extraPorts | list | `[]` |  |
| ruler.extraVolumeMounts | list | `[]` |  |
| ruler.extraVolumes | list | `[]` |  |
| ruler.initContainers | list | `[]` |  |
| ruler.livenessProbe.httpGet.path | string | `"/ready"` |  |
| ruler.livenessProbe.httpGet.port | string | `"http-metrics"` |  |
| ruler.livenessProbe.initialDelaySeconds | int | `45` |  |
| ruler.nodeSelector | object | `{}` |  |
| ruler.persistence.subPath | string | `nil` |  |
| ruler.podAnnotations."prometheus.io/port" | string | `"http-metrics"` |  |
| ruler.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| ruler.podDisruptionBudget | object | `{}` |  |
| ruler.podLabels | object | `{}` |  |
| ruler.readinessProbe.httpGet.path | string | `"/ready"` |  |
| ruler.readinessProbe.httpGet.port | string | `"http-metrics"` |  |
| ruler.readinessProbe.initialDelaySeconds | int | `45` |  |
| ruler.replicas | int | `1` |  |
| ruler.resources.limits.cpu | string | `"200m"` |  |
| ruler.resources.limits.memory | string | `"256Mi"` |  |
| ruler.resources.requests.cpu | string | `"10m"` |  |
| ruler.resources.requests.memory | string | `"32Mi"` |  |
| ruler.securityContext | object | `{}` |  |
| ruler.service.annotations | object | `{}` |  |
| ruler.service.labels | object | `{}` |  |
| ruler.strategy.rollingUpdate.maxSurge | int | `0` |  |
| ruler.strategy.rollingUpdate.maxUnavailable | int | `1` |  |
| ruler.strategy.type | string | `"RollingUpdate"` |  |
| ruler.terminationGracePeriodSeconds | int | `180` |  |
| ruler.tolerations | list | `[]` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `nil` |  |
| store\_gateway.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].key | string | `"target"` |  |
| store\_gateway.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].operator | string | `"In"` |  |
| store\_gateway.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].values[0] | string | `"store-gateway"` |  |
| store\_gateway.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.topologyKey | string | `"kubernetes.io/hostname"` |  |
| store\_gateway.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight | int | `100` |  |
| store\_gateway.annotations | object | `{}` |  |
| store\_gateway.env | list | `[]` |  |
| store\_gateway.extraArgs | object | `{}` |  |
| store\_gateway.extraContainers | list | `[]` |  |
| store\_gateway.extraPorts | list | `[]` |  |
| store\_gateway.extraVolumeMounts | list | `[]` |  |
| store\_gateway.extraVolumes | list | `[]` |  |
| store\_gateway.initContainers | list | `[]` |  |
| store\_gateway.livenessProbe.failureThreshold | int | `20` |  |
| store\_gateway.livenessProbe.httpGet.path | string | `"/ready"` |  |
| store\_gateway.livenessProbe.httpGet.port | string | `"http-metrics"` |  |
| store\_gateway.livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| store\_gateway.livenessProbe.initialDelaySeconds | int | `180` |  |
| store\_gateway.livenessProbe.periodSeconds | int | `30` |  |
| store\_gateway.livenessProbe.successThreshold | int | `1` |  |
| store\_gateway.livenessProbe.timeoutSeconds | int | `1` |  |
| store\_gateway.nodeSelector | object | `{}` |  |
| store\_gateway.persistentVolume.accessModes[0] | string | `"ReadWriteOnce"` |  |
| store\_gateway.persistentVolume.annotations | object | `{}` |  |
| store\_gateway.persistentVolume.enabled | bool | `true` |  |
| store\_gateway.persistentVolume.size | string | `"2Gi"` |  |
| store\_gateway.persistentVolume.subPath | string | `""` |  |
| store\_gateway.podAnnotations."prometheus.io/port" | string | `"http-metrics"` |  |
| store\_gateway.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| store\_gateway.podDisruptionBudget | object | `{}` |  |
| store\_gateway.podLabels | object | `{}` |  |
| store\_gateway.readinessProbe.httpGet.path | string | `"/ready"` |  |
| store\_gateway.readinessProbe.httpGet.port | string | `"http-metrics"` |  |
| store\_gateway.readinessProbe.initialDelaySeconds | int | `60` |  |
| store\_gateway.replicas | int | `1` |  |
| store\_gateway.resources.limits.cpu | int | `1` |  |
| store\_gateway.resources.limits.memory | string | `"1Gi"` |  |
| store\_gateway.resources.requests.cpu | string | `"100m"` |  |
| store\_gateway.resources.requests.memory | string | `"512Mi"` |  |
| store\_gateway.securityContext | object | `{}` |  |
| store\_gateway.service.annotations | object | `{}` |  |
| store\_gateway.service.labels | object | `{}` |  |
| store\_gateway.strategy.type | string | `"RollingUpdate"` |  |
| store\_gateway.terminationGracePeriodSeconds | int | `240` |  |
| store\_gateway.tolerations | list | `[]` |  |
| table\_manager.affinity | object | `{}` |  |
| table\_manager.annotations | object | `{}` |  |
| table\_manager.env | list | `[]` |  |
| table\_manager.extraArgs | object | `{}` |  |
| table\_manager.extraContainers | list | `[]` |  |
| table\_manager.extraPorts | list | `[]` |  |
| table\_manager.extraVolumeMounts | list | `[]` |  |
| table\_manager.extraVolumes | list | `[]` |  |
| table\_manager.initContainers | list | `[]` |  |
| table\_manager.livenessProbe.httpGet.path | string | `"/ready"` |  |
| table\_manager.livenessProbe.httpGet.port | string | `"http-metrics"` |  |
| table\_manager.livenessProbe.initialDelaySeconds | int | `45` |  |
| table\_manager.nodeSelector | object | `{}` |  |
| table\_manager.persistence.subPath | string | `nil` |  |
| table\_manager.podAnnotations."prometheus.io/port" | string | `"http-metrics"` |  |
| table\_manager.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| table\_manager.podDisruptionBudget | object | `{}` |  |
| table\_manager.podLabels | object | `{}` |  |
| table\_manager.readinessProbe.httpGet.path | string | `"/ready"` |  |
| table\_manager.readinessProbe.httpGet.port | string | `"http-metrics"` |  |
| table\_manager.readinessProbe.initialDelaySeconds | int | `45` |  |
| table\_manager.replicas | int | `1` |  |
| table\_manager.resources.limits.cpu | int | `1` |  |
| table\_manager.resources.limits.memory | string | `"1Gi"` |  |
| table\_manager.resources.requests.cpu | string | `"10m"` |  |
| table\_manager.resources.requests.memory | string | `"32Mi"` |  |
| table\_manager.securityContext | object | `{}` |  |
| table\_manager.service.annotations | object | `{}` |  |
| table\_manager.service.labels | object | `{}` |  |
| table\_manager.strategy.rollingUpdate.maxSurge | int | `0` |  |
| table\_manager.strategy.rollingUpdate.maxUnavailable | int | `1` |  |
| table\_manager.strategy.type | string | `"RollingUpdate"` |  |
| table\_manager.terminationGracePeriodSeconds | int | `180` |  |
| table\_manager.tolerations | list | `[]` |  |
| useExternalConfig | bool | `false` |  |

# Development

For local development on single node clusters, the `local.yaml` values file can be used to deploy single replicas of the memcached and consul clusters.

To configure a local default storage class for k3d:

```console
$ kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
$ kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

# Performing a release

1. Update the `version` and `appVersion` fields in the `chart.yaml` file.
2. Add the release archive to the docs directory

```console
$ make release
$ git add -f docs
```

3. Create a release commit
4. Create a release tag
