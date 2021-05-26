# agent

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.14.0](https://img.shields.io/badge/AppVersion-0.14.0-informational?style=flat-square)

Grafana Agent is a telemetry collector for sending metrics, logs, and trace data to the opinionated Grafana observability stack.

## Source Code

* <https://grafana.com/docs/grafana-cloud/agent/>

## Chart Repo

Add the following repo to use the chart:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```

## Upgrading

A major chart version change indicates that there is an incompatible breaking change needing manual actions.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity configuration for pods |
| agentServerConfig | string | See `values.yaml` | Section for configuring the server part of the agent |
| annotations | object | `{}` | Annotations for the SaemonSet |
| containerSecurityContext | object | `{"privileged":true,"runAsUser":0}` | The security context for container |
| defaultVolumeMounts | list | See `values.yaml` | Default volume mounts. Corresponds to `volumes`. |
| defaultVolumes | list | See `values.yaml` | Default volumes that are mounted into pods. In most cases, these should not be changed. Use `extraVolumes`/`extraVolumeMounts` for additional custom volumes. |
| extraArgs | list | `[]` |  |
| extraEnv | list | `[]` | Extra environment variables |
| extraEnvFrom | list | `[]` | Extra environment variables from secrets or configmaps |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| fullnameOverride | string | `nil` | Overrides the chart's computed fullname |
| image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| image.registry | string | `"docker.io"` | The Docker registry |
| image.repository | string | `"grafana/agent"` | Docker image repository |
| image.tag | string | `nil` | Overrides the image tag whose default is the chart's appVersion |
| imagePullSecrets | list | `[]` | Image pull secrets for Docker images |
| integrationsConfig | string | See `values.yaml` | Section for configuring the integrations part of the agent |
| loki.basicAuth | object | `{}` | Credentials of the remote endpoint |
| loki.config | string | See `values.yaml` | Section for configuring the loki part of the agent |
| loki.enabled | bool | `true` | Enable metrics collection in daemonset mode. automatically mount /var/log and /var/lib/docker/containers to the pod when enabled |
| loki.pushURL | string | `"http://localhost/loki/api/v1/push"` |  |
| loki.tenant | string | `""` | Add the tenant option to the requests, usefull when using multitenant loki feature |
| nameOverride | string | `nil` | Overrides the chart's name |
| nodeSelector | object | `{}` | Node selector for pods |
| podAnnotations | object | `{}` | Pod annotations |
| podLabels | object | `{}` | Pod labels |
| podSecurityContext | object | `{}` | The security context for pods |
| priorityClassName | string | `nil` | The name of the PriorityClass |
| prometheusDaemonSet.basicAuth | object | `{}` | Credentials of the remote endpoint |
| prometheusDaemonSet.config | string | See `values.yaml` | Section for configuring the prometheus daemonset part of the agent |
| prometheusDaemonSet.enabled | bool | `true` | Enable metrics collection in daemonset mode |
| prometheusDaemonSet.remoteWriteURL | string | `"http://localhost/api/prom/push"` |  |
| prometheusDaemonSet.tenant | string | `""` | Add the X-Scope-OrgID header to the requests, usefull when using multitenant cortex feature |
| prometheusDeployment.basicAuth | object | `{}` | Credentials of the remote endpoint |
| prometheusDeployment.config | string | See `values.yaml` | Section for configuring the prometheus deployment part of the agent |
| prometheusDeployment.enabled | bool | `true` | Enable metrics collection in deployment mode |
| prometheusDeployment.remoteWriteURL | string | `"http://localhost/api/prom/push"` |  |
| prometheusDeployment.tenant | string | `""` | Add the X-Scope-OrgID header to the requests, usefull when using multitenant cortex feature |
| rbac.create | bool | `true` | Specifies whether RBAC resources are to be created |
| rbac.pspEnabled | bool | `false` | Specifies whether a PodSecurityPolicy is to be created |
| resources | object | `{}` | Resource requests and limits |
| serviceAccount.annotations | object | `{}` | Annotations for the service account |
| serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| serviceAccount.imagePullSecrets | list | `[]` | Image pull secrets for the service account |
| serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and `create` is true, a name is generated using the fullname template |
| tempo.basicAuth | object | `{}` | Credentials of the remote endpoint |
| tempo.config | string | See `values.yaml` | Section for configuring the tempo daemonset part of the agent |
| tempo.enabled | bool | `true` | Enable trace collection in daemonset mode |
| tempo.remoteWriteURL | string | `"http://localhost"` |  |
| tempo.tenant | string | `""` | Add the X-Scope-OrgID header to the requests, usefull when using multitenant tempo feature |
| tolerations | list | `[{"effect":"NoSchedule","key":"node-role.kubernetes.io/master","operator":"Exists"}]` | Tolerations for pods. By default, pods will be scheduled on master nodes. |
| updateStrategy | object | `{"type":"RollingUpdate"}` | The update strategy for the DaemonSet |

## Configuration

The config file for the Agent must be configured as string.
This is necessary because the contents are passed through the `tpl` function.
With this, the file can be templated and assembled from reusable YAML snippets.
See `values.yaml´ for details.

### node\_exporter

If you want to use the `node\_exporter` integration, please add it to the `integrationsConfig`
section and also include the following changes:
```yaml
integrationsConfig: |
  agent:
    enabled: true
  node_exporter:
    enabled: true
    rootfs_path: /host/root
    sysfs_path: /host/sys
    procfs_path: /host/procfs
extraVolumes:
  - hostPath:
      path: /
    name: rootfs
  - hostPath:
      path: /sys
    name: sysfs
  - hostPath:
      path: /proc
    name: procfs
extraVolumeMounts:
  - mountPath: /host/root
    name: rootfs
    readOnly: true
  - mountPath: /host/sys
    name: sysfs
    readOnly: true
  - mountPath: /host/proc
    name: procfs
    readOnly: true
```
