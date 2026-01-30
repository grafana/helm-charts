# Grafana Community Kubernetes Helm Charts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/grafana)](https://artifacthub.io/packages/search?repo=grafana)
[![Release Charts](https://github.com/grafana-community/helm-charts/actions/workflows/release.yaml/badge.svg)](https://github.com/grafana-community/helm-charts/actions/workflows/release.yaml)

The code is provided as-is with no warranties.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add grafana-community https://grafana-community.github.io/helm-charts
```

You can then run `helm search repo grafana-community` to see the charts.

<!-- Keep full URL links to repo files because this README syncs from main to gh-pages.  -->
Chart documentation is available in [grafana directory](https://github.com/grafana-community/helm-charts/blob/main/charts/grafana/README.md).

**OCI artifacts of all Grafana Community Helm charts are available in [ghcr.io](https://github.com/orgs/grafana-community/packages?repo_name=helm-charts).**

## Helm Provenance and Integrity

All charts in this repository are signed. More information about how to verify charts can be found in the official [Helm documentation](https://helm.sh/docs/topics/provenance/).

A local running gpg agent is mandatory.

To import the signing key for this repository, please run the following command:

```console
curl https://grafana-community.github.io/helm-charts/pubkey.gpg | gpg --import
```

After importing the key, you can use the `--verify` flag during `helm install` to enable chart signature validation.

## Contributing

<!-- Keep full URL links to repo files because this README syncs from main to gh-pages.  -->
We'd love to have you contribute! Please refer to our [contribution guidelines](https://github.com/grafana-community/helm-charts/blob/main/CONTRIBUTING.md) for details.

## License

<!-- Keep full URL links to repo files because this README syncs from main to gh-pages.  -->
[Apache 2.0 License](https://github.com/grafana-community/helm-charts/blob/main/LICENSE).
