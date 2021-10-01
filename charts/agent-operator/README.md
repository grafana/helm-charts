# agent-operator

![Version: 0.1.8](https://img.shields.io/badge/Version-0.1.8-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.19.0](https://img.shields.io/badge/AppVersion-v0.19.0-informational?style=flat-square)

A Helm chart for Grafana Agent Operator

## Source Code

* <https://github.com/grafana/agent>

## Chart Repo

```shell
helm repo add grafana https://grafana.github.io/helm-charts
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Deploy Grafana Agent Operator

This kind of deployment uses configuration specified at the time of deployment.

```shell
cat <<END | helm upgrade --create-namespace --namespace grafana --values - --install agent-operator grafana/agent-operator
# Keep the resource names simple
fullnameOverride: grafana-agent-operator
END
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Pod affinity |
| annotations | object | `{}` | Deployment annotations |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.pullSecrets | list | `[]` | List of image pull secrets |
| image.repository | string | `"grafana/agent-operator"` | Image repository and name |
| image.tag | string | `""` | Overrides the image tag whose default is the chart `appVersion` |
| nodeSelector | object | `{}` | Pod node selector |
| podAnnotations | object | `{}` | Pod annotations |
| podSecurityContext | object | `{}` | Security context for the Agent pod |
| rbac.create | bool | `true` | Whether to create Cluster Role and Cluster Role Binding |
| rbac.extraClusterRoleRules | list | `[]` | Extra ClusterRole rules |
| rbac.useExistingRole | string | `nil` | Use an existing ClusterRole/Role |
| resources | object | `{}` | Resources for the Agent container |
| securityContext | object | `{}` | Security context for the Agent container |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Whether to create the Service Account used by the Pod |
| serviceAccount.name | string | `""` | If not set and `create` is `true`, a name is generated using the fullname template |
| tolerations | list | `[]` | Pod tolerations |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Jiri Tyr | jiri.tyr@gmail.com | https://github.com/jtyr |
