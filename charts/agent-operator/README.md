# Grafana Agent Operator Helm Chart

![Version: 0.1.4](https://img.shields.io/badge/Version-0.1.4-informational?style=flat-square) ![AppVersion: v0.18.2](https://img.shields.io/badge/AppVersion-v0.18.2-informational?style=flat-square)

This Helm chart allows to deploy the Grafana Agent Operator.


## Prerequisites

Make sure you have Helm [installed](https://helm.sh/docs/using_helm/#installing-helm).


## Get Repo Info

```shell
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
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


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Jiri Tyr | jiri.tyr(at)gmail.com | [https://github.com/jtyr](https://github.com/jtyr) |


## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | Number of replicas to run |
| annotations | object | `{}` | Deployment annotations. |
| podAnnotations | object | `{}` | Pod annotations. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| image.pullSecrets | list | `[]` | List of image pull secrets. |
| image.repository | string | `"grafana/agent"` | Image repository and name. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart `appVersion`. |
| serviceAccount.annotations | object | `{}` | Service Account annotations. |
| serviceAccount.create | bool | `true` | Whether the Service Account should be created. |
| serviceAccount.name | string | `""` | Service Account name. |
| resources | object | `{}` | Resources for the Agent container. |
| rbac.create | bool | `true` | Whether to create Cluster Role and Cluster Role Binding. |
| rbac.useExistingRole | string | `""` | Name of existing Role or Cluster role to use. |
| rbac.extraClusterRoleRules | list | `[]` | Extra ClusterRole rules. |
| podSecurityContext | object | `{}` | Security context for the Agent Pod. |
| securityContext | object | `{}` | Security context for the Agent container. |
| nodeSelector | object | `{}` | Pod node selector. |
| autoscaling.enabled | bool | `false` | Whether the HPA is enabled or not. |
| autoscaling.minReplicas | int | `1` | Minimal number of repliocas to de-scale to. |
| autoscaling.maxReplicas | int | `100` | Maximum number of replicas to scale to. |
| targetCPUUtilizationPercentage | int | `80` | Target CPU untilization percentage which triggers the autoscaling. |
| tolerations | list | `[]` | List of Pod tolerations. |
| affinity | object | `{}` | Pod affinity. |
