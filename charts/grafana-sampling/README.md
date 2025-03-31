# grafana-sampling

![Version: 1.1.5](https://img.shields.io/badge/Version-1.1.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.7.5](https://img.shields.io/badge/AppVersion-v1.7.5-informational?style=flat-square)

A Helm chart for a layered OTLP tail sampling and metrics generation pipeline.

## Breaking change announcements

### **v1.0.0**

Grafana Agent has been replaced with [Grafana Alloy](https://grafana.com/oss/alloy-opentelemetry-collector/)!

These sections in your values file will need to be renamed:

| Old                         | New                 | Purpose                                        |
|-----------------------------|---------------------|------------------------------------------------|
| `grafana-agent-deployment`  | `alloy-deployment`  | Settings for the Alloy load balancing instance |
| `grafana-agent-statefulset` | `alloy-statefulset` | Settings for the Alloy tail sampling instance  |

For example, if you have something like this:

```yaml
grafana-agent-statefulset:
  agent:
```

you will need to change it to this:

```yaml
alloy-statefulset:
  alloy:
`````

This chart deploys the following architecture to your environment (note the agents have been replaced with Alloy):
![Photo of sampling architecture](./sampling-architecture.png)

Note: by default, only OTLP traces are accepted at the load balancing layer.

## Chart Repo

Add the following repo to use the chart:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```
## Installing the Chart

Use the following command to install the chart with the release name `my-release`. Make sure to populate the required values.

```console
helm install my-release grafana/grafana-sampling --values - <<EOF | less
alloy-statefulset:
  alloy:
    extraEnv:
      - name: GRAFANA_CLOUD_API_KEY
        value: <REQUIRED>
      - name: GRAFANA_CLOUD_PROMETHEUS_URL
        value: <REQUIRED> # This should include /api/prom/push uri
      - name: GRAFANA_CLOUD_PROMETHEUS_USERNAME
        value: <REQUIRED>
      - name: GRAFANA_CLOUD_TEMPO_ENDPOINT
        value: <REQUIRED>
      - name: GRAFANA_CLOUD_TEMPO_USERNAME
        value: <REQUIRED>
      # This is required for adaptive metric deduplication in Grafana Cloud
      - name: POD_UID
        valueFrom:
          fieldRef:
            apiVersion: v1
            fieldPath: metadata.uid
EOF
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Upgrading

A major chart version change indicates that there is an incompatible breaking change needing manual actions.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| alloy-deployment.alloy.configMap.create | bool | `false` |  |
| alloy-deployment.alloy.extraPorts[0].name | string | `"otlp-grpc"` |  |
| alloy-deployment.alloy.extraPorts[0].port | int | `4317` |  |
| alloy-deployment.alloy.extraPorts[0].protocol | string | `"TCP"` |  |
| alloy-deployment.alloy.extraPorts[0].targetPort | int | `4317` |  |
| alloy-deployment.alloy.extraPorts[1].name | string | `"otlp-http"` |  |
| alloy-deployment.alloy.extraPorts[1].port | int | `4318` |  |
| alloy-deployment.alloy.extraPorts[1].protocol | string | `"TCP"` |  |
| alloy-deployment.alloy.extraPorts[1].targetPort | int | `4318` |  |
| alloy-deployment.alloy.resources.requests.cpu | string | `"1"` |  |
| alloy-deployment.alloy.resources.requests.memory | string | `"2G"` |  |
| alloy-deployment.controller.autoscaling.enabled | bool | `false` | Creates a HorizontalPodAutoscaler for controller type deployment. |
| alloy-deployment.controller.autoscaling.maxReplicas | int | `5` | The upper limit for the number of replicas to which the autoscaler can scale up. |
| alloy-deployment.controller.autoscaling.minReplicas | int | `2` | The lower limit for the number of replicas to which the autoscaler can scale down. |
| alloy-deployment.controller.autoscaling.targetCPUUtilizationPercentage | int | `0` | Average CPU utilization across all relevant pods, a percentage of the requested value of the resource for the pods. Setting `targetCPUUtilizationPercentage` to 0 will disable CPU scaling. |
| alloy-deployment.controller.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Average Memory utilization across all relevant pods, a percentage of the requested value of the resource for the pods. Setting `targetMemoryUtilizationPercentage` to 0 will disable Memory scaling. |
| alloy-deployment.controller.replicas | int | `1` |  |
| alloy-deployment.controller.type | string | `"deployment"` |  |
| alloy-deployment.nameOverride | string | `"deployment"` | Do not change this. |
| alloy-statefulset.alloy.configMap.create | bool | `false` |  |
| alloy-statefulset.alloy.extraEnv[0].name | string | `"GRAFANA_CLOUD_API_KEY"` |  |
| alloy-statefulset.alloy.extraEnv[0].value | string | `"<REQUIRED>"` |  |
| alloy-statefulset.alloy.extraEnv[1].name | string | `"GRAFANA_CLOUD_PROMETHEUS_URL"` |  |
| alloy-statefulset.alloy.extraEnv[1].value | string | `"<REQUIRED>"` |  |
| alloy-statefulset.alloy.extraEnv[2].name | string | `"GRAFANA_CLOUD_PROMETHEUS_USERNAME"` |  |
| alloy-statefulset.alloy.extraEnv[2].value | string | `"<REQUIRED>"` |  |
| alloy-statefulset.alloy.extraEnv[3].name | string | `"GRAFANA_CLOUD_TEMPO_ENDPOINT"` |  |
| alloy-statefulset.alloy.extraEnv[3].value | string | `"<REQUIRED>"` |  |
| alloy-statefulset.alloy.extraEnv[4].name | string | `"GRAFANA_CLOUD_TEMPO_USERNAME"` |  |
| alloy-statefulset.alloy.extraEnv[4].value | string | `"<REQUIRED>"` |  |
| alloy-statefulset.alloy.extraEnv[5].name | string | `"POD_UID"` |  |
| alloy-statefulset.alloy.extraEnv[5].valueFrom.fieldRef.apiVersion | string | `"v1"` |  |
| alloy-statefulset.alloy.extraEnv[5].valueFrom.fieldRef.fieldPath | string | `"metadata.uid"` |  |
| alloy-statefulset.alloy.extraPorts[0].name | string | `"otlp-grpc"` |  |
| alloy-statefulset.alloy.extraPorts[0].port | int | `4317` |  |
| alloy-statefulset.alloy.extraPorts[0].protocol | string | `"TCP"` |  |
| alloy-statefulset.alloy.extraPorts[0].targetPort | int | `4317` |  |
| alloy-statefulset.alloy.resources.requests.cpu | string | `"1"` |  |
| alloy-statefulset.alloy.resources.requests.memory | string | `"2G"` |  |
| alloy-statefulset.controller.autoscaling.enabled | bool | `false` | Creates a HorizontalPodAutoscaler for controller type deployment. |
| alloy-statefulset.controller.autoscaling.maxReplicas | int | `5` | The upper limit for the number of replicas to which the autoscaler can scale up. |
| alloy-statefulset.controller.autoscaling.minReplicas | int | `2` | The lower limit for the number of replicas to which the autoscaler can scale down. |
| alloy-statefulset.controller.autoscaling.targetCPUUtilizationPercentage | int | `0` | Average CPU utilization across all relevant pods, a percentage of the requested value of the resource for the pods. Setting `targetCPUUtilizationPercentage` to 0 will disable CPU scaling. |
| alloy-statefulset.controller.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Average Memory utilization across all relevant pods, a percentage of the requested value of the resource for the pods. Setting `targetMemoryUtilizationPercentage` to 0 will disable Memory scaling. |
| alloy-statefulset.controller.replicas | int | `1` |  |
| alloy-statefulset.controller.type | string | `"statefulset"` |  |
| alloy-statefulset.nameOverride | string | `"statefulset"` | Do not change this. |
| alloy-statefulset.rbac.create | bool | `false` |  |
| alloy-statefulset.service.clusterIP | string | `"None"` |  |
| alloy-statefulset.serviceAccount.create | bool | `false` |  |
| batch.deployment | object | `{"send_batch_max_size":0,"send_batch_size":8192,"timeout":"200ms"}` | Configure batch processing options. |
| batch.statefulset.send_batch_max_size | int | `0` |  |
| batch.statefulset.send_batch_size | int | `8192` |  |
| batch.statefulset.timeout | string | `"200ms"` |  |
| deployment.otlp.receiver | object | `{"grpc":{"max_recv_msg_size":"4MB"}}` | otlp receiver settings for deployment (loadbalancer) |
| deployment.otlp.receiver.grpc.max_recv_msg_size | string | `"4MB"` | gRPC max message receive size. Default to 4MB |
| liveDebugging.enabled | bool | `false` | Enable live debugging in the Alloy UI. |
| metricsGeneration.dimensions | list | `["service.namespace","service.version","deployment.environment","k8s.cluster.name","k8s.pod.name"]` | Additional dimensions to add to generated metrics. |
| metricsGeneration.enabled | bool | `true` | Toggle generation of spanmetrics and servicegraph metrics. |
| metricsGeneration.legacy | bool | `true` | Use legacy metric names that match those used by the Tempo metrics generator. |
| metricsGeneration.serviceGraph.metricsFlushInterval | string | `"60s"` | The interval at which metrics are flushed to downstream components. |
| metricsGeneration.spanMetrics.metricsExpiration | string | `"5m"` | Time period after which metrics are considered stale and are removed from the cache. |
| sampling.decisionWait | string | `"15s"` | Wait time since the first span of a trace before making a sampling decision. |
| sampling.enabled | bool | `true` | Toggle tail sampling. |
| sampling.extraPolicies | string | A policy to sample long requests is added by default. | User-defined policies in alloy format. |
| sampling.failedRequests.percentage | int | `50` | Percentage of failed requests to sample. |
| sampling.failedRequests.sample | bool | `false` | Toggle sampling failed requests. |
| sampling.successfulRequests.percentage | int | `10` | Percentage of successful requests to sample. |
| sampling.successfulRequests.sample | bool | `true` | Toggle sampling successful requests. |
| statefulset.otlp.receiver | object | `{"grpc":{"max_recv_msg_size":"4MB"}}` | otlp receiver settings for statefulset (sampler) |
| statefulset.otlp.receiver.grpc.max_recv_msg_size | string | `"4MB"` | gRPC max message receive size. Default to 4MB |

