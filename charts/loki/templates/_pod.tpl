{{/*
Pod helper
*/}}

{{- define "loki.pod" }}
{{- $target := .target }}
{{- $ctx := .ctx }}
{{- $component := .component }}
{{- with $ctx }}
serviceAccountName: {{ include "loki.serviceAccountName" . }}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with (coalesce $component.dnsConfig .Values.defaults.dnsConfig .Values.loki.dnsConfig) }}
dnsConfig:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with (coalesce $component.hostAliases .Values.defaults.hostAliases .Values.loki.hostAliases) }}
hostAliases:
  {{- toYaml . | nindent 2 }}
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
{{- with .Values.loki.podSecurityContext }}
securityContext:
  {{- . | nindent 2 }}
{{- end }}
{{- with (coalesce $component.terminationGracePeriodSeconds .Values.defaults.terminationGracePeriodSeconds .Values.loki.terminationGracePeriodSeconds) }}
terminationGracePeriodSeconds: {{ . }}
{{- end }}
{{- with $component.initContainers }}
initContainers:
  {{- if kindIs "map" . }}
    {{- tpl (toYaml .) $ctx | nindent 2 }}
  {{- else if kindIs "string" . }}
    {{- tpl . $ctx | nindent 2 }}
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
      {{- with (concat .Values.global.extraArgs .Values.defaults.extraArgs .Values.loki.extraArgs $component.extraArgs) | uniq }}
      {{- toYaml . | nindent 6 }}
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
    {{- with (concat .Values.global.extraEnv .Values.defaults.extraEnv .Values.loki.extraEnv $component.extraEnv) | uniq }}
    env:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with (concat .Values.global.extraEnvFrom .Values.defaults.extraEnvFrom .Values.loki.extraEnvFrom $component.extraEnvFrom) | uniq }}
    envFrom:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with (coalesce .Values.defaults.containerSecurityContext .Values.loki.containerSecurityContext) }}
    securityContext:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with (coalesce $component.livenessProbe .Values.defaults.livenessProbe .Values.loki.livenessProbe) }}
      {{- if .enabled | default true }}
    livenessProbe:
      {{- toYaml (omit . "enabled") | nindent 6 }}
      {{- end }}
    {{- end }}
    {{- with (coalesce $component.readinessProbe .Values.defaults.readinessProbe .Values.loki.readinessProbe) }}
      {{- if .enabled | default true }}
    readinessProbe:
      {{- toYaml (omit . "enabled") | nindent 6 }}
      {{- end }}
    {{- end }}
    {{- with (coalesce $component.startupProbe .Values.defaults.startupProbe .Values.loki.startupProbe) }}
      {{- if .enabled | default true }}
    startupProbe:
      {{- toYaml (omit . "enabled") | nindent 6 }}
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
      {{- with (concat .Values.global.extraVolumeMounts .Values.defaults.extraVolumeMounts .Values.loki.extraVolumeMounts $component.extraVolumeMounts) | uniq }}
      {{- toYaml . | nindent 6 }}
      {{- end }}
    {{- with $component.resources }}
    resources:
      {{- toYaml . | nindent 6 }}
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
  {{- tpl ( . | toYaml) $ | nindent 2 }}
{{- end }}
{{- with (coalesce $component.nodeSelector .Values.defaults.nodeSelector .Values.loki.nodeSelector) }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with (coalesce $component.tolerations .Values.defaults.tolerations .Values.loki.tolerations) }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
volumes:
  - name: config
    {{- include "loki.configVolume" . | nindent 4 }}
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
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $component.ephemeralDataVolume.labels }}
          labels:
            {{- toYaml . | nindent 12 }}
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
            {{- toYaml . | nindent 18 }}
          {{- end }}
    {{- else }}
    emptyDir: {}
    {{- end }}
  {{- with (coalesce $component.extraVolumes .Values.defaults.extraVolumes .Values.global.extraVolumes) }}
  {{- toYaml . | nindent 8 }}
  {{- end }}
{{- end }}
{{- end }}
