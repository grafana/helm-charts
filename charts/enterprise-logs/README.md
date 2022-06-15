# Grafana Enterprise Logs Helm Chart

A Helm chart for deploying [Grafana Enterprise Logs](https://grafana.com/products/enterprise/logs/) to Kubernetes.

## Dependencies

This chart depends on the
[`loki-distributed`](https://github.com/grafana/helm-charts/tree/main/charts/loki-distributed) Helm
chart and extends it with Grafana Enterprise Logs components and configuration.
It also depends on [`minio`](https://github.com/minio/charts/tree/master/minio) Helm chart, if the
variable `minio.enabled` is set to `true` (only recommended for testing).

## Requirements

### License

In order to use any enterprise features of Grafana Enterprise Logs, you need to provide the contents
of a Grafana Enterprise Logs license file as the value for the `license.contents` variable. To
obtain a Grafana Enterprise Logs license, refer to [Get a
license](https://grafana.com/docs/enterprise-logs/latest/get-a-license/).

### Storage

Grafana Enterprise Logs requires an object storage backend to store logs and indexes as well as
metadata objects.

The default chart values will deploy [Minio](https://min.io) for initial set up. Production
deployments must use a separately deployed object store or use a compatible storage from cloud
providers, such as Amazon S3, Google Cloud Storage (GCS), or Microsoft Azure Blob Storage.

## Installation

To install the chart with licensed features enabled, using a local Grafana Enterprise Logs
license file called `license.jwt`:

```console
$ # Add the repository
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo update
$ # Perform install
$ helm install <cluster name> grafana/enterprise-logs \
    --set-file 'license.contents=./license.jwt'
```

As part of this chart many different pods and services are installed which all have varying resource
requirements. Please make sure that you have sufficient resources (CPU/memory) available in your
cluster before installing Grafana Enterprise Logs Helm chart.

### Scale values

The default Helm chart values in the `values.yaml` file are configured to allow you to quickly test
out Grafana Enterprise Logs. Alternative values files are included to provide a more realistic
configuration that should facilitate a certain level of ingest and query load.

#### `small.yaml`

These values configure the Grafana Enterprise Logs cluster to handle production ingestion of
~11MiB/s.

To deploy a cluster using `small.yaml` values file:

```console
$ helm install <cluster name> grafana/enterprise-logs \
    --set-file 'license.contents=./license.jwt' \
    -f small.yaml
```

### Updating the GEL version in custom values file

If you need to update the GEL version in a custom values file that overrides
the default vaules, you need to be careful to also override the version in the
`loki-distributed.loki.image` block. This is necessary, because that block
controls the name and version of the image used in the
[loki-enterprise](../loki-enterprise) child chart.

Setting a version in a custom values file without duplicating the value can be
achieved by using a YAML anchor and pointer, like so:

```yaml
image:
  tag: &version v1.2.1

...

loki-distributed:
  loki:
    image:
      tag: *version
```

## Contributing/Releasing

All changes require a bump to the chart version, as this enforced by CI. All changes to the chart
itself should also have a corresponding changelog entry.

When making a change and organizing a release, first ensure your changes are encapuslated in a
commit with a [meaningful commit message](https://chris.beams.io/posts/git-commit/). In a separate
commit, increase the chart version in the `Chart.yaml` file and add an entry in the `CHANGELOG.md`
file under the new version.

Finally, push your changes and open up a pull request with the prefix `[enterprise-logs]` in the
title.

### Updating the GEL version

When updating the GEL version, it is necessary to change the value in both the
`Chart.yaml` as well as in the `values.yaml`.
