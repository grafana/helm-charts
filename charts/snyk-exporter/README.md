# snyk-exporter

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![AppVersion: v1.4.1](https://img.shields.io/badge/AppVersion-v1.4.1-informational?style=flat-square)

Prometheus exporter for Snyk.

## Usage

The Helm chart can be installed like this:

```shell
helm upgrade --install myrelease .
```

The Helm chart can be configured by providing an extra values:

```shell
cat <<END | helm upgrade --install --values - myrelease .
# This is an example how to configure the Snyk exporter for kube-prometheus-stack
exporter:
  apiToken: 87654321-432104321-4321-210987654321
  organizations:
    - 12345678-1234-1234-1234-123456789012
  origins:
    - kubernetes
  projectFilter: attributes.imageCluster=my-prod-cluster
  timeout: 30
END
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Pod affinity |
| exporter.apiToken | string | `nil` | Snyk API token. This must be provided if `secret.create: true`. |
| exporter.apiURL | string | `nil` | Snyk API URL (legacy). If not specified, `https://snyk.io/api/v1` is used by default. |
| exporter.argsFile | string | `nil` | Path to the file containing commandline arguments insude the container |
| exporter.extraArgs | list | `[]` | List of extra command line arguments to pass to the exporter |
| exporter.interval | string | `nil` | Polling interval for requesting data from Snyk API in seconds. If not specified, `600` is used by default. |
| exporter.logFormat | string | `nil` | Log target and format |
| exporter.logLevel | string | `nil` | Log level (`debug`, `info`, `warn`, `error` or `fatal`). If not set, `info` is used by default. |
| exporter.organizations | list | `[]` | List of Snyk organization IDs. If not specified, all organizations will be scraped. |
| exporter.origins | list | `[]` | List of Snyk project origins. If not specified, all origins will be scraped. |
| exporter.port | int | `9532` | Metrics port number for the exporter |
| exporter.projectFilter | string | `nil` | Project filter (e.g. `attributes.imageCluster=mycluster`) |
| exporter.restAPIURL | string | `nil` | Snyk REST API URL. If not specified, `https://api.snyk.io/rest` is used by default. |
| exporter.restAPIVersion | string | `nil` | Snyk REST API Version. If not set, `2023-06-22` is used by default. |
| exporter.targets | list | `[]` | List of Snyk targets. If not specified, all targets will be scraped. |
| exporter.timeout | string | `nil` | Timeout for requests against Snyk API in seconds. If not specified, `10` is used by default. |
| fullnameOverride | string | `nil` | Helm chart full name override |
| image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| image.repository | string | `"grafana/snyk_exporter"` | Docker image registry where the Docker image resides |
| image.tag | string | `nil` | Docker image tag. If not specified, the chart `appVersion` is used by default. |
| imagePullSecrets | list | `[]` | List of Docker image pull sercrets |
| nameOverride | string | `nil` | Helm chart name override |
| nodeSelector | object | `{}` | Node selector |
| podAnnotations | object | `{}` | Pod annotations |
| podSecurityContext | object | See the [`values.yaml`](values.yaml) file | Pod security context |
| replicas | int | `1` | Number of replicas to run |
| resources | object | `{}` | Pod resources |
| secret.annotations | object | `{}` |  |
| secret.asEnv | bool | `true` | Whether the Snyk API token from the secret should be used as environment variable |
| secret.create | bool | `true` | Whether the secret holding the Snyk API key will be created or not |
| secret.key | string | `"snykApiToken"` | Key under which the Snyk API key will be stored in the Secret |
| secret.labels | object | `{}` | Labels for the secret |
| secret.name | string | `""` | Name of the secret. Automatically generated if not set. |
| securityContext | object | See the [`values.yaml`](values.yaml) file | Container security context |
| service.port | string | `nil` | Service port. If not specified, the `exporter.port` is used by default. |
| service.type | string | `"ClusterIP"` | Service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `nil` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor.create | bool | `false` | Whether the Prometheus `ServiceMonitor` will be created or not |
| serviceMonitor.interval | string | `nil` | Metrics scrape interval |
| serviceMonitor.labels | object | `{}` | Labels applied to the `ServiceMonitor` resource |
| serviceMonitor.metricRelabelings | list | `[]` | List of metric relabelings |
| serviceMonitor.relabelings | list | `[]` | List of relabelings |
| serviceMonitor.scrapeTimeout | string | `nil` | Metrics scrape timeout |
| tolerations | list | `[]` | Pod tolerations |
