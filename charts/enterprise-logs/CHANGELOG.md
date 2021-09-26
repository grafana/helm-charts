# Changelog

All notable changes to this library will be documented in this file.

Entries should be ordered as follows:

- [CHANGE]
- [FEATURE]
- [ENHANCEMENT]
- [BUGFIX]

Entries should include a reference to the pull request that introduced the change.

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
