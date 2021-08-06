# Grafana Agent Helm Chart

![Version: 0.2.5](https://img.shields.io/badge/Version-0.2.5-informational?style=flat-square) ![AppVersion: v0.18.2](https://img.shields.io/badge/AppVersion-v0.18.2-informational?style=flat-square)

This Helm chart allows to deploy the Grafana Agent via Grafana Agent Operator.


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
cat <<END | helm upgrade --create-namespace --namespace grafana --values - --install agent grafana/agent
# Keep the resource names simple
fullnameOverride: grafana-agent
# Run 3 replicas of the agent
prometheus:
  replicas: 3
END
```


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Jiri Tyr | jiri.tyr(at)gmail.com | [https://github.com/jtyr](https://github.com/jtyr) |


## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Pod affinity. |
| annotations | object | `{}` | GrafanaAgent annotations. |
| extras | object | `{}` | Extra GrafanaAgent configuration. |
| image.pullSecrets | list | `[]` | List of image pull secrets. |
| image.repository | string | `"grafana/agent"` | Image repository and name. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart `appVersion`. |
| logLevel | string | `"info"` | Log level. |
| nodeSelector | object | `{}` | Pod node selector. |
| podAnnotations | object | `{}` | Pod annotations. |
| prometheus.create | bool | `true` | Whether to configure prometheus Agent. |
| prometheus.extras | object | `` | Extra settings for Prometheus-specific pods. |
| prometheus.instanceSelectorMatchExpressions | list | `[]` | PrometheusInstance selector based on expression matching. |
| prometheus.instanceSelectorMatchLabels | object | `agent: grafana-agent` | PrometheusInstance selector based on label matching. |
| prometheus.replicas | int | `1` | Number of replicas of each shard to deploy for metrics pods. |
| rbac.create | bool | `true` | Whether to create Cluster Role and Cluster Role Binding. |
| rbac.extraClusterRoleRules | list | `[]` | Extra ClusterRole rules. |
| rbac.useExistingRole | string | `""` | Name of existing Role or Cluster role to use. |
| resources | object | `{}` | Resources for the Agent container. |
| securityContext | object | `{}` | Security context for the Agent container. |
| serviceAccount.annotations | object | `{}` | Service Account annotations. |
| serviceAccount.create | bool | `true` | Whether the Service Account should be created. |
| serviceAccount.name | string | `""` | Service Account name. |
| tolerations | list | `[]` | List of Pod tolerations. |
| volumeMounts | list | `[]` | List of volume mounts. |
| volumes | list | `[]` | List of volumes. |
