# Grafana Mimir Helm Chart

Helm chart for deploying [Grafana Mimir](https://grafana.com/docs/mimir/v2.0.x) to Kubernetes. Derived from [Grafana Enterprise Metrics Helm Chart](https://github.com/grafana/helm-charts/blob/main/charts/enterprise-metrics/README.md)

# mimir-distributed

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![AppVersion: 2.0.0](https://img.shields.io/badge/AppVersion-2.0.0-informational?style=flat-square)

Grafana Mimir

## Requirements

Kubernetes: `^1.10.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | memcached | 5.5.2 |
| https://charts.bitnami.com/bitnami | memcached | 5.5.2 |
| https://charts.bitnami.com/bitnami | memcached | 5.5.2 |
| https://helm.min.io/ | minio | 8.0.10 |

### Storage

Grafana Mimir requires an object storage backend to store metrics and indexes.

The default chart values will deploy [Minio](https://min.io) for initial set up. Production deployments should use a separately deployed object store.
See [Grafana Mimir documentation](https://grafana.com/docs/mimir/v2.0.x) for details on storage types and documentation.

## Installation

```console
$ # Add the repository
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo update
$ # Perform install
$ helm install <cluster name> grafana/mimir-distributed
```

As part of this chart many different pods and services are installed which all
have varying resource requirements. Please make sure that you have sufficient
resources (CPU/memory) available in your cluster before installing Grafana Mimir Helm Chart.

### Scale values

The default Helm chart values in the `values.yaml` file are configured to allow you to quickly test out Grafana Mimir.
Alternative values files are included to provide a more realistic configuration that should facilitate a certain level of ingest load.

### Small

The `small.yaml` values file configures the Grafana Mimir cluster to
handle production ingestion of ~1M active series using the blocks storage engine.
Query requirements can vary dramatically depending on query rate and query
ranges. The values here satisfy a "usual" query load as seen from our
production clusters at this scale.
It is important to ensure that you run no more than one ingester replica
per node so that a single node failure does not cause data loss. Zone aware
replication can be configured to ensure data replication spans availability
zones. Refer to [Zone Aware Replication](https://grafana.com/docs/mimir/v2.0.x/operators-guide/configuring/configuring-zone-aware-replication/)
for more information.
Minio is no longer enabled and you are encouraged to use your cloud providers
object storage service for production deployments.

To deploy a cluster using `small.yaml` values file:

```console
$ helm install <cluster name> grafana/mimir-distributed -f small.yaml
```

### Large

The `large.yaml` values file configures the Grafana Mimir cluster to
handle production ingestion of ~10M active series using the blocks
storage engine.
Query requirements can vary dramatically depending on query rate and query
ranges. The values here satisfy a "usual" query load as seen from our
production clusters at this scale.
It is important to ensure that you run no more than one ingester replica
per node so that a single node failure does not cause data loss. Zone aware
replication can be configured to ensure data replication spans availability
zones. Refer to [Zone Aware Replication](https://grafana.com/docs/mimir/v2.0.x/operators-guide/configuring/configuring-zone-aware-replication/)
for more information.
Minio is no longer enabled and you are encouraged to use your cloud providers
object storage service for production deployments.

To deploy a cluster using the `large.yaml` values file:

```console
$ helm install <cluster name> grafana/mimir-distributed -f large.yaml
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

Finally, push your changes and open up a Pull Request with the prefix `[mimir-distributed]`.
