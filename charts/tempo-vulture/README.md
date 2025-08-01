# tempo-vulture

![Version: 0.9.0](https://img.shields.io/badge/Version-0.9.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.8.1](https://img.shields.io/badge/AppVersion-2.8.1-informational?style=flat-square)

Grafana Tempo Vulture - A tool to monitor Tempo performance.

## Source Code

* <https://github.com/grafana/tempo>

## Chart Repo

Add the following repo to use the chart:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release grafana/tempo-vulture
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Vulture

Vulture only works with Jaeger GRPC, so make sure 14250 is open on your distributor. You don't need to specify the port in the distributor url.

Example configuration:
```yaml
tempoAddress:
    push: http://tempo-tempo-distributed-distributor
    query: http://tempo-tempo-distributed-query-frontend:3100
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| annotations | object | `{}` | Common annotations for the deployment and service |
| extraArgs | list | `[]` | Additional CLI args for the vulture |
| extraEnv | list | `[]` | Environment variables to add to the vulture pods |
| extraEnvFrom | list | `[]` | Environment variables from secrets or configmaps to add to the vulture pods |
| fullnameOverride | string | `""` | Overrides the chart's computed fullname |
| global.commonLabels | object | `{}` | Common labels for all object directly managed by this chart. scope: * |
| hostAliases | list | `[]` | hostAliases to add |
| image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| image.repository | string | `"docker.io/grafana/tempo-vulture"` | Docker image repository |
| image.tag | string | `""` | Overrides the image tag whose default is the chart's appVersion |
| imagePullSecrets | list | `[]` | Image pull secrets for Docker images |
| nameOverride | string | `""` | Overrides the chart's name |
| nodeSelector | object | `{}` | Node selector for vulture pods |
| podAnnotations | object | `{}` | Common annotations for all pods |
| podLabels | object | `{}` | Common labels for all pods |
| podMonitor.annotations | object | `{}` | PodMonitor annotations |
| podMonitor.enabled | bool | `false` | If enabled, PodMonitor resources for Prometheus Operator are created |
| podMonitor.interval | string | `nil` | PodMonitor scrape interval |
| podMonitor.labels | object | `{}` | Additional PodMonitor labels |
| podMonitor.namespace | string | `nil` | Alternative namespace for PodMonitor resources |
| podMonitor.namespaceSelector | object | `{}` | Namespace selector for PodMonitor resources |
| podMonitor.scrapeTimeout | string | `nil` | PodMonitor scrape timeout in Go duration format (e.g. 15s) |
| podSecurityContext | object | `{}` | podSecurityContext holds pod-level security attributes and common container settings |
| replicas | int | `1` | Number of replicas of Tempo Vulture |
| resources | object | `{}` | Resource requests and limits for the vulture |
| revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain to allow rollback |
| securityContext | object | `{}` | SecurityContext holds container-level security attributes and common container settings |
| serviceAccount.annotations | object | `{}` | Annotations for the service account |
| serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| serviceAccount.imagePullSecrets | list | `[]` | Image pull secrets for the service account |
| serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| tempoAddress.push | string | `nil` | the url towards your Tempo distributor, e.g. http://distributor |
| tempoAddress.query | string | `nil` | the url towards your Tempo query-frontend, e.g. http://query-frontend:3200 |
| tolerations | list | `[]` | Tolerations for vulture pods |