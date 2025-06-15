# grafana-mcp

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

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
helm install my-release grafana/grafana-mcp
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
| mcpServer | object | `{"affinity":{},"annotations":{},"automountServiceAccountToken":true,"containerSecurityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000},"debug":false,"deploymentStrategy":{"rollingUpdate":{"maxSurge":"25%","maxUnavailable":"25%"},"type":"RollingUpdate"},"disabledCategories":[],"dnsConfig":{},"dnsPolicy":"","enabled":false,"env":{},"envFrom":[],"envValueFrom":{},"extraArgs":[],"extraContainers":[],"extraInitContainers":[],"grafana":{"apiKeySecret":{"key":"api-key","name":"grafana-mcp-api-key"},"url":"http://grafana:3000"},"hostAliases":[],"image":{"pullPolicy":"IfNotPresent","registry":"docker.io","repository":"mcp/grafana","tag":"latest"},"imagePullSecrets":[],"ingress":{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"mcp-grafana.local","paths":[{"path":"/","pathType":"Prefix"}]}],"labels":{},"tls":[]},"initContainers":[],"labels":{},"lifecycle":{},"nodeSelector":{},"podAnnotations":{},"podLabels":{},"priorityClassName":"","replicas":1,"resources":{},"runtimeClassName":"","schedulerName":"","securityContext":{"fsGroup":1000,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000},"service":{"annotations":{},"clusterIP":"","enabled":true,"externalIPs":[],"externalName":"","extraPorts":[],"labels":{},"loadBalancerIP":"","loadBalancerSourceRanges":[],"nodePort":"","port":8000,"sessionAffinity":"","sessionAffinityConfig":{},"type":"ClusterIP"},"tolerations":[],"topologySpreadConstraints":[],"volumeMounts":[],"volumes":[]}` | Enable the Grafana MCP server deployment |
| mcpServer.affinity | object | `{}` | Affinity |
| mcpServer.annotations | object | `{}` | Deployment annotations |
| mcpServer.automountServiceAccountToken | bool | `true` | Automount service account token |
| mcpServer.containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Container security context |
| mcpServer.debug | bool | `false` | Enable debug mode |
| mcpServer.deploymentStrategy | object | `{"rollingUpdate":{"maxSurge":"25%","maxUnavailable":"25%"},"type":"RollingUpdate"}` | Deployment strategy |
| mcpServer.disabledCategories | list | `[]` | Categories to disable (e.g., oncall, incident, sift) |
| mcpServer.dnsConfig | object | `{}` | DNS config |
| mcpServer.dnsPolicy | string | `""` | DNS policy |
| mcpServer.enabled | bool | `false` | Enable the MCP server |
| mcpServer.env | object | `{}` | Environment variables |
| mcpServer.envFrom | list | `[]` | Environment variables from ConfigMaps or Secrets |
| mcpServer.envValueFrom | object | `{}` | Environment variables from other sources |
| mcpServer.extraArgs | list | `[]` | Additional command line arguments |
| mcpServer.extraContainers | list | `[]` | Extra containers |
| mcpServer.extraInitContainers | list | `[]` | Extra init containers |
| mcpServer.grafana | object | `{"apiKeySecret":{"key":"api-key","name":"grafana-mcp-api-key"},"url":"http://grafana:3000"}` | Grafana connection configuration |
| mcpServer.grafana.apiKeySecret | object | `{"key":"api-key","name":"grafana-mcp-api-key"}` | Secret containing the Grafana API key |
| mcpServer.grafana.apiKeySecret.key | string | `"api-key"` | Key within the secret that contains the API key |
| mcpServer.grafana.apiKeySecret.name | string | `"grafana-mcp-api-key"` | Name of the secret containing the API key |
| mcpServer.grafana.url | string | `"http://grafana:3000"` | Grafana URL (should point to the main Grafana service) |
| mcpServer.hostAliases | list | `[]` | Host aliases |
| mcpServer.image | object | `{"pullPolicy":"IfNotPresent","registry":"docker.io","repository":"mcp/grafana","tag":"latest"}` | Image configuration |
| mcpServer.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| mcpServer.image.registry | string | `"docker.io"` | The Docker registry |
| mcpServer.image.repository | string | `"mcp/grafana"` | The Docker repository |
| mcpServer.image.tag | string | `"latest"` | Image tag |
| mcpServer.imagePullSecrets | list | `[]` | Image pull secrets |
| mcpServer.ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"mcp-grafana.local","paths":[{"path":"/","pathType":"Prefix"}]}],"labels":{},"tls":[]}` | Ingress configuration |
| mcpServer.ingress.annotations | object | `{}` | Ingress annotations |
| mcpServer.ingress.className | string | `""` | Ingress class name |
| mcpServer.ingress.enabled | bool | `false` | Enable ingress |
| mcpServer.ingress.hosts | list | `[{"host":"mcp-grafana.local","paths":[{"path":"/","pathType":"Prefix"}]}]` | Ingress hosts |
| mcpServer.ingress.labels | object | `{}` | Ingress labels |
| mcpServer.ingress.tls | list | `[]` | Ingress TLS configuration |
| mcpServer.initContainers | list | `[]` | Init containers |
| mcpServer.labels | object | `{}` | Deployment labels |
| mcpServer.lifecycle | object | `{}` | Lifecycle hooks |
| mcpServer.nodeSelector | object | `{}` | Node selector |
| mcpServer.podAnnotations | object | `{}` | Pod annotations |
| mcpServer.podLabels | object | `{}` | Pod labels |
| mcpServer.priorityClassName | string | `""` | Priority class name |
| mcpServer.replicas | int | `1` | Number of replicas for the MCP server |
| mcpServer.resources | object | `{}` | Resource requests and limits |
| mcpServer.runtimeClassName | string | `""` | Runtime class name |
| mcpServer.schedulerName | string | `""` | Scheduler name |
| mcpServer.securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Pod security context |
| mcpServer.service | object | `{"annotations":{},"clusterIP":"","enabled":true,"externalIPs":[],"externalName":"","extraPorts":[],"labels":{},"loadBalancerIP":"","loadBalancerSourceRanges":[],"nodePort":"","port":8000,"sessionAffinity":"","sessionAffinityConfig":{},"type":"ClusterIP"}` | Service configuration |
| mcpServer.service.annotations | object | `{}` | Service annotations |
| mcpServer.service.clusterIP | string | `""` | Cluster IP (if type is ClusterIP) |
| mcpServer.service.enabled | bool | `true` | Enable service |
| mcpServer.service.externalIPs | list | `[]` | External IPs |
| mcpServer.service.externalName | string | `""` | External name (if type is ExternalName) |
| mcpServer.service.extraPorts | list | `[]` | Extra ports |
| mcpServer.service.labels | object | `{}` | Service labels |
| mcpServer.service.loadBalancerIP | string | `""` | Load balancer IP |
| mcpServer.service.loadBalancerSourceRanges | list | `[]` | Load balancer source ranges |
| mcpServer.service.nodePort | string | `""` | Node port (if type is NodePort or LoadBalancer) |
| mcpServer.service.port | int | `8000` | Service port |
| mcpServer.service.sessionAffinity | string | `""` | Session affinity |
| mcpServer.service.sessionAffinityConfig | object | `{}` | Session affinity config |
| mcpServer.service.type | string | `"ClusterIP"` | Service type |
| mcpServer.tolerations | list | `[]` | Tolerations |
| mcpServer.topologySpreadConstraints | list | `[]` | Topology spread constraints |
| mcpServer.volumeMounts | list | `[]` | Volume mounts |
| mcpServer.volumes | list | `[]` | Volumes |
