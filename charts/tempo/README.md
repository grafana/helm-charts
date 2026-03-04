# tempo Helm Chart

Grafana Tempo Single Binary Mode

## Source Code

* <https://github.com/grafana/tempo>

## Requirements

Kubernetes: `^1.25.0-0`

## Installing the Chart

### OCI Registry

OCI registries are preferred in Helm as they implement unified storage, distribution, and improved security.

```console
helm install RELEASE-NAME oci://ghcr.io/grafana-community/helm-charts/tempo
```

### HTTP Registry

```console
helm repo add grafana-community https://grafana-community.github.io/helm-charts
helm repo update
helm install RELEASE-NAME grafana-community/tempo
```

## Uninstalling the Chart

To remove all of the Kubernetes objects associated with the Helm chart release:

```console
helm delete RELEASE-NAME
```

## Changelog

See the [changelog](https://grafana-community.github.io/helm-charts/changelog/?chart=tempo).

---

## Upgrading

A major chart version change indicates that there is an incompatible breaking change needing manual actions.

### From Chart versions < 2.0.0
* Breaking Change *
The minimum required Kubernetes version is now 1.25. All references to deprecated APIs have been removed.

### From Chart versions < 1.22.0
* Breaking Change *
Please be aware that we've updated the Tempo version to 2.8, which includes some breaking changes
We recommend reviewing the [release notes](https://grafana.com/docs/tempo/latest/release-notes/v2-8/) before upgrading.

### From Chart versions < 1.21.1
* Breaking Change *
In order to be consistent with other projects and documentations, the default port has been changed from 3100 to 3200.

### From Chart versions < 1.19.0
* Breaking Change *
In order to reduce confusion, the overrides configurations have been renamed as below.

`global_overrides` =>  `overrides` (this is where the defaults for every tenant is set)
`overrides` => `per_tenant_overrides` (this is where configurations for specific tenants can be set)

### From Chart versions < 1.17.0

Please be aware that we've updated the Tempo version to 2.7, which includes some breaking changes
We recommend reviewing the [release notes](https://grafana.com/docs/tempo/latest/release-notes/v2-7/) before upgrading.

### From Chart versions < 1.12.0

Upgrading to chart 1.12.0 will set the memberlist cluster_label config option. During rollout your cluster will temporarily be split into two memberlist clusters until all components are rolled out.
This will interrupt reads and writes. This config option is set to prevent cross talk between Tempo and other memberlist clusters.

### From Chart versions < 1.2.0

Please be aware that we've updated the minor version to Tempo 2.1, which includes breaking changes.
We recommend reviewing the [release notes](https://github.com/grafana/tempo/releases/tag/v2.1.0/) before upgrading.

### From Chart versions < 1.0.0

Please note that we've incremented the major version when upgrading to Tempo 2.0. There were a large number of
changes in this release (breaking and otherwise). It is encouraged to review the [release notes](https://grafana.com/docs/tempo/latest/release-notes/v2-0/)
and [1.5 -> 2.0 upgrade guide](https://grafana.com/docs/tempo/latest/setup/upgrade/) before upgrading.

### From Chart versions < 0.7.0

Upgrading from pre 0.7.0 will, by default, move your trace storage from `/tmp/tempo/traces` to `/var/tempo/traces`.
This will cause Tempo to lose trace history. If you would like to retain history just copy the contents from the
old folder to the new.
