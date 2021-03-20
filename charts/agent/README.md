# Agent Helm Chart

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![AppVersion: v0.13.0](https://img.shields.io/badge/AppVersion-v0.13.0-informational?style=flat-square)

This Helm chart allows to deploy all three parts of the Grafana Agent (Logs,
Metrics and Traces) at once.


## Prerequisites

Make sure you have Helm [installed](https://helm.sh/docs/using_helm/#installing-helm).


## Get Repo Info

```shell
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._


## Deploy Agent

### Static configuration

This kind of deployment uses configuration specified at the time of deployment.

```shell
cat <<END | helm upgrade --create-namespace --namespace grafana --values - --install agent grafana/agent
# Just to share the same password accross all parts of the Agent
_secret: &secret
  data:
    password: cdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZZYXWVUTSRQPONMLKJIHGFEDCBAzyxwvutsrqponmlkjihgfedc

# Make resource names simple
fullnameOverride: agent

# Configure the Agent Logs chart
agent-logs:
  secret: *secret
  accessConfig:
    username: 12345

# Configure the Agent Metrics chart
agent-metrics:
  secret: *secret
  accessConfig:
    username: 67890
  extraDeploymentDefaultScrapeConfig:
    - job_name: test-app
      kubernetes_sd_configs:
        - role: endpoints
          namespaces:
            names:
              - test-app

# Configure the Agent Traces chart
agent-traces:
  secret: *secret
  accessConfig:
    username: 34567
END
```

### Dynamic configuration

This kind of deployment uses configuration specified in YAML files and loaded
after the Grafana Agent is deployed. It requires a shared key-value store, in
this case [ETCD](https://etcd.io/), to work.

Add Helm repository from which we can install the ETCD:

```shell
hel repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

Install ETCD:

```shell
cat <<END | helm upgrade --create-namespace --namespace grafana --install --values - etcd bitnami/etcd
persistence:
  enabled: false
auth:
  rbac:
    enabled: false
END
```

Install Grafana Agent:

```shell
cat <<END | helm upgrade --create-namespace --namespace grafana --values - --install agent .
# Make resource names simple
fullnameOverride: agent

# Share some of the configurations accross all Agent parts
_etcd: &etcd
  endpoints:
    - etcd:2379

_kvs: &kvs
  store: etcd
  etcd: *etcd

_ss: &ss
  enabled: true
  lifecycler:
    ring:
      replication_factor: 1
      kvstore: *kvs

_secret: &secret
  data:
    password: cdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZZYXWVUTSRQPONMLKJIHGFEDCBAzyxwvutsrqponmlkjihgfedc

# Configure the Agent Logs chart
agent-logs:
  secret: *secret
  urlConfig:
    username: 12345

# Configure the Agent Metrics chart
agent-metrics:
  scrapingServiceDeployment:
    <<: *ss
    kvstore:
      <<: *kvs
      prefix: configurations/metrics/
  scrapingService:
    <<: *ss
    kvstore:
      <<: *kvs
      prefix: configurations/deployment/
  secret: *secret

# Configure the Agent Traces chart
agent-traces:
  secret: *secret
  pushConfig:
    username: 34567
END
```

Create config example:

```shell
cat <<END > /path/to/my/config.yaml
host_filter: false
remote_write:
  - url: https://prometheus-blocks-prod-us-central1.grafana.net/api/prom/push
    basic_auth:
      username: 12345
      password_file: /var/run/secrets/grafana.com/agent/password
scrape_configs:
  - job_name: test-app
    kubernetes_sd_configs:
      - role: endpoints
        namespaces:
          names:
            - test-app
```

Forward Grafana Agent port from a pod (e.g `agent-metrics`) to the local
machine:

```shell
kubectl port-forward -n grafana $(kubectl get pod -n grafana -l app.kubernetes.io/component=agent-metrics -o name) 8080:8080
```

Load the configuration into the agent via [Config Management
API](https://github.com/grafana/agent/blob/main/docs/api.md#config-management-api)
using `curl`:

```shell
curl -X POST --data-binary /path/to/my/config.yaml localhost:8080/agent/api/v1/config/test-app
```


## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Jiri Tyr | jiri.tyr(at)gmail.com | [https://github.com/jtyr](https://github.com/jtyr) |


## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| agent-logs.enabled | bool | `true` |  |
| agent-metrics.enabled | bool | `true` |  |
| agent-traces.enabled | bool | `true` |  |
