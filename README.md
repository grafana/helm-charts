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

## Verifying OCI charts with Cosign

In addition to the GPG provenance described above, charts are also published as OCI
artifacts to the GitHub Container Registry (GHCR) under `ghcr.io/grafana/helm-charts`.
Each pushed chart is keyless-signed with [Cosign](https://docs.sigstore.dev/) using the
release workflow's GitHub Actions identity (via Sigstore/Fulcio), and ships with two
attestations:

- an **SPDX SBOM** describing the chart package's contents, and
- a **SLSA build provenance** statement describing how and where the chart was built.

[Install Cosign](https://docs.sigstore.dev/system_config/installation/) (v2 or newer),
then set the chart you want to verify along with the signing identity. The signatures and
attestations are all produced by the reusable release workflow, so the keyless certificate
identity is stable regardless of which chart triggered the release:

```console
export CHART=grafana
export VERSION=9.0.0
export OCI_REF="ghcr.io/grafana/helm-charts/${CHART}:${VERSION}"

export CERT_IDENTITY="^https://github.com/grafana/helm-charts/.github/workflows/update-helm-repo.yaml@.*$"
export CERT_ISSUER="https://token.actions.githubusercontent.com"
```

Verify the chart signature:

```console
cosign verify "${OCI_REF}" \
  --certificate-identity-regexp "${CERT_IDENTITY}" \
  --certificate-oidc-issuer "${CERT_ISSUER}"
```

Verify the SBOM attestation:

```console
cosign verify-attestation "${OCI_REF}" \
  --type spdxjson \
  --certificate-identity-regexp "${CERT_IDENTITY}" \
  --certificate-oidc-issuer "${CERT_ISSUER}"
```

Verify the SLSA build provenance attestation:

```console
cosign verify-attestation "${OCI_REF}" \
  --type slsaprovenance1 \
  --certificate-identity-regexp "${CERT_IDENTITY}" \
  --certificate-oidc-issuer "${CERT_ISSUER}"
```

A successful run prints the validated certificate identity and, for attestations, the
decoded predicate. The build provenance can alternatively be verified with the GitHub CLI:

```console
gh attestation verify "oci://${OCI_REF}" --owner grafana
```

## Contributing

<!-- Keep full URL links to repo files because this README syncs from main to gh-pages.  -->
We'd love to have you contribute! Please refer to our [contribution guidelines](https://github.com/grafana/helm-charts/blob/main/CONTRIBUTING.md) for details.

## License

<!-- Keep full URL links to repo files because this README syncs from main to gh-pages.  -->
[Apache 2.0 License](https://github.com/grafana/helm-charts/blob/main/LICENSE).
