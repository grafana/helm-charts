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
| gateway.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"loki.gatewaySelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"loki.gatewaySelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| gateway.autoscaling.enabled | bool | `false` |  |
| gateway.autoscaling.maxReplicas | int | `3` |  |
| gateway.autoscaling.minReplicas | int | `1` |  |
| gateway.autoscaling.targetCPUUtilizationPercentage | int | `60` |  |
| gateway.autoscaling.targetMemoryUtilizationPercentage | string | `nil` |  |
| gateway.basicAuth.enabled | bool | `false` |  |
| gateway.basicAuth.existingSecret | string | `nil` | Existing basic auth secret to use. Must contain '.htpasswd' |
| gateway.basicAuth.htpasswd | string | `"{{ htpasswd (required \"'gateway.basicAuth.username' is required\" .Values.gateway.basicAuth.username) (required \"'gateway.basicAuth.password' is required\" .Values.gateway.basicAuth.password) }}"` |  |
| gateway.basicAuth.password | string | `nil` |  |
| gateway.basicAuth.username | string | `nil` |  |
| gateway.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| gateway.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| gateway.containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| gateway.deploymentStrategy | object | `{"type":"RollingUpdate"}` | ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy |
| gateway.enabled | bool | `true` |  |
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
| gateway.ingress.hosts[0].host | string | `"gateway.loki.example.com"` |  |
| gateway.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| gateway.ingress.tls | list | `[{"hosts":["gateway.loki.example.com"],"secretName":"loki-gateway-tls"}]` | TLS configuration for the gateway ingress |
| gateway.nginxConfig.file | string | `"worker_processes  5;  ## Default: 1\nerror_log  /dev/stderr;\npid        /tmp/nginx.pid;\nworker_rlimit_nofile 8192;\n\nevents {\n  worker_connections  4096;  ## Default: 1024\n}\n\nhttp {\n  client_body_temp_path /tmp/client_temp;\n  proxy_temp_path       /tmp/proxy_temp_path;\n  fastcgi_temp_path     /tmp/fastcgi_temp;\n  uwsgi_temp_path       /tmp/uwsgi_temp;\n  scgi_temp_path        /tmp/scgi_temp;\n\n  default_type application/octet-stream;\n  log_format   {{ .Values.gateway.nginxConfig.logFormat }}\n\n  {{- if .Values.gateway.verboseLogging }}\n  access_log   /dev/stderr  main;\n  {{- else }}\n\n  map $status $loggable {\n    ~^[23]  0;\n    default 1;\n  }\n  access_log   /dev/stderr  main  if=$loggable;\n  {{- end }}\n\n  sendfile     on;\n  tcp_nopush   on;\n  resolver {{ .Values.global.dnsService }}.{{ .Values.global.dnsNamespace }}.svc.{{ .Values.global.clusterDomain }};\n\n  {{- with .Values.gateway.nginxConfig.httpSnippet }}\n  {{ . | nindent 2 }}\n  {{- end }}\n\n  server {\n    listen             8080;\n\n    {{- if .Values.gateway.basicAuth.enabled }}\n    auth_basic           \"Loki\";\n    auth_basic_user_file /etc/nginx/secrets/.htpasswd;\n    {{- end }}\n\n    location = / {\n      return 200 'OK';\n      auth_basic off;\n    }\n\n    location = /api/prom/push {\n      proxy_pass       http://{{ include \"loki.writeFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location = /api/prom/tail {\n      proxy_pass       http://{{ include \"loki.readFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n      proxy_set_header Upgrade $http_upgrade;\n      proxy_set_header Connection \"upgrade\";\n    }\n\n    location ~ /api/prom/.* {\n      proxy_pass       http://{{ include \"loki.readFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location = /loki/api/v1/push {\n      proxy_pass       http://{{ include \"loki.writeFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location = /loki/api/v1/tail {\n      proxy_pass       http://{{ include \"loki.readFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n      proxy_set_header Upgrade $http_upgrade;\n      proxy_set_header Connection \"upgrade\";\n    }\n\n    location ~ /loki/api/.* {\n      proxy_pass       http://{{ include \"loki.readFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    {{- with .Values.gateway.nginxConfig.serverSnippet }}\n    {{ . | nindent 4 }}\n    {{- end }}\n  }\n}\n"` |  |
| gateway.nginxConfig.httpSnippet | string | `""` |  |
| gateway.nginxConfig.logFormat | string | `"main '$remote_addr - $remote_user [$time_local]  $status '\n        '\"$request\" $body_bytes_sent \"$http_referer\" '\n        '\"$http_user_agent\" \"$http_x_forwarded_for\"';"` |  |
| gateway.nginxConfig.serverSnippet | string | `""` |  |
| gateway.nodeSelector | object | `{}` |  |
| gateway.podAnnotations | object | `{}` |  |
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
| loki.commonConfig | object | `{"path_prefix":"/var/loki","replication_factor":1,"storage":{"filesystem":{"chunks_directory":"/var/loki/chunks","rules_directory":"/var/loki/rules"}}}` | Check https://grafana.com/docs/loki/latest/configuration/#common_config for more info on how to provide a common configuration |
| loki.config | string | `"auth_enabled: false\n\nserver:\n  http_listen_port: 3100\n\nmemberlist:\n  join_members:\n    - {{ include \"loki.fullname\" . }}-memberlist\n\n{{- if .Values.loki.commonConfig}}\ncommon:\n{{- toYaml .Values.loki.commonConfig | nindent 2}}\n{{- end}}\n\nlimits_config:\n  enforce_metric_name: false\n  reject_old_samples: true\n  reject_old_samples_max_age: 168h\n  max_cache_freshness_per_query: 10m\n\n{{- if .Values.loki.schemaConfig}}\nschema_config:\n{{- toYaml .Values.loki.schemaConfig | nindent 2}}\n{{- end}}\n\n{{- if .Values.loki.storageConfig}}\nstorage_config:\n{{- toYaml .Values.loki.storageConfig | nindent 2}}\n{{- end}}\n"` |  |
| loki.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| loki.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| loki.containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| loki.existingSecretForConfig | string | `""` |  |
| loki.image.pullPolicy | string | `"IfNotPresent"` |  |
| loki.image.registry | string | `"docker.io"` |  |
| loki.image.repository | string | `"grafana/loki"` |  |
| loki.image.tag | string | `nil` |  |
| loki.podAnnotations | object | `{}` |  |
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
| loki.storageConfig | object | `{}` | Check https://grafana.com/docs/loki/latest/configuration/#storage_config for more info on how to configure storages |
| loki.structuredConfig | object | `{}` |  |
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
| rbac.pspEnabled | bool | `false` |  |
| rbac.sccEnabled | bool | `false` |  |
| read.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"loki.readSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"loki.readSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| read.autoscaling.enabled | bool | `false` |  |
| read.autoscaling.maxReplicas | int | `3` |  |
| read.autoscaling.minReplicas | int | `1` |  |
| read.autoscaling.targetCPUUtilizationPercentage | int | `60` |  |
| read.autoscaling.targetMemoryUtilizationPercentage | string | `nil` |  |
| read.extraArgs | list | `[]` |  |
| read.extraEnv | list | `[]` |  |
| read.extraEnvFrom | list | `[]` |  |
| read.extraVolumeMounts | list | `[]` |  |
| read.extraVolumes | list | `[]` |  |
| read.image.registry | string | `nil` |  |
| read.image.repository | string | `nil` |  |
| read.image.tag | string | `nil` |  |
| read.nodeSelector | object | `{}` |  |
| read.persistence.size | string | `"10Gi"` |  |
| read.persistence.storageClass | string | `nil` |  |
| read.podAnnotations | object | `{}` |  |
| read.priorityClassName | string | `nil` |  |
| read.replicas | int | `1` |  |
| read.resources | object | `{}` |  |
| read.serviceLabels | object | `{}` |  |
| read.terminationGracePeriodSeconds | int | `30` |  |
| read.tolerations | list | `[]` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.imagePullSecrets | list | `[]` |  |
| serviceAccount.name | string | `nil` |  |
| serviceMonitor.annotations | object | `{}` |  |
| serviceMonitor.enabled | bool | `false` |  |
| serviceMonitor.interval | string | `nil` |  |
| serviceMonitor.labels | object | `{}` |  |
| serviceMonitor.namespace | string | `nil` |  |
| serviceMonitor.namespaceSelector | object | `{}` |  |
| serviceMonitor.relabelings | list | `[]` |  |
| serviceMonitor.scheme | string | `"http"` |  |
| serviceMonitor.scrapeTimeout | string | `nil` |  |
| serviceMonitor.tlsConfig | string | `nil` |  |
| write.affinity | string | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          {{- include \"loki.writeSelectorLabels\" . | nindent 10 }}\n      topologyKey: kubernetes.io/hostname\n  preferredDuringSchedulingIgnoredDuringExecution:\n    - weight: 100\n      podAffinityTerm:\n        labelSelector:\n          matchLabels:\n            {{- include \"loki.writeSelectorLabels\" . | nindent 12 }}\n        topologyKey: failure-domain.beta.kubernetes.io/zone\n"` |  |
| write.extraArgs | list | `[]` |  |
| write.extraEnv | list | `[]` |  |
| write.extraEnvFrom | list | `[]` |  |
| write.extraVolumeMounts | list | `[]` |  |
| write.extraVolumes | list | `[]` |  |
| write.image.registry | string | `nil` |  |
| write.image.repository | string | `nil` |  |
| write.image.tag | string | `nil` |  |
| write.nodeSelector | object | `{}` |  |
| write.persistence.size | string | `"10Gi"` |  |
| write.persistence.storageClass | string | `nil` |  |
| write.podAnnotations | object | `{}` |  |
| write.priorityClassName | string | `nil` |  |
| write.replicas | int | `1` |  |
| write.resources | object | `{}` |  |
| write.serviceLabels | object | `{}` |  |
| write.terminationGracePeriodSeconds | int | `300` |  |
| write.tolerations | list | `[]` |  |

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
