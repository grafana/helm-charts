# Changelog

All notable changes to this library will be documented in this file.

Entries should be ordered as follows:
- [CHANGE]
- [FEATURE]
- [ENHANCEMENT]
- [BUGFIX]

Entries should include a reference to the Pull Request that introduced the change.

## 1.9.0

* [CHANGE] This chart is now deprecated and will no longer be updated. Grafana Enterprise Metrics v2.0.0 is included in the new `mimir-distributed` chart which implements Grafana Enterprise Metrics as an option (`enterprise.enabled: true`). To upgrade to using the new chart, see the [Grafana Enterprise Metrics migration guide](https://grafana.com/docs/enterprise-metrics/latest/migrating-from-gem-1.7/).

## 1.8.1

* [ENHANCEMENT] Support Grafana Mimir monitoring mixin labels by setting container names to the component names.
  This will make it easier to select different components in cadvisor metrics.
  Previously, all containers used "enterprise-metrics" as the container name.
  Now, the ingester Pod will have a container name "ingester".

## 1.8.0

* [FEATURE] Upgrade to [Grafana Enterprise Metrics v1.7.0](https://grafana.com/docs/metrics-enterprise/latest/downloads/#v170----january-6th-2022).

## 1.7.3

* [BUGFIX] Alertmanager does not fail anymore to load configuration via the API. #945

## 1.7.2

* [CHANGE] The Ingester statefulset now uses podManagementPolicy Parallel, upgrading requires recreating the statefulset #920

## 1.7.1

* [BUGFIX] Remove chunks related default limits. #867

## 1.7.0

* [FEATURE] Upgrade to [Grafana Enterprise Metrics v1.6.1](https://grafana.com/docs/metrics-enterprise/latest/downloads/#v161----november-18th-2021). #839

## 1.6.0

* [FEATURE] Upgrade to [Grafana Enterprise Metrics v1.5.1](https://grafana.com/docs/metrics-enterprise/latest/downloads/#v151----september-21st-2021). #729
* [CHANGE] Production values set the ingester replication factor to three to avoid data loss.
  The resource calculations of these values already factored in this replication factor but did not apply it in the configuration.
  If you have not reduced the compute resources in these values then this change should have no impact besides increased resilience to ingester failure.
  If you have reduced the compute resources, consider increasing them back to the recommended values before installing this version. #729

## 1.5.6

* [BUGFIX] YAML exports are no longer included as part of the Helm chart. #726

## 1.5.5

* [BUGFIX] Ensure all PodSpecs have configurable initContainers. #708

## 1.5.4

* [BUGFIX] Adds a `Service` resource for the Compactor Pods and adds Compactor to the default set of gateway proxy URLs. In previous chart versions the Compactor would not show up in the GEM plugin "Ring Health" tab because the gateway did not know how to reach Compactor. #714

## 1.5.3

* [BUGFIX] This change does not affect single replica deployments of the
  admin-api but does fix the potential for an inconsistent state when
  running with multiple replicas of the admin-api and experiencing
  parallel writes for the same objects. #675

## 1.5.2

* [CHANGE] Removed all references to Consul in the yaml files since GEM will be focused on deploying with memberlist. Deleted the multi-kv-consul-primary-values.yaml and multi-kv-memberlist-primary-values.yaml files since they assume you're running Consul as your primary or second kvstore. #674

## 1.5.1

* [BUGFIX] Unused `ingress` configuration section removed from `values.yaml`. #658

## 1.5.0

* [FEATURE] Upgrade to [Grafana Enterprise Metrics v1.5.0](https://grafana.com/docs/metrics-enterprise/latest/downloads/#v150----august-24th-2021). #641

## 1.4.7

* [CHANGE] Enabled enterprise authentication by default.
  > **Breaking:** This change can cause losing access to the GEM cluster in case `auth.type` has not
  > been set explicitly.
  > This is a security related change and therefore released in a patch release.

## 1.4.6

* [FEATURE] Run an instance of the GEM overrides-exporter by default. #590

## 1.4.5

* [BUGFIX] Add `memberlist.join` configuration to the ruler. #618

## 1.4.4

* [CHANGE] Removed livenessProbe configuration as it can often be more detrimental than having none. Users can still configure livenessProbes with the per App configuration hooks. #594

## 1.4.3

* [ENHANCEMENT] Added values files for installations that require setting resource limits. #583

## 1.4.2

* [CHANGE] The compactor data directory configuration has been corrected to `/data`. #562
  > **Note:** The compactor is stateless and no data stored in the existing data directory needs to be moved in order to facilitate this upgrade.
  > For more information, refer to the [Cortex Compactor documentation](https://cortexmetrics.io/docs/blocks-storage/compactor/).
* [FEATURE] Upgrade to [Grafana Enterprise Metrics v1.4.2](https://grafana.com/docs/metrics-enterprise/latest/downloads/#v142----jul-21st-2021) #562

## 1.4.1

* [BUGFIX] Fixed DNS address of distributor client for self-monitoring. #569

## 1.4.0

* [CHANGE] Use updated querier response compression configuration, changed in 1.4.0. #524
* [CHANGE] Use updated alertmanager storage configuration, changed in 1.4.0. #524
* [FEATURE] Upgrade to [Grafana Enterprise Metrics v1.4.1](https://grafana.com/docs/metrics-enterprise/latest/downloads/#v141----june-29th-2021). #524
* [FEATURE] Enable [GEM self-monitoring](https://grafana.com/docs/metrics-enterprise/latest/self-monitoring/). #524

## 1.3.5

* [CHANGE] The GRPC port on the query-frontend and store-gateway Kubernetes Services have been changed to match the naming of all other services. #523
* [FEATURE] Expose GRPC port on all GEM services. #523

## 1.3.4

* [BUGFIX] Removed symlinks from chart to fix Rancher repository imports. #504

## 1.3.3

* [FEATURE] The GEM config now uses the `{{ .Release.Name }}` variable as the default value for `cluster_name` which removes the need to additionally override this setting during an initial install. #500

## 1.3.2

* [FEATURE] Chart memcached dependencies are now at the latest release. This includes the memcached and the related exporter. #467

## 1.3.1

* [BUGFIX] Use non-deprecated alertmanager flags for cluster peers. #441
* [BUGFIX] Make store-gateway Service not headless. #441

## 1.3.0

* [FEATURE] Upgrade to [Grafana Enterprise Metrics v1.3.0](https://grafana.com/docs/metrics-enterprise/latest/downloads/#v130----april-26th-2021). #415

## 1.2.0

* [CHANGE] The chart now uses memberlist for the ring key-value store removing the need to run Consul. #340
  > **Warning:** Existing clusters will need to follow an upgrade procedure.
  > **Warning:** Existing clusters should first be upgraded to `v1.1.1` and use that version for migration before upgrading to `v1.2.0`.
  To upgrade to using memberlist:
  1. Ensure you are running the `v1.1.1` version of the chart.
  2. Deploy runtime `multi_kv_config` to use Consul as a primary and memberlist as the secondary key-value store.
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
  > **Warning:** This change will result in the cycling of your memcached Pods and will invalidate the existing cache.
* [CHANGE] Memcached Pod resource limits have been lowered to match requests. #333
* [FEATURE] YAML exports have been created for all chart values files. #333
* [BUGFIX] The values for the querier/ruler/store-gateway `-<prefix>.memcached.max-item-size` have been corrected to match the limit configured on the memcached server. #333

## 1.0.0

* [FEATURE] Initial versioned release. ##168
