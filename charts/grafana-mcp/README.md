# grafana-mcp

MCP server for Grafana.

## Source Code

* <https://github.com/grafana/mcp-grafana>
* <https://github.com/grafana/helm-charts>

## Requirements

Kubernetes: `^1.8.0-0`

## Chart Repo

Add the following repo to use the chart:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install --set grafana.apiKey=<Grafana_ApiKey> my-release grafana/grafana-mcp
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity |
| annotations | object | `{}` | Deployment annotations |
| automountServiceAccountToken | bool | `true` | Automount service account token |
| containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Container security context |
| debug | bool | `false` | Enable debug mode |
| deploymentStrategy | object | `{"rollingUpdate":{"maxSurge":"25%","maxUnavailable":"25%"},"type":"RollingUpdate"}` | Deployment strategy |
| disabledCategories | list | `[]` | Categories to disable (e.g., oncall, incident, sift) |
| dnsConfig | object | `{}` | DNS config |
| dnsPolicy | string | `""` | DNS policy |
| env | object | `{}` | Environment variables |
| envFrom | list | `[]` | Environment variables from ConfigMaps or Secrets |
| envValueFrom | object | `{}` | Environment variables from other sources |
| extraArgs | list | `[]` | Additional command line arguments |
| extraContainers | list | `[]` | Extra containers |
| extraInitContainers | list | `[]` | Extra init containers |
| grafana | object | `{"apiKey":"","apiKeySecret":{"key":"","name":""},"url":"http://grafana:3000"}` | Grafana connection configuration |
| grafana.apiKey | string | `""` | Grafana ApiKey (if not using a secret) |
| grafana.apiKeySecret | object | `{"key":"","name":""}` | Secret containing the Grafana API key |
| grafana.apiKeySecret.key | string | `""` | Key within the secret that contains the API key |
| grafana.apiKeySecret.name | string | `""` | Name of the secret containing the API key |
| grafana.url | string | `"http://grafana:3000"` | Grafana URL (should point to the main Grafana service) |
| hostAliases | list | `[]` | Host aliases |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"docker.io","repository":"mcp/grafana","tag":"latest"}` | Image configuration |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.registry | string | `"docker.io"` | The Docker registry |
| image.repository | string | `"mcp/grafana"` | The Docker repository |
| image.tag | string | `"latest"` | Image tag |
| imagePullSecrets | list | `[]` | Image pull secrets |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"mcp-grafana.local","paths":[{"path":"/","pathType":"Prefix"}]}],"labels":{},"tls":[]}` | Ingress configuration |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.className | string | `""` | Ingress class name |
| ingress.enabled | bool | `false` | Enable ingress |
| ingress.hosts | list | `[{"host":"mcp-grafana.local","paths":[{"path":"/","pathType":"Prefix"}]}]` | Ingress hosts |
| ingress.labels | object | `{}` | Ingress labels |
| ingress.tls | list | `[]` | Ingress TLS configuration |
| initContainers | list | `[]` | Init containers |
| labels | object | `{}` | Deployment labels |
| lifecycle | object | `{}` | Lifecycle hooks |
| livenessProbe | object | `{}` | MCP server Liveness probe configuration |
| nodeSelector | object | `{}` | Node selector |
| podAnnotations | object | `{}` | Pod annotations |
| podLabels | object | `{}` | Pod labels |
| priorityClassName | string | `""` | Priority class name |
| readinessProbe | object | `{}` | MCP server Readiness probe configuration |
| replicas | int | `1` | Number of replicas for the MCP server |
| resources | object | `{}` | Resource requests and limits |
| runtimeClassName | string | `""` | Runtime class name |
| schedulerName | string | `""` | Scheduler name |
| securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Pod security context |
| service | object | `{"annotations":{},"clusterIP":"","enabled":true,"externalIPs":[],"externalName":"","extraPorts":[],"labels":{},"loadBalancerIP":"","loadBalancerSourceRanges":[],"nodePort":"","port":8000,"sessionAffinity":"","sessionAffinityConfig":{},"type":"ClusterIP"}` | Service configuration |
| service.annotations | object | `{}` | Service annotations |
| service.clusterIP | string | `""` | Cluster IP (if type is ClusterIP) |
| service.enabled | bool | `true` | Enable service |
| service.externalIPs | list | `[]` | External IPs |
| service.externalName | string | `""` | External name (if type is ExternalName) |
| service.extraPorts | list | `[]` | Extra ports |
| service.labels | object | `{}` | Service labels |
| service.loadBalancerIP | string | `""` | Load balancer IP |
| service.loadBalancerSourceRanges | list | `[]` | Load balancer source ranges |
| service.nodePort | string | `""` | Node port (if type is NodePort or LoadBalancer) |
| service.port | int | `8000` | Service port |
| service.sessionAffinity | string | `""` | Session affinity |
| service.sessionAffinityConfig | object | `{}` | Session affinity config |
| service.type | string | `"ClusterIP"` | Service type |
| serviceAccount | object | `{"annotations":{},"automountServiceAccountToken":false,"enabled":true,"labels":{},"name":""}` | Service account Configuration |
| serviceAccount.annotations | object | `{}` | Annotations for the service account |
| serviceAccount.automountServiceAccountToken | bool | `false` | Automount service account token |
| serviceAccount.enabled | bool | `true` | Enable service account |
| serviceAccount.labels | object | `{}` | Labels for the service account |
| serviceAccount.name | string | `""` | Name of the service account |
| startupProbe | object | `{}` | MCP server Startup probe configuration |
| tolerations | list | `[]` | Tolerations |
| topologySpreadConstraints | list | `[]` | Topology spread constraints |
| volumeMounts | list | `[]` | Volume mounts |
| volumes | list | `[]` | Volumes |
