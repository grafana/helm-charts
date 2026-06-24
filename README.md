# Grafana Kubernetes Helm Charts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/grafana)](https://artifacthub.io/packages/search?repo=grafana)

The code is provided as-is with no warranties.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```

You can then run `helm search repo grafana` to see the charts.

<!-- Keep full URL links to repo files because this README syncs from main to gh-pages.  -->
Chart documentation is available in [grafana directory](https://github.com/grafana/helm-charts/blob/main/charts/grafana/README.md).

## Helm Provenance and Integrity

Charts in this repository may be signed, allowing you to verify their integrity and
origin. More information about how provenance works can be found in the official
[Helm documentation](https://helm.sh/docs/topics/provenance/).

A local running GPG agent is required to complete the verification process.

To add the public signing key to your keyring, run:

```console
curl https://grafana.github.io/helm-charts/pubkey.gpg | gpg --import
```

Depending on your GnuPG version (2.1+ in particular), you may need to export the
imported key so that Helm can find it:

```console
gpg --export > ~/.gnupg/pubring.gpg
```

Once your keyring is configured, pass the `--verify` flag to `helm install`,
`helm upgrade`, `helm pull`, or `helm template` to validate a chart's signature and
confirm its authenticity.

## Contributing

<!-- Keep full URL links to repo files because this README syncs from main to gh-pages.  -->
We'd love to have you contribute! Please refer to our [contribution guidelines](https://github.com/grafana/helm-charts/blob/main/CONTRIBUTING.md) for details.

## License

<!-- Keep full URL links to repo files because this README syncs from main to gh-pages.  -->
[Apache 2.0 License](https://github.com/grafana/helm-charts/blob/main/LICENSE).
