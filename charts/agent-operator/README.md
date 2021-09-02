# Grafana Agent Operator

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.18.2](https://img.shields.io/badge/AppVersion-0.18.2-informational?style=flat-square)

Helm Chart for the [Grafana Agent Operator](https://grafana.com/docs/agent/latest/operator/).

Note that this chart does not provision custom resources like `GrafanaAgent` and `MetricsInstance` (formerly `PrometheusInstance`) or any `*Monitor` resources.

To learn how to deploy these resources, please see [Get started with Grafana Agent Operator](https://grafana.com/docs/agent/latest/operator/getting-started/). 

## CRDs

The CRDs are synced from the Grafana Agent [GitHub repo](https://github.com/grafana/agent/tree/main/production/operator/crds). To learn more about how Helm manages CRDs, please see [Custom Resource Definitions](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/) from the Helm docs.

## Get Repo Info

```console
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release grafana/ga-operator
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Upgrading an existing Release to a new major version

A major chart version change (like v1.2.3 -> v2.0.0) indicates that there is an
incompatible breaking change needing manual actions.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| annotations | object | `{}` |  |
| fullnameOverride | string | `""` | Overrides the chart's computed fullname |
| imagePullSecrets | list | `[]` |  |
| image.registry | string | `"docker.io"` | |
| image.repository | string | `"grafana/agent-operator"` | |
| image.tag | string | `"v0.18.2"` | |
| image.pullPolicy | string | `"IfNotPresent"` | | 
| nameOverride | string | `""` | Overrides the chart's name |
| nodeSelector | object | `{}` |  |
| podAnnotations | list | `[]` |  |
| rbac.create | bool | `true` | Specifies whether ClusterRole and ClusterRoleBinding should be created |
| resources | object | `{}` | Specifies any limits or requests |
| serviceAccount.annotations | object | `{}` | Annotations for the service account |
| serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` |  |