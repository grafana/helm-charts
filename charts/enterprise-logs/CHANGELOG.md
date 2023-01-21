# Changelog

All notable changes to this library will be documented in this file.

Entries should be ordered as follows:

- [CHANGE]
- [FEATURE]
- [ENHANCEMENT]
- [BUGFIX]

Entries should include a reference to the pull request that introduced the change.

## 2.4.3

- [CHANGE] Make Gateway service type configurable

## 2.4.2

- [CHANGE] Bump GEL version to v1.5.2

## 2.4.1

- [CHANGE] Bump GEL version to v1.5.1 to use version with a fix for GEL Node API.

## 2.4.0

- [CHANGE] Update loki-distributed to 0.55.0
- [CHANGE] Harmonized `securityContext` configs with loki-distributed:
  - Rename `adminApi.securityContext` option to `adminApi.podSecurityContext`
  - Add `adminApi.securityContext` option
  - Rename `tokengen.securityContext` option to `tokengen.podSecurityContext`
  - Add `tokengen.securityContext` option
  - Rename `compactor.securityContext` to `compactor.podSecurityContext`
  - Rename `gateway.securityContext` to `gateway.podSecurityContext`

## 2.3.1

- [CHANGE] Support configuring `containerSecurityContext` for compactor and gateway targets. #1656

## 2.3.0

- [CHANGE] Bump GEL version to v1.5.0

## 2.2.3

- [BUGFIX] Mount rw /tmp directory in Compactor to fix error about read-only filesystem. #1548

## 2.2.2

## 2.2.1

## 2.2.0

## 2.1.0

## 2.0.4

- [FEATURE] Added OpenShift support. #1085

## 2.0.3

## 2.0.2

- [BUGFIX] Have tokengen use the same ServiceAccount as the other components. #1031

## 2.0.1

- [BUGFIX] Configure Loki WAL directory that was absent in the 2.0.0 change. #1033

## 2.0.0

- [CHANGE] Expect GEL configuration as a string rather than structured data in the values.yaml file #943

## 1.4.0

- [CHANGE] Bump GEL version to v1.3.0

## 1.3.5

- [BUGFIX] Use correct subPath configuration for the compactor's storage mount.
- [BUGFIX] Fixed issue that prevented users from mounting extra persistent volumes for the compactor.
- [CHANGE] Configure `securityContext.fsGroup` value for Admin API pod based on the value `adminApi.securityContext.runAsGroup`.

## 1.3.4

- [CHANGE] Remove selector and config hash annotations from the tokengen job that make it hard to update the helm chart after deploying that job

## 1.3.3

- [BUGFIX] Bumped version of `loki-distributed` chart to 0.39.3 that defines default WAL location. #863

## 1.3.2

- [BUGFIX] Fixed issue that caused GEL version not to be updated in the templates of the loki-distributed child chart. #863

## 1.3.1

- [BUGFIX] Fixed error in template rendering when MinIO is disabled.

## 1.3.0

- [CHANGE] Bump GEL version to v1.2.0

## 1.2.1

- [BUGFIX] Fixed the dev cluster MinIO endpoints in the default configuration. #826

## 1.2.0

- [CHANGE] Removed unused deployment of `memcached-index-writes` StatefulSet when using `small.yaml` values file.

## 1.1.1

- [BUGFIX] Ensure that Pods run as non-root user `enterprise-logs` (`uid=10001,gid=10001`). #690

## 1.1.0

* [CHANGE] Updated `loki-distributed` chart dependency to `^0.37.3`. #684
* [CHANGE] Removed table manager deployment, because GEL uses boltdb-shipper and compactor. #684
* [ENHANCEMENT] Enabled deployment of `index-gateway`. #684
* [ENHANCEMENT] Enabled persistent volume for `querier` service. #684

## 1.0.0

* [FEATURE] Initial version of the `enterprise-logs` (GEL) Helm chart. #629
