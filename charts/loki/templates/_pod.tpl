{{/*
Pod helper
*/}}

{{- define "loki.podTemplate" }}
{{- $target := .target }}
{{- $ctx := .ctx }}
{{- $component := .component }}
{{- $args := .args }}
{{- with $ctx }}
metadata:
  annotations:
    {{- include "loki.config.checksum" . | nindent 4 }}
    {{- with (mergeOverwrite (dict) .Values.loki.podAnnotations .Values.defaults.podAnnotations $component.podAnnotations) }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  labels:
    {{- include "loki.labels" . | nindent 4 }}
    app.kubernetes.io/component: {{ $target }}
    app.kubernetes.io/part-of: memberlist
    {{- with (mergeOverwrite (dict) .Values.loki.podLabels .Values.defaults.podLabels $component.podLabels) }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  {{- with $component.topologySpreadConstraints }}
  topologySpreadConstraints:
    {{- tpl ( . | toYaml) $ctx | nindent 4 }}
  {{- end }}
  serviceAccountName: {{ include "loki.serviceAccountName" . }}
  {{- if (kindIs "bool" $component.enableServiceLinks) }}
  enableServiceLinks: {{ $component.enableServiceLinks }}
  {{- else if (kindIs "bool" .Values.defaults.enableServiceLinks) }}
  enableServiceLinks: {{ .Values.defaults.enableServiceLinks }}
  {{- else if (kindIs "bool" .Values.loki.hostUsers) }}
  enableServiceLinks: {{ .Values.loki.enableServiceLinks }}
  {{- end }}
  {{- if (kindIs "bool" (coalesce $component.automountServiceAccountToken .Values.defaults.automountServiceAccountToken)) }}
  automountServiceAccountToken: {{ (coalesce $component.automountServiceAccountToken .Values.defaults.automountServiceAccountToken) }}
  {{- end }}
  {{- with .Values.imagePullSecrets }}
  imagePullSecrets:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (coalesce $component.dnsConfig .Values.defaults.dnsConfig .Values.loki.dnsConfig) }}
  dnsConfig:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (coalesce $component.hostAliases .Values.defaults.hostAliases .Values.loki.hostAliases) }}
  hostAliases:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if (kindIs "bool" $component.hostUsers) }}
  hostUsers: {{ $component.hostUsers }}
  {{- else if (kindIs "bool" .Values.defaults.hostUsers) }}
  hostUsers: {{ .Values.defaults.hostUsers }}
  {{- else if (kindIs "bool" .Values.loki.hostUsers) }}
  hostUsers: {{ .Values.loki.hostUsers }}
  {{- end }}
  {{- with (coalesce $component.priorityClassName .Values.defaults.priorityClassName .Values.loki.priorityClassName .Values.global.priorityClassName) }}
  priorityClassName: {{ . }}
  {{- end }}
  {{- with (coalesce .Values.defaults.podSecurityContext .Values.loki.podSecurityContext) }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (coalesce $component.terminationGracePeriodSeconds .Values.defaults.terminationGracePeriodSeconds .Values.loki.terminationGracePeriodSeconds) }}
  terminationGracePeriodSeconds: {{ . }}
  {{- end }}
  {{- with $component.initContainers }}
  initContainers:
    {{- if kindIs "map" . }}
      {{- tpl (toYaml .) $ctx | nindent 4 }}
    {{- else if kindIs "string" . }}
      {{- tpl . $ctx | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with $component.affinity }}
  affinity:
    {{- tpl ( . | toYaml) $ctx | nindent 4 }}
  {{- end }}
  {{- with (coalesce $component.nodeSelector .Values.defaults.nodeSelector .Values.loki.nodeSelector) }}
  nodeSelector:
    {{- tpl ( . | toYaml) $ctx | nindent 4 }}
  {{- end }}
  {{- with (coalesce $component.tolerations .Values.defaults.tolerations .Values.loki.tolerations) }}
  tolerations:
    {{- tpl ( . | toYaml) $ctx | nindent 4 }}
  {{- end }}
  volumes:
    - name: config
      {{- include "loki.configVolume" . | nindent 6 }}
    - name: runtime-config
      configMap:
        name: {{ template "loki.name" . }}-runtime
    - name: temp
      emptyDir: {}
    - name: data
      {{- if dig "persistence" "ephemeralDataVolume" "enabled" false $component }}
      ephemeral:
        volumeClaimTemplate:
          metadata:
            {{- with $component.ephemeralDataVolume.annotations }}
            annotations:
              {{- toYaml . | nindent 14 }}
            {{- end }}
            {{- with $component.ephemeralDataVolume.labels }}
            labels:
              {{- toYaml . | nindent 14 }}
            {{- end }}
          spec:
            accessModes:
              {{- toYaml $component.ephemeralDataVolume.accessModes | nindent 12 }}
            {{- if not (kindIs "invalid" $component.ephemeralDataVolume.storageClass) }}
            storageClassName: {{ if (eq "-" $component.ephemeralDataVolume.storageClass) }}""{{ else }}{{ $component.ephemeralDataVolume.storageClass }}{{ end }}
            {{- end }}
            {{- with $component.ephemeralDataVolume.volumeAttributesClassName }}
            volumeAttributesClassName: {{ . }}
            {{- end }}
            resources:
              requests:
                storage: {{ $component.ephemeralDataVolume.size | quote }}
            {{- with $component.ephemeralDataVolume.selector }}
            selector:
              {{- toYaml . | nindent 14 }}
            {{- end }}
      {{- else if not (or (dig "persistence" "volumeClaimsEnabled" false $component) (dig "persistence" "enabled" false $component)) }}
        {{- with (dig "persistence" "dataVolumeParameters" (dict "emptyDir" (dict)) $component) }}
      {{- toYaml . | nindent 6 }}
        {{- end }}
      {{- end }}
    {{- if and $component.sidecar .Values.sidecar.rules.enabled }}
    - name: sc-rules-volume
      {{- if .Values.sidecar.sizeLimit }}
      emptyDir:
        sizeLimit: {{ .Values.sidecar.sizeLimit }}
      {{- else }}
      emptyDir: {}
      {{- end }}
    - name: sc-rules-temp
      emptyDir: {}
    {{- end }}
    {{- with (coalesce $component.extraVolumes .Values.defaults.extraVolumes .Values.global.extraVolumes) }}
    {{- toYaml . | nindent 8 }}
    {{- end }}
  containers:
    - name: {{ $target }}
      image: {{ include "loki.image" . }}
      imagePullPolicy: {{ .Values.loki.image.pullPolicy }}
      {{- with coalesce $component.command .Values.defaults.command .Values.loki.command }}
      command:
        - {{ . | quote }}
      {{- end }}
      args:
        - -config.file=/etc/loki/config/config.yaml
        - -target={{ $target }}
        {{- with $args }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
        {{- with (concat .Values.global.extraArgs .Values.defaults.extraArgs $component.extraArgs) | uniq }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      ports:
        - name: http-metrics
          containerPort: 3100
          protocol: TCP
        - name: grpc
          containerPort: 9095
          protocol: TCP
        - name: http-memberlist
          containerPort: 7946
          protocol: TCP
      {{- include "loki.componentEnv" (dict "extraEnv" (concat .Values.global.extraEnv .Values.defaults.extraEnv $component.extraEnv) "resources" $component.resources "factor" .Values.defaults.goSettings.goMemLimitFactor "gogc" .Values.defaults.goSettings.gogc) | nindent 6 }}
      {{- with (concat .Values.global.extraEnvFrom .Values.defaults.extraEnvFrom $component.extraEnvFrom) | uniq }}
      envFrom:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with (coalesce .Values.defaults.containerSecurityContext .Values.loki.containerSecurityContext) }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with (coalesce $component.livenessProbe .Values.defaults.livenessProbe .Values.loki.livenessProbe) }}
        {{- if .enabled | default true }}
      livenessProbe:
        {{- toYaml (omit . "enabled") | nindent 8 }}
        {{- end }}
      {{- end }}
      {{- with (coalesce $component.readinessProbe .Values.defaults.readinessProbe .Values.loki.readinessProbe) }}
        {{- if .enabled | default true }}
      readinessProbe:
        {{- toYaml (omit . "enabled") | nindent 8 }}
        {{- end }}
      {{- end }}
      {{- with (coalesce $component.startupProbe .Values.defaults.startupProbe .Values.loki.startupProbe) }}
        {{- if .enabled | default true }}
      startupProbe:
        {{- toYaml (omit . "enabled") | nindent 8 }}
        {{- end }}
      {{- end }}
      volumeMounts:
        - name: config
          mountPath: /etc/loki/config
        - name: runtime-config
          mountPath: /etc/loki/runtime-config
        - name: temp
          mountPath: /tmp
        - name: data
          mountPath: /var/loki
        {{- if and $component.sidecar .Values.sidecar.rules.enabled }}
        - name: sc-rules-volume
          mountPath: {{ .Values.sidecar.rules.folder | quote }}
        {{- end }}
        {{- with (concat .Values.global.extraVolumeMounts .Values.defaults.extraVolumeMounts $component.extraVolumeMounts) | uniq }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      {{- with $component.resources }}
      resources:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- if and $component.sidecar .Values.sidecar.rules.enabled }}
    {{- include "loki.rulesSidecar" . | nindent 4 }}
      {{- end }}
    {{- with $component.extraContainers }}
      {{- if kindIs "slice" . }}
        {{- tpl (toYaml .) $ctx | nindent 4 }}
      {{- else if kindIs "string" . }}
        {{- tpl . $ctx | nindent 4 }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}


{{/*
rules sidecar
*/}}
{{- define "loki.rulesSidecar" -}}
{{- if .Values.sidecar.rules.enabled }}
- name: loki-sc-rules
  {{- $dict := dict "service" .Values.sidecar.image "global" .Values.global }}
  image: {{ include "loki.baseImage" $dict }}
  imagePullPolicy: {{ .Values.sidecar.image.pullPolicy }}
  {{- with .Values.sidecar.resources }}
  resources:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.sidecar.securityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.sidecar.livenessProbe }}
    {{- if .enabled | default true }}
  livenessProbe:
    {{- toYaml (omit . "enabled") | nindent 8 }}
    {{- end }}
  {{- end }}
  {{- with .Values.sidecar.readinessProbe }}
    {{- if .enabled | default true }}
  readinessProbe:
    {{- toYaml (omit . "enabled") | nindent 8 }}
    {{- end }}
  {{- end }}
  {{- with .Values.sidecar.startupProbe }}
    {{- if .enabled | default true }}
  startupProbe:
    {{- toYaml (omit . "enabled") | nindent 8 }}
    {{- end }}
  {{- end }}
  env:
    - name: METHOD
      value: {{ .Values.sidecar.rules.watchMethod }}
    - name: LABEL
      value: "{{ .Values.sidecar.rules.label }}"
    {{- if .Values.sidecar.rules.labelValue }}
    - name: LABEL_VALUE
      value: {{ quote .Values.sidecar.rules.labelValue }}
    {{- end }}
    - name: FOLDER
      value: "{{ .Values.sidecar.rules.folder }}"
    {{- if .Values.sidecar.rules.folderAnnotation }}
    - name: FOLDER_ANNOTATION
      value: "{{ .Values.sidecar.rules.folderAnnotation }}"
    {{- end }}
    - name: RESOURCE
      value: {{ quote .Values.sidecar.rules.resource }}
    {{- if .Values.sidecar.enableUniqueFilenames }}
    - name: UNIQUE_FILENAMES
      value: "{{ .Values.sidecar.enableUniqueFilenames }}"
    {{- end }}
    {{- if .Values.sidecar.rules.searchNamespace }}
    - name: NAMESPACE
      value: "{{ .Values.sidecar.rules.searchNamespace | join "," }}"
    {{- end }}
    {{- if .Values.sidecar.skipTlsVerify }}
    - name: SKIP_TLS_VERIFY
      value: "{{ .Values.sidecar.skipTlsVerify }}"
    {{- end }}
    {{- if .Values.sidecar.disableX509StrictVerification }}
    - name: DISABLE_X509_STRICT_VERIFICATION
      value: "{{ .Values.sidecar.disableX509StrictVerification }}"
    {{- end }}
    {{- if .Values.sidecar.rules.script }}
    - name: SCRIPT
      value: "{{ .Values.sidecar.rules.script }}"
    {{- end }}
    {{- if .Values.sidecar.rules.watchServerTimeout }}
    - name: WATCH_SERVER_TIMEOUT
      value: "{{ .Values.sidecar.rules.watchServerTimeout }}"
    {{- end }}
    {{- if .Values.sidecar.rules.watchClientTimeout }}
    - name: WATCH_CLIENT_TIMEOUT
      value: "{{ .Values.sidecar.rules.watchClientTimeout }}"
    {{- end }}
    {{- if .Values.sidecar.rules.logLevel }}
    - name: LOG_LEVEL
      value: "{{ .Values.sidecar.rules.logLevel }}"
    {{- end }}
  volumeMounts:
    - name: sc-rules-temp
      mountPath: /tmp
    - name: sc-rules-volume
      mountPath: {{ .Values.sidecar.rules.folder | quote }}
{{- end }}
{{- end }}
