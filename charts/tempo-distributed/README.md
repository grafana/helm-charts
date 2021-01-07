# tempo-distributed

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.5.0](https://img.shields.io/badge/AppVersion-0.5.0-informational?style=flat-square)

Grafana Tempo in MicroService mode

## Source Code

* <https://github.com/grafana/tempo>

## Chart Repo

Add the following repo to use the chart:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| compactor.enabled | bool | `false` | Specifies whether compactor should be enabled |
| compactor.extraArgs | list | `[]` | Additional CLI args for the compactor |
| compactor.extraEnv | list | `[]` | Environment variables to add to the compactor pods |
| compactor.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the compactor pods |
| compactor.image.registry | string | `nil` | The Docker registry for the compactor image. Overrides `tempo.image.registry` |
| compactor.image.repository | string | `nil` | Docker image repository for the compactor image. Overrides `tempo.image.repository` |
| compactor.image.tag | string | `nil` | Docker image tag for the compactor image. Overrides `tempo.image.tag` |
| compactor.nodeSelector | object | `{}` | Node selector for compactor pods |
| compactor.persistence.enabled | bool | `false` | Enable creating PVCs for the compactor |
| compactor.persistence.size | string | `"10Gi"` | Size of persistent disk |
| compactor.persistence.storageClass | string | `nil` | Storage class to be used. If defined, storageClassName: <storageClass>. If set to "-", storageClassName: "", which disables dynamic provisioning. If empty or set to null, no storageClassName spec is set, choosing the default provisioner (gp2 on AWS, standard on GKE, AWS, and OpenStack). |
| compactor.podAnnotations | object | `{}` | Annotations for compactor pods |
| compactor.priorityClassName | string | `nil` | The name of the PriorityClass for compactor pods |
| compactor.resources | object | `{}` | Resource requests and limits for the compactor |
| compactor.terminationGracePeriodSeconds | int | `30` | Grace period to allow the compactor to shutdown before it is killed |
| compactor.tolerations | list | `[]` | Tolerations for compactor pods |
| config | string | `"auth_enabled: false\ncompactor:\n  compaction:\n    block_retention: 48h\n  ring:\n    kvstore:\n      store: memberlist\ndistributor:\n  receivers:\n    jaeger:\n      protocols:\n        grpc:\n          endpoint: 0.0.0.0:14250\n        thrift_binary:\n          endpoint: 0.0.0.0:6832\n        thrift_compact:\n          endpoint: 0.0.0.0:6831\n        thrift_http:\n          endpoint: 0.0.0.0:14268\nquerier:\n  frontend_worker:\n    frontend_address: {{ include \"tempo.queryFrontendFullname\" . }}:9095\ningester:\n  lifecycler:\n    ring:\n      replication_factor: 1\nmemberlist:\n  abort_if_cluster_join_fails: false\n  join_members:\n    - {{ include \"tempo.fullname\" . }}-gossip-ring\noverrides:\n  per_tenant_override_config: /conf/overrides.yaml\nserver:\n  http_listen_port: 3100\nstorage:\n  trace:\n    backend: local\n    blocklist_poll: 0\n    local:\n      path: /var/tempo/traces\n    pool:\n      max_workers: 10\n      queue_depth: 100\n    wal:\n      bloom_filter_false_positive: 0.01\n      index_downsample: 11\n      path: /var/tempo/wal\n    memcached:\n      consistent_hash: true\n      host: {{ include \"tempo.fullname\" . }}-memcached\n      service: memcached-client\n      timeout: 500ms\n"` |  |
| distributor.affinity | object | Hard node and soft zone anti-affinity | Affinity for distributor pods. Passed through `tpl` and, thus, to be configured as string |
| distributor.extraArgs | list | `[]` | Additional CLI args for the distributor |
| distributor.extraEnv | list | `[]` | Environment variables to add to the distributor pods |
| distributor.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the distributor pods |
| distributor.image.registry | string | `nil` | The Docker registry for the ingester image. Overrides `tempo.image.registry` |
| distributor.image.repository | string | `nil` | Docker image repository for the ingester image. Overrides `tempo.image.repository` |
| distributor.image.tag | string | `nil` | Docker image tag for the ingester image. Overrides `tempo.image.tag` |
| distributor.nodeSelector | object | `{}` |  |
| distributor.podAnnotations | object | `{}` | Annotations for distributor pods |
| distributor.priorityClassName | string | `nil` | The name of the PriorityClass for distributor pods |
| distributor.replicas | int | `1` | Number of replicas for the distributor |
| distributor.resources | object | `{}` | Resource requests and limits for the distributor |
| distributor.service.annotations | object | `{}` | Annotations for distributor service |
| distributor.service.type | string | `"ClusterIP"` |  |
| distributor.terminationGracePeriodSeconds | int | `30` | Grace period to allow the distributor to shutdown before it is killed |
| distributor.tolerations | list | `[]` | Tolerations for distributor pods |
| global.image.registry | string | `nil` | Overrides the Docker registry globally for all images |
| global.priorityClassName | string | `nil` | Overrides the priorityClassName for all pods |
| ingester.affinity | object | Hard node and soft zone anti-affinity | Affinity for ingester pods. Passed through `tpl` and, thus, to be configured as string |
| ingester.extraArgs | list | `[]` | Additional CLI args for the ingester |
| ingester.extraEnv | list | `[]` | Environment variables to add to the ingester pods |
| ingester.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the ingester pods |
| ingester.image.registry | string | `nil` | The Docker registry for the ingester image. Overrides `tempo.image.registry` |
| ingester.image.repository | string | `nil` | Docker image repository for the ingester image. Overrides `tempo.image.repository` |
| ingester.image.tag | string | `nil` | Docker image tag for the ingester image. Overrides `tempo.image.tag` |
| ingester.nodeSelector | object | `{}` |  |
| ingester.persistence.enabled | bool | `false` | Enable creating PVCs which is required when using boltdb-shipper |
| ingester.persistence.size | string | `"10Gi"` | Size of persistent disk |
| ingester.persistence.storageClass | string | `nil` | Storage class to be used. If defined, storageClassName: <storageClass>. If set to "-", storageClassName: "", which disables dynamic provisioning. If empty or set to null, no storageClassName spec is set, choosing the default provisioner (gp2 on AWS, standard on GKE, AWS, and OpenStack). |
| ingester.podAnnotations | object | `{}` | Annotations for ingester pods |
| ingester.priorityClassName | string | `nil` | The name of the PriorityClass for ingester pods |
| ingester.replicas | int | `1` | Number of replicas for the ingester |
| ingester.resources | object | `{}` | Resource requests and limits for the ingester |
| ingester.terminationGracePeriodSeconds | int | `300` | Grace period to allow the ingester to shutdown before it is killed. Especially for the ingestor, this must be increased. It must be long enough so ingesters can be gracefully shutdown flushing/transferring all data and to successfully leave the member ring on shutdown. |
| ingester.tolerations | list | `[]` | Tolerations for ingester pods |
| memcached.enabled | bool | `true` |  |
| memcached.exporter.pullPolicy | string | `"IfNotPresent"` |  |
| memcached.exporter.repository | string | `"prom/memcached-exporter"` |  |
| memcached.exporter.tag | string | `"v0.8.0"` |  |
| memcached.host | string | `"memcached"` |  |
| memcached.pullPolicy | string | `"IfNotPresent"` |  |
| memcached.replicas | int | `1` |  |
| memcached.repository | string | `"memcached"` |  |
| memcached.servicte | string | `"memcached-client"` |  |
| memcached.tag | string | `"1.5.17-alpine"` |  |
| querier.affinity | object | Hard node and soft zone anti-affinity | Affinity for querier pods. Passed through `tpl` and, thus, to be configured as string |
| querier.extraArgs | list | `[]` | Additional CLI args for the querier |
| querier.extraEnv | list | `[]` | Environment variables to add to the querier pods |
| querier.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the querier pods |
| querier.image.registry | string | `nil` | The Docker registry for the querier image. Overrides `tempo.image.registry` |
| querier.image.repository | string | `nil` | Docker image repository for the querier image. Overrides `tempo.image.repository` |
| querier.image.tag | string | `nil` | Docker image tag for the querier image. Overrides `tempo.image.tag` |
| querier.nodeSelector | object | `{}` |  |
| querier.persistence.enabled | bool | `false` | Enable creating PVCs for the querier cache |
| querier.persistence.size | string | `"10Gi"` | Size of persistent disk |
| querier.persistence.storageClass | string | `nil` | Storage class to be used. If defined, storageClassName: <storageClass>. If set to "-", storageClassName: "", which disables dynamic provisioning. If empty or set to null, no storageClassName spec is set, choosing the default provisioner (gp2 on AWS, standard on GKE, AWS, and OpenStack). |
| querier.podAnnotations | object | `{}` | Annotations for querier pods |
| querier.priorityClassName | string | `nil` | The name of the PriorityClass for querier pods |
| querier.replicas | int | `1` | Number of replicas for the querier |
| querier.resources | object | `{}` | Resource requests and limits for the querier |
| querier.terminationGracePeriodSeconds | int | `30` | Grace period to allow the querier to shutdown before it is killed |
| querier.tolerations | list | `[]` | Tolerations for querier pods |
| queryFrontend.affinity | object | Hard node and soft zone anti-affinity | Affinity for query-frontend pods. Passed through `tpl` and, thus, to be configured as string |
| queryFrontend.extraArgs | list | `[]` | Additional CLI args for the query-frontend |
| queryFrontend.extraEnv | list | `[]` | Environment variables to add to the query-frontend pods |
| queryFrontend.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the query-frontend pods |
| queryFrontend.image.registry | string | `nil` | The Docker registry for the query-frontend image. Overrides `tempo.image.registry` |
| queryFrontend.image.repository | string | `nil` | Docker image repository for the query-frontend image. Overrides `tempo.image.repository` |
| queryFrontend.image.tag | string | `nil` | Docker image tag for the query-frontend image. Overrides `tempo.image.tag` |
| queryFrontend.nodeSelector | object | `{}` |  |
| queryFrontend.podAnnotations | object | `{}` | Annotations for query-frontend pods |
| queryFrontend.priorityClassName | string | `nil` | The name of the PriorityClass for query-frontend pods |
| queryFrontend.query.config | string | `"backend: 127.0.0.1:3100\n"` |  |
| queryFrontend.query.image.registry | string | `nil` | The Docker registry for the query-frontend image. Overrides `tempo.image.registry` |
| queryFrontend.query.image.repository | string | `"grafana/tempo-query"` | Docker image repository for the query-frontend image. Overrides `tempo.image.repository` |
| queryFrontend.query.image.tag | string | `nil` | Docker image tag for the query-frontend image. Overrides `tempo.image.tag` |
| queryFrontend.query.resources | object | `{}` | Resource requests and limits for the query |
| queryFrontend.replicas | int | `1` | Number of replicas for the query-frontend |
| queryFrontend.resources | object | `{}` | Resource requests and limits for the query-frontend |
| queryFrontend.terminationGracePeriodSeconds | int | `30` | Grace period to allow the query-frontend to shutdown before it is killed |
| queryFrontend.tolerations | list | `[]` | Tolerations for query-frontend pods |
| serviceAccount.annotations | object | `{}` | Annotations for the service account |
| serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| serviceAccount.imagePullSecrets | list | `[]` | Image pull secrets for the service account |
| serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| tempo | object | `{"image":{"pullPolicy":"IfNotPresent","registry":"docker.io","repository":"grafana/tempo","tag":null}}` | Overrides the chart's computed fullname fullnameOverride: tempo -- Overrides the chart's computed fullname |
| tempo.image.registry | string | `"docker.io"` | The Docker registry |
| tempo.image.repository | string | `"grafana/tempo"` | Docker image repository |
| tempo.image.tag | string | `nil` | Overrides the image tag whose default is the chart's appVersion |

## Components

The chart supports the compontents shown in the following table.
Ingester, distributor, querier, and query-frontend are always installed.
The other components are optional and must be explicitly enabled.

| Component | Optional |
| --- | --- |
| ingester | no |
| distributor | no |
| querier | no |
| query-frontend | no |
| compactor | yes |
| memcached | yes |

## (Configuration)[https://grafana.com/docs/tempo/latest/configuration/]

This chart configures Tempo in microservices mode.

**NOTE:**
In its default configuration, the chart uses `local` filesystem as storage.
The reason for this is that the chart can be validated and installed in a CI pipeline.
However, this setup is not fully functional.
The recommendation is to use object storage, such as S3, GCS, MinIO, etc., or one of the other options documented at https://grafana.com/docs/tempo/latest/configuration/#storage.

Alternatively, in order to quickly test Loki using the filestore, the [single binary chart](https://github.com/grafana/helm-charts/tree/main/charts/tempo) can be used.

----

### Directory and File Locations

* Volumes are mounted to `/var/loki`. The various directories Loki needs should be configured as subdirectories (e. g. `/var/loki/index`, `/var/loki/cache`). Loki will create the directories automatically.
* The config file is mounted to `/etc/loki/config/config.yaml` and passed as CLI arg.

### Example configuration using S3 for storage

```yaml
config: |
  auth_enabled: false
    compactor:
      compaction:
        block_retention: 48h
      ring:
        kvstore:
          store: memberlist
    distributor:
      receivers:
        jaeger:
          protocols:
            grpc:
              endpoint: 0.0.0.0:14250
            thrift_binary:
              endpoint: 0.0.0.0:6832
            thrift_compact:
              endpoint: 0.0.0.0:6831
            thrift_http:
              endpoint: 0.0.0.0:14268
    querier:
      frontend_worker:
        frontend_address: {{ include "tempo.queryFrontendFullname" . }}:9095
    ingester:
      lifecycler:
        ring:
          replication_factor: 1
    memberlist:
      abort_if_cluster_join_fails: false
      join_members:
        - {{ include "tempo.fullname" . }}-memberlist
    overrides:
      per_tenant_override_config: /conf/overrides.yaml
    server:
      http_listen_port: 3100
    storage:
      trace:      
        backend: s3
        s3:
          access_key: tempo
          bucket: tempo
          endpoint: minio:9000
          insecure: true
          secret_key: supersecret
        pool:
          queue_depth: 2000
        wal:
          path: /var/tempo/wal
        memcached:
          consistent_hash: true
          host: a-tempo-distributed-memcached
          service: memcached-client
          timeout: 500ms
```