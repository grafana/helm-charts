# loki

![Version: 0.3.3](https://img.shields.io/badge/Version-0.3.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.6.1](https://img.shields.io/badge/AppVersion-1.6.1-informational?style=flat-square)

Helm chart for Grafana Loki

**Homepage:** <https://github.com/unguiculus/loki-helm-chart>

## Source Code

* <https://github.com/grafana/loki>
* <https://grafana.com/oss/loki/>
* <https://grafana.com/docs/loki/latest/>

## Chart Repo

Add the following repo to use the chart:

```console
helm repo add loki https://unguiculus.github.io/loki-helm-chart
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| canary.enabled | bool | `false` | Specifies whether the canary should be enabled |
| canary.extraArgs | list | `["-labelname=pod","-labelvalue=$(POD_NAME)"]` | Additional CLI args for the canary |
| canary.extraEnv | list | `[]` | Environment variables to add to the canary pods |
| canary.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the canary pods |
| canary.image.pullPolicy | string | `"IfNotPresent"` | canary image pull policy |
| canary.image.repository | string | `"grafana/loki-canary"` | canary image repository |
| canary.image.tag | string | `"1.6.1"` | canary image tag |
| canary.kind | string | `"Deployment"` | canary can be run as a Deployment or DaemonSet |
| canary.nodeSelector | object | `{}` | Node selector for canary pods |
| canary.podAnnotations | object | `{}` | Annotations for canary pods |
| canary.resources | object | `{}` | Resource requests and limits for the canary |
| canary.terminationGracePeriodSeconds | int | `30` | Grace period to allow the canary to shutdown before it is killed |
| canary.tolerations | list | `[]` | Tolerations for canary pods |
| distributor.affinity | string | Hard node and soft zone anti-affinity | Affinity for distributor pods. Passed through `tpl` and, thus, to be configured as string |
| distributor.extraArgs | list | `[]` | Additional CLI args for the distributor |
| distributor.extraEnv | list | `[]` | Environment variables to add to the distributor pods |
| distributor.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the distributor pods |
| distributor.nodeSelector | object | `{}` | Node selector for distributor pods |
| distributor.podAnnotations | object | `{}` | Annotations for distributor pods |
| distributor.replicas | int | `1` | Number of replicas for the distributor |
| distributor.resources | object | `{}` | Resource requests and limits for the distributor |
| distributor.terminationGracePeriodSeconds | int | `30` | Grace period to allow the distributor to shutdown before it is killed |
| distributor.tolerations | list | `[]` | Tolerations for distributor pods |
| fullnameOverride | string | `""` | Overrides the chart's computed fullname |
| gateway.affinity | string | Hard node and soft zone anti-affinity | Affinity for gateway pods. Passed through `tpl` and, thus, to be configured as string |
| gateway.extraArgs | list | `[]` | Additional CLI args for the gateway |
| gateway.extraEnv | list | `[]` | Environment variables to add to the gateway pods |
| gateway.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the gateway pods |
| gateway.image.pullPolicy | string | `"IfNotPresent"` | The gateway image pull policy |
| gateway.image.repository | string | `"nginxinc/nginx-unprivileged"` | The gateway image repository |
| gateway.image.tag | string | `"1.19-alpine"` | The gateway image tag |
| gateway.ingress.annotations | object | `{}` | Annotations for the gateway ingress |
| gateway.ingress.enabled | bool | `false` | Specifies whether an ingress for the gateway should be created |
| gateway.ingress.hosts | list | `[{"host":"gateway.loki.example.com","paths":["/"]}]` | Hosts configuration for the gateway ingress |
| gateway.ingress.tls | list | `[{"hosts":["gateway.loki.example.com"],"secretName":"loki-gateway-tls"}]` | TLS configuration for the gateway ingress |
| gateway.nginxConfig | string | See values.yaml | Config file contents for Nginx. Passed through the `tpl` function to allow templating |
| gateway.nodeSelector | object | `{}` | Node selector for gateway pods |
| gateway.podAnnotations | object | `{}` | Annotations for gateway pods |
| gateway.replicas | int | `1` | Number of replicas for the gateway |
| gateway.resources | object | `{}` | Resource requests and limits for the gateway |
| gateway.service.clusterIP | string | `nil` | ClusterIP of the gateway service |
| gateway.service.loadBalancerIP | string | `nil` | Load balancer IPO address if service type is LoadBalancer |
| gateway.service.nodePort | string | `nil` | Node port if service type is NodePort |
| gateway.service.port | int | `80` | Port of the gateway service |
| gateway.service.type | string | `"ClusterIP"` | Type of the gateway service |
| gateway.terminationGracePeriodSeconds | int | `30` | Grace period to allow the gateway to shutdown before it is killed |
| gateway.tolerations | list | `[]` | Tolerations for gateway pods |
| imagePullSecrets | list | `[]` | Image pull secrets for Docker images |
| ingester.affinity | string | Hard node and soft zone anti-affinity | Affinity for ingester pods. Passed through `tpl` and, thus, to be configured as string |
| ingester.extraArgs | list | `[]` | Additional CLI args for the ingester |
| ingester.extraEnv | list | `[]` | Environment variables to add to the ingester pods |
| ingester.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the ingester pods |
| ingester.nodeSelector | object | `{}` | Node selector for ingester pods |
| ingester.persistence.enabled | bool | `false` | Enable creating PVCs which is required when using boltdb-shipper |
| ingester.persistence.size | string | `"100Gi"` | Size of persistent disk |
| ingester.persistence.storageClass | string | `""` |  |
| ingester.podAnnotations | object | `{}` | Annotations for ingester pods |
| ingester.replicas | int | `2` | Number of replicas for the ingester |
| ingester.resources | object | `{}` | Resource requests and limits for the ingester |
| ingester.terminationGracePeriodSeconds | int | `300` | Grace period to allow the ingester to shutdown before it is killed. Especially for the ingestor, this must be increased. It must be long enough so ingesters can be gracefully shutdown flushing/transferring all data and to successfully leave the member ring on shutdown. |
| ingester.tolerations | list | `[]` | Tolerations for ingester pods |
| loki.config | string | See values.yaml | Config file contents for Loki |
| loki.image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| loki.image.repository | string | `"grafana/loki"` | Docker image repository |
| loki.image.tag | string | `""` | Overrides the image tag whose default is the chart's appVersion |
| loki.podAnnotations | object | `{}` | Common annotations for all pods |
| loki.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain to allow rollback |
| nameOverride | string | `""` | Overrides the chart's name |
| querier.affinity | string | Hard node and soft zone anti-affinity | Affinity for querier pods. Passed through `tpl` and, thus, to be configured as string |
| querier.extraArgs | list | `[]` | Additional CLI args for the querier |
| querier.extraEnv | list | `[]` | Environment variables to add to the querier pods |
| querier.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the querier pods |
| querier.nodeSelector | object | `{}` | Node selector for querier pods |
| querier.persistence.enabled | bool | `false` | Enable creating PVCs for the querier cache |
| querier.persistence.size | string | `"1Gi"` | Size of persistent disk |
| querier.persistence.storageClass | string | `""` | Storage class to be used. If defined, storageClassName: <storageClass>. If set to "-", storageClassName: "", which disables dynamic provisioning. If empty (the default) or set to null, no storageClassName spec is set, choosing the default provisioner (gp2 on AWS, standard on GKE, AWS, and OpenStack). |
| querier.podAnnotations | object | `{}` | Annotations for querier pods |
| querier.replicas | int | `1` | Number of replicas for the querier |
| querier.resources | object | `{}` | Resource requests and limits for the querier |
| querier.terminationGracePeriodSeconds | int | `30` | Grace period to allow the querier to shutdown before it is killed |
| querier.tolerations | list | `[]` | Tolerations for querier pods |
| queryFrontend.affinity | string | Hard node and soft zone anti-affinity | Affinity for query-frontend pods. Passed through `tpl` and, thus, to be configured as string |
| queryFrontend.extraArgs | list | `[]` | Additional CLI args for the query-frontend |
| queryFrontend.extraEnv | list | `[]` | Environment variables to add to the query-frontend pods |
| queryFrontend.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the query-frontend pods |
| queryFrontend.nodeSelector | object | `{}` | Node selector for query-frontend pods |
| queryFrontend.podAnnotations | object | `{}` | Annotations for query-frontend pods |
| queryFrontend.replicas | int | `1` | Number of replicas for the query-frontend |
| queryFrontend.resources | object | `{}` | Resource requests and limits for the query-frontend |
| queryFrontend.terminationGracePeriodSeconds | int | `30` | Grace period to allow the query-frontend to shutdown before it is killed |
| queryFrontend.tolerations | list | `[]` | Tolerations for query-frontend pods |
| serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| serviceAccount.imagePullSecrets | list | `[]` | Image pull secrets for the service account |
| serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor.annotations | object | `{}` | ServiceMonitor annotations |
| serviceMonitor.enabled | bool | `false` | If enabled, ServiceMonitor resources for Prometheus Operator are created |
| serviceMonitor.interval | string | `nil` | ServiceMonitor scrape interval |
| serviceMonitor.labels | object | `{}` | Additional ServiceMonitor labels |
| serviceMonitor.namespace | string | `nil` | Alternative namespace for ServiceMonitor resources |
| serviceMonitor.scrapeTimeout | string | `nil` | ServiceMonitor scrape timeout in Go duration format (e.g. 15s) |
| tableManager.affinity | string | Hard node and soft zone anti-affinity | Affinity for table-manager pods. Passed through `tpl` and, thus, to be configured as string |
| tableManager.enabled | bool | `false` | Specifies whether the table-manager should be enabled |
| tableManager.extraArgs | list | `[]` | Additional CLI args for the table-manager |
| tableManager.extraEnv | list | `[]` | Environment variables to add to the table-manager pods |
| tableManager.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the table-manager pods |
| tableManager.nodeSelector | object | `{}` | Node selector for table-manager pods |
| tableManager.podAnnotations | object | `{}` | Annotations for table-manager pods |
| tableManager.replicas | int | `1` | Number of replicas for the table-manager |
| tableManager.resources | object | `{}` | Resource requests and limits for the table-manager |
| tableManager.terminationGracePeriodSeconds | int | `30` | Grace period to allow the table-manager to shutdown before it is killed |
| tableManager.tolerations | list | `[]` | Tolerations for table-manager pods |

## Configuration

This chart configures Loki in microservices mode.
The chart can be installed with defaults out of the box.
As such, it runs two replicas of ingester and one replica for each of the other components using BoltDB as storage.
Ingester is run as a StatefulSet so each Pod gets its own persistent volume.

The chart does not support setting up Consul or Etcd for discovery.
These would have to be set up separately.
Instead, memberlist can be used which does not require a separate key/value store.
The chart creates a headless service for the gossip ring which ingester, distributor, and querier are part of.

As of now, setting up a cache server (Redis, Memcached) is not included either.
This may be added at a later stage.

### Example configuration using memberlist, boltdb-shipper, and S3 for storage

Note that `loki.config` must be configured as string.
That's required because it is passed through the `tpl` function in order to support templating.
This means that a complete configuration needs to be supplied to the charts which is a good thing anyways.
Also, this allows using a separate YAML file which can be passed using `--set-file loki.config=<path to config file>`.

```yaml
loki:
  config: |
    server:
      log_level: info
      # Must be set to 3100
      http_listen_port: 3100

    distributor:
      ring:
        kvstore:
          store: memberlist

    ingester:
      # disable chunk transfer which is not possible with statefulsets
      # and unnecessary for boltdb-shipper
      max_transfer_retries: 0
      lifecycler:
        join_after: 0s
        ring:
          kvstore:
            store: memberlist

    memberlist:
      join_members:
        - {{ include "loki.fullname" . }}-gossip-ring

    limits_config:
      ingestion_rate_mb: 10
      ingestion_burst_size_mb: 20
      max_concurrent_tail_requests: 20

    schema_config:
      configs:
        - from: 2020-09-07
          store: boltdb-shipper
          object_store: aws
          schema: v11
          index:
            prefix: loki_index_
            period: 24h

    storage_config:
      aws:
        s3: s3://eu-central-1
        bucketnames: my-loki-s3-bucket
      boltdb_shipper:
        active_index_directory: /var/loki/index
        shared_store: s3
        cache_location: /var/loki/cache

    query_range:
      # make queries more cache-able by aligning them with their step intervals
      align_queries_with_step: true
      max_retries: 5
      # parallelize queries in 15min intervals
      split_queries_by_interval: 15m
      cache_results: true

      results_cache:
        max_freshness: 10m
        cache:
          enable_fifocache: true
          fifocache:
            max_size_items: 1024
            validity: 24h

    frontend_worker:
      frontend_address: {{ include "loki.queryFrontendFullname" . }}:9095

    frontend:
      log_queries_longer_than: 5s
      compress_responses: true
```
