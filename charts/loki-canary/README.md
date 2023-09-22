# loki-canary

![Version: 0.14.0](https://img.shields.io/badge/Version-0.14.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.9.1](https://img.shields.io/badge/AppVersion-2.9.1-informational?style=flat-square)

Helm chart for Grafana Loki Canary

## Source Code

* <https://github.com/grafana/loki>
* <https://grafana.com/oss/loki/>
* <https://grafana.com/docs/loki/latest/>

## Chart Repo

Add the following repo to use the chart:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| basicAuth.enabled | bool | `false` | Enables basic authentication for the gateway |
| basicAuth.existingSecret | string | `nil` | Existing basic auth secret to use. Must contain '.htpasswd' and, if canary is enabled, 'username' and 'password' |
| basicAuth.password | string | `nil` | The basic auth password for the gateway |
| basicAuth.username | string | `nil` | The basic auth username for the gateway |
| containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | The SecurityContext for Loki containers |
| extraArgs | list | `["-labelname=pod","-labelvalue=$(POD_NAME)"]` | Additional CLI args for the canary |
| extraEnv | list | `[]` | Environment variables to add to the canary pods |
| extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the canary pods |
| extraVolumeMounts | list | `[]` | Volume mounts to add to the containers |
| extraVolumes | list | `[]` | Volumes to add to the containers |
| fullnameOverride | string | `""` | Overrides the chart's computed fullname |
| hostAliases | list | `[]` | hostAliases to add |
| image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| image.repository | string | `"docker.io/grafana/loki-canary"` | Docker image repository |
| image.tag | string | `nil` | Overrides the image tag whose default is the chart's appVersion |
| imagePullSecrets | list | `[]` | Image pull secrets for Docker images |
| lokiAddress | string | `nil` | The Loki server URL:Port, e.g. loki:3100 |
| nameOverride | string | `""` | Overrides the chart's name |
| namespace.name | string | `nil` | The name of the Namespace to deploy If not set, `.Release.Namespace` is used |
| nodeSelector | object | `{}` | Node selector for canary pods |
| podAnnotations | object | `{}` | Common annotations for all pods |
| podLabels | object | `{}` | Common labels for all pods |
| podSecurityContext | object | `{"fsGroup":10001,"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001}` | The SecurityContext for Loki pods |
| priorityClassName | string | `nil` | The name of the PriorityClass for pods |
| resources | object | `{}` | Resource requests and limits for the canary |
| revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain to allow rollback |
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
| serviceMonitor.scrapeTimeout | string | `nil` | ServiceMonitor scrape timeout in Go duration format (e.g. 15s) |
| tolerations | list | `[]` | Tolerations for canary pods |
