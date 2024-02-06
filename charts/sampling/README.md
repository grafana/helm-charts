# sampling

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.38.1](https://img.shields.io/badge/AppVersion-v0.38.1-informational?style=flat-square)

A Helm chart for Kubernetes

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://grafana.github.io/helm-charts | grafana-agent-deployment(grafana-agent) | 0.30.0 |
| https://grafana.github.io/helm-charts | grafana-agent-statefulset(grafana-agent) | 0.30.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| grafana-agent-deployment.agent.configMap.create | bool | `false` |  |
| grafana-agent-deployment.agent.extraPorts[0].name | string | `"otlp-grpc"` |  |
| grafana-agent-deployment.agent.extraPorts[0].port | int | `4317` |  |
| grafana-agent-deployment.agent.extraPorts[0].protocol | string | `"TCP"` |  |
| grafana-agent-deployment.agent.extraPorts[0].targetPort | int | `4317` |  |
| grafana-agent-deployment.agent.extraPorts[1].name | string | `"otlp-http"` |  |
| grafana-agent-deployment.agent.extraPorts[1].port | int | `4318` |  |
| grafana-agent-deployment.agent.extraPorts[1].protocol | string | `"TCP"` |  |
| grafana-agent-deployment.agent.extraPorts[1].targetPort | int | `4318` |  |
| grafana-agent-deployment.agent.resources.requests.cpu | string | `"1"` |  |
| grafana-agent-deployment.agent.resources.requests.memory | string | `"2G"` |  |
| grafana-agent-deployment.controller.autoscaling.enabled | bool | `false` | Creates a HorizontalPodAutoscaler for controller type deployment. |
| grafana-agent-deployment.controller.autoscaling.maxReplicas | int | `5` | The upper limit for the number of replicas to which the autoscaler can scale up. |
| grafana-agent-deployment.controller.autoscaling.minReplicas | int | `2` | The lower limit for the number of replicas to which the autoscaler can scale down. |
| grafana-agent-deployment.controller.autoscaling.targetCPUUtilizationPercentage | int | `0` | Average CPU utilization across all relevant pods, a percentage of the requested value of the resource for the pods. Setting `targetCPUUtilizationPercentage` to 0 will disable CPU scaling. |
| grafana-agent-deployment.controller.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Average Memory utilization across all relevant pods, a percentage of the requested value of the resource for the pods. Setting `targetMemoryUtilizationPercentage` to 0 will disable Memory scaling. |
| grafana-agent-deployment.controller.replicas | int | `1` |  |
| grafana-agent-deployment.controller.type | string | `"deployment"` |  |
| grafana-agent-statefulset.agent.configMap.create | bool | `false` |  |
| grafana-agent-statefulset.agent.extraEnv[0].name | string | `"GRAFANA_CLOUD_API_KEY"` |  |
| grafana-agent-statefulset.agent.extraEnv[0].value | string | `"<REQUIRED>"` |  |
| grafana-agent-statefulset.agent.extraEnv[1].name | string | `"GRAFANA_CLOUD_PROMETHEUS_URL"` |  |
| grafana-agent-statefulset.agent.extraEnv[1].value | string | `"<REQUIRED>"` |  |
| grafana-agent-statefulset.agent.extraEnv[2].name | string | `"GRAFANA_CLOUD_PROMETHEUS_USERNAME"` |  |
| grafana-agent-statefulset.agent.extraEnv[2].value | string | `"<REQUIRED>"` |  |
| grafana-agent-statefulset.agent.extraEnv[3].name | string | `"GRAFANA_CLOUD_TEMPO_ENDPOINT"` |  |
| grafana-agent-statefulset.agent.extraEnv[3].value | string | `"<REQUIRED>"` |  |
| grafana-agent-statefulset.agent.extraEnv[4].name | string | `"GRAFANA_CLOUD_TEMPO_USERNAME"` |  |
| grafana-agent-statefulset.agent.extraEnv[4].value | string | `"<REQUIRED>"` |  |
| grafana-agent-statefulset.agent.extraEnv[5].name | string | `"POD_UID"` |  |
| grafana-agent-statefulset.agent.extraEnv[5].valueFrom.fieldRef.apiVersion | string | `"v1"` |  |
| grafana-agent-statefulset.agent.extraEnv[5].valueFrom.fieldRef.fieldPath | string | `"metadata.uid"` |  |
| grafana-agent-statefulset.agent.extraPorts[0].name | string | `"otlp-grpc"` |  |
| grafana-agent-statefulset.agent.extraPorts[0].port | int | `4317` |  |
| grafana-agent-statefulset.agent.extraPorts[0].protocol | string | `"TCP"` |  |
| grafana-agent-statefulset.agent.extraPorts[0].targetPort | int | `4317` |  |
| grafana-agent-statefulset.agent.resources.requests.cpu | string | `"1"` |  |
| grafana-agent-statefulset.agent.resources.requests.memory | string | `"2G"` |  |
| grafana-agent-statefulset.controller.autoscaling.enabled | bool | `false` | Creates a HorizontalPodAutoscaler for controller type deployment. |
| grafana-agent-statefulset.controller.autoscaling.maxReplicas | int | `5` | The upper limit for the number of replicas to which the autoscaler can scale up. |
| grafana-agent-statefulset.controller.autoscaling.minReplicas | int | `2` | The lower limit for the number of replicas to which the autoscaler can scale down. |
| grafana-agent-statefulset.controller.autoscaling.targetCPUUtilizationPercentage | int | `0` | Average CPU utilization across all relevant pods, a percentage of the requested value of the resource for the pods. Setting `targetCPUUtilizationPercentage` to 0 will disable CPU scaling. |
| grafana-agent-statefulset.controller.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Average Memory utilization across all relevant pods, a percentage of the requested value of the resource for the pods. Setting `targetMemoryUtilizationPercentage` to 0 will disable Memory scaling. |
| grafana-agent-statefulset.controller.replicas | int | `1` |  |
| grafana-agent-statefulset.controller.type | string | `"statefulset"` |  |
| grafana-agent-statefulset.rbac.create | bool | `false` |  |
| grafana-agent-statefulset.service.clusterIP | string | `"None"` |  |
| grafana-agent-statefulset.serviceAccount.create | bool | `false` |  |
| metricsGeneration.dimensions[0] | string | `"service.namespace"` |  |
| metricsGeneration.dimensions[1] | string | `"service.version"` |  |
| metricsGeneration.dimensions[2] | string | `"deployment.environment"` |  |
| metricsGeneration.dimensions[3] | string | `"k8s.pod.name"` |  |
| metricsGeneration.dimensions[4] | string | `"k8s.cluster.name"` |  |
| metricsGeneration.enabled | bool | `true` |  |
| sampling.enabled | bool | `true` |  |
| sampling.extraPolicies | string | `"policy {\n  name = \"sample-long-requests\"\n  type = \"and\"\n  and {\n    and_sub_policy {\n      name = \"latency\"\n      type = \"latency\"\n      latency {\n        threshold_ms = 5000\n      }\n    }\n    and_sub_policy {\n     name = \"probabilistic-policy\"\n     type = \"probabilistic\"\n      probabilistic {\n       sampling_percentage = 50\n      }\n    }\n  }\n}"` |  |
| sampling.failedRequests.percentage | int | `50` |  |
| sampling.failedRequests.sample | bool | `false` |  |
| sampling.successfulRequests.percentage | int | `10` |  |
| sampling.successfulRequests.sample | bool | `true` |  |

