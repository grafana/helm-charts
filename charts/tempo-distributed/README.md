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
| compactor.config.compaction.block_retention | string | `"48h"` |  |
| compactor.extraArgs | list | `[]` |  |
| compactor.extraEnv | list | `[]` |  |
| compactor.extraEnvFrom | list | `[]` |  |
| compactor.extraVolumeMounts | list | `[]` |  |
| compactor.extraVolumes | list | `[]` |  |
| compactor.image.registry | string | `nil` |  |
| compactor.image.repository | string | `nil` |  |
| compactor.image.tag | string | `nil` |  |
| compactor.nodeSelector | object | `{}` |  |
| compactor.podAnnotations | object | `{}` |  |
| compactor.podLabels | object | `{}` |  |
| compactor.priorityClassName | string | `nil` |  |
| compactor.resources | object | `{}` |  |
| compactor.terminationGracePeriodSeconds | int | `30` |  |
| compactor.tolerations | list | `[]` |  |
| config | string | `"multitenancy_enabled: false\nsearch_enabled: {{ .Values.search.enabled }}\ncompactor:\n  compaction:\n    block_retention: {{ .Values.compactor.config.compaction.block_retention }}\n  ring:\n    kvstore:\n      store: memberlist\ndistributor:\n  ring:\n    kvstore:\n      store: memberlist\n  receivers:\n    {{- if  or (.Values.traces.jaeger.thriftCompact) (.Values.traces.jaeger.thriftBinary) (.Values.traces.jaeger.thriftHttp) (.Values.traces.jaeger.grpc) }}\n    jaeger:\n      protocols:\n        {{- if .Values.traces.jaeger.thriftCompact }}\n        thrift_compact:\n          endpoint: 0.0.0.0:6831\n        {{- end }}\n        {{- if .Values.traces.jaeger.thriftBinary }}\n        thrift_binary:\n          endpoint: 0.0.0.0:6832\n        {{- end }}\n        {{- if .Values.traces.jaeger.thriftHttp }}\n        thrift_http:\n          endpoint: 0.0.0.0:14268\n        {{- end }}\n        {{- if .Values.traces.jaeger.grpc }}\n        grpc:\n          endpoint: 0.0.0.0:14250\n        {{- end }}\n    {{- end }}\n    {{- if .Values.traces.zipkin}}\n    zipkin:\n      endpoint: 0.0.0.0:9411\n    {{- end }}\n    {{- if or (.Values.traces.otlp.http) (.Values.traces.otlp.grpc) }}\n    otlp:\n      protocols:\n        {{- if .Values.traces.otlp.http }}\n        http:\n          endpoint: 0.0.0.0:55681\n        {{- end }}\n        {{- if .Values.traces.otlp.grpc }}\n        grpc:\n          endpoint: 0.0.0.0:4317\n        {{- end }}\n    {{- end }}\n    {{- if .Values.traces.opencensus }}\n    opencensus:\n      endpoint: 0.0.0.0:55678\n    {{- end }}\n    {{- if .Values.traces.kafka }}\n    kafka:\n      {{- toYaml .Values.traces.kafka | nindent 6 }}\n    {{- end }}\nquerier:\n  frontend_worker:\n    frontend_address: {{ include \"tempo.queryFrontendFullname\" . }}-discovery:9095\n    {{- if .Values.querier.config.frontend_worker.grpc_client_config }}\n    grpc_client_config:\n      {{- toYaml .Values.querier.config.frontend_worker.grpc_client_config | nindent 6 }}\n    {{- end }}\ningester:\n  lifecycler:\n    ring:\n      replication_factor: 1\n      kvstore:\n        store: memberlist\n    tokens_file_path: /var/tempo/tokens.json\n  {{- if .Values.ingester.config.maxBlockBytes }}\n  max_block_bytes: {{ .Values.ingester.config.maxBlockBytes }}\n  {{- end }}\n  {{- if .Values.ingester.config.maxBlockDuration }}\n  max_block_duration: {{ .Values.ingester.config.maxBlockDuration }}\n  {{- end }}\n  {{- if .Values.ingester.config.completeBlockTimeout }}\n  complete_block_timeout: {{ .Values.ingester.config.completeBlockTimeout }}\n  {{- end }}\nmemberlist:\n  abort_if_cluster_join_fails: false\n  join_members:\n    - {{ include \"tempo.fullname\" . }}-gossip-ring\noverrides:\n  {{- toYaml .Values.global_overrides | nindent 2 }}\nserver:\n  http_listen_port: {{ .Values.server.httpListenPort }}\n  log_level: {{ .Values.server.logLevel }}\n  log_format: {{ .Values.server.logFormat }}\n  grpc_server_max_recv_msg_size: {{ .Values.server.grpc_server_max_recv_msg_size }}\n  grpc_server_max_send_msg_size: {{ .Values.server.grpc_server_max_send_msg_size }}\nstorage:\n  trace:\n    backend: {{.Values.storage.trace.backend}}\n    {{- if eq .Values.storage.trace.backend \"gcs\"}}\n    gcs:\n      {{- toYaml .Values.storage.trace.gcs | nindent 6}}\n    {{- end}}\n    {{- if eq .Values.storage.trace.backend \"s3\"}}\n    s3:\n      {{- toYaml .Values.storage.trace.s3 | nindent 6}}\n    {{- end}}\n    {{- if eq .Values.storage.trace.backend \"azure\"}}\n    azure:\n      {{- toYaml .Values.storage.trace.azure | nindent 6}}\n    {{- end}}\n    blocklist_poll: 5m\n    local:\n      path: /var/tempo/traces\n    wal:\n      path: /var/tempo/wal\n    cache: memcached\n    memcached:\n      consistent_hash: true\n      host: {{ include \"tempo.fullname\" . }}-memcached\n      service: memcached-client\n      timeout: 500ms\n"` |  |
| distributor.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"tempo.distributorSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"tempo.distributorSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| distributor.extraArgs | list | `[]` |  |
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
| distributor.service.annotations | object | `{}` |  |
| distributor.service.loadBalancerIP | string | `""` |  |
| distributor.service.loadBalancerSourceRanges | list | `[]` |  |
| distributor.service.type | string | `"ClusterIP"` |  |
| distributor.terminationGracePeriodSeconds | int | `30` |  |
| distributor.tolerations | list | `[]` |  |
| gateway.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"tempo.gatewaySelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"tempo.gatewaySelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| gateway.basicAuth.enabled | bool | `false` |  |
| gateway.basicAuth.existingSecret | string | `nil` |  |
| gateway.basicAuth.htpasswd | string | `"{{ htpasswd (required \"'gateway.basicAuth.username' is required\" .Values.gateway.basicAuth.username) (required \"'gateway.basicAuth.password' is required\" .Values.gateway.basicAuth.password) }}"` |  |
| gateway.basicAuth.password | string | `nil` |  |
| gateway.basicAuth.username | string | `nil` |  |
| gateway.enabled | bool | `false` |  |
| gateway.extraArgs | list | `[]` |  |
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
| gateway.ingress.hosts[0].host | string | `"gateway.tempo.example.com"` |  |
| gateway.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| gateway.ingress.tls | list | `[{"hosts":["gateway.tempo.example.com"],"secretName":"tempo-gateway-tls"}]` | TLS configuration for the gateway ingress |
| gateway.nginxConfig.file | string | `"worker_processes  5;  ## Default: 1\nerror_log  /dev/stderr;\npid        /tmp/nginx.pid;\nworker_rlimit_nofile 8192;\n\nevents {\n  worker_connections  4096;  ## Default: 1024\n}\n\nhttp {\n  client_body_temp_path /tmp/client_temp;\n  proxy_temp_path       /tmp/proxy_temp_path;\n  fastcgi_temp_path     /tmp/fastcgi_temp;\n  uwsgi_temp_path       /tmp/uwsgi_temp;\n  scgi_temp_path        /tmp/scgi_temp;\n\n  default_type application/octet-stream;\n  log_format   {{ .Values.gateway.nginxConfig.logFormat }}\n\n  {{- if .Values.gateway.verboseLogging }}\n  access_log   /dev/stderr  main;\n  {{- else }}\n\n  map $status $loggable {\n    ~^[23]  0;\n    default 1;\n  }\n  access_log   /dev/stderr  main  if=$loggable;\n  {{- end }}\n\n  sendfile     on;\n  tcp_nopush   on;\n  resolver {{ .Values.global.dnsService }}.{{ .Values.global.dnsNamespace }}.svc.{{ .Values.global.clusterDomain }};\n\n  {{- with .Values.gateway.nginxConfig.httpSnippet }}\n  {{ . | nindent 2 }}\n  {{- end }}\n\n  server {\n    listen             8080;\n\n    {{- if .Values.gateway.basicAuth.enabled }}\n    auth_basic           \"Tempo\";\n    auth_basic_user_file /etc/nginx/secrets/.htpasswd;\n    {{- end }}\n\n    location = / {\n      return 200 'OK';\n      auth_basic off;\n    }\n\n    location = /jaeger/api/traces {\n      proxy_pass       http://{{ include \"tempo.distributorFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:14268/api/traces;\n    }\n\n    location = /zipkin/spans {\n      proxy_pass       http://{{ include \"tempo.distributorFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:9411/spans;\n    }\n\n    location = /otlp/v1/traces {\n      proxy_pass       http://{{ include \"tempo.distributorFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:55681/v1/traces;\n    }\n\n    location ^~ /api {\n      proxy_pass       http://{{ include \"tempo.queryFrontendFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location = /flush {\n      proxy_pass       http://{{ include \"tempo.ingesterFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location = /shutdown {\n      proxy_pass       http://{{ include \"tempo.ingesterFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location = /distributor/ring {\n      proxy_pass       http://{{ include \"tempo.distributorFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location = /ingester/ring {\n      proxy_pass       http://{{ include \"tempo.distributorFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location = /compactor/ring {\n      proxy_pass       http://{{ include \"tempo.compactorFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    {{- with .Values.gateway.nginxConfig.serverSnippet }}\n    {{ . | nindent 4 }}\n    {{- end }}\n  }\n}\n"` |  |
| gateway.nginxConfig.httpSnippet | string | `""` |  |
| gateway.nginxConfig.logFormat | string | `"main '$remote_addr - $remote_user [$time_local]  $status '\n        '\"$request\" $body_bytes_sent \"$http_referer\" '\n        '\"$http_user_agent\" \"$http_x_forwarded_for\"';"` |  |
| gateway.nginxConfig.serverSnippet | string | `""` |  |
| gateway.nodeSelector | object | `{}` |  |
| gateway.podAnnotations | object | `{}` |  |
| gateway.podLabels | object | `{}` |  |
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
| global_overrides.per_tenant_override_config | string | `"/conf/overrides.yaml"` |  |
| ingester.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"tempo.ingesterSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"tempo.ingesterSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| ingester.config.complete_block_timeout | string | `nil` |  |
| ingester.config.max_block_bytes | string | `nil` |  |
| ingester.config.max_block_duration | string | `nil` |  |
| ingester.extraArgs | list | `[]` |  |
| ingester.extraEnv | list | `[]` |  |
| ingester.extraEnvFrom | list | `[]` |  |
| ingester.extraVolumeMounts | list | `[]` |  |
| ingester.extraVolumes | list | `[]` |  |
| ingester.image.registry | string | `nil` |  |
| ingester.image.repository | string | `nil` |  |
| ingester.image.tag | string | `nil` |  |
| ingester.nodeSelector | object | `{}` |  |
| ingester.persistence.enabled | bool | `false` |  |
| ingester.persistence.size | string | `"10Gi"` |  |
| ingester.persistence.storageClass | string | `nil` |  |
| ingester.podAnnotations | object | `{}` |  |
| ingester.podLabels | object | `{}` |  |
| ingester.priorityClassName | string | `nil` |  |
| ingester.replicas | int | `1` |  |
| ingester.resources | object | `{}` |  |
| ingester.terminationGracePeriodSeconds | int | `300` |  |
| ingester.tolerations | list | `[]` |  |
| memcached.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"tempo.memcachedSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"tempo.memcachedSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| memcached.enabled | bool | `true` |  |
| memcached.extraArgs | list | `[]` |  |
| memcached.extraEnv | list | `[]` |  |
| memcached.extraEnvFrom | list | `[]` |  |
| memcached.host | string | `"memcached"` |  |
| memcached.podAnnotations | object | `{}` |  |
| memcached.podLabels | object | `{}` |  |
| memcached.pullPolicy | string | `"IfNotPresent"` |  |
| memcached.replicas | int | `1` |  |
| memcached.repository | string | `"memcached"` |  |
| memcached.resources | object | `{}` |  |
| memcached.service | string | `"memcached-client"` |  |
| memcached.tag | string | `"1.5.17-alpine"` |  |
| memcachedExporter.enabled | bool | `false` |  |
| memcachedExporter.image.pullPolicy | string | `"IfNotPresent"` |  |
| memcachedExporter.image.repository | string | `"prom/memcached-exporter"` |  |
| memcachedExporter.image.tag | string | `"v0.8.0"` |  |
| memcachedExporter.resources | object | `{}` |  |
| overrides | string | `"overrides: {}\n"` |  |
| prometheusRule.annotations | object | `{}` |  |
| prometheusRule.enabled | bool | `false` |  |
| prometheusRule.groups | list | `[]` |  |
| prometheusRule.labels | object | `{}` |  |
| prometheusRule.namespace | string | `nil` |  |
| querier.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"tempo.querierSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"tempo.querierSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| querier.config.frontend_worker.grpc_client_config | object | `{}` |  |
| querier.extraArgs | list | `[]` |  |
| querier.extraEnv | list | `[]` |  |
| querier.extraEnvFrom | list | `[]` |  |
| querier.extraVolumeMounts | list | `[]` |  |
| querier.extraVolumes | list | `[]` |  |
| querier.image.registry | string | `nil` |  |
| querier.image.repository | string | `nil` |  |
| querier.image.tag | string | `nil` |  |
| querier.nodeSelector | object | `{}` |  |
| querier.podAnnotations | object | `{}` |  |
| querier.podLabels | object | `{}` |  |
| querier.priorityClassName | string | `nil` |  |
| querier.replicas | int | `1` |  |
| querier.resources | object | `{}` |  |
| querier.terminationGracePeriodSeconds | int | `30` |  |
| querier.tolerations | list | `[]` |  |
| queryFrontend.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"tempo.queryFrontendSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"tempo.queryFrontendSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| queryFrontend.extraArgs | list | `[]` |  |
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
| queryFrontend.query.config | string | `"backend: 127.0.0.1:3100\n"` |  |
| queryFrontend.query.enabled | bool | `true` |  |
| queryFrontend.query.extraArgs | list | `[]` |  |
| queryFrontend.query.extraEnv | list | `[]` |  |
| queryFrontend.query.extraEnvFrom | list | `[]` |  |
| queryFrontend.query.extraVolumeMounts | list | `[]` |  |
| queryFrontend.query.extraVolumes | list | `[]` |  |
| queryFrontend.query.image.registry | string | `nil` |  |
| queryFrontend.query.image.repository | string | `"grafana/tempo-query"` |  |
| queryFrontend.query.image.tag | string | `nil` |  |
| queryFrontend.query.resources | object | `{}` |  |
| queryFrontend.replicas | int | `1` |  |
| queryFrontend.resources | object | `{}` |  |
| queryFrontend.service.annotations | object | `{}` |  |
| queryFrontend.service.type | string | `"ClusterIP"` |  |
| queryFrontend.serviceDiscovery.annotations | object | `{}` |  |
| queryFrontend.terminationGracePeriodSeconds | int | `30` |  |
| queryFrontend.tolerations | list | `[]` |  |
| rbac.create | bool | `false` |  |
| rbac.pspEnabled | bool | `false` |  |
| search.enabled | bool | `false` |  |
| server.grpc_server_max_recv_msg_size | int | `4194304` |  |
| server.grpc_server_max_send_msg_size | int | `4194304` |  |
| server.httpListenPort | int | `3100` |  |
| server.logFormat | string | `"logfmt"` |  |
| server.logLevel | string | `"info"` |  |
| serviceAccount.annotations | object | `{}` |  |
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
| storage.trace.backend | string | `"local"` |  |
| tempo.image.pullPolicy | string | `"IfNotPresent"` |  |
| tempo.image.registry | string | `"docker.io"` |  |
| tempo.image.repository | string | `"grafana/tempo"` |  |
| tempo.image.tag | string | `nil` |  |
| tempo.podAnnotations | object | `{}` |  |
| tempo.podLabels | object | `{}` |  |
| tempo.readinessProbe.httpGet.path | string | `"/ready"` |  |
| tempo.readinessProbe.httpGet.port | string | `"http"` |  |
| tempo.readinessProbe.initialDelaySeconds | int | `30` |  |
| tempo.readinessProbe.timeoutSeconds | int | `1` |  |
| tempo.securityContext | object | `{}` |  |
| traces.jaeger.grpc | bool | `false` |  |
| traces.jaeger.thriftBinary | bool | `false` |  |
| traces.jaeger.thriftCompact | bool | `false` |  |
| traces.jaeger.thriftHttp | bool | `false` |  |
| traces.kafka | object | `{}` |  |
| traces.opencensus | bool | `false` |  |
| traces.otlp.grpc | bool | `false` |  |
| traces.otlp.http | bool | `false` |  |
| traces.zipkin | bool | `false` |  |

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