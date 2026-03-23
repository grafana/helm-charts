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
    {{ include "loki.labels" . | nindent 4 }}
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
      {{- with (concat .Values.global.extraEnv .Values.defaults.extraEnv $component.extraEnv) | uniq }}
      env:
        {{- toYaml . | nindent 8 }}
      {{- end }}
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
        {{- with (concat .Values.global.extraVolumeMounts .Values.defaults.extraVolumeMounts $component.extraVolumeMounts) | uniq }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      {{- with $component.resources }}
      resources:
        {{- toYaml . | nindent 8 }}
      {{- end }}
    {{- with $component.extraContainers }}
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
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (coalesce $component.tolerations .Values.defaults.tolerations .Values.loki.tolerations) }}
  tolerations:
    {{- toYaml . | nindent 4 }}
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
      {{- if dig "ephemeralDataVolume" "enabled" false $component }}
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
      {{- else }}
      emptyDir: {}
      {{- end }}
    {{- with (coalesce $component.extraVolumes .Values.defaults.extraVolumes .Values.global.extraVolumes) }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
{{- end }}
