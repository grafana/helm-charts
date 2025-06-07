# grafana

![Version: 9.3.0](https://img.shields.io/badge/Version-9.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 12.0.1](https://img.shields.io/badge/AppVersion-12.0.1-informational?style=flat-square)

The leading tool for querying and visualizing time series and metrics.

**Homepage:** <https://grafana.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| zanhsieh | <zanhsieh@gmail.com> |  |
| rtluckie | <rluckie@cisco.com> |  |
| maorfr | <maor.friedman@redhat.com> |  |
| Xtigyro | <miroslav.hadzhiev@gmail.com> |  |
| torstenwalter | <mail@torstenwalter.de> |  |
| jkroepke | <github@jkroepke.de> |  |

## Source Code

* <https://github.com/grafana/grafana>
* <https://github.com/grafana/helm-charts>

## Requirements

Kubernetes: `^1.8.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| "grafana.ini".analytics.check_for_updates | bool | `true` |  |
| "grafana.ini".grafana_net.url | string | `"https://grafana.net"` |  |
| "grafana.ini".log.mode | string | `"console"` |  |
| "grafana.ini".paths.data | string | `"/var/lib/grafana/"` |  |
| "grafana.ini".paths.logs | string | `"/var/log/grafana"` |  |
| "grafana.ini".paths.plugins | string | `"/var/lib/grafana/plugins"` |  |
| "grafana.ini".paths.provisioning | string | `"/etc/grafana/provisioning"` |  |
| "grafana.ini".server.domain | string | `"{{ if (and .Values.ingress.enabled .Values.ingress.hosts) }}{{ tpl (.Values.ingress.hosts | first) . }}{{ else }}''{{ end }}"` |  |
| admin.existingSecret | string | `""` |  |
| admin.passwordKey | string | `"admin-password"` |  |
| admin.userKey | string | `"admin-user"` |  |
| adminUser | string | `"admin"` |  |
| affinity | object | `{}` |  |
| alerting | object | `{}` |  |
| assertNoLeakedSecrets | bool | `true` |  |
| automountServiceAccountToken | bool | `true` |  |
| autoscaling.behavior | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `5` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPU | string | `"60"` |  |
| autoscaling.targetMemory | string | `""` |  |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| createConfigmap | bool | `true` |  |
| dashboardProviders | object | `{}` |  |
| dashboards | object | `{}` |  |
| dashboardsConfigMaps | object | `{}` |  |
| datasources | object | `{}` |  |
| defaultCurlOptions | string | `"-skf"` |  |
| deploymentStrategy.type | string | `"RollingUpdate"` |  |
| dnsConfig | object | `{}` |  |
| dnsPolicy | string | `nil` |  |
| downloadDashboards.env | object | `{}` |  |
| downloadDashboards.envFromSecret | string | `""` |  |
| downloadDashboards.envValueFrom | object | `{}` |  |
| downloadDashboards.resources | object | `{}` |  |
| downloadDashboards.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| downloadDashboards.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| downloadDashboards.securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| downloadDashboardsImage.pullPolicy | string | `"IfNotPresent"` |  |
| downloadDashboardsImage.registry | string | `"docker.io"` | The Docker registry |
| downloadDashboardsImage.repository | string | `"curlimages/curl"` |  |
| downloadDashboardsImage.sha | string | `""` |  |
| downloadDashboardsImage.tag | string | `"8.9.1"` |  |
| enableKubeBackwardCompatibility | bool | `false` |  |
| enableServiceLinks | bool | `true` |  |
| env | object | `{}` |  |
| envFromConfigMaps | list | `[]` |  |
| envFromSecret | string | `""` |  |
| envFromSecrets | list | `[]` |  |
| envRenderSecret | object | `{}` |  |
| envValueFrom | object | `{}` |  |
| extraConfigmapMounts | list | `[]` |  |
| extraContainerVolumes | list | `[]` |  |
| extraContainers | string | `""` |  |
| extraEmptyDirMounts | list | `[]` |  |
| extraExposePorts | list | `[]` |  |
| extraInitContainers | list | `[]` |  |
| extraLabels | object | `{}` |  |
| extraObjects | list | `[]` |  |
| extraSecretMounts | list | `[]` |  |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `nil` | Overrides the Docker registry globally for all images |
| gossipPortName | string | `"gossip"` |  |
| headlessService | bool | `false` |  |
| hostAliases | list | `[]` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"docker.io"` | The Docker registry |
| image.repository | string | `"grafana/grafana"` | Docker image repository |
| image.sha | string | `""` |  |
| image.tag | string | `""` |  |
| imageRenderer.affinity | object | `{}` |  |
| imageRenderer.automountServiceAccountToken | bool | `false` |  |
| imageRenderer.autoscaling.behavior | object | `{}` |  |
| imageRenderer.autoscaling.enabled | bool | `false` |  |
| imageRenderer.autoscaling.maxReplicas | int | `5` |  |
| imageRenderer.autoscaling.minReplicas | int | `1` |  |
| imageRenderer.autoscaling.targetCPU | string | `"60"` |  |
| imageRenderer.autoscaling.targetMemory | string | `""` |  |
| imageRenderer.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| imageRenderer.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| imageRenderer.containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| imageRenderer.containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| imageRenderer.deploymentStrategy | object | `{}` |  |
| imageRenderer.enabled | bool | `false` |  |
| imageRenderer.env.HTTP_HOST | string | `"0.0.0.0"` |  |
| imageRenderer.env.XDG_CACHE_HOME | string | `"/tmp/.chromium"` |  |
| imageRenderer.env.XDG_CONFIG_HOME | string | `"/tmp/.chromium"` |  |
| imageRenderer.envValueFrom | object | `{}` |  |
| imageRenderer.extraConfigmapMounts | list | `[]` |  |
| imageRenderer.extraSecretMounts | list | `[]` |  |
| imageRenderer.extraVolumeMounts | list | `[]` |  |
| imageRenderer.extraVolumes | list | `[]` |  |
| imageRenderer.grafanaProtocol | string | `"http"` |  |
| imageRenderer.grafanaSubPath | string | `""` |  |
| imageRenderer.hostAliases | list | `[]` |  |
| imageRenderer.image.pullPolicy | string | `"Always"` |  |
| imageRenderer.image.pullSecrets | list | `[]` |  |
| imageRenderer.image.registry | string | `"docker.io"` | The Docker registry |
| imageRenderer.image.repository | string | `"grafana/grafana-image-renderer"` |  |
| imageRenderer.image.sha | string | `""` |  |
| imageRenderer.image.tag | string | `"latest"` |  |
| imageRenderer.networkPolicy.extraIngressSelectors | list | `[]` |  |
| imageRenderer.networkPolicy.limitEgress | bool | `false` |  |
| imageRenderer.networkPolicy.limitIngress | bool | `true` |  |
| imageRenderer.nodeSelector | object | `{}` |  |
| imageRenderer.podAnnotations | object | `{}` |  |
| imageRenderer.podPortName | string | `"http"` |  |
| imageRenderer.priorityClassName | string | `""` |  |
| imageRenderer.renderingCallbackURL | string | `""` |  |
| imageRenderer.replicas | int | `1` |  |
| imageRenderer.resources | object | `{}` |  |
| imageRenderer.revisionHistoryLimit | int | `10` |  |
| imageRenderer.securityContext | object | `{}` |  |
| imageRenderer.serverURL | string | `""` |  |
| imageRenderer.service.appProtocol | string | `""` |  |
| imageRenderer.service.enabled | bool | `true` |  |
| imageRenderer.service.port | int | `8081` |  |
| imageRenderer.service.portName | string | `"http"` |  |
| imageRenderer.service.targetPort | int | `8081` |  |
| imageRenderer.serviceAccountName | string | `""` |  |
| imageRenderer.serviceMonitor.enabled | bool | `false` |  |
| imageRenderer.serviceMonitor.interval | string | `"1m"` |  |
| imageRenderer.serviceMonitor.labels | object | `{}` |  |
| imageRenderer.serviceMonitor.path | string | `"/metrics"` |  |
| imageRenderer.serviceMonitor.relabelings | list | `[]` |  |
| imageRenderer.serviceMonitor.scheme | string | `"http"` |  |
| imageRenderer.serviceMonitor.scrapeTimeout | string | `"30s"` |  |
| imageRenderer.serviceMonitor.targetLabels | list | `[]` |  |
| imageRenderer.serviceMonitor.tlsConfig | object | `{}` |  |
| imageRenderer.tolerations | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.extraPaths | list | `[]` |  |
| ingress.hosts[0] | string | `"chart-example.local"` |  |
| ingress.labels | object | `{}` |  |
| ingress.path | string | `"/"` |  |
| ingress.pathType | string | `"Prefix"` |  |
| ingress.tls | list | `[]` |  |
| initChownData.enabled | bool | `true` |  |
| initChownData.image.pullPolicy | string | `"IfNotPresent"` |  |
| initChownData.image.registry | string | `"docker.io"` | The Docker registry |
| initChownData.image.repository | string | `"library/busybox"` |  |
| initChownData.image.sha | string | `""` |  |
| initChownData.image.tag | string | `"1.31.1"` |  |
| initChownData.resources | object | `{}` |  |
| initChownData.securityContext.capabilities.add[0] | string | `"CHOWN"` |  |
| initChownData.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| initChownData.securityContext.readOnlyRootFilesystem | bool | `false` |  |
| initChownData.securityContext.runAsNonRoot | bool | `false` |  |
| initChownData.securityContext.runAsUser | int | `0` |  |
| initChownData.securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| ldap.config | string | `""` |  |
| ldap.enabled | bool | `false` |  |
| ldap.existingSecret | string | `""` |  |
| lifecycleHooks | object | `{}` |  |
| livenessProbe.failureThreshold | int | `10` |  |
| livenessProbe.httpGet.path | string | `"/api/health"` |  |
| livenessProbe.httpGet.port | int | `3000` |  |
| livenessProbe.initialDelaySeconds | int | `60` |  |
| livenessProbe.timeoutSeconds | int | `30` |  |
| mcpServer | object | `{"affinity":{},"annotations":{},"automountServiceAccountToken":true,"containerSecurityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000},"debug":false,"deploymentStrategy":{"rollingUpdate":{"maxSurge":"25%","maxUnavailable":"25%"},"type":"RollingUpdate"},"disabledCategories":[],"dnsConfig":{},"dnsPolicy":"","enabled":true,"env":{},"envFrom":[],"envValueFrom":{},"extraArgs":[],"extraContainers":[],"extraInitContainers":[],"grafana":{"apiKeySecret":{"key":"api-key","name":"grafana-mcp-api-key"},"url":"http://grafana:3000"},"hostAliases":[],"image":{"pullPolicy":"IfNotPresent","registry":"docker.io","repository":"mcp/grafana","tag":"latest"},"imagePullSecrets":[],"ingress":{"annotations":{},"className":"","enabled":true,"hosts":[{"host":"mcp-grafana.local","paths":[{"path":"/","pathType":"Prefix"}]}],"labels":{},"tls":[]},"initContainers":[],"labels":{},"lifecycle":{},"nodeSelector":{},"podAnnotations":{},"podLabels":{},"priorityClassName":"","replicas":1,"resources":{},"runtimeClassName":"","schedulerName":"","securityContext":{"fsGroup":1000,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000},"service":{"annotations":{},"clusterIP":"","enabled":true,"externalIPs":[],"externalName":"","extraPorts":[],"labels":{},"loadBalancerIP":"","loadBalancerSourceRanges":[],"nodePort":"","port":8000,"sessionAffinity":"","sessionAffinityConfig":{},"type":"ClusterIP"},"tolerations":[],"topologySpreadConstraints":[],"volumeMounts":[],"volumes":[]}` | Enable the Grafana MCP server deployment |
| mcpServer.affinity | object | `{}` | Affinity |
| mcpServer.annotations | object | `{}` | Deployment annotations |
| mcpServer.automountServiceAccountToken | bool | `true` | Automount service account token |
| mcpServer.containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Container security context |
| mcpServer.debug | bool | `false` | Enable debug mode |
| mcpServer.deploymentStrategy | object | `{"rollingUpdate":{"maxSurge":"25%","maxUnavailable":"25%"},"type":"RollingUpdate"}` | Deployment strategy |
| mcpServer.disabledCategories | list | `[]` | Categories to disable (e.g., oncall, incident, sift) |
| mcpServer.dnsConfig | object | `{}` | DNS config |
| mcpServer.dnsPolicy | string | `""` | DNS policy |
| mcpServer.enabled | bool | `true` | Enable the MCP server |
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
| mcpServer.ingress | object | `{"annotations":{},"className":"","enabled":true,"hosts":[{"host":"mcp-grafana.local","paths":[{"path":"/","pathType":"Prefix"}]}],"labels":{},"tls":[]}` | Ingress configuration |
| mcpServer.ingress.annotations | object | `{}` | Ingress annotations |
| mcpServer.ingress.className | string | `""` | Ingress class name |
| mcpServer.ingress.enabled | bool | `true` | Enable ingress |
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
| namespaceOverride | string | `""` |  |
| networkPolicy.allowExternal | bool | `true` |  |
| networkPolicy.egress.blockDNSResolution | bool | `false` |  |
| networkPolicy.egress.enabled | bool | `false` |  |
| networkPolicy.egress.ports | list | `[]` |  |
| networkPolicy.egress.to | list | `[]` |  |
| networkPolicy.enabled | bool | `false` |  |
| networkPolicy.explicitNamespacesSelector | object | `{}` |  |
| networkPolicy.ingress | bool | `true` |  |
| nodeSelector | object | `{}` |  |
| notifiers | object | `{}` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.disableWarning | bool | `false` |  |
| persistence.enabled | bool | `false` |  |
| persistence.extraPvcLabels | object | `{}` |  |
| persistence.finalizers[0] | string | `"kubernetes.io/pvc-protection"` |  |
| persistence.inMemory.enabled | bool | `false` |  |
| persistence.lookupVolumeName | bool | `true` |  |
| persistence.size | string | `"10Gi"` |  |
| persistence.type | string | `"pvc"` |  |
| persistence.volumeName | string | `""` |  |
| plugins | list | `[]` |  |
| podDisruptionBudget | object | `{}` |  |
| podPortName | string | `"grafana"` |  |
| rbac.create | bool | `true` |  |
| rbac.extraClusterRoleRules | list | `[]` |  |
| rbac.extraRoleRules | list | `[]` |  |
| rbac.namespaced | bool | `false` |  |
| rbac.pspEnabled | bool | `false` |  |
| rbac.pspUseAppArmor | bool | `false` |  |
| readinessProbe.httpGet.path | string | `"/api/health"` |  |
| readinessProbe.httpGet.port | int | `3000` |  |
| replicas | int | `1` |  |
| resources | object | `{}` |  |
| revisionHistoryLimit | int | `10` |  |
| route | object | `{"main":{"additionalRules":[],"annotations":{},"apiVersion":"gateway.networking.k8s.io/v1","enabled":false,"filters":[],"hostnames":[],"kind":"HTTPRoute","labels":{},"matches":[{"path":{"type":"PathPrefix","value":"/"}}],"parentRefs":[]}}` | BETA: Configure the gateway routes for the chart here. More routes can be added by adding a dictionary key like the 'main' route. Be aware that this is an early beta of this feature, kube-prometheus-stack does not guarantee this works and is subject to change. Being BETA this can/will change in the future without notice, do not use unless you want to take that risk [[ref]](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io%2fv1alpha2) |
| route.main.apiVersion | string | `"gateway.networking.k8s.io/v1"` | Set the route apiVersion, e.g. gateway.networking.k8s.io/v1 or gateway.networking.k8s.io/v1alpha2 |
| route.main.enabled | bool | `false` | Enables or disables the route |
| route.main.kind | string | `"HTTPRoute"` | Set the route kind Valid options are GRPCRoute, HTTPRoute, TCPRoute, TLSRoute, UDPRoute |
| securityContext.fsGroup | int | `472` |  |
| securityContext.runAsGroup | int | `472` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `472` |  |
| service.annotations | object | `{}` |  |
| service.appProtocol | string | `""` |  |
| service.enabled | bool | `true` |  |
| service.ipFamilies | list | `[]` |  |
| service.ipFamilyPolicy | string | `""` |  |
| service.labels | object | `{}` |  |
| service.loadBalancerClass | string | `""` |  |
| service.loadBalancerIP | string | `""` |  |
| service.loadBalancerSourceRanges | list | `[]` |  |
| service.port | int | `80` |  |
| service.portName | string | `"service"` |  |
| service.sessionAffinity | string | `""` |  |
| service.targetPort | int | `3000` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.labels | object | `{}` |  |
| serviceAccount.name | string | `nil` |  |
| serviceAccount.nameTest | string | `nil` |  |
| serviceMonitor.basicAuth | object | `{}` |  |
| serviceMonitor.enabled | bool | `false` |  |
| serviceMonitor.interval | string | `"30s"` |  |
| serviceMonitor.labels | object | `{}` |  |
| serviceMonitor.metricRelabelings | list | `[]` |  |
| serviceMonitor.path | string | `"/metrics"` |  |
| serviceMonitor.relabelings | list | `[]` |  |
| serviceMonitor.scheme | string | `"http"` |  |
| serviceMonitor.scrapeTimeout | string | `"30s"` |  |
| serviceMonitor.targetLabels | list | `[]` |  |
| serviceMonitor.tlsConfig | object | `{}` |  |
| shareProcessNamespace | bool | `false` |  |
| sidecar.alerts.enabled | bool | `false` |  |
| sidecar.alerts.env | object | `{}` |  |
| sidecar.alerts.envValueFrom | object | `{}` |  |
| sidecar.alerts.extraMounts | list | `[]` |  |
| sidecar.alerts.initAlerts | bool | `false` |  |
| sidecar.alerts.label | string | `"grafana_alert"` |  |
| sidecar.alerts.labelValue | string | `""` |  |
| sidecar.alerts.reloadURL | string | `"http://localhost:3000/api/admin/provisioning/alerting/reload"` |  |
| sidecar.alerts.resource | string | `"both"` |  |
| sidecar.alerts.resourceName | string | `""` |  |
| sidecar.alerts.script | string | `nil` |  |
| sidecar.alerts.searchNamespace | string | `nil` |  |
| sidecar.alerts.sizeLimit | object | `{}` |  |
| sidecar.alerts.skipReload | bool | `false` |  |
| sidecar.alerts.watchMethod | string | `"WATCH"` |  |
| sidecar.dashboards.SCProvider | bool | `true` |  |
| sidecar.dashboards.defaultFolderName | string | `nil` |  |
| sidecar.dashboards.enabled | bool | `false` |  |
| sidecar.dashboards.env | object | `{}` |  |
| sidecar.dashboards.envValueFrom | object | `{}` |  |
| sidecar.dashboards.extraMounts | list | `[]` |  |
| sidecar.dashboards.folder | string | `"/tmp/dashboards"` |  |
| sidecar.dashboards.folderAnnotation | string | `nil` |  |
| sidecar.dashboards.label | string | `"grafana_dashboard"` |  |
| sidecar.dashboards.labelValue | string | `""` |  |
| sidecar.dashboards.provider.allowUiUpdates | bool | `false` |  |
| sidecar.dashboards.provider.disableDelete | bool | `false` |  |
| sidecar.dashboards.provider.folder | string | `""` |  |
| sidecar.dashboards.provider.folderUid | string | `""` |  |
| sidecar.dashboards.provider.foldersFromFilesStructure | bool | `false` |  |
| sidecar.dashboards.provider.name | string | `"sidecarProvider"` |  |
| sidecar.dashboards.provider.orgid | int | `1` |  |
| sidecar.dashboards.provider.type | string | `"file"` |  |
| sidecar.dashboards.reloadURL | string | `"http://localhost:3000/api/admin/provisioning/dashboards/reload"` |  |
| sidecar.dashboards.resource | string | `"both"` |  |
| sidecar.dashboards.resourceName | string | `""` |  |
| sidecar.dashboards.script | string | `nil` |  |
| sidecar.dashboards.searchNamespace | string | `nil` |  |
| sidecar.dashboards.sizeLimit | object | `{}` |  |
| sidecar.dashboards.skipReload | bool | `false` |  |
| sidecar.dashboards.watchMethod | string | `"WATCH"` |  |
| sidecar.datasources.enabled | bool | `false` |  |
| sidecar.datasources.env | object | `{}` |  |
| sidecar.datasources.envValueFrom | object | `{}` |  |
| sidecar.datasources.extraMounts | list | `[]` |  |
| sidecar.datasources.initDatasources | bool | `false` |  |
| sidecar.datasources.label | string | `"grafana_datasource"` |  |
| sidecar.datasources.labelValue | string | `""` |  |
| sidecar.datasources.reloadURL | string | `"http://localhost:3000/api/admin/provisioning/datasources/reload"` |  |
| sidecar.datasources.resource | string | `"both"` |  |
| sidecar.datasources.resourceName | string | `""` |  |
| sidecar.datasources.script | string | `nil` |  |
| sidecar.datasources.searchNamespace | string | `nil` |  |
| sidecar.datasources.sizeLimit | object | `{}` |  |
| sidecar.datasources.skipReload | bool | `false` |  |
| sidecar.datasources.watchMethod | string | `"WATCH"` |  |
| sidecar.enableUniqueFilenames | bool | `false` |  |
| sidecar.image.registry | string | `"quay.io"` | The Docker registry |
| sidecar.image.repository | string | `"kiwigrid/k8s-sidecar"` |  |
| sidecar.image.sha | string | `""` |  |
| sidecar.image.tag | string | `"1.30.0"` |  |
| sidecar.imagePullPolicy | string | `"IfNotPresent"` |  |
| sidecar.livenessProbe | object | `{}` |  |
| sidecar.notifiers.enabled | bool | `false` |  |
| sidecar.notifiers.env | object | `{}` |  |
| sidecar.notifiers.extraMounts | list | `[]` |  |
| sidecar.notifiers.initNotifiers | bool | `false` |  |
| sidecar.notifiers.label | string | `"grafana_notifier"` |  |
| sidecar.notifiers.labelValue | string | `""` |  |
| sidecar.notifiers.reloadURL | string | `"http://localhost:3000/api/admin/provisioning/notifications/reload"` |  |
| sidecar.notifiers.resource | string | `"both"` |  |
| sidecar.notifiers.resourceName | string | `""` |  |
| sidecar.notifiers.script | string | `nil` |  |
| sidecar.notifiers.searchNamespace | string | `nil` |  |
| sidecar.notifiers.sizeLimit | object | `{}` |  |
| sidecar.notifiers.skipReload | bool | `false` |  |
| sidecar.notifiers.watchMethod | string | `"WATCH"` |  |
| sidecar.plugins.enabled | bool | `false` |  |
| sidecar.plugins.env | object | `{}` |  |
| sidecar.plugins.extraMounts | list | `[]` |  |
| sidecar.plugins.initPlugins | bool | `false` |  |
| sidecar.plugins.label | string | `"grafana_plugin"` |  |
| sidecar.plugins.labelValue | string | `""` |  |
| sidecar.plugins.reloadURL | string | `"http://localhost:3000/api/admin/provisioning/plugins/reload"` |  |
| sidecar.plugins.resource | string | `"both"` |  |
| sidecar.plugins.resourceName | string | `""` |  |
| sidecar.plugins.script | string | `nil` |  |
| sidecar.plugins.searchNamespace | string | `nil` |  |
| sidecar.plugins.sizeLimit | object | `{}` |  |
| sidecar.plugins.skipReload | bool | `false` |  |
| sidecar.plugins.watchMethod | string | `"WATCH"` |  |
| sidecar.readinessProbe | object | `{}` |  |
| sidecar.resources | object | `{}` |  |
| sidecar.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| sidecar.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| sidecar.securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| smtp.existingSecret | string | `""` |  |
| smtp.passwordKey | string | `"password"` |  |
| smtp.userKey | string | `"user"` |  |
| testFramework.containerSecurityContext | object | `{}` |  |
| testFramework.enabled | bool | `true` |  |
| testFramework.image.registry | string | `"docker.io"` | The Docker registry |
| testFramework.image.repository | string | `"bats/bats"` |  |
| testFramework.image.tag | string | `"v1.4.1"` |  |
| testFramework.imagePullPolicy | string | `"IfNotPresent"` |  |
| testFramework.resources | object | `{}` |  |
| testFramework.securityContext | object | `{}` |  |
| tolerations | list | `[]` |  |
| topologySpreadConstraints | list | `[]` |  |
| useStatefulSet | bool | `false` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.8.1](https://github.com/norwoodj/helm-docs/releases/v1.8.1)
