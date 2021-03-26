# Changelog

All notable changes to this library will be documented in this file.

Entries should be ordered as follows:
- [CHANGE]
- [FEATURE]
- [ENHANCEMENT]
- [BUGFIX]

Entries should include a reference to the Pull Request that introduced the change.

## Unreleased

## 1.1.1

* [FEATURE] Facilitate some runtime configuration of microservices. #342
* [FEATURE] Upgrade to [Grafana Enterprise Metrics v1.2.0](https://grafana.com/docs/metrics-enterprise/latest/downloads/#v120----march-10-2021). #342

## 1.1.0

* [CHANGE] The memcached chart from the deprecated Helm stable repository has been removed and replaced with a Bitnami chart. #333
  > **Warning:** This change will result in then cycling of your memcached Pods and will invalidate the existing cache.
* [CHANGE] Memcached Pod resource limits have been lowered to match requests. #333
* [FEATURE] YAML exports have been created for all chart values files. #333
* [BUGFIX] The values for the querier/ruler/store-gateway `-<prefix>.memcached.max-item-size` have been corrected to match the limit configured on the memcached server. #333

## 1.0.0

* [FEATURE] Initial versioned release. ##168
