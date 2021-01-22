# Grafana Metrics Enterprise Helm Chart

Helm chart for deploying [Grafana Metrics Enterprise](https://grafana.com/products/metrics-enterprise/) to Kubernetes. Originally forked from the [Cortex Helm Chart](https://github.com/cortexproject/cortex-helm-chart)

## Dependencies

## Grafana Metrics Enterprise license

In order to use the enterprise features of Grafana Metrics Enterprise, you need to provide the contents of a Grafana Metrics Enterprise license file as the value for the `license.contents` variable.
To obtain a Grafana Metrics Enterprise license, refer to [Get a license](https://grafana.com/docs/metrics-enterprise/latest/getting-started/#get-a-license).

### Key-Value store

Grafana Metrics Enterprise requires an externally provided key-value store, such as [etcd](https://etcd.io/) or [Consul](https://www.consul.io/).

Both services can be installed alongside Grafana Metrics Enterprise, for example using helm charts available [here](https://github.com/bitnami/charts/tree/master/bitnami/etcd) and [here](https://github.com/helm/charts/tree/master/stable/consul).

For convenient first time set up, consul is deployed in the default configuration.

### Storage

Grafana Metrics Enterprise requires an object storage backend to store metrics and indexes.

The default chart values will deploy [Minio](https://min.io) for initial set up. Production deployments should use a separately deployed object store.
See [cortex documentation](https://cortexmetrics.io/docs/) for details on storage types and documentation.

## Installation

To install the chart with licensed features enabled, using a local Grafana Metrics Enterprise license file called `license.jwt`:

```console
$ # Add the repository
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo update
$ # Perform install
$ helm install <cluster name> grafana/metrics-enterprise --set-file 'license.contents=./license.jwt'
```

As part of this chart many different pods and services are installed which all
have varying resource requirements. Please make sure that you have sufficient
resources (CPU/memory) available in your cluster before installing Grafana Metrics Enterprise Helm
chart.


# Development

To configure a local default storage class for k3d:

```console
$ kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
$ kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```
