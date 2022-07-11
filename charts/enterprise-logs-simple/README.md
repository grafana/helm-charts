# enterprise-logs-simple

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.3.0](https://img.shields.io/badge/AppVersion-v1.3.0-informational?style=flat-square)

Grafana Enterprise Logs (Simple Scalable)

**Homepage:** <https://grafana.com/products/enterprise/logs/>


## Deprecation warning

This chart is now deprecated and will no longer be updated. Grafana Enterprise Logs v1.4.0 is included in the `loki-simple-scalable` chart which implements Grafana Enterprise Logs as an option (`enterprise.enabled: true`).

## Requirements

Kubernetes: `^1.10.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://grafana.github.io/helm-charts | loki-simple-scalable | ^0.3.0 |
| https://helm.min.io/ | minio | 8.0.9 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| commonConfig | object | `{"path_prefix":"/var/loki","replication_factor":3,"storage":{"s3":{"access_key_id":"enterprise-logs","bucketnames":"enterprise-logs-tsdb","endpoint":"{{ include \"enterprise-logs.minio\" . }}","insecure":true,"s3forcepathstyle":true,"secret_access_key":"supersecret"}}}` | Check https://grafana.com/docs/loki/latest/configuration/#common_config for more info on how to provide a common configuration |
| config | string | `"auth:\n  type: enterprise\n\nauth_enabled: true\n\nlicense:\n  path: /etc/enterprise-logs/license/license.jwt\n\ncluster_name: {{ .Release.Name }}\n\n{{- if .Values.commonConfig}}\ncommon:\n{{- toYaml .Values.commonConfig | nindent 2}}\n{{- end}}\n\nserver:\n  http_listen_port: 3100\n  grpc_listen_port: 9095\n\nadmin_client:\n  storage:\n    # TODO: type should not be necessary\n    type: s3\n    s3:\n      bucket_name: enterprise-logs-admin\n\ningester:\n  max_chunk_age: '2h'\n\ningester_client:\n  grpc_client_config:\n    max_recv_msg_size: 104857600\n    max_send_msg_size: 104857600\n\nlimits_config:\n  enforce_metric_name: false\n  reject_old_samples: true\n  reject_old_samples_max_age: 168h\n  max_cache_freshness_per_query: 10m\n\nmemberlist:\n  join_members:\n    - {{ include \"loki.fullname\" . }}-memberlist\n\nquerier:\n  query_ingesters_within: 2h\n\n{{- if .Values.schemaConfig}}\nschema_config:\n{{- toYaml .Values.schemaConfig | nindent 2}}\n{{- end}}\n\n{{- if .Values.storageConfig}}\nstorage_config:\n{{- toYaml .Values.storageConfig | nindent 2}}\n{{- end}}\n\nruler:\n  storage:\n    s3:\n      bucketnames: enterprise-logs-ruler\n  enable_alertmanager_discovery: false\n  enable_api: true\n  enable_sharding: true\n"` | Grafana Enterprise Logs configuration file |
| externalConfigName | string | `"enterprise-logs-config"` |  |
| externalConfigVersion | string | `"0"` |  |
| externalLicenseName | string | `"enterprise-logs-license"` |  |
| externalLicenseVersion | string | `"0"` |  |
| fullnameOverride | string | `nil` | Overrides the chart's computed fullname |
| image | object | `{"pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"docker.io","repository":"grafana/enterprise-logs","tag":"v1.3.0"}` | Definition of the Docker image for Grafana Enterprise Logs If the image block is overwritten in a custom values file, it is also required to update the values in the `loki-simple-scalable.loki.image` block. This can be done by copying the values, or like here, by using an anchor and a pointer. |
| image.pullPolicy | string | `"IfNotPresent"` | Defines the policy how and when images are pulled |
| image.pullSecrets | list | `[]` | Additional image pull secrets |
| image.repository | string | `"grafana/enterprise-logs"` | The image repository to use |
| image.tag | string | `"v1.3.0"` | The version of Grafana Enterprise Logs |
| license | object | `{"contents":"NOTAVALIDLICENSE"}` | Grafana Enterprise Logs license In order to use Grafana Enterprise Logs features, you will need to provide the contents of your Grafana Enterprise Logs license, either by providing the contents of the license.jwt, or the name Kubernetes Secret that contains your license.jwt. To set the license contents, use the flag `--set-file 'license.contents=./license.jwt'` |
| loki-simple-scalable.gateway | object | `{"enabled":true,"nginxConfig":{"file":"worker_processes  5;  ## Default: 1\nerror_log  /dev/stderr;\npid        /tmp/nginx.pid;\nworker_rlimit_nofile 8192;\n\nevents {\n  worker_connections  4096;  ## Default: 1024\n}\n\nhttp {\n  client_body_temp_path /tmp/client_temp;\n  proxy_temp_path       /tmp/proxy_temp_path;\n  fastcgi_temp_path     /tmp/fastcgi_temp;\n  uwsgi_temp_path       /tmp/uwsgi_temp;\n  scgi_temp_path        /tmp/scgi_temp;\n\n  default_type application/octet-stream;\n  log_format   {{ .Values.gateway.nginxConfig.logFormat }}\n\n  {{- if .Values.gateway.verboseLogging }}\n  access_log   /dev/stderr  main;\n  {{- else }}\n\n  map $status $loggable {\n    ~^[23]  0;\n    default 1;\n  }\n  access_log   /dev/stderr  main  if=$loggable;\n  {{- end }}\n\n  sendfile     on;\n  tcp_nopush   on;\n  resolver {{ .Values.global.dnsService }}.{{ .Values.global.dnsNamespace }}.svc.{{ .Values.global.clusterDomain }};\n\n  {{- with .Values.gateway.nginxConfig.httpSnippet }}\n  {{ . | nindent 2 }}\n  {{- end }}\n\n  server {\n    listen             8080;\n\n    {{- if .Values.gateway.basicAuth.enabled }}\n    auth_basic           \"Loki\";\n    auth_basic_user_file /etc/nginx/secrets/.htpasswd;\n    {{- end }}\n\n    location = / {\n      return 200 'OK';\n      auth_basic off;\n    }\n\n    location = /api/prom/push {\n      proxy_pass       http://{{ include \"loki.writeFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location = /api/prom/tail {\n      proxy_pass       http://{{ include \"loki.readFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n      proxy_set_header Upgrade $http_upgrade;\n      proxy_set_header Connection \"upgrade\";\n    }\n\n    location ~ /api/prom/.* {\n      proxy_pass       http://{{ include \"loki.readFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location = /loki/api/v1/push {\n      proxy_pass       http://{{ include \"loki.writeFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location = /loki/api/v1/tail {\n      proxy_pass       http://{{ include \"loki.readFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n      proxy_set_header Upgrade $http_upgrade;\n      proxy_set_header Connection \"upgrade\";\n    }\n\n    location ~ /loki/api/.* {\n      proxy_pass       http://{{ include \"loki.readFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location ~ /admin/api/.* {\n      proxy_pass       http://{{ include \"loki.writeFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location ~ /compactor/.* {\n      proxy_pass       http://{{ include \"loki.readFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location ~ /distributor/.* {\n      proxy_pass       http://{{ include \"loki.writeFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location ~ /ring {\n      proxy_pass       http://{{ include \"loki.writeFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location ~ /ingester/.* {\n      proxy_pass       http://{{ include \"loki.writeFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location ~ /ruler/.* {\n      proxy_pass       http://{{ include \"loki.readFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    location ~ /scheduler/.* {\n      proxy_pass       http://{{ include \"loki.readFullname\" . }}.{{ .Release.Namespace }}.svc.{{ .Values.global.clusterDomain }}:3100$request_uri;\n    }\n\n    {{- with .Values.gateway.nginxConfig.serverSnippet }}\n    {{ . | nindent 4 }}\n    {{- end }}\n  }\n}\n"}}` | Override gateway nginx.conf to include admin-api routes |
| loki-simple-scalable.loki.config | string | `nil` |  |
| loki-simple-scalable.loki.existingSecretForConfig | string | `"enterprise-logs-config"` |  |
| loki-simple-scalable.loki.image.pullPolicy | string | `"IfNotPresent"` | Defines the policy how and when images are pulled |
| loki-simple-scalable.loki.image.pullSecrets | list | `[]` | Additional image pull secrets |
| loki-simple-scalable.loki.image.registry | string | `"docker.io"` |  |
| loki-simple-scalable.loki.image.repository | string | `"grafana/enterprise-logs"` | The image repository to use |
| loki-simple-scalable.loki.image.tag | string | `"v1.3.0"` | The version of Grafana Enterprise Logs |
| loki-simple-scalable.nameOverride | string | `"enterprise-logs"` | In order to have consistent Pod names for both pods from the enterprise-logs and loki-simple-scalable chart, we override the name of the child chart to match the name of the parent chart. |
| loki-simple-scalable.rbac.pspEnabled | bool | `true` | If enabled, a PodSecurityPolicy is created |
| loki-simple-scalable.read | object | `{"extraVolumeMounts":[{"mountPath":"/etc/enterprise-logs/license","name":"license"}],"extraVolumes":[{"name":"license","secret":{"secretName":"enterprise-logs-license"}}],"replicas":3}` | Configuration for the `read` target |
| loki-simple-scalable.read.extraVolumeMounts[0] | object | `{"mountPath":"/etc/enterprise-logs/license","name":"license"}` | Mount the license volume |
| loki-simple-scalable.read.extraVolumes[0] | object | `{"name":"license","secret":{"secretName":"enterprise-logs-license"}}` | Create license volume from license secret |
| loki-simple-scalable.serviceAccount | object | `{"annotations":{},"automountServiceAccountToken":true,"create":true,"imagePullSecrets":[],"name":null}` | Definition of the ServiceAccount for containers |
| loki-simple-scalable.serviceAccount.annotations | object | `{}` | Annotations for the service account |
| loki-simple-scalable.serviceAccount.automountServiceAccountToken | bool | `true` | Set this toggle to false to opt out of automounting API credentials for the service account |
| loki-simple-scalable.serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| loki-simple-scalable.serviceAccount.imagePullSecrets | list | `[]` | Image pull secrets for the service account |
| loki-simple-scalable.serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| loki-simple-scalable.write | object | `{"extraVolumeMounts":[{"mountPath":"/etc/enterprise-logs/license","name":"license"}],"extraVolumes":[{"name":"license","secret":{"secretName":"enterprise-logs-license"}}],"replicas":3}` | Configuration for the `write` target |
| loki-simple-scalable.write.extraVolumeMounts[0] | object | `{"mountPath":"/etc/enterprise-logs/license","name":"license"}` | Mount the license volume |
| loki-simple-scalable.write.extraVolumes[0] | object | `{"name":"license","secret":{"secretName":"enterprise-logs-license"}}` | Create license volume from license secret |
| minio.accessKey | string | `"enterprise-logs"` |  |
| minio.buckets[0].name | string | `"enterprise-logs-tsdb"` |  |
| minio.buckets[0].policy | string | `"none"` |  |
| minio.buckets[0].purge | bool | `false` |  |
| minio.buckets[1].name | string | `"enterprise-logs-admin"` |  |
| minio.buckets[1].policy | string | `"none"` |  |
| minio.buckets[1].purge | bool | `false` |  |
| minio.buckets[2].name | string | `"enterprise-logs-ruler"` |  |
| minio.buckets[2].policy | string | `"none"` |  |
| minio.buckets[2].purge | bool | `false` |  |
| minio.enabled | bool | `true` |  |
| minio.persistence.size | string | `"5Gi"` |  |
| minio.resources.requests.cpu | string | `"100m"` |  |
| minio.resources.requests.memory | string | `"128Mi"` |  |
| minio.secretKey | string | `"supersecret"` |  |
| nameOverride | string | `nil` | Overrides the chart's name |
| schemaConfig | object | `{"configs":[{"from":"2020-09-07","index":{"period":"24h","prefix":"loki_index_"},"object_store":"filesystem","schema":"v11","store":"boltdb-shipper"}]}` | Check https://grafana.com/docs/loki/latest/configuration/#schema_config for more info on how to configure schemas |
| serviceAccount | object | `{"create":true}` | Definition of the ServiceAccount for containers Any additional configuration of the ServiceAccount has to be done in `loki-simple-scalable.serviceAccount`. |
| serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created If this value is changed to `false`, it also needs to be reflected in `loki-simple-scalable.serviceAccount.create`. |
| storageConfig | object | `{}` | Check https://grafana.com/docs/loki/latest/configuration/#storage_config for more info on how to configure storages |
| structuredConfig | object | `{}` | Uncomment to configure each storage individually boltdb_shipper: {} filesystem: {} azure: {} gcs: {} s3: {} -- Structured GEL configuration, takes precedence over `loki.config`, `loki.schemaConfig`, `loki.storageConfig` |
| tokengen | object | `{"adminTokenSecret":"gel-admin-token","annotations":{},"enable":true,"env":[],"extraArgs":[],"extraVolumeMounts":[],"extraVolumes":[],"labels":{},"securityContext":{"fsGroup":10001,"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001}}` | Configuration for `tokengen` target |
| tokengen.adminTokenSecret | string | `"gel-admin-token"` | Name of the secret to store the admin token in |
| tokengen.annotations | object | `{}` | Additional annotations for the `tokengen` Job |
| tokengen.enable | bool | `true` | Whether the job should be part of the deployment |
| tokengen.env | list | `[]` | Additional Kubernetes environment |
| tokengen.extraArgs | list | `[]` | Additional CLI arguments for the `tokengen` target |
| tokengen.extraVolumeMounts | list | `[]` | Additional volume mounts for Pods |
| tokengen.extraVolumes | list | `[]` | Additional volumes for Pods |
| tokengen.labels | object | `{}` | Additional labels for the `tokengen` Job |
| tokengen.securityContext | object | `{"fsGroup":10001,"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001}` | Run containers as user `enterprise-logs(uid=10001)` |
| useExternalConfig | bool | `false` | External config.yaml A GEL configuration file may be provided as Kubernetes Secret outside of this Helm chart. |
| useExternalLicense | bool | `false` | External license.jwt A GEL license file may be provided as Kubernetes Secret outside of this Helm chart. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.4.0](https://github.com/norwoodj/helm-docs/releases/v1.4.0)
