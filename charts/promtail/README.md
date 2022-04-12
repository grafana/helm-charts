# promtail


![Version: 4.2.0](https://img.shields.io/badge/Version-4.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.5.0](https://img.shields.io/badge/AppVersion-2.5.0-informational?style=flat-square) 

Promtail is an agent which ships the contents of local logs to a Loki instance

## Source Code

* <https://github.com/grafana/loki>
* <https://grafana.com/oss/loki/>
* <https://grafana.com/docs/loki/latest/>



## Chart Repo

Add the following repo to use the chart:

```console
helm repo add grafana https://grafana.github.io/helm-charts
```

## Upgrading

A major chart version change indicates that there is an incompatible breaking change needing manual actions.

### From Chart Versions < 3.0.0

#### Notable Changes

* Helm 3 is required
* Labels have been updated to follow the official Kubernetes [label recommendations](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/)
* The default scrape configs have been updated to take new and old labels into consideration
* The config file must be specified as string which can be templated.
  See below for details
* The config file is now stored in a Secret and no longer in a ConfigMap because it may contain sensitive data, such as basic auth credentials

Due to the label changes, an existing installation cannot be upgraded without manual interaction.
There are basically two options:

##### Option 1

Uninstall the old release and re-install the new one.
There will be no data loss.
Promtail will cleanly shut down and write the `positions.yaml`.
The new release which will pick up again from the existing `positions.yaml`.

##### Option 2

* Add new selector labels to the existing pods:

  ```
  kubectl label pods -n <namespace> -l app=promtail,release=<release> app.kubernetes.io/name=promtail app.kubernetes.io/instance=<release>
  ```

* Perform a non-cascading deletion of the DaemonSet which will keep the pods running:

  ```
  kubectl delete daemonset -n <namespace> -l app=promtail,release=<release> --cascade=false
  ```

* Perform a regular Helm upgrade on the existing release.
  The new DaemonSet will pick up the existing pods and perform a rolling upgrade.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity configuration for pods |
| annotations | object | `{}` | Annotations for the DaemonSet |
| config | object | See `values.yaml` | Section for crafting Promtails config file. The only directly relevant value is `config.file` which is a templated string that references the other values and snippets below this key. |
| config.file | string | See `values.yaml` | Config file contents for Promtail. Must be configured as string. It is templated so it can be assembled from reusable snippets in order to avoid redundancy. |
| config.snippets.extraClientConfigs | list | empty | You can put here any keys that will be directly added to the config file's 'client' block. |
| config.snippets.extraRelabelConfigs | list | `[]` | You can put here any additional relabel_configs to "kubernetes-pods" job |
| config.snippets.extraScrapeConfigs | string | empty | You can put here any additional scrape configs you want to add to the config file. |
| containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | The security context for containers |
| defaultVolumeMounts | list | See `values.yaml` | Default volume mounts. Corresponds to `volumes`. |
| defaultVolumes | list | See `values.yaml` | Default volumes that are mounted into pods. In most cases, these should not be changed. Use `extraVolumes`/`extraVolumeMounts` for additional custom volumes. |
| extraArgs | list | `[]` |  |
| extraEnv | list | `[]` | extraArgs: --   - -client.external-labels=hostname=$(HOSTNAME) -- Extra environment variables |
| extraEnvFrom | list | `[]` | Extra environment variables from secrets or configmaps |
| extraObjects | list | `[]` | Extra K8s manifests to deploy |
| extraPorts | object | `{}` | Configure additional ports and services. For each configured port, a corresponding service is created. See values.yaml for details |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| fullnameOverride | string | `nil` | Overrides the chart's computed fullname |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.registry | string | `"docker.io"` |  |
| image.repository | string | `"grafana/promtail"` |  |
| image.tag | string | `nil` |  |
| imagePullSecrets | list | `[]` | Image pull secrets for Docker images |
| initContainer.enabled | bool | `false` |  |
| initContainer.fsInotifyMaxUserInstances | int | `128` |  |
| initContainer.image.pullPolicy | string | `"IfNotPresent"` |  |
| initContainer.image.registry | string | `"docker.io"` |  |
| initContainer.image.repository | string | `"busybox"` |  |
| initContainer.image.tag | float | `1.33` |  |
| livenessProbe | object | `{}` | Liveness probe |
| nameOverride | string | `nil` |  |
| networkPolicy.enabled | bool | `false` |  |
| networkPolicy.k8sApi.cidrs | list | `[]` |  |
| networkPolicy.k8sApi.port | int | `8443` |  |
| networkPolicy.metrics.cidrs | list | `[]` |  |
| networkPolicy.metrics.namespaceSelector | object | `{}` |  |
| networkPolicy.metrics.podSelector | object | `{}` |  |
| nodeSelector | object | `{}` | Node selector for pods |
| podAnnotations | object | `{}` | Pod annotations |
| podLabels | object | `{}` | Pod labels |
| podSecurityContext.runAsGroup | int | `0` |  |
| podSecurityContext.runAsUser | int | `0` |  |
| podSecurityPolicy.allowPrivilegeEscalation | bool | `true` |  |
| podSecurityPolicy.fsGroup.rule | string | `"RunAsAny"` |  |
| podSecurityPolicy.hostIPC | bool | `false` |  |
| podSecurityPolicy.hostNetwork | bool | `false` |  |
| podSecurityPolicy.hostPID | bool | `false` |  |
| podSecurityPolicy.privileged | bool | `true` |  |
| podSecurityPolicy.readOnlyRootFilesystem | bool | `true` |  |
| podSecurityPolicy.requiredDropCapabilities[0] | string | `"ALL"` |  |
| podSecurityPolicy.runAsUser.rule | string | `"RunAsAny"` |  |
| podSecurityPolicy.seLinux.rule | string | `"RunAsAny"` |  |
| podSecurityPolicy.supplementalGroups.rule | string | `"RunAsAny"` |  |
| podSecurityPolicy.volumes[0] | string | `"secret"` |  |
| podSecurityPolicy.volumes[1] | string | `"hostPath"` |  |
| podSecurityPolicy.volumes[2] | string | `"downwardAPI"` |  |
| priorityClassName | string | `nil` |  |
| rbac.create | bool | `true` |  |
| rbac.pspEnabled | bool | `false` |  |
| readinessProbe | object | See `values.yaml` | Readiness probe |
| resources | object | `{}` | Resource requests and limits |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.imagePullSecrets | list | `[]` |  |
| serviceAccount.name | string | `nil` |  |
| serviceMonitor.annotations | object | `{}` |  |
| serviceMonitor.enabled | bool | `false` |  |
| serviceMonitor.interval | string | `nil` |  |
| serviceMonitor.labels | object | `{}` |  |
| serviceMonitor.namespace | string | `nil` |  |
| serviceMonitor.namespaceSelector | object | `{}` |  |
| serviceMonitor.relabelings | list | `[]` |  |
| serviceMonitor.scrapeTimeout | string | `nil` |  |
| tolerations | list | `[{"effect":"NoSchedule","key":"node-role.kubernetes.io/master","operator":"Exists"},{"effect":"NoSchedule","key":"node-role.kubernetes.io/control-plane","operator":"Exists"}]` | Tolerations for pods. By default, pods will be scheduled on master/control-plane nodes. |
| updateStrategy | object | `{}` | The update strategy for the DaemonSet |

## Configuration

The config file for Promtail must be configured as string.
This is necessary because the contents are passed through the `tpl` function.
With this, the file can be templated and assembled from reusable YAML snippets.
It is common to have multiple `kubernetes_sd_configs` that, in turn, usually need the same `pipeline_stages`.
Thus, extracting reusable snippets helps reduce redundancy and avoid copy/paste errors.
See `values.yaml´ for details.
Also, the following examples make use of this feature.

For additional reference, please refer to Promtail's docs:

https://grafana.com/docs/loki/latest/clients/promtail/configuration/

### Syslog Support

```yaml
extraPorts:
  syslog:
    name: tcp-syslog
    containerPort: 1514
    service:
      port: 80
      type: LoadBalancer
      externalTrafficPolicy: Local
      loadBalancerIP: 123.234.123.234

config:
  snippets:
    extraScrapeConfigs: |
      # Add an additional scrape config for syslog
      - job_name: syslog
        syslog:
          listen_address: 0.0.0.0:{{ .Values.extraPorts.syslog.containerPort }}
          labels:
            job: syslog
        relabel_configs:
          - source_labels:
              - __syslog_message_hostname
            target_label: host
```

### Journald Support

```yaml
config:
  snippets:
    extraScrapeConfigs: |
      # Add an additional scrape config for syslog
      - job_name: journal
        journal:
          path: /var/log/journal
          max_age: 12h
          labels:
            job: systemd-journal
        relabel_configs:
          - source_labels:
              - '__journal__systemd_unit'
            target_label: 'unit'
          - source_labels:
              - '__journal__hostname'
            target_label: 'hostname'

# Mount journal directory into promtail pods
extraVolumes:
  - name: journal
    hostPath:
      path: /var/log/journal

extraVolumeMounts:
  - name: journal
    mountPath: /var/log/journal
    readOnly: true
```

### Push API Support

```
extraPorts:
  httpPush:
    name: http-push
    containerPort: 3500
  grpcPush:
    name: grpc-push
    containerPort: 3600

config:
  file: |
    server:
      log_level: {{ .Values.config.logLevel }}
      http_listen_port: {{ .Values.config.serverPort }}

    client:
      url: {{ .Values.config.lokiAddress }}

    positions:
      filename: /run/promtail/positions.yaml

    scrape_configs:
      {{- tpl .Values.config.snippets.scrapeConfigs . | nindent 2 }}

      - job_name: push1
        loki_push_api:
          server:
            http_listen_port: {{ .Values.extraPorts.httpPush.containerPort }}
            grpc_listen_port: {{ .Values.extraPorts.grpcPush.containerPort }}
          labels:
            pushserver: push1
```

### Extra client config options

If you want to add additional options to the `client` section of promtail's config, please use
the `extraClientConfigs` section. For example, to enable HTTP basic auth and include OrgID
header, you can use:

```yaml
config:
  snippets:
    extraClientConfigs: |
      basic_auth:
        username: loki
        password: secret
      tenant_id: 1
```
