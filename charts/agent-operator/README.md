# grafana-agent-operator

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.18.2](https://img.shields.io/badge/AppVersion-0.18.2-informational?style=flat-square)

A Helm chart for the Grafana Agent Operator

## Source Code

* <https://github.com/grafana/agent/tree/main/pkg/operator>

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
| affinity | object | `{}` | Pod affinity configuration |
| annotations | object | `{}` | Annotations for the Deployment |
| fullnameOverride | string | `""` | Overrides the chart's computed fullname |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.pullSecrets | list | `[]` | Image pull secrets |
| image.registry | string | `"docker.io"` | Image registry |
| image.repository | string | `"grafana/agent-operator"` | Image repo |
| image.tag | string | `"v0.18.2"` | Image tag |
| nameOverride | string | `""` | Overrides the chart's name |
| nodeSelector | object | `{}` | nodeSelector configuration |
| podAnnotations | object | `{}` | Annotations for the Deployment Pods |
| podSecurityContext | object | `{}` | Pod security context (runAsUser, etc.) |
| rbac | object | `{"create":true}` | Toggle to create ClusterRole and ClusterRoleBinding |
| resources | object | `{}` | Resource limits and requests config |
| serviceAccount.create | bool | `true` | Toggle to create ServiceAccount |
| serviceAccount.name | string | `nil` | Service account name |
| tolerations | list | `[]` | Tolerations applied to Pods |
