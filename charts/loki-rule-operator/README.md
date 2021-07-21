
# loki-rule-operator

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.5.0](https://img.shields.io/badge/AppVersion-v0.5.0-informational?style=flat-square)

Install CRDs to handle Loki rules

## Source Code

* <https://github.com/opsgy/loki-rule-operator>

## Chart Repo

Add the following repo to use the chart:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| admissionWebhooks.annotations | object | `{}` | Additionnal annotations for the admission webhook |
| admissionWebhooks.enabled | bool | `true` | Enable admission webhooks to validate CRDs |
| affinity | object | `{}` | Affinity for the pod |
| certManager.enabled | bool | `true` | Enable the creation of a Certificate for cert-manager. This is only useful if admissionWebhooks.enabled is true |
| certManager.group | string | `"cert-manager.io"` |  |
| certManager.issuerName | string | `"selfsigned"` | Name of the issuer |
| certManager.kind | string | `"ClusterIssuer"` | Kind of issuer to use |
| fullnameOverride | string | `""` | Overrides the chart's computed fullname |
| image.pullPolicy | string | `"IfNotPresent"` | The pull policy |
| image.repository | string | `"eu.gcr.io/opsgy-com/loki-rule-operator"` | The Docker registry for the image |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | Image pull secrets for Docker images |
| loki.rulesConfigMap.name | string | `"loki-rules"` | Name of the loki configmap storing the rules |
| loki.rulesConfigMap.namespace | string | `""` | Namespace where the loki rules configmap reside in |
| nameOverride | string | `""` | Overrides the chart's name |
| nodeSelector | object | `{}` | Node selector for the pod |
| podAnnotations | object | `{}` | Annotations for pod |
| podSecurityContext | object | `{"fsGroup":2000,"runAsUser":10000}` | The SecurityContext for pod |
| replicaCount | int | `1` | Number of replica |
| resources | object | `{}` | Resource requests and limits |
| securityContext | object | `{"readOnlyRootFilesystem":true}` | The SecurityContext for the containers |
| service | object | `{"port":443,"type":"ClusterIP"}` | Service configuration |
| service.port | int | `443` | Port of the service |
| service.type | string | `"ClusterIP"` | Type of service |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `"loki-rule-operator"` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration for the pod |
