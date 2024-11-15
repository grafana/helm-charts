# enterprise-logs

![Version: 2.5.0](https://img.shields.io/badge/Version-2.5.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.5.2](https://img.shields.io/badge/AppVersion-v1.5.2-informational?style=flat-square)

Grafana Enterprise Logs

**Homepage:** <https://grafana.com/products/enterprise/logs/>

## Requirements

Kubernetes: `^1.10.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://grafana.github.io/helm-charts | loki-distributed | 0.55.0 |
| https://helm.min.io/ | minio(minio) | 8.0.9 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalConfig | string | `nil` |  |
| adminApi | object | `{"affinity":{},"annotations":{},"containerSecurityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true},"env":[],"extraArgs":{},"extraContainers":[],"extraVolumeMounts":[],"extraVolumes":[],"hostAliases":[],"initContainers":[],"labels":{},"livenessProbe":{"httpGet":{"path":"/ready","port":"http-metrics"},"initialDelaySeconds":45},"nodeSelector":{},"persistence":{"subPath":null},"podSecurityContext":{"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001},"readinessProbe":{"httpGet":{"path":"/ready","port":"http-metrics"},"initialDelaySeconds":45},"replicas":1,"resources":{},"service":{"annotations":{},"labels":{}},"strategy":{"type":"RollingUpdate"},"terminationGracePeriodSeconds":60,"tolerations":[]}` | Configuration for the `admin-api` target |
| adminApi.affinity | object | `{}` | Affinity for admin-api Pods |
| adminApi.annotations | object | `{}` | Additional annotations for the `admin-api` Deployment |
| adminApi.extraArgs | object | `{}` | Additional CLI arguments for the `admin-api` target |
| adminApi.extraVolumeMounts | list | `[]` | Additional volume mounts for Pods |
| adminApi.extraVolumes | list | `[]` | Additional volumes for Pods |
| adminApi.hostAliases | list | `[]` | hostAliases to add |
| adminApi.labels | object | `{}` | Additional labels for the `admin-api` Deployment |
| adminApi.nodeSelector | object | `{}` | Node selector for admin-api Pods |
| adminApi.podSecurityContext | object | `{"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001}` | Run container as user `enterprise-logs(uid=10001)` `fsGroup` must not be specified, because these security options are applied on container level not on Pod level. |
| adminApi.replicas | int | `1` | Define the amount of instances |
| adminApi.resources | object | `{}` | Values are defined in small.yaml and large.yaml |
| adminApi.service | object | `{"annotations":{},"labels":{}}` | Additional labels and annotations for the `admin-api` Service |
| adminApi.terminationGracePeriodSeconds | int | `60` | Grace period to allow the admin-api to shutdown before it is killed |
| adminApi.tolerations | list | `[]` | Tolerations for admin-api Pods |
| commonConfig | object | `{"path_prefix":"/var/loki","replication_factor":3,"storage":{"s3":{"access_key_id":"enterprise-logs","bucketnames":"enterprise-logs-tsdb","endpoint":"{{ include \"enterprise-logs.minio\" . }}","insecure":true,"s3forcepathstyle":true,"secret_access_key":"supersecret"}}}` | Check https://grafana.com/docs/loki/latest/configuration/#common_config for more info on how to provide a common configuration |
| compactor | object | `{"affinity":{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchExpressions":[{"key":"target","operator":"In","values":["compactor"]}]},"topologyKey":"kubernetes.io/hostname"},"weight":100}]}},"annotations":{},"containerSecurityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true},"env":[],"extraArgs":{},"extraContainers":[],"extraVolumeMounts":[],"extraVolumes":[],"hostAliases":[],"initContainers":[],"labels":{},"livenessProbe":{"failureThreshold":20,"httpGet":{"path":"/ready","port":"http-metrics","scheme":"HTTP"},"initialDelaySeconds":180,"periodSeconds":30,"successThreshold":1,"timeoutSeconds":1},"nodeSelector":{},"persistentVolume":{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":true,"size":"2Gi"},"podSecurityContext":{"fsGroup":10001,"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001},"readinessProbe":{"httpGet":{"path":"/ready","port":"http-metrics"},"initialDelaySeconds":60},"replicas":1,"resources":{},"service":{"annotations":{},"labels":{}},"strategy":{"type":"RollingUpdate"},"terminationGracePeriodSeconds":300,"tolerations":[]}` | Configuration for the `compactor` target |
| compactor.affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchExpressions":[{"key":"target","operator":"In","values":["compactor"]}]},"topologyKey":"kubernetes.io/hostname"},"weight":100}]}}` | Affinity for compactor Pods |
| compactor.annotations | object | `{}` | Additional annotations for the `compactor` Pod |
| compactor.extraArgs | object | `{}` | Additional CLI arguments for the `compactor` target |
| compactor.extraVolumeMounts | list | `[]` | Additional volume mounts for Pods |
| compactor.extraVolumes | list | `[]` | Additional volumes for Pods |
| compactor.hostAliases | list | `[]` | hostAliases to add |
| compactor.labels | object | `{}` | Additional labels for the `compactor` Pod |
| compactor.nodeSelector | object | `{}` | Node selector for compactor Pods |
| compactor.podSecurityContext | object | `{"fsGroup":10001,"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001}` | Run containers as user `enterprise-logs(uid=10001)` |
| compactor.replicas | int | `1` | Define the amount of instances |
| compactor.resources | object | `{}` | Values are defined in small.yaml and large.yaml |
| compactor.service | object | `{"annotations":{},"labels":{}}` | Additional labels and annotations for the `compactor` Service |
| compactor.terminationGracePeriodSeconds | int | `300` | Grace period to allow the compactor to shutdown before it is killed |
| compactor.tolerations | list | `[]` | Tolerations for compactor Pods |
| config | string | `"auth:\n  type: enterprise\nauth_enabled: true\n\nlicense:\n  path: /etc/enterprise-logs/license/license.jwt\n\ncluster_name: {{ .Release.Name }}\n\nserver:\n  http_listen_port: 3100\n  grpc_listen_port: 9095\n\n{{- if .Values.commonConfig}}\ncommon:\n{{- toYaml .Values.commonConfig | nindent 2}}\n{{- end}}\n\nadmin_client:\n  storage:\n    s3:\n      bucket_name: enterprise-logs-admin\n\ningester:\n  chunk_idle_period: 30m\n  chunk_block_size: 262144\n  chunk_encoding: snappy\n  chunk_retain_period: 1m\n\ningester_client:\n  grpc_client_config:\n    max_recv_msg_size: 104857600\n    max_send_msg_size: 104857600\n\nlimits_config:\n  enforce_metric_name: false\n  reject_old_samples: true\n  reject_old_samples_max_age: 168h\n  max_cache_freshness_per_query: 10m\n  split_queries_by_interval: 24h\n\nfrontend:\n  log_queries_longer_than: 10s\n  compress_responses: true\n  tail_proxy_url: http://{{ include \"loki.querierFullname\" . }}:3100\n\nfrontend_worker:\n  frontend_address: {{ include \"loki.queryFrontendFullname\" . }}:9095\n\nmemberlist:\n  join_members:\n    - {{ include \"loki.fullname\" . }}-memberlist\n\nquerier:\n  query_ingesters_within: 12h\n\nquery_range:\n  align_queries_with_step: true\n  cache_results: true\n  results_cache:\n    cache:\n      memcached:\n        expiration: 1h\n      memcached_client:\n        timeout: 1s\n\nschema_config:\n  configs:\n    - from: 2021-01-01\n      store: boltdb-shipper\n      object_store: aws\n      schema: v11\n      index:\n        prefix: index_\n        period: 24h\n\nstorage_config:\n  aws:\n    bucketnames: enterprise-logs-tsdb\n  boltdb_shipper:\n    index_gateway_client:\n      server_address: dns:///{{ include \"loki.indexGatewayFullname\" . }}:9095\n\nruler:\n  storage:\n    s3:\n      bucketnames: enterprise-logs-ruler\n\n{{- if .Values.additionalConfig}}\n{{.Values.additionalConfig}}\n{{- end}}\n"` | Grafana Enterprise Logs configuration file |
| externalConfigName | string | `"enterprise-logs-config"` |  |
| externalConfigVersion | string | `"0"` |  |
| externalLicenseName | string | `"enterprise-logs-license"` |  |
| externalLicenseVersion | string | `"0"` |  |
| fullnameOverride | string | `nil` | Overrides the chart's computed fullname |
| gateway | object | `{"affinity":{},"annotations":{},"containerSecurityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true},"env":[],"extraArgs":{},"extraContainers":[],"extraVolumeMounts":[],"extraVolumes":[],"hostAliases":[],"initContainers":[],"labels":{},"livenessProbe":{"httpGet":{"path":"/ready","port":"http-metrics"},"initialDelaySeconds":45},"nodeSelector":{},"persistence":{"subPath":null},"podSecurityContext":{"fsGroup":10001,"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001},"readinessProbe":{"httpGet":{"path":"/ready","port":"http-metrics"},"initialDelaySeconds":45},"replicas":1,"resources":{},"service":{"annotations":{},"labels":{},"type":"ClusterIP"},"strategy":{"type":"RollingUpdate"},"terminationGracePeriodSeconds":60,"tolerations":[],"useDefaultProxyURLs":true}` | Configuration for the `gateway` target |
| gateway.affinity | object | `{}` | Affinity for gateway Pods |
| gateway.annotations | object | `{}` | Additional annotations for the `gateway` Pod |
| gateway.extraArgs | object | `{}` | Additional CLI arguments for the `gateway` target |
| gateway.extraVolumeMounts | list | `[]` | Additional volume mounts for Pods |
| gateway.extraVolumes | list | `[]` | Additional volumes for Pods |
| gateway.hostAliases | list | `[]` | hostAliases to add |
| gateway.labels | object | `{}` | Additional labels for the `gateway` Pod |
| gateway.nodeSelector | object | `{}` | Node selector for gateway Pods |
| gateway.podSecurityContext | object | `{"fsGroup":10001,"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001}` | Run container as user `enterprise-logs(uid=10001)` |
| gateway.replicas | int | `1` | Define the amount of instances |
| gateway.resources | object | `{}` | Values are defined in small.yaml and large.yaml |
| gateway.service | object | `{"annotations":{},"labels":{},"type":"ClusterIP"}` | Service overriding service type |
| gateway.terminationGracePeriodSeconds | int | `60` | Grace period to allow the gateway to shutdown before it is killed |
| gateway.tolerations | list | `[]` | Tolerations for gateway Pods |
| image | object | `{"pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"docker.io","repository":"grafana/enterprise-logs","tag":"v1.5.2"}` | Definition of the Docker image for Grafana Enterprise Logs If the image block is overwritten in a custom values file, it is also required to update the values in the `loki-distributed.loki.image` block. This can be done by copying the values, or like here, by using an anchor and a pointer. |
| image.pullPolicy | string | `"IfNotPresent"` | Defines the policy how and when images are pulled |
| image.pullSecrets | list | `[]` | Additional image pull secrets |
| image.registry | string | `"docker.io"` | The container registry to use |
| image.repository | string | `"grafana/enterprise-logs"` | The image repository to use |
| image.tag | string | `"v1.5.2"` | The version of Grafana Enterprise Logs |
| license | object | `{"contents":"NOTAVALIDLICENSE"}` | Grafana Enterprise Logs license In order to use Grafana Enterprise Logs features, you will need to provide the contents of your Grafana Enterprise Logs license, either by providing the contents of the license.jwt, or the name Kubernetes Secret that contains your license.jwt. To set the license contents, use the flag `--set-file 'license.contents=./license.jwt'` |
| loki-distributed | object | `{"compactor":{"enabled":false},"distributor":{"enabled":true,"extraVolumeMounts":[{"mountPath":"/etc/enterprise-logs/license","name":"license"}],"extraVolumes":[{"name":"license","secret":{"secretName":"enterprise-logs-license"}}]},"gateway":{"enabled":false},"indexGateway":{"enabled":true,"extraVolumeMounts":[{"mountPath":"/etc/enterprise-logs/license","name":"license"}],"extraVolumes":[{"name":"license","secret":{"secretName":"enterprise-logs-license"}}],"persistence":{"enabled":true}},"ingester":{"enabled":true,"extraVolumeMounts":[{"mountPath":"/etc/enterprise-logs/license","name":"license"}],"extraVolumes":[{"name":"license","secret":{"secretName":"enterprise-logs-license"}}],"replicas":3},"loki":{"config":null,"existingSecretForConfig":"enterprise-logs-config","image":{"pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"docker.io","repository":"grafana/enterprise-logs","tag":"v1.5.2"}},"nameOverride":"enterprise-logs","querier":{"enabled":true,"extraVolumeMounts":[{"mountPath":"/etc/enterprise-logs/license","name":"license"}],"extraVolumes":[{"name":"license","secret":{"secretName":"enterprise-logs-license"}}],"persistence":{"enabled":true}},"queryFrontend":{"enabled":true,"extraVolumeMounts":[{"mountPath":"/etc/enterprise-logs/license","name":"license"}],"extraVolumes":[{"name":"license","secret":{"secretName":"enterprise-logs-license"}}]},"rbac":{"pspEnabled":false,"sccEnabled":false},"ruler":{"enabled":true,"extraVolumeMounts":[{"mountPath":"/etc/enterprise-logs/license","name":"license"}],"extraVolumes":[{"name":"license","secret":{"secretName":"enterprise-logs-license"}}]},"serviceAccount":{"annotations":{},"automountServiceAccountToken":true,"create":true,"imagePullSecrets":[],"name":null},"tableManager":{"enabled":false}}` | ---------------------------------------------- |
| loki-distributed.compactor | object | `{"enabled":false}` | Compactor is defined in parent chart |
| loki-distributed.distributor | object | `{"enabled":true,"extraVolumeMounts":[{"mountPath":"/etc/enterprise-logs/license","name":"license"}],"extraVolumes":[{"name":"license","secret":{"secretName":"enterprise-logs-license"}}]}` | Configuration for the `distributor` target |
| loki-distributed.distributor.extraVolumeMounts[0] | object | `{"mountPath":"/etc/enterprise-logs/license","name":"license"}` | Mount the license volume |
| loki-distributed.distributor.extraVolumes[0] | object | `{"name":"license","secret":{"secretName":"enterprise-logs-license"}}` | Create license volume from license secret |
| loki-distributed.gateway | object | `{"enabled":false}` | Gateway is defined in parent chart |
| loki-distributed.indexGateway | object | `{"enabled":true,"extraVolumeMounts":[{"mountPath":"/etc/enterprise-logs/license","name":"license"}],"extraVolumes":[{"name":"license","secret":{"secretName":"enterprise-logs-license"}}],"persistence":{"enabled":true}}` | Configuration for the `index-gateway` target |
| loki-distributed.indexGateway.extraVolumeMounts[0] | object | `{"mountPath":"/etc/enterprise-logs/license","name":"license"}` | Mount the license volume |
| loki-distributed.indexGateway.extraVolumes[0] | object | `{"name":"license","secret":{"secretName":"enterprise-logs-license"}}` | Create license volume from license secret |
| loki-distributed.ingester | object | `{"enabled":true,"extraVolumeMounts":[{"mountPath":"/etc/enterprise-logs/license","name":"license"}],"extraVolumes":[{"name":"license","secret":{"secretName":"enterprise-logs-license"}}],"replicas":3}` | Configuration for the `ingester` target |
| loki-distributed.ingester.extraVolumeMounts[0] | object | `{"mountPath":"/etc/enterprise-logs/license","name":"license"}` | Mount the license volume |
| loki-distributed.ingester.extraVolumes[0] | object | `{"name":"license","secret":{"secretName":"enterprise-logs-license"}}` | Create license volume from license secret |
| loki-distributed.loki.image.pullPolicy | string | `"IfNotPresent"` | Defines the policy how and when images are pulled |
| loki-distributed.loki.image.pullSecrets | list | `[]` | Additional image pull secrets |
| loki-distributed.loki.image.registry | string | `"docker.io"` | The container registry to use |
| loki-distributed.loki.image.repository | string | `"grafana/enterprise-logs"` | The image repository to use |
| loki-distributed.loki.image.tag | string | `"v1.5.2"` | The version of Grafana Enterprise Logs |
| loki-distributed.nameOverride | string | `"enterprise-logs"` | In order to have consistent Pod names for both pods from the enterprise-logs and loki-distributed chart, we override the name of the child chart to match the name of the parent chart. |
| loki-distributed.querier | object | `{"enabled":true,"extraVolumeMounts":[{"mountPath":"/etc/enterprise-logs/license","name":"license"}],"extraVolumes":[{"name":"license","secret":{"secretName":"enterprise-logs-license"}}],"persistence":{"enabled":true}}` | Configuration for the `querier` target |
| loki-distributed.querier.extraVolumeMounts[0] | object | `{"mountPath":"/etc/enterprise-logs/license","name":"license"}` | Mount the license volume |
| loki-distributed.querier.extraVolumes[0] | object | `{"name":"license","secret":{"secretName":"enterprise-logs-license"}}` | Create license volume from license secret |
| loki-distributed.queryFrontend | object | `{"enabled":true,"extraVolumeMounts":[{"mountPath":"/etc/enterprise-logs/license","name":"license"}],"extraVolumes":[{"name":"license","secret":{"secretName":"enterprise-logs-license"}}]}` | Configuration for the `query-frontend` target |
| loki-distributed.queryFrontend.extraVolumeMounts[0] | object | `{"mountPath":"/etc/enterprise-logs/license","name":"license"}` | Mount the license volume |
| loki-distributed.queryFrontend.extraVolumes[0] | object | `{"name":"license","secret":{"secretName":"enterprise-logs-license"}}` | Create license volume from license secret |
| loki-distributed.rbac.pspEnabled | bool | `false` | If pspEnabled true, a PodSecurityPolicy is created for K8s that use psp. Disable due to deprecated since k8s v1.25. |
| loki-distributed.rbac.sccEnabled | bool | `false` | For OpenShift set pspEnabled to 'false' and sccEnabled to 'true' to use the SecurityContextConstraints. |
| loki-distributed.ruler | object | `{"enabled":true,"extraVolumeMounts":[{"mountPath":"/etc/enterprise-logs/license","name":"license"}],"extraVolumes":[{"name":"license","secret":{"secretName":"enterprise-logs-license"}}]}` | Configuration for the `ruler` target |
| loki-distributed.ruler.extraVolumeMounts[0] | object | `{"mountPath":"/etc/enterprise-logs/license","name":"license"}` | Mount the license volume |
| loki-distributed.ruler.extraVolumes[0] | object | `{"name":"license","secret":{"secretName":"enterprise-logs-license"}}` | Create license volume from license secret |
| loki-distributed.serviceAccount | object | `{"annotations":{},"automountServiceAccountToken":true,"create":true,"imagePullSecrets":[],"name":null}` | Definition of the ServiceAccount for containers |
| loki-distributed.serviceAccount.annotations | object | `{}` | Annotations for the service account |
| loki-distributed.serviceAccount.automountServiceAccountToken | bool | `true` | Set this toggle to false to opt out of automounting API credentials for the service account |
| loki-distributed.serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| loki-distributed.serviceAccount.imagePullSecrets | list | `[]` | Image pull secrets for the service account |
| loki-distributed.serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| loki-distributed.tableManager | object | `{"enabled":false}` | Table manager is not needed because we use boltdb-shipper and compactor |
| minio | object | `{"accessKey":"enterprise-logs","buckets":[{"name":"enterprise-logs-tsdb","policy":"none","purge":false},{"name":"enterprise-logs-admin","policy":"none","purge":false},{"name":"enterprise-logs-ruler","policy":"none","purge":false}],"configPathmc":"/tmp/minio/mc/","enabled":true,"persistence":{"size":"5Gi"},"resources":{"requests":{"cpu":"100m","memory":"128Mi"}},"secretKey":"supersecret"}` | ----------------------------------- |
| minio.configPathmc | string | `"/tmp/minio/mc/"` | Change the mc config path to '/tmp' from '/etc' as '/etc' is only writable by root |
| nameOverride | string | `nil` | Overrides the chart's name |
| serviceAccount | object | `{"create":true}` | Definition of the ServiceAccount for containers Any additional configuration of the ServiceAccount has to be done in `loki-distributed.serviceAccount`. |
| serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created If this value is changed to `false`, it also needs to be reflected in `loki-distributed.serviceAccount.create`. |
| structuredConfig | object | `{}` | Structured GEL configuration, takes precedence over `loki.config`, `loki.schemaConfig`, `loki.storageConfig` |
| tokengen | object | `{"annotations":{},"containerSecurityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true},"enable":true,"env":[],"extraArgs":{},"extraVolumeMounts":[],"extraVolumes":[],"hostAliases":[],"labels":{},"podSecurityContext":{"fsGroup":10001,"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001}}` | Configuration for `tokengen` target |
| tokengen.annotations | object | `{}` | Additional annotations for the `tokengen` Job |
| tokengen.enable | bool | `true` | Whether the job should be part of the deployment |
| tokengen.env | list | `[]` | Additional Kubernetes environment |
| tokengen.extraArgs | object | `{}` | Additional CLI arguments for the `tokengen` target |
| tokengen.extraVolumeMounts | list | `[]` | Additional volume mounts for Pods |
| tokengen.extraVolumes | list | `[]` | Additional volumes for Pods |
| tokengen.hostAliases | list | `[]` | hostAliases to add |
| tokengen.labels | object | `{}` | Additional labels for the `tokengen` Job |
| tokengen.podSecurityContext | object | `{"fsGroup":10001,"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001}` | Run containers as user `enterprise-logs(uid=10001)` |
| useExternalConfig | bool | `false` | External config.yaml A GEL configuration file may be provided as Kubernetes Secret outside of this Helm chart. |
| useExternalLicense | bool | `false` | External license.jwt A GEL license file may be provided as Kubernetes Secret outside of this Helm chart. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
