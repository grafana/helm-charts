# tempo-distributed

![Version: 0.16.10](https://img.shields.io/badge/Version-0.16.10-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.3.2](https://img.shields.io/badge/AppVersion-1.3.2-informational?style=flat-square)

Grafana Tempo in MicroService mode

## Source Code

* <https://github.com/grafana/tempo>

## Chart Repo

Add the following repo to use the chart:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```

## Upgrading

A major chart version change indicates that there is an incompatible breaking change needing manual actions.

### From Chart versions < 0.9.0

This release the component label was shortened to be more aligned with the Loki-distributed chart and the [mixin](https://github.com/grafana/tempo/tree/master/operations/tempo-mixin) dashboards.

Due to the label changes, an existing installation cannot be upgraded without manual interaction. There are basically two options:

Option 1
Uninstall the old release and re-install the new one. There will be no data loss, as the collectors/agents can cache for a short period.

Option 2
Add new selector labels to the existing pods. This option will make your pods also temporarely unavailable, option 1 is faster:

```
kubectl label pod -n <namespace> -l app.kubernetes.io/component=<release-name>-tempo-distributed-<component>,app.kubernetes.io/instance=<instance-name> app.kubernetes.io/component=<component> --overwrite
```

Perform a non-cascading deletion of the Deployments and Statefulsets which will keep the pods running:

```
kubectl delete <deployment/statefulset> -n <namespace> -l app.kubernetes.io/component=<release-name>-tempo-distributed-<component>,app.kubernetes.io/instance=<instance-name> --cascade=false
```

Perform a regular Helm upgrade on the existing release. The new Deployment/Statefulset will pick up the existing pods and perform a rolling upgrade.

### From Chart versions < 0.8.0

By default all tracing protocols are disabled and you need to specify which protocols to enable for ingestion.

For example to enable Jaeger grpc thrift http and zipkin protocols:
```yaml
traces:
  jaeger:
    grpc: true
    thriftHttp: true
  zipkin: true
```

The distributor service is now called {{tempo.fullname}}-distributor. That could impact your ingestion towards this service.

### From Chart Versions < 0.7.0

The memcached default args are removed and should be provided manually. The settings for the `memcached.exporter` moved to `memcachedExporter`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| compactor.config.compaction.block_retention | string | `"48h"` | Duration to keep blocks |
| compactor.extraArgs | list | `[]` | Additional CLI args for the compactor |
| compactor.extraEnv | list | `[]` | Environment variables to add to the compactor pods |
| compactor.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the compactor pods |
| compactor.extraVolumeMounts | list | `[]` | Extra volumes for compactor pods |
| compactor.extraVolumes | list | `[]` | Extra volumes for compactor deployment |
| compactor.image.registry | string | `nil` | The Docker registry for the compactor image. Overrides `tempo.image.registry` |
| compactor.image.repository | string | `nil` | Docker image repository for the compactor image. Overrides `tempo.image.repository` |
| compactor.image.tag | string | `nil` | Docker image tag for the compactor image. Overrides `tempo.image.tag` |
| compactor.nodeSelector | object | `{}` | Node selector for compactor pods |
| compactor.podAnnotations | object | `{}` | Annotations for compactor pods |
| compactor.podLabels | object | `{}` | Labels for compactor pods |
| compactor.priorityClassName | string | `nil` | The name of the PriorityClass for compactor pods |
| compactor.resources | object | `{}` | Resource requests and limits for the compactor |
| compactor.terminationGracePeriodSeconds | int | `30` | Grace period to allow the compactor to shutdown before it is killed |
| compactor.tolerations | list | `[]` | Tolerations for compactor pods |
| config | string | `"multitenancy_enabled: false\nsearch_enabled: {{ .Values.search.enabled }}\ncompactor:\n  compaction:\n    block_retention: {{ .Values.compactor.config.compaction.block_retention }}\n  ring:\n    kvstore:\n      store: memberlist\ndistributor:\n  ring:\n    kvstore:\n      store: memberlist\n  receivers:\n    {{- if  or (.Values.traces.jaeger.thriftCompact) (.Values.traces.jaeger.thriftBinary) (.Values.traces.jaeger.thriftHttp) (.Values.traces.jaeger.grpc) }}\n    jaeger:\n      protocols:\n        {{- if .Values.traces.jaeger.thriftCompact }}\n        thrift_compact:\n          endpoint: 0.0.0.0:6831\n        {{- end }}\n        {{- if .Values.traces.jaeger.thriftBinary }}\n        thrift_binary:\n          endpoint: 0.0.0.0:6832\n        {{- end }}\n        {{- if .Values.traces.jaeger.thriftHttp }}\n        thrift_http:\n          endpoint: 0.0.0.0:14268\n        {{- end }}\n        {{- if .Values.traces.jaeger.grpc }}\n        grpc:\n          endpoint: 0.0.0.0:14250\n        {{- end }}\n    {{- end }}\n    {{- if .Values.traces.zipkin}}\n    zipkin:\n      endpoint: 0.0.0.0:9411\n    {{- end }}\n    {{- if or (.Values.traces.otlp.http) (.Values.traces.otlp.grpc) }}\n    otlp:\n      protocols:\n        {{- if .Values.traces.otlp.http }}\n        http:\n          endpoint: 0.0.0.0:55681\n        {{- end }}\n        {{- if .Values.traces.otlp.grpc }}\n        grpc:\n          endpoint: 0.0.0.0:4317\n        {{- end }}\n    {{- end }}\n    {{- if .Values.traces.opencensus }}\n    opencensus:\n      endpoint: 0.0.0.0:55678\n    {{- end }}\n    {{- if .Values.traces.kafka }}\n    kafka:\n      {{- toYaml .Values.traces.kafka | nindent 6 }}\n    {{- end }}\nquerier:\n  frontend_worker:\n    frontend_address: {{ include \"tempo.queryFrontendFullname\" . }}-discovery:9095\n    {{- if .Values.querier.config.frontend_worker.grpc_client_config }}\n    grpc_client_config:\n      {{- toYaml .Values.querier.config.frontend_worker.grpc_client_config | nindent 6 }}\n    {{- end }}\ningester:\n  lifecycler:\n    ring:\n      replication_factor: 1\n      kvstore:\n        store: memberlist\n    tokens_file_path: /var/tempo/tokens.json\n  {{- if .Values.ingester.config.maxBlockBytes }}\n  max_block_bytes: {{ .Values.ingester.config.maxBlockBytes }}\n  {{- end }}\n  {{- if .Values.ingester.config.maxBlockDuration }}\n  max_block_duration: {{ .Values.ingester.config.maxBlockDuration }}\n  {{- end }}\n  {{- if .Values.ingester.config.completeBlockTimeout }}\n  complete_block_timeout: {{ .Values.ingester.config.completeBlockTimeout }}\n  {{- end }}\nmemberlist:\n  abort_if_cluster_join_fails: false\n  join_members:\n    - {{ include \"tempo.fullname\" . }}-gossip-ring\noverrides:\n  {{- toYaml .Values.global_overrides | nindent 2 }}\nserver:\n  http_listen_port: {{ .Values.server.httpListenPort }}\n  log_level: {{ .Values.server.logLevel }}\n  log_format: {{ .Values.server.logFormat }}\n  grpc_server_max_recv_msg_size: {{ .Values.server.grpc_server_max_recv_msg_size }}\n  grpc_server_max_send_msg_size: {{ .Values.server.grpc_server_max_send_msg_size }}\nstorage:\n  trace:\n    backend: {{.Values.storage.trace.backend}}\n    {{- if eq .Values.storage.trace.backend \"gcs\"}}\n    gcs:\n      {{- toYaml .Values.storage.trace.gcs | nindent 6}}\n    {{- end}}\n    {{- if eq .Values.storage.trace.backend \"s3\"}}\n    s3:\n      {{- toYaml .Values.storage.trace.s3 | nindent 6}}\n    {{- end}}\n    {{- if eq .Values.storage.trace.backend \"azure\"}}\n    azure:\n      {{- toYaml .Values.storage.trace.azure | nindent 6}}\n    {{- end}}\n    blocklist_poll: 5m\n    local:\n      path: /var/tempo/traces\n    wal:\n      path: /var/tempo/wal\n    cache: memcached\n    memcached:\n      consistent_hash: true\n      host: {{ include \"tempo.fullname\" . }}-memcached\n      service: memcached-client\n      timeout: 500ms\n"` |  |
| distributor.affinity | string | Hard node and soft zone anti-affinity | Affinity for distributor pods. Passed through `tpl` and, thus, to be configured as string |
| distributor.extraArgs | list | `[]` | Additional CLI args for the distributor |
| distributor.extraEnv | list | `[]` | Environment variables to add to the distributor pods |
| distributor.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the distributor pods |
| distributor.extraVolumeMounts | list | `[]` | Extra volumes for distributor pods |
| distributor.extraVolumes | list | `[]` | Extra volumes for distributor deployment |
| distributor.image.registry | string | `nil` | The Docker registry for the ingester image. Overrides `tempo.image.registry` |
| distributor.image.repository | string | `nil` | Docker image repository for the ingester image. Overrides `tempo.image.repository` |
| distributor.image.tag | string | `nil` | Docker image tag for the ingester image. Overrides `tempo.image.tag` |
| distributor.nodeSelector | object | `{}` | Node selector for distributor pods |
| distributor.podAnnotations | object | `{}` | Annotations for distributor pods |
| distributor.podLabels | object | `{}` | Labels for distributor pods |
| distributor.priorityClassName | string | `nil` | The name of the PriorityClass for distributor pods |
| distributor.replicas | int | `1` | Number of replicas for the distributor |
| distributor.resources | object | `{}` | Resource requests and limits for the distributor |
| distributor.service.annotations | object | `{}` | Annotations for distributor service |
| distributor.service.loadBalancerIP | string | `""` | If type is LoadBalancer you can assign the IP to the LoadBalancer |
| distributor.service.loadBalancerSourceRanges | list | `[]` | If type is LoadBalancer limit incoming traffic from IPs. |
| distributor.service.type | string | `"ClusterIP"` | Type of service for the distributor |
| distributor.terminationGracePeriodSeconds | int | `30` | Grace period to allow the distributor to shutdown before it is killed |
| distributor.tolerations | list | `[]` | Tolerations for distributor pods |
| gateway.affinity | string | Hard node and soft zone anti-affinity | Affinity for gateway pods. Passed through `tpl` and, thus, to be configured as string |
| gateway.basicAuth.enabled | bool | `false` | Enables basic authentication for the gateway |
| gateway.basicAuth.existingSecret | string | `nil` | Existing basic auth secret to use. Must contain '.htpasswd' |
| gateway.basicAuth.htpasswd | string | `"{{ htpasswd (required \"'gateway.basicAuth.username' is required\" .Values.gateway.basicAuth.username) (required \"'gateway.basicAuth.password' is required\" .Values.gateway.basicAuth.password) }}"` | Uses the specified username and password to compute a htpasswd using Sprig's `htpasswd` function. The value is templated using `tpl`. Override this to use a custom htpasswd, e.g. in case the default causes high CPU load. |
| gateway.basicAuth.password | string | `nil` | The basic auth password for the gateway |
| gateway.basicAuth.username | string | `nil` | The basic auth username for the gateway |
| gateway.enabled | bool | `false` | Specifies whether the gateway should be enabled |
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
| gateway.ingress.hosts | list | `[{"host":"gateway.tempo.example.com","paths":[{"path":"/"}]}]` | Hosts configuration for the gateway ingress |
| gateway.ingress.tls | list | `[{"hosts":["gateway.tempo.example.com"],"secretName":"tempo-gateway-tls"}]` | TLS configuration for the gateway ingress |
| gateway.nginxConfig.file | string | See values.yaml | Config file contents for Nginx. Passed through the `tpl` function to allow templating |
| gateway.nginxConfig.httpSnippet | string | `""` | Allows appending custom configuration to the http block |
| gateway.nginxConfig.logFormat | string | `"main '$remote_addr - $remote_user [$time_local]  $status '\n        '\"$request\" $body_bytes_sent \"$http_referer\" '\n        '\"$http_user_agent\" \"$http_x_forwarded_for\"';"` | NGINX log format |
| gateway.nginxConfig.serverSnippet | string | `""` | Allows appending custom configuration to the server block |
| gateway.nodeSelector | object | `{}` | Node selector for gateway pods |
| gateway.podAnnotations | object | `{}` | Annotations for gateway pods |
| gateway.podLabels | object | `{}` | Labels for gateway pods |
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
| global_overrides.per_tenant_override_config | string | `"/conf/overrides.yaml"` |  |
| ingester.affinity | string | Hard node and soft zone anti-affinity | Affinity for ingester pods. Passed through `tpl` and, thus, to be configured as string |
| ingester.config.complete_block_timeout | string | `nil` | Duration to keep blocks in the ingester after they have been flushed |
| ingester.config.max_block_bytes | string | `nil` | Maximum size of a block before cutting it |
| ingester.config.max_block_duration | string | `nil` | Maximum length of time before cutting a block |
| ingester.extraArgs | list | `[]` | Additional CLI args for the ingester |
| ingester.extraEnv | list | `[]` | Environment variables to add to the ingester pods |
| ingester.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the ingester pods |
| ingester.extraVolumeMounts | list | `[]` | Extra volumes for ingester pods |
| ingester.extraVolumes | list | `[]` | Extra volumes for ingester deployment |
| ingester.image.registry | string | `nil` | The Docker registry for the ingester image. Overrides `tempo.image.registry` |
| ingester.image.repository | string | `nil` | Docker image repository for the ingester image. Overrides `tempo.image.repository` |
| ingester.image.tag | string | `nil` | Docker image tag for the ingester image. Overrides `tempo.image.tag` |
| ingester.nodeSelector | object | `{}` | Node selector for ingester pods |
| ingester.persistence.enabled | bool | `false` | Enable creating PVCs which is required when using boltdb-shipper |
| ingester.persistence.size | string | `"10Gi"` | Size of persistent disk |
| ingester.persistence.storageClass | string | `nil` | Storage class to be used. If defined, storageClassName: <storageClass>. If set to "-", storageClassName: "", which disables dynamic provisioning. If empty or set to null, no storageClassName spec is set, choosing the default provisioner (gp2 on AWS, standard on GKE, AWS, and OpenStack). |
| ingester.podAnnotations | object | `{}` | Annotations for ingester pods |
| ingester.podLabels | object | `{}` | Labels for ingester pods |
| ingester.priorityClassName | string | `nil` | The name of the PriorityClass for ingester pods |
| ingester.replicas | int | `1` | Number of replicas for the ingester |
| ingester.resources | object | `{}` | Resource requests and limits for the ingester |
| ingester.terminationGracePeriodSeconds | int | `300` | Grace period to allow the ingester to shutdown before it is killed. Especially for the ingestor, this must be increased. It must be long enough so ingesters can be gracefully shutdown flushing/transferring all data and to successfully leave the member ring on shutdown. |
| ingester.tolerations | list | `[]` | Tolerations for ingester pods |
| memcached.affinity | string | Hard node and soft zone anti-affinity | Affinity for memcached pods. Passed through `tpl` and, thus, to be configured as string |
| memcached.enabled | bool | `true` | Specified whether the memcached cachce should be enabled |
| memcached.extraArgs | list | `[]` | Additional CLI args for memcached |
| memcached.extraEnv | list | `[]` | Environment variables to add to memcached pods |
| memcached.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to memcached pods |
| memcached.host | string | `"memcached"` |  |
| memcached.podAnnotations | object | `{}` | Annotations for memcached pods |
| memcached.podLabels | object | `{}` | Labels for memcached pods |
| memcached.pullPolicy | string | `"IfNotPresent"` | Memcached Docker image pull policy |
| memcached.replicas | int | `1` |  |
| memcached.repository | string | `"memcached"` | Memcached Docker image repository |
| memcached.resources | object | `{}` | Resource requests and limits for memcached |
| memcached.service | string | `"memcached-client"` |  |
| memcached.tag | string | `"1.5.17-alpine"` | Memcached Docker image tag |
| memcachedExporter.enabled | bool | `false` | Specifies whether the Memcached Exporter should be enabled |
| memcachedExporter.image.pullPolicy | string | `"IfNotPresent"` | Memcached Exporter Docker image pull policy |
| memcachedExporter.image.repository | string | `"prom/memcached-exporter"` | Memcached Exporter Docker image repository |
| memcachedExporter.image.tag | string | `"v0.8.0"` | Memcached Exporter Docker image tag |
| memcachedExporter.resources | object | `{}` |  |
| overrides | string | `"overrides: {}\n"` |  |
| prometheusRule.annotations | object | `{}` | PrometheusRule annotations |
| prometheusRule.enabled | bool | `false` | If enabled, a PrometheusRule resource for Prometheus Operator is created |
| prometheusRule.groups | list | `[]` | Contents of Prometheus rules file |
| prometheusRule.labels | object | `{}` | Additional PrometheusRule labels |
| prometheusRule.namespace | string | `nil` | Alternative namespace for the PrometheusRule resource |
| querier.affinity | string | Hard node and soft zone anti-affinity | Affinity for querier pods. Passed through `tpl` and, thus, to be configured as string |
| querier.config.frontend_worker.grpc_client_config | object | `{}` | grpc client configuration |
| querier.extraArgs | list | `[]` | Additional CLI args for the querier |
| querier.extraEnv | list | `[]` | Environment variables to add to the querier pods |
| querier.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the querier pods |
| querier.extraVolumeMounts | list | `[]` | Extra volumes for querier pods |
| querier.extraVolumes | list | `[]` | Extra volumes for querier deployment |
| querier.image.registry | string | `nil` | The Docker registry for the querier image. Overrides `tempo.image.registry` |
| querier.image.repository | string | `nil` | Docker image repository for the querier image. Overrides `tempo.image.repository` |
| querier.image.tag | string | `nil` | Docker image tag for the querier image. Overrides `tempo.image.tag` |
| querier.nodeSelector | object | `{}` | Node selector for querier pods |
| querier.podAnnotations | object | `{}` | Annotations for querier pods |
| querier.podLabels | object | `{}` | Labels for querier pods |
| querier.priorityClassName | string | `nil` | The name of the PriorityClass for querier pods |
| querier.replicas | int | `1` | Number of replicas for the querier |
| querier.resources | object | `{}` | Resource requests and limits for the querier |
| querier.terminationGracePeriodSeconds | int | `30` | Grace period to allow the querier to shutdown before it is killed |
| querier.tolerations | list | `[]` | Tolerations for querier pods |
| queryFrontend.affinity | string | Hard node and soft zone anti-affinity | Affinity for query-frontend pods. Passed through `tpl` and, thus, to be configured as string |
| queryFrontend.extraArgs | list | `[]` | Additional CLI args for the query-frontend |
| queryFrontend.extraEnv | list | `[]` | Environment variables to add to the query-frontend pods |
| queryFrontend.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the query-frontend pods |
| queryFrontend.extraVolumeMounts | list | `[]` | Extra volumes for query-frontend pods |
| queryFrontend.extraVolumes | list | `[]` | Extra volumes for query-frontend deployment |
| queryFrontend.image.registry | string | `nil` | The Docker registry for the query-frontend image. Overrides `tempo.image.registry` |
| queryFrontend.image.repository | string | `nil` | Docker image repository for the query-frontend image. Overrides `tempo.image.repository` |
| queryFrontend.image.tag | string | `nil` | Docker image tag for the query-frontend image. Overrides `tempo.image.tag` |
| queryFrontend.nodeSelector | object | `{}` | Node selector for query-frontend pods |
| queryFrontend.podAnnotations | object | `{}` | Annotations for query-frontend pods |
| queryFrontend.podLabels | object | `{}` | Labels for queryFrontend pods |
| queryFrontend.priorityClassName | string | `nil` | The name of the PriorityClass for query-frontend pods |
| queryFrontend.query.config | string | `"backend: 127.0.0.1:3100\n"` |  |
| queryFrontend.query.enabled | bool | `true` | Required for grafana version <7.5 for compatibility with jaeger-ui. Doesn't work on ARM arch |
| queryFrontend.query.extraArgs | list | `[]` | Additional CLI args for tempo-query pods |
| queryFrontend.query.extraEnv | list | `[]` | Environment variables to add to the tempo-query pods |
| queryFrontend.query.extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the tempo-query pods |
| queryFrontend.query.extraVolumeMounts | list | `[]` | Extra volumes for tempo-query pods |
| queryFrontend.query.extraVolumes | list | `[]` | Extra volumes for tempo-query deployment |
| queryFrontend.query.image.registry | string | `nil` | The Docker registry for the query-frontend image. Overrides `tempo.image.registry` |
| queryFrontend.query.image.repository | string | `"grafana/tempo-query"` | Docker image repository for the query-frontend image. Overrides `tempo.image.repository` |
| queryFrontend.query.image.tag | string | `nil` | Docker image tag for the query-frontend image. Overrides `tempo.image.tag` |
| queryFrontend.query.resources | object | `{}` | Resource requests and limits for the query |
| queryFrontend.replicas | int | `1` | Number of replicas for the query-frontend |
| queryFrontend.resources | object | `{}` | Resource requests and limits for the query-frontend |
| queryFrontend.service.annotations | object | `{}` | Annotations for queryFrontend service |
| queryFrontend.service.type | string | `"ClusterIP"` | Type of service for the queryFrontend |
| queryFrontend.serviceDiscovery.annotations | object | `{}` | Annotations for queryFrontendDiscovery service |
| queryFrontend.terminationGracePeriodSeconds | int | `30` | Grace period to allow the query-frontend to shutdown before it is killed |
| queryFrontend.tolerations | list | `[]` | Tolerations for query-frontend pods |
| rbac.create | bool | `false` | Specifies whether RBAC manifests should be created |
| rbac.pspEnabled | bool | `false` | Specifies whether a PodSecurityPolicy should be created |
| search.enabled | bool | `false` | Enable Tempo search |
| server.grpc_server_max_recv_msg_size | int | `4194304` | Max gRPC message size that can be received |
| server.grpc_server_max_send_msg_size | int | `4194304` | Max gRPC message size that can be sent |
| server.httpListenPort | int | `3100` | HTTP server listen host |
| server.logFormat | string | `"logfmt"` | Log format. Can be set to logfmt (default) or json. |
| server.logLevel | string | `"info"` | Log level. Can be set to trace, debug, info (default), warn error, fatal, panic |
| serviceAccount.annotations | object | `{}` | Annotations for the service account |
| serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| serviceAccount.imagePullSecrets | list | `[]` | Image pull secrets for the service account |
| serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor.annotations | object | `{}` | ServiceMonitor annotations |
| serviceMonitor.enabled | bool | `false` | If enabled, ServiceMonitor resources for Prometheus Operator are created |
| serviceMonitor.interval | string | `nil` | ServiceMonitor scrape interval |
| serviceMonitor.labels | object | `{}` | Additional ServiceMonitor labels |
| serviceMonitor.metricRelabelings | list | `[]` | ServiceMonitor metric relabel configs to apply to samples before ingestion https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#endpoint |
| serviceMonitor.namespace | string | `nil` | Alternative namespace for ServiceMonitor resources |
| serviceMonitor.namespaceSelector | object | `{}` | Namespace selector for ServiceMonitor resources |
| serviceMonitor.relabelings | list | `[]` | ServiceMonitor relabel configs to apply to samples before scraping https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/api.md#relabelconfig |
| serviceMonitor.scheme | string | `"http"` | ServiceMonitor will use http by default, but you can pick https as well |
| serviceMonitor.scrapeTimeout | string | `nil` | ServiceMonitor scrape timeout in Go duration format (e.g. 15s) |
| serviceMonitor.tlsConfig | string | `nil` | ServiceMonitor will use these tlsConfig settings to make the health check requests |
| storage.trace.backend | string | `"local"` |  |
| tempo | object | `{"image":{"pullPolicy":"IfNotPresent","registry":"docker.io","repository":"grafana/tempo","tag":null},"podAnnotations":{},"podLabels":{},"readinessProbe":{"httpGet":{"path":"/ready","port":"http"},"initialDelaySeconds":30,"timeoutSeconds":1},"securityContext":{}}` | Overrides the chart's computed fullname fullnameOverride: tempo |
| tempo.image.registry | string | `"docker.io"` | The Docker registry |
| tempo.image.repository | string | `"grafana/tempo"` | Docker image repository |
| tempo.image.tag | string | `nil` | Overrides the image tag whose default is the chart's appVersion |
| tempo.podAnnotations | object | `{}` | Common annotations for all pods |
| tempo.podLabels | object | `{}` | Global labels for all tempo pods |
| traces.jaeger.grpc | bool | `false` | Enable Tempo to ingest Jaeger GRPC traces |
| traces.jaeger.thriftBinary | bool | `false` | Enable Tempo to ingest Jaeger Thrift Binary traces |
| traces.jaeger.thriftCompact | bool | `false` | Enable Tempo to ingest Jaeger Thrift Compact traces |
| traces.jaeger.thriftHttp | bool | `false` | Enable Tempo to ingest Jaeger Thrift HTTP traces |
| traces.kafka | object | `{}` | Enable Tempo to ingest traces from Kafka. Reference: https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/kafkareceiver |
| traces.opencensus | bool | `false` | Enable Tempo to ingest Open Census traces |
| traces.otlp.grpc | bool | `false` | Enable Tempo to ingest Open Telemetry GRPC traces |
| traces.otlp.http | bool | `false` | Enable Tempo to ingest Open Telemetry HTTP traces |
| traces.zipkin | bool | `false` | Enable Tempo to ingest Zipkin traces |

## Components

The chart supports the components shown in the following table.
Ingester, distributor, querier, query-frontend, and compactor are always installed.
The other components are optional and must be explicitly enabled.

| Component | Optional |
| --- | --- |
| ingester | no |
| distributor | no |
| querier | no |
| query-frontend | no |
| compactor | no |
| memcached | yes |
| gateway | yes |

## (Configuration)[https://grafana.com/docs/tempo/latest/configuration/]

This chart configures Tempo in microservices mode.

**NOTE:**
In its default configuration, the chart uses `local` filesystem as storage.
The reason for this is that the chart can be validated and installed in a CI pipeline.
However, this setup is not fully functional.
The recommendation is to use object storage, such as S3, GCS, MinIO, etc., or one of the other options documented at https://grafana.com/docs/tempo/latest/configuration/#storage.

Alternatively, in order to quickly test Tempo using the filestore, the [single binary chart](https://github.com/grafana/helm-charts/tree/main/charts/tempo) can be used.

----

### Directory and File Locations

* Volumes are mounted to `/var/tempo`. The various directories Tempo needs should be configured as subdirectories (e. g. `/var/tempo/wal`, `/var/tempo/traces`). Tempo will create the directories automatically.
* The config file is mounted to `/conf/tempo-query.yaml` and passed as CLI arg.

### Example configuration using S3 for storage

```yaml
config: |
  multitenancy_enabled: false
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