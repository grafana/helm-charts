# loki-distributed


![Version: 0.48.1](https://img.shields.io/badge/Version-0.48.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.5.0](https://img.shields.io/badge/AppVersion-2.5.0-informational?style=flat-square) 

Helm chart for Grafana Loki in microservices mode

## Source Code

* <https://github.com/grafana/loki>
* <https://grafana.com/oss/loki/>
* <https://grafana.com/docs/loki/latest/>



## Chart Repo

Add the following repo to use the chart:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```

## Upgrading

### Upgrading an existing Release to a new major version

Major version upgrades listed here indicate that there is an incompatible breaking change needing manual actions.

### From 0.41.x to 0.42.0
All containers were previously named "loki". This version changes the container names to make the chart compatible with the loki-mixin. Now the container names correctly reflect the component (querier, distributor, ingester, ...). If you are using custom prometheus rules that use the container name you probably have to change them.

### From 0.34.x to 0.35.0
This version updates the `Ingress` API Version of the Loki Gateway component to `networking.k8s.io/v1` of course given that the cluster supports it. Here it's important to notice the change in the `values.yml` with regards to the ingress configuration section and its new structure.
```yaml
gateway:
  ingress:
    enabled: true
    # Newly added optional property
    ingressClassName: nginx
    hosts:
      - host: gateway.loki.example.com
        paths:
          # New data structure introduced
          - path: /
            # Newly added optional property
            pathType: Prefix
```

### From 0.30.x to 0.31.0
This version updates the `podManagementPolicy` of running the Loki components as `StatefulSet`'s to `Parallel` instead of the default `OrderedReady` in order to allow better scalability for Loki e.g. in case the pods weren't terminated gracefully. This change requires a manual action deleting the existing StatefulSets before upgrading with Helm.
```bash
# Delete the Ingesters StatefulSets
kubectl delete statefulset RELEASE_NAME-loki-distributed-ingester -n LOKI_NAMESPACE --cascade=orphan
# Delete the Queriers StatefulSets
kubectl delete statefulset RELEASE_NAME-loki-distributed-querier -n LOKI_NAMESPACE --cascade=orphan
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| compactor.enabled | bool | `false` |  |
| compactor.extraArgs | list | `[]` |  |
| compactor.extraContainers | list | `[]` |  |
| compactor.extraEnv | list | `[]` |  |
| compactor.extraEnvFrom | list | `[]` |  |
| compactor.extraVolumeMounts | list | `[]` |  |
| compactor.extraVolumes | list | `[]` |  |
| compactor.image.registry | string | `nil` |  |
| compactor.image.repository | string | `nil` |  |
| compactor.image.tag | string | `nil` |  |
| compactor.nodeSelector | object | `{}` |  |
| compactor.persistence.enabled | bool | `false` |  |
| compactor.persistence.size | string | `"10Gi"` |  |
| compactor.persistence.storageClass | string | `nil` |  |
| compactor.podAnnotations | object | `{}` |  |
| compactor.podLabels | object | `{}` |  |
| compactor.priorityClassName | string | `nil` |  |
| compactor.resources | object | `{}` |  |
| compactor.serviceAccount.annotations | object | `{}` |  |
| compactor.serviceAccount.automountServiceAccountToken | bool | `true` |  |
| compactor.serviceAccount.create | bool | `false` |  |
| compactor.serviceAccount.imagePullSecrets | list | `[]` |  |
| compactor.serviceAccount.name | string | `nil` |  |
| compactor.serviceLabels | object | `{}` |  |
| compactor.terminationGracePeriodSeconds | int | `30` |  |
| compactor.tolerations | list | `[]` |  |
| distributor.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"loki.distributorSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"loki.distributorSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| distributor.autoscaling.enabled | bool | `false` |  |
| distributor.autoscaling.maxReplicas | int | `3` |  |
| distributor.autoscaling.minReplicas | int | `1` |  |
| distributor.autoscaling.targetCPUUtilizationPercentage | int | `60` |  |
| distributor.autoscaling.targetMemoryUtilizationPercentage | string | `nil` |  |
| distributor.extraArgs | list | `[]` |  |
| distributor.extraContainers | list | `[]` |  |
| distributor.extraEnv | list | `[]` |  |
| distributor.extraEnvFrom | list | `[]` |  |
| distributor.extraVolumeMounts | list | `[]` |  |
| distributor.extraVolumes | list | `[]` |  |
| distributor.image.registry | string | `nil` |  |
| distributor.image.repository | string | `nil` |  |
| distributor.image.tag | string | `nil` |  |
| distributor.nodeSelector | object | `{}` |  |
| distributor.podAnnotations | object | `{}` |  |
| distributor.podLabels | object | `{}` |  |
| distributor.priorityClassName | string | `nil` |  |
| distributor.replicas | int | `1` |  |
| distributor.resources | object | `{}` |  |
| distributor.serviceLabels | object | `{}` |  |
| distributor.terminationGracePeriodSeconds | int | `30` |  |
| distributor.tolerations | list | `[]` |  |
| fullnameOverride | string | `nil` | Overrides the chart's computed fullname |
| gateway.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"loki.gatewaySelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"loki.gatewaySelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| gateway.autoscaling.enabled | bool | `false` |  |
| gateway.autoscaling.maxReplicas | int | `3` |  |
| gateway.autoscaling.minReplicas | int | `1` |  |
| gateway.autoscaling.targetCPUUtilizationPercentage | int | `60` |  |
| gateway.autoscaling.targetMemoryUtilizationPercentage | string | `nil` |  |
| gateway.basicAuth.enabled | bool | `false` |  |
| gateway.basicAuth.existingSecret | string | `nil` |  |
| gateway.basicAuth.htpasswd | string | `"{{ htpasswd (required \"'gateway.basicAuth.username' is required\" .Values.gateway.basicAuth.username) (required \"'gateway.basicAuth.password' is required\" .Values.gateway.basicAuth.password) }}"` |  |
| gateway.basicAuth.password | string | `nil` |  |
| gateway.basicAuth.username | string | `nil` |  |
| gateway.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| gateway.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| gateway.containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| gateway.deploymentStrategy.type | string | `"RollingUpdate"` |  |
| gateway.enabled | bool | `true` |  |
| gateway.extraArgs | list | `[]` |  |
| gateway.extraContainers | list | `[]` |  |
| gateway.extraEnv | list | `[]` |  |
| gateway.extraEnvFrom | list | `[]` |  |
| gateway.extraVolumeMounts | list | `[]` |  |
| gateway.extraVolumes | list | `[]` |  |
| gateway.image.pullPolicy | string | `"IfNotPresent"` |  |
| gateway.image.registry | string | `"docker.io"` |  |
| gateway.image.repository | string | `"nginxinc/nginx-unprivileged"` |  |
| gateway.image.tag | string | `"1.19-alpine"` |  |
| gateway.ingress.annotations | object | `{}` |  |
| gateway.ingress.enabled | bool | `false` |  |
| gateway.ingress.hosts[0].host | string | `"gateway.loki.example.com"` |  |
| gateway.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| gateway.ingress.tls | list | `[{"hosts":["gateway.loki.example.com"],"secretName":"loki-gateway-tls"}]` | TLS configuration for the gateway ingress |
| gateway.nginxConfig.file | string | `"worker_processes  5;  ## Default: 1\nerror_log  /dev/stderr;\npid        /tmp/nginx.pid;\nworker_rlimit_nofile 8192;\n\nevents {\n  worker_connections  4096;  ## Default: 1024\n}\n\nhttp {\n  client_body_temp_path /tmp/client_temp;\n  proxy_temp_path       /tmp/proxy_temp_path;\n  fastcgi_temp_path     /tmp/fastcgi_temp;\n  uwsgi_temp_path       /tmp/uwsgi_temp;\n  scgi_temp_path        /tmp/scgi_temp;\n\n  default_type application/octet-stream;\n  log_format   {{ .Values.gateway.nginxConfig.logFormat }}\n\n  {{- if .Values.gateway.verboseLogging }}\n  access_log   /dev/stderr  main;\n  {{- else }}\n\n  map $status $loggable {\n    ~^[23]  0;\n    default 1;\n  }\n  access_log   /dev/stderr  main  if=$loggable;\n  {{- end }}\n\n  sendfile     on;\n  tcp_nopush   on;\n  resolver {{ .Values.global.dnsService }}.{{ .Values.global.dnsNamespace }}.svc.{{ .Values.global.clusterDomain }};\n\n  {{- with .Values.gateway.nginxConfig.httpSnippet }}\n  {{ . | nindent 2 }}\n  {{- end }}\n\n  server {\n    listen             8080;\n\n    {{- if .Values.gateway.basicAuth.enabled }}\n    auth_basic           \"Loki\";\n    auth_basic_user_file /etc/nginx/secrets/.htpasswd;\n    {{- end }}\n\n    location = / {\n      return 200 'OK';\n      auth_basic off;\n    }\n\n    location = /api/prom/push {\n      proxy_pass       http://{{ include \"loki.distributorFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location = /api/prom/tail {\n      proxy_pass       http://{{ include \"loki.querierFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n      proxy_set_header Upgrade $http_upgrade;\n      proxy_set_header Connection \"upgrade\";\n    }\n\n    location ~ /api/prom/.* {\n      proxy_pass       http://{{ include \"loki.queryFrontendFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location = /loki/api/v1/push {\n      proxy_pass       http://{{ include \"loki.distributorFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location = /loki/api/v1/tail {\n      proxy_pass       http://{{ include \"loki.querierFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n      proxy_set_header Upgrade $http_upgrade;\n      proxy_set_header Connection \"upgrade\";\n    }\n\n    location ~ /loki/api/.* {\n      proxy_pass       http://{{ include \"loki.queryFrontendFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    {{- with .Values.gateway.nginxConfig.serverSnippet }}\n    {{ . | nindent 4 }}\n    {{- end }}\n  }\n}\n"` |  |
| gateway.nginxConfig.httpSnippet | string | `""` |  |
| gateway.nginxConfig.logFormat | string | `"main '$remote_addr - $remote_user [$time_local]  $status '\n        '\"$request\" $body_bytes_sent \"$http_referer\" '\n        '\"$http_user_agent\" \"$http_x_forwarded_for\"';"` |  |
| gateway.nginxConfig.serverSnippet | string | `""` |  |
| gateway.nodeSelector | object | `{}` |  |
| gateway.podAnnotations | object | `{}` |  |
| gateway.podLabels | object | `{}` |  |
| gateway.podSecurityContext.fsGroup | int | `101` |  |
| gateway.podSecurityContext.runAsGroup | int | `101` |  |
| gateway.podSecurityContext.runAsNonRoot | bool | `true` |  |
| gateway.podSecurityContext.runAsUser | int | `101` |  |
| gateway.priorityClassName | string | `nil` |  |
| gateway.readinessProbe.httpGet.path | string | `"/"` |  |
| gateway.readinessProbe.httpGet.port | string | `"http"` |  |
| gateway.readinessProbe.initialDelaySeconds | int | `15` |  |
| gateway.readinessProbe.timeoutSeconds | int | `1` |  |
| gateway.replicas | int | `1` |  |
| gateway.resources | object | `{}` |  |
| gateway.service.annotations | object | `{}` |  |
| gateway.service.clusterIP | string | `nil` |  |
| gateway.service.labels | object | `{}` |  |
| gateway.service.loadBalancerIP | string | `nil` |  |
| gateway.service.nodePort | string | `nil` |  |
| gateway.service.port | int | `80` |  |
| gateway.service.type | string | `"ClusterIP"` |  |
| gateway.terminationGracePeriodSeconds | int | `30` |  |
| gateway.tolerations | list | `[]` |  |
| gateway.verboseLogging | bool | `true` |  |
| global.clusterDomain | string | `"cluster.local"` |  |
| global.dnsNamespace | string | `"kube-system"` |  |
| global.dnsService | string | `"kube-dns"` |  |
| global.image.registry | string | `nil` |  |
| global.priorityClassName | string | `nil` |  |
| imagePullSecrets | list | `[]` | Image pull secrets for Docker images |
| indexGateway.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"loki.indexGatewaySelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"loki.indexGatewaySelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| indexGateway.enabled | bool | `false` |  |
| indexGateway.extraArgs | list | `[]` |  |
| indexGateway.extraContainers | list | `[]` |  |
| indexGateway.extraEnv | list | `[]` |  |
| indexGateway.extraEnvFrom | list | `[]` |  |
| indexGateway.extraVolumeMounts | list | `[]` |  |
| indexGateway.extraVolumes | list | `[]` |  |
| indexGateway.image.registry | string | `nil` |  |
| indexGateway.image.repository | string | `nil` |  |
| indexGateway.image.tag | string | `nil` |  |
| indexGateway.nodeSelector | object | `{}` |  |
| indexGateway.persistence.enabled | bool | `false` |  |
| indexGateway.persistence.size | string | `"10Gi"` |  |
| indexGateway.persistence.storageClass | string | `nil` |  |
| indexGateway.podAnnotations | object | `{}` |  |
| indexGateway.podLabels | object | `{}` |  |
| indexGateway.priorityClassName | string | `nil` |  |
| indexGateway.replicas | int | `1` |  |
| indexGateway.resources | object | `{}` |  |
| indexGateway.serviceLabels | object | `{}` |  |
| indexGateway.terminationGracePeriodSeconds | int | `300` |  |
| indexGateway.tolerations | list | `[]` |  |
| ingester.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"loki.ingesterSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"loki.ingesterSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| ingester.extraArgs | list | `[]` |  |
| ingester.extraContainers | list | `[]` |  |
| ingester.extraEnv | list | `[]` |  |
| ingester.extraEnvFrom | list | `[]` |  |
| ingester.extraVolumeMounts | list | `[]` |  |
| ingester.extraVolumes | list | `[]` |  |
| ingester.image.registry | string | `nil` |  |
| ingester.image.repository | string | `nil` |  |
| ingester.image.tag | string | `nil` |  |
| ingester.kind | string | `"StatefulSet"` |  |
| ingester.nodeSelector | object | `{}` |  |
| ingester.persistence.enabled | bool | `false` |  |
| ingester.persistence.size | string | `"10Gi"` |  |
| ingester.persistence.storageClass | string | `nil` |  |
| ingester.podAnnotations | object | `{}` |  |
| ingester.podLabels | object | `{}` |  |
| ingester.priorityClassName | string | `nil` |  |
| ingester.replicas | int | `1` |  |
| ingester.resources | object | `{}` |  |
| ingester.serviceLabels | object | `{}` |  |
| ingester.terminationGracePeriodSeconds | int | `300` |  |
| ingester.tolerations | list | `[]` |  |
| loki.annotations | object | `{}` |  |
| loki.config | string | `"auth_enabled: false\n\nserver:\n  http_listen_port: 3100\n\ndistributor:\n  ring:\n    kvstore:\n      store: memberlist\n\nmemberlist:\n  join_members:\n    - {{ include \"loki.fullname\" . }}-memberlist\n\ningester:\n  lifecycler:\n    ring:\n      kvstore:\n        store: memberlist\n      replication_factor: 1\n  chunk_idle_period: 30m\n  chunk_block_size: 262144\n  chunk_encoding: snappy\n  chunk_retain_period: 1m\n  max_transfer_retries: 0\n  wal:\n    dir: /var/loki/wal\n\nlimits_config:\n  enforce_metric_name: false\n  reject_old_samples: true\n  reject_old_samples_max_age: 168h\n  max_cache_freshness_per_query: 10m\n  split_queries_by_interval: 15m\n\n{{- if .Values.loki.schemaConfig}}\nschema_config:\n{{- toYaml .Values.loki.schemaConfig | nindent 2}}\n{{- end}}\n{{- if .Values.loki.storageConfig}}\nstorage_config:\n{{- if .Values.indexGateway.enabled}}\n{{- $indexGatewayClient := dict \"server_address\" (printf \"dns:///%s:9095\" (include \"loki.indexGatewayFullname\" .)) }}\n{{- $_ := set .Values.loki.storageConfig.boltdb_shipper \"index_gateway_client\" $indexGatewayClient }}\n{{- end}}\n{{- toYaml .Values.loki.storageConfig | nindent 2}}\n{{- end}}\n\nchunk_store_config:\n  max_look_back_period: 0s\n\ntable_manager:\n  retention_deletes_enabled: false\n  retention_period: 0s\n\nquery_range:\n  align_queries_with_step: true\n  max_retries: 5\n  cache_results: true\n  results_cache:\n    cache:\n      enable_fifocache: true\n      fifocache:\n        max_size_items: 1024\n        validity: 24h\n\nfrontend_worker:\n  frontend_address: {{ include \"loki.queryFrontendFullname\" . }}:9095\n\nfrontend:\n  log_queries_longer_than: 5s\n  compress_responses: true\n  tail_proxy_url: http://{{ include \"loki.querierFullname\" . }}:3100\n\ncompactor:\n  shared_store: filesystem\n\nruler:\n  storage:\n    type: local\n    local:\n      directory: /etc/loki/rules\n  ring:\n    kvstore:\n      store: memberlist\n  rule_path: /tmp/loki/scratch\n  alertmanager_url: https://alertmanager.xx\n  external_url: https://alertmanager.xx\n"` |  |
| loki.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| loki.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| loki.containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| loki.existingSecretForConfig | string | `""` |  |
| loki.image.pullPolicy | string | `"IfNotPresent"` |  |
| loki.image.registry | string | `"docker.io"` |  |
| loki.image.repository | string | `"grafana/loki"` |  |
| loki.image.tag | string | `nil` |  |
| loki.podAnnotations | object | `{}` |  |
| loki.podLabels | object | `{}` |  |
| loki.podSecurityContext.fsGroup | int | `10001` |  |
| loki.podSecurityContext.runAsGroup | int | `10001` |  |
| loki.podSecurityContext.runAsNonRoot | bool | `true` |  |
| loki.podSecurityContext.runAsUser | int | `10001` |  |
| loki.readinessProbe.httpGet.path | string | `"/ready"` |  |
| loki.readinessProbe.httpGet.port | string | `"http"` |  |
| loki.readinessProbe.initialDelaySeconds | int | `30` |  |
| loki.readinessProbe.timeoutSeconds | int | `1` |  |
| loki.revisionHistoryLimit | int | `10` |  |
| loki.schemaConfig | object | `{"configs":[{"from":"2020-09-07","index":{"period":"24h","prefix":"loki_index_"},"object_store":"filesystem","schema":"v11","store":"boltdb-shipper"}]}` | Check https://grafana.com/docs/loki/latest/configuration/#schema_config for more info on how to configure schemas |
| loki.storageConfig | object | `{"boltdb_shipper":{"active_index_directory":"/var/loki/index","cache_location":"/var/loki/cache","cache_ttl":"168h","shared_store":"filesystem"},"filesystem":{"directory":"/var/loki/chunks"}}` | Check https://grafana.com/docs/loki/latest/configuration/#storage_config for more info on how to configure storages |
| loki.structuredConfig | object | `{}` | Structured loki configuration, takes precedence over `loki.config`, `loki.schemaConfig`, `loki.storageConfig` |
| memcached.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| memcached.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| memcached.containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| memcached.image.pullPolicy | string | `"IfNotPresent"` |  |
| memcached.image.registry | string | `"docker.io"` |  |
| memcached.image.repository | string | `"memcached"` |  |
| memcached.image.tag | string | `"1.6.7-alpine"` |  |
| memcached.podLabels | object | `{}` |  |
| memcached.podSecurityContext.fsGroup | int | `11211` |  |
| memcached.podSecurityContext.runAsGroup | int | `11211` |  |
| memcached.podSecurityContext.runAsNonRoot | bool | `true` |  |
| memcached.podSecurityContext.runAsUser | int | `11211` |  |
| memcachedChunks.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"loki.memcachedChunksSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"loki.memcachedChunksSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| memcachedChunks.enabled | bool | `false` |  |
| memcachedChunks.extraArgs[0] | string | `"-I 32m"` |  |
| memcachedChunks.extraContainers | list | `[]` |  |
| memcachedChunks.extraEnv | list | `[]` |  |
| memcachedChunks.extraEnvFrom | list | `[]` |  |
| memcachedChunks.nodeSelector | object | `{}` |  |
| memcachedChunks.podAnnotations | object | `{}` |  |
| memcachedChunks.podLabels | object | `{}` |  |
| memcachedChunks.priorityClassName | string | `nil` |  |
| memcachedChunks.replicas | int | `1` |  |
| memcachedChunks.resources | object | `{}` |  |
| memcachedChunks.serviceLabels | object | `{}` |  |
| memcachedChunks.terminationGracePeriodSeconds | int | `30` |  |
| memcachedChunks.tolerations | list | `[]` |  |
| memcachedExporter.enabled | bool | `false` |  |
| memcachedExporter.image.pullPolicy | string | `"IfNotPresent"` |  |
| memcachedExporter.image.registry | string | `"docker.io"` |  |
| memcachedExporter.image.repository | string | `"prom/memcached-exporter"` |  |
| memcachedExporter.image.tag | string | `"v0.6.0"` |  |
| memcachedExporter.podLabels | object | `{}` |  |
| memcachedExporter.resources | object | `{}` |  |
| memcachedFrontend.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"loki.memcachedFrontendSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"loki.memcachedFrontendSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| memcachedFrontend.enabled | bool | `false` |  |
| memcachedFrontend.extraArgs[0] | string | `"-I 32m"` |  |
| memcachedFrontend.extraContainers | list | `[]` |  |
| memcachedFrontend.extraEnv | list | `[]` |  |
| memcachedFrontend.extraEnvFrom | list | `[]` |  |
| memcachedFrontend.nodeSelector | object | `{}` |  |
| memcachedFrontend.podAnnotations | object | `{}` |  |
| memcachedFrontend.podLabels | object | `{}` |  |
| memcachedFrontend.priorityClassName | string | `nil` |  |
| memcachedFrontend.replicas | int | `1` |  |
| memcachedFrontend.resources | object | `{}` |  |
| memcachedFrontend.serviceLabels | object | `{}` |  |
| memcachedFrontend.terminationGracePeriodSeconds | int | `30` |  |
| memcachedFrontend.tolerations | list | `[]` |  |
| memcachedIndexQueries.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"loki.memcachedIndexQueriesSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"loki.memcachedIndexQueriesSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| memcachedIndexQueries.enabled | bool | `false` |  |
| memcachedIndexQueries.extraArgs[0] | string | `"-I 32m"` |  |
| memcachedIndexQueries.extraContainers | list | `[]` |  |
| memcachedIndexQueries.extraEnv | list | `[]` |  |
| memcachedIndexQueries.extraEnvFrom | list | `[]` |  |
| memcachedIndexQueries.nodeSelector | object | `{}` |  |
| memcachedIndexQueries.podAnnotations | object | `{}` |  |
| memcachedIndexQueries.podLabels | object | `{}` |  |
| memcachedIndexQueries.priorityClassName | string | `nil` |  |
| memcachedIndexQueries.replicas | int | `1` |  |
| memcachedIndexQueries.resources | object | `{}` |  |
| memcachedIndexQueries.serviceLabels | object | `{}` |  |
| memcachedIndexQueries.terminationGracePeriodSeconds | int | `30` |  |
| memcachedIndexQueries.tolerations | list | `[]` |  |
| memcachedIndexWrites.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"loki.memcachedIndexWritesSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"loki.memcachedIndexWritesSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| memcachedIndexWrites.enabled | bool | `false` |  |
| memcachedIndexWrites.extraArgs[0] | string | `"-I 32m"` |  |
| memcachedIndexWrites.extraContainers | list | `[]` |  |
| memcachedIndexWrites.extraEnv | list | `[]` |  |
| memcachedIndexWrites.extraEnvFrom | list | `[]` |  |
| memcachedIndexWrites.nodeSelector | object | `{}` |  |
| memcachedIndexWrites.podAnnotations | object | `{}` |  |
| memcachedIndexWrites.podLabels | object | `{}` |  |
| memcachedIndexWrites.priorityClassName | string | `nil` |  |
| memcachedIndexWrites.replicas | int | `1` |  |
| memcachedIndexWrites.resources | object | `{}` |  |
| memcachedIndexWrites.serviceLabels | object | `{}` |  |
| memcachedIndexWrites.terminationGracePeriodSeconds | int | `30` |  |
| memcachedIndexWrites.tolerations | list | `[]` |  |
| nameOverride | string | `nil` | Overrides the chart's name |
| networkPolicy.alertmanager.namespaceSelector | object | `{}` |  |
| networkPolicy.alertmanager.podSelector | object | `{}` |  |
| networkPolicy.alertmanager.port | int | `9093` |  |
| networkPolicy.discovery.namespaceSelector | object | `{}` |  |
| networkPolicy.discovery.podSelector | object | `{}` |  |
| networkPolicy.discovery.port | string | `nil` |  |
| networkPolicy.enabled | bool | `false` |  |
| networkPolicy.externalStorage.cidrs | list | `[]` |  |
| networkPolicy.externalStorage.ports | list | `[]` |  |
| networkPolicy.ingress.namespaceSelector | object | `{}` |  |
| networkPolicy.ingress.podSelector | object | `{}` |  |
| networkPolicy.metrics.cidrs | list | `[]` |  |
| networkPolicy.metrics.namespaceSelector | object | `{}` |  |
| networkPolicy.metrics.podSelector | object | `{}` |  |
| prometheusRule.annotations | object | `{}` |  |
| prometheusRule.enabled | bool | `false` |  |
| prometheusRule.groups | list | `[]` |  |
| prometheusRule.labels | object | `{}` |  |
| prometheusRule.namespace | string | `nil` |  |
| querier.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"loki.querierSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"loki.querierSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| querier.autoscaling.enabled | bool | `false` |  |
| querier.autoscaling.maxReplicas | int | `3` |  |
| querier.autoscaling.minReplicas | int | `1` |  |
| querier.autoscaling.targetCPUUtilizationPercentage | int | `60` |  |
| querier.autoscaling.targetMemoryUtilizationPercentage | string | `nil` |  |
| querier.extraArgs | list | `[]` |  |
| querier.extraContainers | list | `[]` |  |
| querier.extraEnv | list | `[]` |  |
| querier.extraEnvFrom | list | `[]` |  |
| querier.extraVolumeMounts | list | `[]` |  |
| querier.extraVolumes | list | `[]` |  |
| querier.image.registry | string | `nil` |  |
| querier.image.repository | string | `nil` |  |
| querier.image.tag | string | `nil` |  |
| querier.nodeSelector | object | `{}` |  |
| querier.persistence.enabled | bool | `false` |  |
| querier.persistence.size | string | `"10Gi"` |  |
| querier.persistence.storageClass | string | `nil` |  |
| querier.podAnnotations | object | `{}` |  |
| querier.podLabels | object | `{}` |  |
| querier.priorityClassName | string | `nil` |  |
| querier.replicas | int | `1` |  |
| querier.resources | object | `{}` |  |
| querier.serviceLabels | object | `{}` |  |
| querier.terminationGracePeriodSeconds | int | `30` |  |
| querier.tolerations | list | `[]` |  |
| queryFrontend.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"loki.queryFrontendSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"loki.queryFrontendSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| queryFrontend.autoscaling.enabled | bool | `false` |  |
| queryFrontend.autoscaling.maxReplicas | int | `3` |  |
| queryFrontend.autoscaling.minReplicas | int | `1` |  |
| queryFrontend.autoscaling.targetCPUUtilizationPercentage | int | `60` |  |
| queryFrontend.autoscaling.targetMemoryUtilizationPercentage | string | `nil` |  |
| queryFrontend.extraArgs | list | `[]` |  |
| queryFrontend.extraContainers | list | `[]` |  |
| queryFrontend.extraEnv | list | `[]` |  |
| queryFrontend.extraEnvFrom | list | `[]` |  |
| queryFrontend.extraVolumeMounts | list | `[]` |  |
| queryFrontend.extraVolumes | list | `[]` |  |
| queryFrontend.image.registry | string | `nil` |  |
| queryFrontend.image.repository | string | `nil` |  |
| queryFrontend.image.tag | string | `nil` |  |
| queryFrontend.nodeSelector | object | `{}` |  |
| queryFrontend.podAnnotations | object | `{}` |  |
| queryFrontend.podLabels | object | `{}` |  |
| queryFrontend.priorityClassName | string | `nil` |  |
| queryFrontend.replicas | int | `1` |  |
| queryFrontend.resources | object | `{}` |  |
| queryFrontend.serviceLabels | object | `{}` |  |
| queryFrontend.terminationGracePeriodSeconds | int | `30` |  |
| queryFrontend.tolerations | list | `[]` |  |
| rbac.pspEnabled | bool | `false` |  |
| rbac.sccEnabled | bool | `false` |  |
| ruler.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"loki.rulerSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"loki.rulerSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| ruler.directories | object | `{}` |  |
| ruler.enabled | bool | `false` |  |
| ruler.extraArgs | list | `[]` |  |
| ruler.extraContainers | list | `[]` |  |
| ruler.extraEnv | list | `[]` |  |
| ruler.extraEnvFrom | list | `[]` |  |
| ruler.extraVolumeMounts | list | `[]` |  |
| ruler.extraVolumes | list | `[]` |  |
| ruler.image.registry | string | `nil` |  |
| ruler.image.repository | string | `nil` |  |
| ruler.image.tag | string | `nil` |  |
| ruler.kind | string | `"Deployment"` |  |
| ruler.nodeSelector | object | `{}` |  |
| ruler.persistence.enabled | bool | `false` |  |
| ruler.persistence.size | string | `"10Gi"` |  |
| ruler.persistence.storageClass | string | `nil` |  |
| ruler.podAnnotations | object | `{}` |  |
| ruler.podLabels | object | `{}` |  |
| ruler.priorityClassName | string | `nil` |  |
| ruler.replicas | int | `1` |  |
| ruler.resources | object | `{}` |  |
| ruler.serviceLabels | object | `{}` |  |
| ruler.terminationGracePeriodSeconds | int | `300` |  |
| ruler.tolerations | list | `[]` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.imagePullSecrets | list | `[]` |  |
| serviceAccount.name | string | `nil` |  |
| serviceMonitor.annotations | object | `{}` |  |
| serviceMonitor.enabled | bool | `false` |  |
| serviceMonitor.interval | string | `nil` |  |
| serviceMonitor.labels | object | `{}` |  |
| serviceMonitor.metricRelabelings | list | `[]` |  |
| serviceMonitor.namespace | string | `nil` |  |
| serviceMonitor.namespaceSelector | object | `{}` |  |
| serviceMonitor.relabelings | list | `[]` |  |
| serviceMonitor.scheme | string | `"http"` |  |
| serviceMonitor.scrapeTimeout | string | `nil` |  |
| serviceMonitor.tlsConfig | string | `nil` |  |
| tableManager.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"loki.tableManagerSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"loki.tableManagerSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| tableManager.enabled | bool | `false` |  |
| tableManager.extraArgs | list | `[]` |  |
| tableManager.extraContainers | list | `[]` |  |
| tableManager.extraEnv | list | `[]` |  |
| tableManager.extraEnvFrom | list | `[]` |  |
| tableManager.extraVolumeMounts | list | `[]` |  |
| tableManager.extraVolumes | list | `[]` |  |
| tableManager.image.registry | string | `nil` |  |
| tableManager.image.repository | string | `nil` |  |
| tableManager.image.tag | string | `nil` |  |
| tableManager.nodeSelector | object | `{}` |  |
| tableManager.podAnnotations | object | `{}` |  |
| tableManager.podLabels | object | `{}` |  |
| tableManager.priorityClassName | string | `nil` |  |
| tableManager.resources | object | `{}` |  |
| tableManager.serviceLabels | object | `{}` |  |
| tableManager.terminationGracePeriodSeconds | int | `30` |  |
| tableManager.tolerations | list | `[]` |  |

## Components

The chart supports the components shown in the following table.
Ingester, distributor, querier, and query-frontend are always installed.
The other components are optional.

| Component | Optional | Enabled by default |
| --- | --- | --- |
| gateway |  ✅ |  ✅ |
| ingester |  ❎ | n/a |
| distributor |  ❎ | n/a |
| querier |  ❎ | n/a |
| query-frontend |  ❎ | n/a |
| table-manager |  ✅ |  ❎ |
| compactor |  ✅ |  ❎ |
| ruler |  ✅ |  ❎ |
| index-gateway |  ✅ |  ❎ |
| memcached-chunks |  ✅ |  ❎ |
| memcached-frontend |  ✅ |  ❎ |
| memcached-index-queries |  ✅ |  ❎ |
| memcached-index-writes |  ✅ |  ❎ |

## Configuration

This chart configures Loki in microservices mode.
It has been tested to work with [boltdb-shipper](https://grafana.com/docs/loki/latest/operations/storage/boltdb-shipper/)
and [memberlist](https://grafana.com/docs/loki/latest/configuration/#memberlist_config) while other storage and discovery options should work as well.
However, the chart does not support setting up Consul or Etcd for discovery,
and it is not intended to support these going forward.
They would have to be set up separately.
Instead, memberlist can be used which does not require a separate key/value store.
The chart creates a headless service for the memberlist which ingester, distributor, querier, and ruler are part of.

----

**NOTE:**
In its default configuration, the chart uses `boltdb-shipper` and `filesystem` as storage.
The reason for this is that the chart can be validated and installed in a CI pipeline.
However, this setup is not fully functional.
Querying will not be possible (or limited to the ingesters' in-memory caches) because that would otherwise require shared storage between ingesters and queriers
which the chart does not support and would require a volume that supports `ReadWriteMany` access mode anyways.
The recommendation is to use object storage, such as S3, GCS, MinIO, etc., or one of the other options documented at https://grafana.com/docs/loki/latest/storage/.

Alternatively, in order to quickly test Loki using the filestore, the [single binary chart](https://github.com/grafana/helm-charts/tree/main/charts/loki) can be used.

----

### Directory and File Locations

* Volumes are mounted to `/var/loki`. The various directories Loki needs should be configured as subdirectories (e. g. `/var/loki/index`, `/var/loki/cache`). Loki will create the directories automatically.
* The config file is mounted to `/etc/loki/config/config.yaml` and passed as CLI arg.

### Example configuration using memberlist, boltdb-shipper, and S3 for storage

```yaml
loki:
  structuredConfig:
    ingester:
      # Disable chunk transfer which is not possible with statefulsets
      # and unnecessary for boltdb-shipper
      max_transfer_retries: 0
      chunk_idle_period: 1h
      chunk_target_size: 1536000
      max_chunk_age: 1h
    storage_config:
      aws:
        s3: s3://eu-central-1
        bucketnames: my-loki-s3-bucket
      boltdb_shipper:
        shared_store: s3
    schema_config:
      configs:
        - from: 2020-09-07
          store: boltdb-shipper
          object_store: aws
          schema: v11
          index:
            prefix: loki_index_
            period: 24h
```

The above configuration selectively overrides default values found in the `loki.config` template file.

Using `loki.structuredConfig` it is possible to externally set most any configuration parameter (special considerations for elements of an array).

```
helm upgrade loki --install -f values.yaml --set loki.structuredConfig.storage_config.aws.bucketnames=my-loki-bucket
```

`loki.config`, `loki.schemaConfig` and `loki.storageConfig` may also be used in conjuction with `loki.structuredConfig`. Values found in `loki.structuredConfig` will take precedence. Array values, such as those found in `loki.schema_config` will be overridden wholesale and not amended to.

For `loki.schema_config` its generally expected that this will always be configured per usage as its values over time are in reference to the history of loki schema versions and schema configurations throughout the lifetime of a given loki instance.

Note that when using `loki.config` must be configured as string.
That's required because it is passed through the `tpl` function in order to support templating.

When using `loki.config` the passed in template must include template sections for `loki.schemaConfig` and `loki.storageConfig` for those to continue to work as expected.

Because the config file is templated, it is also possible to reference other values provided to helm e.g. externalize S3 bucket names:

```yaml
loki:
  config: |
    storage_config:
      aws:
        s3: s3://eu-central-1
        bucketnames: {{ .Values.bucketnames }}
```

```console
helm upgrade loki --install -f values.yaml --set bucketnames=my-loki-bucket
```

## Gateway

By default and inspired by Grafana's [Tanka setup](https://github.com/grafana/loki/tree/master/production/ksonnet/loki), the chart installs the gateway component which is an NGINX that exposes Loki's API
and automatically proxies requests to the correct Loki components (distributor, querier, query-frontend).
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

The chart can configure up to four Memcached instances for the various caches Lokis can use.
Configuration works the same for all caches.
The configuration of `memcached-chunks` below demonstrates setting additional options.

Exporters for the Memcached instances can be configured as well.

```yaml
memcachedExporter:
  enabled: true
```

### memcached-chunks

```yaml
memcachedChunks:
  enabled: true
  replicas: 2
  extraArgs:
    - -m 2048
    - -I 2m
    - -v
  resources:
    requests:
      cpu: 500m
      memory: 3Gi
    limits:
      cpu: "2"
      memory: 3Gi

loki:
  config: |
    chunk_store_config:
      chunk_cache_config:
        memcached:
          batch_size: 100
          parallelism: 100
        memcached_client:
          consistent_hash: true
          host: {{ include "loki.memcachedChunksFullname" . }}
          service: http
```

### memcached-frontend

```yaml
memcachedFrontend:
  enabled: true

loki:
  config: |
    query_range:
      cache_results: true
      results_cache:
        cache:
          memcached_client:
            consistent_hash: true
            host: {{ include "loki.memcachedFrontendFullname" . }}
            max_idle_conns: 16
            service: http
            timeout: 500ms
            update_interval: 1m
```

### memcached-index-queries

```yaml
memcachedIndexQueries:
  enabled: true

loki:
  config: |
    storage_config:
      index_queries_cache_config:
        memcached:
          batch_size: 100
          parallelism: 100
        memcached_client:
          consistent_hash: true
          host: {{ include "loki.memcachedIndexQueriesFullname" . }}
          service: http
```

### memcached-index-writes

NOTE: This cache is not used with `boltdb-shipper` and should not be enabled in that case.

```yaml
memcachedIndexWrite:
  enabled: true

loki:
  config: |
    chunk_store_config:
      write_dedupe_cache_config:
        memcached:
          batch_size: 100
          parallelism: 100
        memcached_client:
          consistent_hash: true
          host: {{ include "loki.memcachedIndexWritesFullname" . }}
          service: http
```

## Compactor

Compactor is an optional component which must explicitly be enabled.
The chart automatically sets the correct working directory as command-line arg.
The correct storage backend must be configured, e.g. `s3`.

```yaml
compactor:
  enabled: true

loki:
  config: |
    compactor:
      shared_store: s3
```

## Ruler

Ruler is an optional component which must explicitly be enabled.
In addition to installing the ruler, the chart also supports creating rules.
Rules files must be added to directories named after the tenants.
See `values.yaml` for a more detailed example.

```yaml
ruler:
  enabled: true
  directories:
    fake:
      rules.txt: |
        groups:
          - name: should_fire
            rules:
              - alert: HighPercentageError
                expr: |
                  sum(rate({app="loki"} |= "error" [5m])) by (job)
                    /
                  sum(rate({app="loki"}[5m])) by (job)
                    > 0.05
                for: 10m
                labels:
                  severity: warning
                annotations:
                  summary: High error percentage
```
