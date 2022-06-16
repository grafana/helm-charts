# Grafana Enterprise Metrics Helm Chart

Helm chart for deploying [Grafana Enterprise Metrics](https://grafana.com/enterprise/metrics) to Kubernetes. Originally forked from the [Cortex Helm Chart](https://github.com/cortexproject/cortex-helm-chart)

## Deprecation warning

This chart is now deprecated and will no longer be updated. Grafana Enterprise Metrics v2.0.0 is included in the new `mimir-distributed` chart which implements Grafana Enterprise Metrics as an option (`enterprise.enabled: true`). To upgrade to using the new chart, see the [Grafana Enterprise Metrics migration guide](https://grafana.com/docs/enterprise-metrics/latest/migrating-from-gem-1.7/).

## Dependencies

## Grafana Enterprise Metrics license

In order to use the enterprise features of Grafana Enterprise Metrics, you need to provide the contents of a Grafana Enterprise Metrics license file as the value for the `license.contents` variable.
To obtain a Grafana Enterprise Metrics license, refer to [Get a license](https://grafana.com/docs/metrics-enterprise/latest/getting-started/#get-a-license).

### Storage

Grafana Enterprise Metrics requires an object storage backend to store metrics and indexes.

The default chart values will deploy [Minio](https://min.io) for initial set up. Production deployments should use a separately deployed object store.
See [cortex documentation](https://cortexmetrics.io/docs/) for details on storage types and documentation.

## Installation

To install the chart with licensed features enabled, using a local Grafana Enterprise Metrics license file called `license.jwt`:

```console
$ # Add the repository
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo update
$ # Perform install
$ helm install <cluster name> grafana/enterprise-metrics --set-file 'license.contents=./license.jwt'
```

As part of this chart many different pods and services are installed which all
have varying resource requirements. Please make sure that you have sufficient
resources (CPU/memory) available in your cluster before installing Grafana Enterprise Metrics Helm
chart.

### Scale values

The default Helm chart values in the `values.yaml` file are configured to allow you to quickly test out Grafana Enterprise Metrics.
Alternative values files are included to provide a more realistic configuration that should facilitate a certain level of ingest load.

### Small

The `small.yaml` values file configures the Grafana Enterprise Metrics cluster to
handle production ingestion of ~1M active series using the blocks storage engine.
Query requirements can vary dramatically depending on query rate and query
ranges. The values here satisfy a "usual" query load as seen from our
production clusters at this scale.
It is important to ensure that you run no more than one ingester replica
per node so that a single node failure does not cause data loss. Zone aware
replication can be configured to ensure data replication spans availability
zones. Refer to [Zone Aware Replication](https://cortexmetrics.io/docs/guides/zone-aware-replication/)
for more information.
Minio is no longer enabled and you are encouraged to use your cloud providers
object storage service for production deployments.

To deploy a cluster using `small.yaml` values file:

```console
$ helm install <cluster name> grafana/enterprise-metrics --set-file 'license.contents=./license.jwt' -f small.yaml
```

### Large

The `large.yaml` values file configures the Grafana Enterprise Metrics cluster to
handle production ingestion of ~10M active series using the blocks
storage engine.
Query requirements can vary dramatically depending on query rate and query
ranges. The values here satisfy a "usual" query load as seen from our
production clusters at this scale.
It is important to ensure that you run no more than one ingester replica
per node so that a single node failure does not cause data loss. Zone aware
replication can be configured to ensure data replication spans availability
zones. Refer to [Zone Aware Replication](https://cortexmetrics.io/docs/guides/zone-aware-replication/)
for more information.
Minio is no longer enabled and you are encouraged to use your cloud providers
object storage service for production deployments.

To deploy a cluster using the `large.yaml` values file:

```console
$ helm install <cluster name> grafana/enterprise-metrics --set-file 'license.contents=./license.jwt' -f large.yaml
```

# Development

To configure a local default storage class for k3d:

```console
$ kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
$ kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

To install the chart with the values used in CI tests:

```console
$ helm install test ./ --values ./ci/test-values.yaml
```

# Contributing/Releasing

All changes require a bump to the chart version, as this enforced by CI. All changes to the chart itself should also have a corresponding CHANGELOG entry.

When making a change and organizing a release, first ensure your changes are encapuslated in a meaningful commit.
In a separate commit, increase the chart version in the `Chart.yaml` file and add a CHANGELOG entry in the `CHANGELOG.md` file under the new version.

Finally, push your changes and open up a Pull Request with the prefix `[enterprise-metrics]`.
