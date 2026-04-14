{{/*
Shared pod template for all Tempo binary components.

Usage:
  {{ include "tempo.podTemplate" (dict "ctx" $ "component" .Values.distributor "target" "distributor") }}

Parameters:
  ctx        - root context ($)
  component  - component values dict (e.g. .Values.distributor)
  target     - component name string used in args and volume names (e.g. "distributor")

*/}}
{{- define "tempo.podTemplate" }}
{{- $target := .target }}
{{- $ctx := .ctx }}
{{- $component := .component }}
{{- with $ctx }}
metadata:
  annotations:
    {{- with (mergeOverwrite (dict) (.Values.defaults.podAnnotations | default (dict)) (.Values.tempo.podAnnotations | default (dict)) ($component.podAnnotations | default (dict))) }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
    checksum/config: {{ include (print .Template.BasePath "/configmap-tempo.yaml") . | sha256sum }}
  labels:
    {{- include "tempo.podLabels" (dict "ctx" . "component" $target "memberlist" true) | nindent 4 }}
    {{- with (mergeOverwrite (dict) (.Values.defaults.podLabels | default (dict)) (.Values.tempo.podLabels | default (dict)) ($component.podLabels | default (dict))) }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  serviceAccountName: {{ include "tempo.serviceAccountName" . }}
  enableServiceLinks: false
  {{- with (coalesce $component.podSecurityContext .Values.tempo.podSecurityContext .Values.defaults.podSecurityContext) }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (coalesce $component.priorityClassName .Values.defaults.priorityClassName .Values.global.priorityClassName) }}
  priorityClassName: {{ . }}
  {{- end }}
  {{- include "tempo.componentImagePullSecrets" (dict "ctx" . "component" $target) | nindent 2 -}}
  {{- with (coalesce $component.hostAliases .Values.defaults.hostAliases) }}
  hostAliases:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $component.initContainers }}
  initContainers:
    {{- if kindIs "slice" . }}
      {{- tpl (toYaml .) $ctx | nindent 4 }}
    {{- else if kindIs "string" . }}
      {{- tpl . $ctx | nindent 4 }}
    {{- end }}
  {{- end }}
  containers:
    - name: {{ $target }}
      image: {{ include "tempo.imageReference" (dict "ctx" . "component" $target) }}
      imagePullPolicy: {{ .Values.tempo.image.pullPolicy }}
      args:
        - -target={{ $target }}
        - -config.file=/conf/tempo.yaml
        {{- with (concat .Values.global.extraArgs (.Values.defaults.extraArgs | default list) $component.extraArgs) | uniq }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      ports:
        - containerPort: {{ include "tempo.memberlistBindPort" . }}
          name: http-memberlist
          protocol: TCP
        - containerPort: 3200
          name: http-metrics
          protocol: TCP
        {{- with $component.extraPorts }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      {{- $resolvedResources := coalesce $component.resources .Values.tempo.resources .Values.defaults.resources | default (dict) }}
      {{- include "tempo.componentEnv" (dict "extraEnv" (concat .Values.global.extraEnv (.Values.defaults.extraEnv | default list) $component.extraEnv) "resources" $resolvedResources "factor" .Values.global.goSettings.goMemLimitFactor "gogc" .Values.global.goSettings.gogc) | nindent 6 }}
      {{- with (concat .Values.global.extraEnvFrom (.Values.defaults.extraEnvFrom | default list) $component.extraEnvFrom) | uniq }}
      envFrom:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with (coalesce $component.livenessProbe .Values.tempo.livenessProbe .Values.defaults.livenessProbe) }}
      livenessProbe:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with (coalesce $component.readinessProbe .Values.tempo.readinessProbe .Values.defaults.readinessProbe) }}
      readinessProbe:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $resolvedResources }}
      resources:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with (coalesce $component.containerSecurityContext .Values.tempo.securityContext .Values.defaults.containerSecurityContext) }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $component.lifecycle }}
      lifecycle:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      volumeMounts:
        - mountPath: /conf
          name: config
        - mountPath: /runtime-config
          name: runtime-config
        - mountPath: /var/tempo
          name: tempo-{{ $target }}-store
        {{- if .Values.enterprise.enabled }}
        - name: license
          mountPath: /license
        {{- end }}
        {{- with (concat (.Values.defaults.extraVolumeMounts | default list) $component.extraVolumeMounts) | uniq }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    {{- with $component.extraContainers }}
    {{- if kindIs "slice" . }}
      {{- tpl (toYaml .) $ctx | nindent 4 }}
    {{- else if kindIs "string" . }}
      {{- tpl . $ctx | nindent 4 }}
    {{- end }}
    {{- end }}
  terminationGracePeriodSeconds: {{ $component.terminationGracePeriodSeconds }}
  {{- if semverCompare ">= 1.19-0" .Capabilities.KubeVersion.Version }}
  {{- with $component.topologySpreadConstraints }}
  topologySpreadConstraints:
    {{- tpl . $ctx | nindent 4 }}
  {{- end }}
  {{- end }}
  {{- with $component.affinity }}
  affinity:
    {{- tpl . $ctx | nindent 4 }}
  {{- end }}
  {{- with (coalesce $component.nodeSelector .Values.defaults.nodeSelector) }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (coalesce $component.tolerations .Values.defaults.tolerations) }}
  tolerations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  volumes:
    - name: config
      {{- include "tempo.configVolume" . | nindent 6 }}
    - name: runtime-config
      {{- include "tempo.runtimeVolume" . | nindent 6 }}
    - name: tempo-{{ $target }}-store
      emptyDir: {}
    {{- if .Values.enterprise.enabled }}
    - name: license
      secret:
        secretName: {{ tpl .Values.license.secretName . }}
    {{- end }}
    {{- with (concat (.Values.global.extraVolumes | default list) (.Values.defaults.extraVolumes | default list) $component.extraVolumes) | uniq }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
{{- end }}
{{- end }}
