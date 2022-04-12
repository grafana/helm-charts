# loki-simple-scalable

![Version: 0.4.0](https://img.shields.io/badge/Version-0.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.5.0](https://img.shields.io/badge/AppVersion-2.5.0-informational?style=flat-square)

Helm chart for Grafana Loki in simple, scalable mode

## Source Code

* <https://github.com/grafana/loki>
* <https://grafana.com/oss/loki/>
* <https://grafana.com/docs/loki/latest/>

## Chart Repo

Add the following repo to use the chart:

```sh
helm repo add grafana https://grafana.github.io/helm-charts
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `nil` | Overrides the chart's computed fullname |
| gateway.affinity | string | Hard node and soft zone anti-affinity | Affinity for gateway pods. Passed through `tpl` and, thus, to be configured as string |
| gateway.autoscaling.enabled | bool | `false` | Enable autoscaling for the gateway |
| gateway.autoscaling.maxReplicas | int | `3` | Maximum autoscaling replicas for the gateway |
| gateway.autoscaling.minReplicas | int | `1` | Minimum autoscaling replicas for the gateway |
| gateway.autoscaling.targetCPUUtilizationPercentage | int | `60` | Target CPU utilisation percentage for the gateway |
| gateway.autoscaling.targetMemoryUtilizationPercentage | string | `nil` | Target memory utilisation percentage for the gateway |
| gateway.basicAuth.enabled | bool | `false` | Enables basic authentication for the gateway |
| gateway.basicAuth.existingSecret | string | `nil` | Existing basic auth secret to use. Must contain '.htpasswd' |
| gateway.basicAuth.htpasswd | string | `"{{ htpasswd (required \"'gateway.basicAuth.username' is required\" .Values.gateway.basicAuth.username) (required \"'gateway.basicAuth.password' is required\" .Values.gateway.basicAuth.password) }}"` | Uses the specified username and password to compute a htpasswd using Sprig's `htpasswd` function. The value is templated using `tpl`. Override this to use a custom htpasswd, e.g. in case the default causes high CPU load. |
| gateway.basicAuth.password | string | `nil` | The basic auth password for the gateway |
| gateway.basicAuth.username | string | `nil` | The basic auth username for the gateway |
| gateway.containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | The SecurityContext for gateway containers |
| gateway.deploymentStrategy | object | `{"type":"RollingUpdate"}` | See `kubectl explain deployment.spec.strategy` for more -- ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy |
| gateway.enabled | bool | `true` | Specifies whether the gateway should be enabled |
| gateway.extraArgs | list | `[]` | Additional CLI args for the gateway |
| gateway.extraEnv | list | `[]` | Environment variables to add to the gateway pods |
| gateway.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the gateway pods |
| gateway.extraVolumeMounts | list | `[]` | Volume mounts to add to the gateway pods |
| gateway.extraVolumes | list | `[]` | Volumes to add to the gateway pods |
| gateway.image.pullPolicy | string | `"IfNotPresent"` | The gateway image pull policy |
| gateway.image.registry | string | `"docker.io"` | The Docker registry for the gateway image |
| gateway.image.repository | string | `"nginxinc/nginx-unprivileged"` | The gateway image repository |
| gateway.image.tag | string | `"1.19-alpine"` | The gateway image tag |
| gateway.ingress.annotations | object | `{}` | Ingress Class Name. MAY be required for Kubernetes versions >= 1.18 ingressClassName: nginx -- Annotations for the gateway ingress |
| gateway.ingress.enabled | bool | `false` | Specifies whether an ingress for the gateway should be created |
| gateway.ingress.hosts | list | `[{"host":"gateway.loki.example.com","paths":[{"path":"/"}]}]` | Hosts configuration for the gateway ingress |
| gateway.ingress.tls | list | `[{"hosts":["gateway.loki.example.com"],"secretName":"loki-gateway-tls"}]` | TLS configuration for the gateway ingress |
| gateway.nginxConfig.file | string | See values.yaml | Config file contents for Nginx. Passed through the `tpl` function to allow templating |
| gateway.nginxConfig.httpSnippet | string | `""` | Allows appending custom configuration to the http block |
| gateway.nginxConfig.logFormat | string | `"main '$remote_addr - $remote_user [$time_local]  $status '\n        '\"$request\" $body_bytes_sent \"$http_referer\" '\n        '\"$http_user_agent\" \"$http_x_forwarded_for\"';"` | NGINX log format |
| gateway.nginxConfig.serverSnippet | string | `""` | Allows appending custom configuration to the server block |
| gateway.nodeSelector | object | `{}` | Node selector for gateway pods |
| gateway.podAnnotations | object | `{}` | Annotations for gateway pods |
| gateway.podSecurityContext | object | `{"fsGroup":101,"runAsGroup":101,"runAsNonRoot":true,"runAsUser":101}` | The SecurityContext for gateway containers |
| gateway.priorityClassName | string | `nil` | The name of the PriorityClass for gateway pods |
| gateway.readinessProbe.httpGet.path | string | `"/"` |  |
| gateway.readinessProbe.httpGet.port | string | `"http"` |  |
| gateway.readinessProbe.initialDelaySeconds | int | `15` |  |
| gateway.readinessProbe.timeoutSeconds | int | `1` |  |
| gateway.replicas | int | `1` | Number of replicas for the gateway |
| gateway.resources | object | `{}` | Resource requests and limits for the gateway |
| gateway.service.annotations | object | `{}` | Annotations for the gateway service |
| gateway.service.clusterIP | string | `nil` | ClusterIP of the gateway service |
| gateway.service.labels | object | `{}` | Labels for gateway service |
| gateway.service.loadBalancerIP | string | `nil` | Load balancer IPO address if service type is LoadBalancer |
| gateway.service.nodePort | string | `nil` | Node port if service type is NodePort |
| gateway.service.port | int | `80` | Port of the gateway service |
| gateway.service.type | string | `"ClusterIP"` | Type of the gateway service |
| gateway.terminationGracePeriodSeconds | int | `30` | Grace period to allow the gateway to shutdown before it is killed |
| gateway.tolerations | list | `[]` | Tolerations for gateway pods |
| gateway.verboseLogging | bool | `true` | Enable logging of 2xx and 3xx HTTP requests |
| global.clusterDomain | string | `"cluster.local"` | configures cluster domain ("cluster.local" by default) |
| global.dnsNamespace | string | `"kube-system"` | configures DNS service namespace |
| global.dnsService | string | `"kube-dns"` | configures DNS service name |
| global.image.registry | string | `nil` | Overrides the Docker registry globally for all images |
| global.priorityClassName | string | `nil` | Overrides the priorityClassName for all pods |
| imagePullSecrets | list | `[]` | Image pull secrets for Docker images |
| loki.commonConfig | object | `{"path_prefix":"/var/loki","replication_factor":1,"storage":{"filesystem":{"chunks_directory":"/var/loki/chunks","rules_directory":"/var/loki/rules"}}}` | Check https://grafana.com/docs/loki/latest/configuration/#common_config for more info on how to provide a common configuration |
| loki.config | string | See values.yaml | Config file contents for Loki |
| loki.containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | The SecurityContext for Loki containers |
| loki.existingSecretForConfig | string | `""` | Specify an existing secret containing loki configuration. If non-empty, overrides `loki.config` |
| loki.image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| loki.image.registry | string | `"docker.io"` | The Docker registry |
| loki.image.repository | string | `"grafana/loki"` | Docker image repository |
| loki.image.tag | string | `nil` | Overrides the image tag whose default is the chart's appVersion |
| loki.podAnnotations | object | `{}` | Common annotations for all pods |
| loki.podSecurityContext | object | `{"fsGroup":10001,"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001}` | The SecurityContext for Loki pods |
| loki.readinessProbe.httpGet.path | string | `"/ready"` |  |
| loki.readinessProbe.httpGet.port | string | `"http"` |  |
| loki.readinessProbe.initialDelaySeconds | int | `30` |  |
| loki.readinessProbe.timeoutSeconds | int | `1` |  |
| loki.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain to allow rollback |
| loki.schemaConfig | object | `{"configs":[{"from":"2020-09-07","index":{"period":"24h","prefix":"loki_index_"},"object_store":"filesystem","schema":"v11","store":"boltdb-shipper"}]}` | Check https://grafana.com/docs/loki/latest/configuration/#schema_config for more info on how to configure schemas |
| loki.storageConfig | object | `{}` | Check https://grafana.com/docs/loki/latest/configuration/#storage_config for more info on how to configure storages |
| loki.structuredConfig | object | `{}` | Structured loki configuration, takes precedence over `loki.config`, `loki.schemaConfig`, `loki.storageConfig` |
| nameOverride | string | `nil` | Overrides the chart's name |
| networkPolicy.alertmanager.namespaceSelector | object | `{}` | Specifies the namespace the alertmanager is running in |
| networkPolicy.alertmanager.podSelector | object | `{}` | Specifies the alertmanager Pods. As this is cross-namespace communication, you also need the namespaceSelector. |
| networkPolicy.alertmanager.port | int | `9093` | Specify the alertmanager port used for alerting |
| networkPolicy.discovery.namespaceSelector | object | `{}` | Specifies the namespace the discovery Pods are running in |
| networkPolicy.discovery.podSelector | object | `{}` | Specifies the Pods labels used for discovery. As this is cross-namespace communication, you also need the namespaceSelector. |
| networkPolicy.discovery.port | string | `nil` | Specify the port used for discovery |
| networkPolicy.enabled | bool | `false` | Specifies whether Network Policies should be created |
| networkPolicy.externalStorage.cidrs | list | `[]` | Specifies specific network CIDRs you want to limit access to |
| networkPolicy.externalStorage.ports | list | `[]` | Specify the port used for external storage, e.g. AWS S3 |
| networkPolicy.ingress.namespaceSelector | object | `{}` | Specifies the namespaces which are allowed to access the http port |
| networkPolicy.ingress.podSelector | object | `{}` | Specifies the Pods which are allowed to access the http port. As this is cross-namespace communication, you also need the namespaceSelector. |
| networkPolicy.metrics.cidrs | list | `[]` | Specifies specific network CIDRs which are allowed to access the metrics port. In case you use namespaceSelector, you also have to specify your kubelet networks here. The metrics ports are also used for probes. |
| networkPolicy.metrics.namespaceSelector | object | `{}` | Specifies the namespaces which are allowed to access the metrics port |
| networkPolicy.metrics.podSelector | object | `{}` | Specifies the Pods which are allowed to access the metrics port. As this is cross-namespace communication, you also need the namespaceSelector. |
| prometheusRule.annotations | object | `{}` | PrometheusRule annotations |
| prometheusRule.enabled | bool | `false` | If enabled, a PrometheusRule resource for Prometheus Operator is created |
| prometheusRule.groups | list | `[]` | Contents of Prometheus rules file |
| prometheusRule.labels | object | `{}` | Additional PrometheusRule labels |
| prometheusRule.namespace | string | `nil` | Alternative namespace for the PrometheusRule resource |
| rbac.pspEnabled | bool | `false` | If pspEnabled true, a PodSecurityPolicy is created for K8s that use psp. |
| rbac.sccEnabled | bool | `false` | For OpenShift set pspEnabled to 'false' and sccEnabled to 'true' to use the SecurityContextConstraints. |
| read.affinity | string | Hard node and soft zone anti-affinity | Affinity for read pods. Passed through `tpl` and, thus, to be configured as string |
| read.autoscaling.enabled | bool | `false` | Enable autoscaling for the read, this is only used if `queryIndex.enabled: true` |
| read.autoscaling.maxReplicas | int | `3` | Maximum autoscaling replicas for the read |
| read.autoscaling.minReplicas | int | `1` | Minimum autoscaling replicas for the read |
| read.autoscaling.targetCPUUtilizationPercentage | int | `60` | Target CPU utilisation percentage for the read |
| read.autoscaling.targetMemoryUtilizationPercentage | string | `nil` | Target memory utilisation percentage for the read |
| read.extraArgs | list | `[]` | Additional CLI args for the read |
| read.extraEnv | list | `[]` | Environment variables to add to the read pods |
| read.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the read pods |
| read.extraVolumeMounts | list | `[]` | Volume mounts to add to the read pods |
| read.extraVolumes | list | `[]` | Volumes to add to the read pods |
| read.image.registry | string | `nil` | The Docker registry for the read image. Overrides `loki.image.registry` |
| read.image.repository | string | `nil` | Docker image repository for the read image. Overrides `loki.image.repository` |
| read.image.tag | string | `nil` | Docker image tag for the read image. Overrides `loki.image.tag` |
| read.nodeSelector | object | `{}` | Node selector for read pods |
| read.persistence.size | string | `"10Gi"` | Size of persistent disk |
| read.persistence.storageClass | string | `nil` | Storage class to be used. If defined, storageClassName: <storageClass>. If set to "-", storageClassName: "", which disables dynamic provisioning. If empty or set to null, no storageClassName spec is set, choosing the default provisioner (gp2 on AWS, standard on GKE, AWS, and OpenStack). |
| read.podAnnotations | object | `{}` | Annotations for read pods |
| read.priorityClassName | string | `nil` | The name of the PriorityClass for read pods |
| read.replicas | int | `1` | Number of replicas for the read |
| read.resources | object | `{}` | Resource requests and limits for the read |
| read.serviceLabels | object | `{}` | Labels for read service |
| read.terminationGracePeriodSeconds | int | `30` | Grace period to allow the read to shutdown before it is killed |
| read.tolerations | list | `[]` | Tolerations for read pods |
| serviceAccount.annotations | object | `{}` | Annotations for the service account |
| serviceAccount.automountServiceAccountToken | bool | `true` | Set this toggle to false to opt out of automounting API credentials for the service account |
| serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| serviceAccount.imagePullSecrets | list | `[]` | Image pull secrets for the service account |
| serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor.annotations | object | `{}` | ServiceMonitor annotations |
| serviceMonitor.enabled | bool | `false` | If enabled, ServiceMonitor resources for Prometheus Operator are created |
| serviceMonitor.interval | string | `nil` | ServiceMonitor scrape interval |
| serviceMonitor.labels | object | `{}` | Additional ServiceMonitor labels |
| serviceMonitor.namespace | string | `nil` | Alternative namespace for ServiceMonitor resources |
| serviceMonitor.namespaceSelector | object | `{}` | Namespace selector for ServiceMonitor resources |
| serviceMonitor.relabelings | list | `[]` | ServiceMonitor relabel configs to apply to samples before scraping https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/api.md#relabelconfig |
| serviceMonitor.scheme | string | `"http"` | ServiceMonitor will use http by default, but you can pick https as well |
| serviceMonitor.scrapeTimeout | string | `nil` | ServiceMonitor scrape timeout in Go duration format (e.g. 15s) |
| serviceMonitor.tlsConfig | string | `nil` | ServiceMonitor will use these tlsConfig settings to make the health check requests |
| write.affinity | string | Hard node and soft zone anti-affinity | Affinity for write pods. Passed through `tpl` and, thus, to be configured as string |
| write.extraArgs | list | `[]` | Additional CLI args for the write |
| write.extraEnv | list | `[]` | Environment variables to add to the write pods |
| write.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the write pods |
| write.extraVolumeMounts | list | `[]` | Volume mounts to add to the write pods |
| write.extraVolumes | list | `[]` | Volumes to add to the write pods |
| write.image.registry | string | `nil` | The Docker registry for the write image. Overrides `loki.image.registry` |
| write.image.repository | string | `nil` | Docker image repository for the write image. Overrides `loki.image.repository` |
| write.image.tag | string | `nil` | Docker image tag for the write image. Overrides `loki.image.tag` |
| write.nodeSelector | object | `{}` | Node selector for write pods |
| write.persistence.size | string | `"10Gi"` | Size of persistent disk |
| write.persistence.storageClass | string | `nil` | Storage class to be used. If defined, storageClassName: <storageClass>. If set to "-", storageClassName: "", which disables dynamic provisioning. If empty or set to null, no storageClassName spec is set, choosing the default provisioner (gp2 on AWS, standard on GKE, AWS, and OpenStack). |
| write.podAnnotations | object | `{}` | Annotations for write pods |
| write.priorityClassName | string | `nil` | The name of the PriorityClass for write pods |
| write.replicas | int | `1` | Number of replicas for the write |
| write.resources | object | `{}` | Resource requests and limits for the write |
| write.serviceLabels | object | `{}` | Labels for ingestor service |
| write.terminationGracePeriodSeconds | int | `300` | Grace period to allow the write to shutdown before it is killed. Especially for the ingestor, this must be increased. It must be long enough so writes can be gracefully shutdown flushing/transferring all data and to successfully leave the member ring on shutdown. |
| write.tolerations | list | `[]` | Tolerations for write pods |

## Components

The chart supports the components shown in the following table.
Ingester, distributor, querier, and query-frontend are always installed.
The other components are optional.

| Component | Optional | Enabled by default |
| --- | --- | --- |
| gateway |  ✅ |  ✅ |
| write |  ❎ | n/a |
| read |  ❎ | n/a |

## Configuration

This chart configures Loki in simple, scalable mode.
It has been tested to work with [boltdb-shipper](https://grafana.com/docs/loki/latest/operations/storage/boltdb-shipper/)
and [memberlist](https://grafana.com/docs/loki/latest/configuration/#memberlist_config) while other storage and discovery options should work as well.
However, the chart does not support setting up Consul or Etcd for discovery,
and it is not intended to support these going forward.
They would have to be set up separately.
Instead, memberlist can be used which does not require a separate key/value store.
The chart creates a headless service for the memberlist which read and write nodes are part of.

----

**NOTE:**
In its default configuration, the chart uses `boltdb-shipper` and `filesystem` as storage.
The reason for this is that the chart can be validated and installed in a CI pipeline.
However, this setup is not fully functional.
Querying will not be possible (or limited to the write nodes' in-memory caches) because that would otherwise require shared storage between read and write nodes
which the chart does not support and would require a volume that supports `ReadWriteMany` access mode anyways.
The recommendation is to use object storage, such as S3, GCS, MinIO, etc., or one of the other options documented at https://grafana.com/docs/loki/latest/storage/.
In order to do this, please override the `loki.config` value with a valid object storage configuration. This means overriding
the `common.storage` section, as well as the `object_store` in your `schema_config`. Please note that because of the way
helm deep merges values, you will need to explicitly `null` out the default `filesystem` configuration.

For exmaple, to use MinIO (deployed separately) as your backend, provide the following values when installing this chart:

```yaml
loki:
  config:
    common:
      storage:
        filesystem: null
        s3:
          endpoint: minio.minio.svc.cluster.local:9000
          insecure: true
          bucketnames: loki-data
          access_key_id: loki
          secret_access_key: supersecret
          s3forcepathstyle: true
    schema_config:
      configs:
        - from: "2020-09-07"
          store: boltdb-shipper
          object_store: s3
          schema: v11
          index:
            period: 24h
            prefix: loki_index_
```

Alternatively, in order to quickly test Loki using the filestore, the [single binary chart](https://github.com/grafana/helm-charts/tree/main/charts/loki) can be used.

----

### Directory and File Locations

* Volumes are mounted to `/var/loki`. The various directories Loki needs should be configured as subdirectories (e. g. `/var/loki/index`, `/var/loki/cache`). Loki will create the directories automatically.
  * Persistence is require to use this chart, and PVCs will be created and mapped to `/var/loki`
* The config file is mounted to `/etc/loki/config/config.yaml` and passed as CLI arg.

### Example configuration using memberlist, boltdb-shipper, and S3 for storage

If using the default config values, queries will not work. At a minimum you need to provide:
  * `loki.config.common.storage` (with `filesystem` set to `null`, and valid cloud storage provided)
  * `loki.config.schema_config.configs` (with at least one config that has an `object_store` that matches the the `loki.config.common.storage` config)
values, you must provide an entire `loki.config` value.

`loki.config` is passed through the `tpl` function, meaning it is also possible to e.g. externalize S3 bucket names:

```yaml
loki:
  config:
    common:
      storage:
        s3:
          s3: s3://eu-central-1
          bucketnames: {{ .values.bucketnames }}
```

```console
helm upgrade loki --install -f values.yaml --set bucketnames=my-loki-bucket
```

## Gateway

By default and inspired by Grafana's [Tanka setup](https://github.com/grafana/loki/tree/master/production/ksonnet/loki), the chart installs the gateway component which is an NGINX that exposes Loki's API
and automatically proxies requests to the correct Loki components (read or write).
The gateway must be enabled if an Ingress is required, since the Ingress exposes the gateway only.
If the gateway is enabled, Grafana and log shipping agents, such as Promtail, should be configured to use the gateway.
If NetworkPolicies are enabled, they are more restrictive if the gateway is enabled.

## Metrics

Loki exposes Prometheus metrics.
The chart can create ServiceMonitor objects for all Loki components.

```yaml
serviceMonitor:
  enabled: true
```

Furthermore, it is possible to add Prometheus rules:

```yaml
prometheusRule:
  enabled: true
  groups:
    - name: loki-rules
      rules:
        - record: job:loki_request_duration_seconds_bucket:sum_rate
          expr: sum(rate(loki_request_duration_seconds_bucket[1m])) by (le, job)
        - record: job_route:loki_request_duration_seconds_bucket:sum_rate
          expr: sum(rate(loki_request_duration_seconds_bucket[1m])) by (le, job, route)
        - record: node_namespace_pod_container:container_cpu_usage_seconds_total:sum_rate
          expr: sum(rate(container_cpu_usage_seconds_total[1m])) by (node, namespace, pod, container)
```

## Caching

By default, this chart configures in-memory caching. If that caching does not work for your deployment, take a lot at the [distributed chart](https://github.com/grafana/helm-charts/tree/main/charts/loki) for how to setup memcache.
