# Loki Helm Chart

## Prerequisites

Make sure you have Helm [installed](https://helm.sh/docs/using_helm/#installing-helm).

## Get Repo Info

```console
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._


## Deploy Loki only

```bash
helm upgrade --install loki grafana/loki
```

## Upgrading

### Upgrading an existing Release to a new major version

Major version upgrades listed here indicate that there is an incompatible breaking change needing manual actions.

### From 2.11.x to 2.12.0

In version 2.12.0, we enabled memberlist by default and added additional kubernetes service used for members communication.

If you already use `memberlist`, just review the config (`.Values.config.memberlist`) to make sure new `memberlist` config matches with your current configuration.

If you use another implementation(`etcd`, `consul`, `inmemory`) for the ring, you can disable `memberlist` with setting `.Values.config.memberlist` to `null`. 
It prevents from enabling `memberlist` and creating additional kubernetes service.

### From 2.12.x to 2.13.0

In version 2.13.0, we added custom labels to the `volumeClaimTemplates` in the `loki` Statefulset.

If you want to add labels to PersistentVolumeClaim (PVC) via `persistence.labels` values, you must delete the old `loki` Statefulset in the existing release prior upgrading. Without it, the upgrade fails with the following error:

> Error: UPGRADE FAILED: cannot patch "loki" with kind StatefulSet: StatefulSet.apps "loki" is invalid: spec: Forbidden: updates to statefulset spec for fields other than 'replicas', 'template', and 'updateStrategy' are forbidden

## Run Loki behind https ingress

If Loki and Promtail are deployed on different clusters you can add an Ingress in front of Loki.
By adding a certificate you create an https endpoint. For extra security enable basic authentication on the Ingress.

In Promtail set the following values to communicate with https and basic auth

```yaml
loki:
  serviceScheme: https
  user: user
  password: pass
```

Sample helm template for ingress:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: loki
  annotations:
    kubernetes.io/ingress.class: {{ .Values.ingress.class }}
    ingress.kubernetes.io/auth-type: basic
    ingress.kubernetes.io/auth-secret: {{ .Values.ingress.basic.secret }}
spec:
  rules:
  - host: {{ .Values.ingress.host }}
    http:
      paths:
      - backend:
          service:
            name: loki
            port:
              number: 3100
        path: /
        pathType: Prefix
  tls:
  - hosts:
    - {{ .Values.ingress.host }}
    secretName: {{ .Values.ingress.cert }}
```

## Use Loki Alerting

You can add your own alerting rules with `alerting_groups` in `values.yaml`. This will create a ConfigMap with your rules and additional volumes and mounts for Loki.

This does **not** enable the Loki `ruler` component which does the evaluation of your rules. The `values.yaml` file does contain a simple example. For more details take a look at the official [alerting docs](https://grafana.com/docs/loki/latest/rules/).

## Enable retention policy (log deletion)

Set Helm value `config.compactor.retention_enabled` to enable retention using the default policy, which deletes logs after 31 days.

```yaml
config:
  compactor:
    retention_enabled: true
```

See [the documentation](https://grafana.com/docs/loki/latest/operations/storage/retention/) for additional options.
