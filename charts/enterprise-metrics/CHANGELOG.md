# Changelog

All notable changes to this library will be documented in this file.

Entries should be ordered as follows:
- [CHANGE]
- [FEATURE]
- [ENHANCEMENT]
- [BUGFIX]

Entries should include a reference to the Pull Request that introduced the change.

## Unreleased

## 1.2.0

* [CHANGE] The chart now uses memberlist for the ring key-value store removing the need to run Consul. #340
  > **Warning:** Existing clusters will need to follow an upgrade procedure.
  > **Warning:** Existing clusters should first be upgraded to `v1.1.1` and use that version for migration before upgrading to `v1.2.0`.
  To upgrade to using memberlist:
  1. Ensure you are running the `v1.1.1` version of the chart.
  2. Deploy runtime `multi_kv_config` to use the Consul as a primary and memberlist as the secondary key-value store.
     The values for such a change can be found in the [`multi-kv-consul-primary-values.yaml`](./multi-kv-consul-primary-values.yaml).
  3. Verify the configuration is in use by querying the [Configuration](https://cortexmetrics.io/docs/api/#configuration) HTTP API endpoint.
  4. Deploy runtime `multi_kv_config` to use memberlist as the primary and Consul as the secondary key-value store.
     The values for such a change can be found in [`multi-kv-memberlist-primary-values.yaml`](./multi-kv-memberlist-primary-values.yaml)
  5. Verify the configuration is in use by querying the [Configuration](https://cortexmetrics.io/docs/api/#configuration) HTTP API endpoint.
  6. Deploy `v1.2.0` helm chart which configures memberlist as the sole key-value store and removes the Consul resources.

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
