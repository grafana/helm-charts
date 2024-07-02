# synthetic-monitoring-agent

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.9.3-0-gcd7aadd](https://img.shields.io/badge/AppVersion-v0.9.3--0--gcd7aadd-informational?style=flat-square)

Grafana's Synthetic Monitoring application. The agent provides probe functionality and executes network checks for monitoring remote targets.

**Homepage:** <https://grafana.net>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| zanhsieh | <zanhsieh@gmail.com> |  |
| torstenwalter | <mail@torstenwalter.de> |  |
| sc250024 | <scott.crooks@gmail.com> |  |

## Source Code

* <https://github.com/grafana/synthetic-monitoring-agent>

## Requirements

Kubernetes: `^1.16.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Node affinity for pod assignment. |
| agent.apiServerAddress | string | `"synthetic-monitoring-grpc.grafana.net:443"` | Default server endpoint for receiving synthetic monitoring checks on Grafana's side. See https://grafana.com/docs/grafana-cloud/synthetic-monitoring/private-probes/#probe-api-server-url for more information. |
| agent.apiToken | string | `""` | API token from Grafana Cloud when secret is created by the chart. |
| agent.debug | bool | `false` | Enable / disable debug logging on the agent. |
| agent.enableDisconnect | bool | `false` | Enable / disable the HTTP /disconnect endpoint |
| agent.verbose | bool | `false` | Enable / disable verbose logging on the agent. |
| autoscaling.enabled | bool | `false` | Enable autoscaling |
| autoscaling.maxReplicas | int | `3` | Maximum autoscaling replicas |
| autoscaling.minReplicas | int | `1` | Minimum autoscaling replicas |
| autoscaling.targetCPUUtilizationPercentage | int | `60` | Target CPU utilisation percentage |
| autoscaling.targetMemoryUtilizationPercentage | string | `nil` | Target memory utilisation percentage |
| extraObjects | list | `[]` | Add dynamic manifests via values: |
| fullnameOverride | string | `""` | Override the fullname of the chart. |
| hostAliases | list | `[]` | hostAliases to add |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| image.registry | string | `"docker.io"` | Base registry to pull the container image from. |
| image.repository | string | `"grafana/synthetic-monitoring-agent"` | Base repository for container image. |
| image.tag | string | `""` | Image tag; overrides the image tag whose default is the chart `appVersion`. |
| imagePullSecrets | list | `[]` | Docker registry secret names as an array. |
| livenessProbe | object | `{"httpGet":{"path":"/","port":"http"}}` | Liveness probe for the agent |
| nameOverride | string | `""` | Override the name of the chart. |
| nodeSelector | object | `{}` | Node labels for pod assignment. |
| podAnnotations | object | `{}` | Annotations to add to each pod. |
| podLabels | object | `{}` | Labels to add to each pod. |
| podSecurityContext | object | `{"fsGroup":65534}` | Security context on the Pod level. |
| readinessProbe | object | `{"httpGet":{"path":"/ready","port":"http"}}` | Readiness probe for the agent |
| replicaCount | int | `1` | Number of replicas to use; ignored if `autoscaling.enabled` is set to `true`. |
| resources | object | `{}` | Default resources to apply. |
| secret.existingSecret | string | `""` | Reference an existing secret for API token |
| securityContext | object | `{"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":65534}` | Security context for the container level. |
| service.annotations | object | `{}` | Annotations for the service |
| service.port | int | `4050` | Service port. |
| service.type | string | `"ClusterIP"` | Type of service to create. |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automountServiceAccountToken | bool | `true` | Whether to automatically mount a service account token volume. |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor.annotations | object | `{}` | ServiceMonitor annotations |
| serviceMonitor.enabled | bool | `false` | If enabled, ServiceMonitor resources for Prometheus Operator are created |
| serviceMonitor.interval | string | `nil` | ServiceMonitor scrape interval |
| serviceMonitor.labels | object | `{}` | Additional ServiceMonitor labels |
| serviceMonitor.namespace | string | `nil` | Alternative namespace for ServiceMonitor resources |
| serviceMonitor.namespaceSelector | object | `{}` | Namespace selector for ServiceMonitor resources |
| serviceMonitor.path | string | `"/metrics"` | ServiceMonitor path to scrape |
| serviceMonitor.relabelings | list | `[]` | ServiceMonitor relabeling config |
| serviceMonitor.scheme | string | `"http"` | ServiceMonitor scheme (http or https) |
| serviceMonitor.scrapeTimeout | string | `nil` | ServiceMonitor scrape timeout in Go duration format (e.g. 15s) |
| tolerations | list | `[]` | List of node taints to tolerate. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.8.1](https://github.com/norwoodj/helm-docs/releases/v1.8.1)
