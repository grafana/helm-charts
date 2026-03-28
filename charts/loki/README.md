# loki

Helm chart for Grafana Loki supporting monolithic, simple scalable, and microservices modes.

## Source Code

* <https://github.com/grafana/loki>
* <https://grafana.com/oss/loki/>
* <https://grafana.com/docs/loki/latest/>

## Requirements

The Following are installed via subchart

| Repository | Name |
|------------|------|
| https://charts.min.io/ | minio(minio) |
| https://grafana.github.io/helm-charts | rollout_operator(rollout-operator) |

Find more information in the Loki Helm Chart [documentation](https://grafana.com/docs/loki/latest/setup/install/helm/).

## Installing the Chart

### OCI Registry

OCI registries are preferred in Helm as they implement unified storage, distribution, and improved security.

```console
helm install RELEASE-NAME oci://ghcr.io/grafana-community/helm-charts/loki
```

### HTTP Registry

```console
helm repo add grafana-community https://grafana-community.github.io/helm-charts
helm repo update
helm install RELEASE-NAME grafana-community/loki
```

## Uninstalling the Chart

To remove all of the Kubernetes objects associated with the Helm chart release:

```console
helm delete RELEASE-NAME
```

## Changelog

See the [changelog](https://grafana-community.github.io/helm-charts/changelog/?chart=loki).

---

## Upgrading

### From 8.x to 9.0.0 ([#187](https://github.com/grafana-community/helm-charts/pull/187))

The `monitoring.selfMonitoring` component has been removed along with `grafana-agent-operator` subchart dependency.  Additionally, loki-canary tenant authentication has been moved as it was located under selfMonitoring.

Actions required:
- `monitoring.selfMonitoring` has been removed because [Grafana Agent is EOL](https://grafana.com/docs/agent/latest/).  Native support for collection and shipment of logs to Loki is no longer supported in the chart.  [Grafana Alloy](https://grafana.com/docs/alloy/latest/) is the successor to Grafana Agent if you're to re-implement the same functionality.
- `monitoring.serviceMonitor.metricsInstance` has been removed as it implemented a (Grafana Agent) CRD object no longer supported.
- loki-canary authentication is now configured via `lokiCanary.tenant.name` and `lokiCanary.tenant.password`.

### From 7.x to 8.0.0 ([#184](https://github.com/grafana-community/helm-charts/pull/184))

Grafana Enterprise Logs (GEL) / Loki Enterprise support has been removed from this chart. This chart is intended for open-source Loki users only.

If you are a GEL user, do not migrate to this chart. The upstream `grafana/loki` chart remains available for GEL users. Consult your Grafana Labs account team about your migration options. See the [migration announcement](https://github.com/grafana/loki/issues/20705) for details.

### From 6.x to 7.0.0 ([#183](https://github.com/grafana-community/helm-charts/pull/183))

Support for deprecated Kubernetes APIs has been dropped. **Kubernetes 1.25 or later is now required.**

Actions required:

- Remove `rbac.pspEnabled` and `rbac.pspAnnotations` from your values file — PodSecurityPolicy support has been removed (PSP was removed in Kubernetes 1.25).
- Ingress resources now use `networking.k8s.io/v1` only; `v1beta1` is no longer supported.
- PodDisruptionBudget resources now use `policy/v1` only.
