{{/* vim: set filetype=mustache: */}}
{{/*
Render a StatefulSet for a per-role memcached cluster.
Params:
  ctx            = root context ($)
  memcachedConfig = per-role values section (e.g. .Values.memcachedBloom)
  component      = K8s component name (e.g. "memcached-bloom")
*/}}
{{- define "tempo.memcached.statefulSet" -}}
{{- if $.memcachedConfig.enabled }}
{{ $dict := dict "ctx" $.ctx "component" $.component }}
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ include "tempo.resourceName" $dict }}
  namespace: {{ $.ctx.Release.Namespace }}
  labels:
    {{- include "tempo.labels" $dict | nindent 4 }}
  {{- with $.memcachedConfig.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  replicas: {{ $.memcachedConfig.replicas }}
  revisionHistoryLimit: {{ $.ctx.Values.tempo.revisionHistoryLimit }}
  selector:
    matchLabels:
      {{- include "tempo.selectorLabels" $dict | nindent 6 }}
  serviceName: {{ $.component }}
  template:
    metadata:
      {{- if or $.ctx.Values.tempo.podAnnotations $.memcachedConfig.podAnnotations }}
      annotations:
        {{- with $.ctx.Values.tempo.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
        {{- with $.memcachedConfig.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      {{- end }}
      labels:
        {{- include "tempo.labels" $dict | nindent 8 }}
        {{- with $.ctx.Values.tempo.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
        {{- with $.memcachedConfig.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      {{- if or ($.memcachedConfig.priorityClassName) ($.ctx.Values.global.priorityClassName) }}
      priorityClassName: {{ default $.memcachedConfig.priorityClassName $.ctx.Values.global.priorityClassName }}
      {{- end }}
      serviceAccountName: {{ include "tempo.serviceAccountName" $.ctx }}
      {{- with $.ctx.Values.tempo.podSecurityContext }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      enableServiceLinks: false
      {{- include "tempo.componentImagePullSecrets" (dict "ctx" $.ctx "component" "memcached-exporter" "noTempoFallback" true) | nindent 6 -}}
      {{- with $.ctx.Values.memcachedExporter.hostAliases }}
      hostAliases:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $.memcachedConfig.initContainers }}
      initContainers:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      containers:
        - image: {{ include "tempo.imageReference" (dict "ctx" $.ctx "component" "memcached") }}
          imagePullPolicy: {{ $.ctx.Values.memcached.image.pullPolicy }}
          name: memcached
          {{- if or $.ctx.Values.global.extraArgs $.memcachedConfig.extraArgs }}
          args:
            {{- with $.memcachedConfig.extraArgs }}
            {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $.ctx.Values.global.extraArgs }}
            {{- toYaml . | nindent 12 }}
            {{- end }}
          {{- end }}
          ports:
            - containerPort: 11211
              name: client
          {{- if or $.ctx.Values.global.extraEnv $.memcachedConfig.extraEnv }}
          env:
            {{- with $.ctx.Values.global.extraEnv }}
              {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $.memcachedConfig.extraEnv }}
              {{- toYaml . | nindent 12 }}
            {{- end }}
          {{- end }}
          {{- if or $.ctx.Values.global.extraEnvFrom $.memcachedConfig.extraEnvFrom }}
          envFrom:
            {{- with $.ctx.Values.global.extraEnvFrom }}
              {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $.memcachedConfig.extraEnvFrom }}
              {{- toYaml . | nindent 12 }}
            {{- end }}
          {{- end }}
          {{- with $.memcachedConfig.readinessProbe }}
          readinessProbe:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $.memcachedConfig.livenessProbe }}
          livenessProbe:
            exec:
              command:
                - pgrep
                - memcached
            {{- toYaml . | nindent 12 }}
          {{- end }}
          resources:
            {{- toYaml $.memcachedConfig.resources | nindent 12 }}
          {{- with $.ctx.Values.tempo.securityContext }}
          securityContext:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $.memcachedConfig.extraVolumeMounts }}
          volumeMounts:
            {{- toYaml . | nindent 12 }}
          {{- end }}
        {{- if $.ctx.Values.memcachedExporter.enabled }}
        - args:
            - --memcached.address=localhost:11211
            - --web.listen-address=0.0.0.0:9150
          {{- with $.ctx.Values.memcachedExporter.extraArgs }}
            {{- toYaml . | nindent 12 }}
          {{- end }}
          image: {{ include "tempo.imageReference" (dict "ctx" $.ctx "component" "memcached-exporter") }}
          imagePullPolicy: {{ $.ctx.Values.memcachedExporter.image.pullPolicy }}
          name: exporter
          ports:
            - containerPort: 9150
              name: http-metrics
          resources:
            {{- toYaml $.ctx.Values.memcachedExporter.resources | nindent 12 }}
          {{- with $.ctx.Values.tempo.securityContext }}
          securityContext:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $.memcachedConfig.extraVolumeMounts }}
          volumeMounts:
            {{- toYaml . | nindent 12 }}
          {{- end }}
        {{- end }}
        {{- with $.memcachedConfig.extraContainers }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      {{- if semverCompare ">= 1.19-0" $.ctx.Capabilities.KubeVersion.Version }}
      {{- with $.memcachedConfig.topologySpreadConstraints }}
      topologySpreadConstraints:
        {{- tpl . $.ctx | nindent 8 }}
      {{- end }}
      {{- end }}
      {{- with $.memcachedConfig.affinity }}
      affinity:
        {{- tpl . $.ctx | nindent 8 }}
      {{- end }}
      {{- with $.memcachedConfig.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $.memcachedConfig.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $.memcachedConfig.extraVolumes }}
      volumes:
        {{- toYaml . | nindent 8 }}
      {{- end }}
  updateStrategy:
    type: RollingUpdate
{{- end }}
{{- end -}}

{{/*
Render a Service for a per-role memcached cluster.
Params:
  ctx            = root context ($)
  memcachedConfig = per-role values section (e.g. .Values.memcachedBloom)
  component      = K8s component name (e.g. "memcached-bloom")
*/}}
{{- define "tempo.memcached.service" -}}
{{- if $.memcachedConfig.enabled }}
{{ $dict := dict "ctx" $.ctx "component" $.component }}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "tempo.resourceName" $dict }}
  namespace: {{ $.ctx.Release.Namespace }}
  labels:
    {{- include "tempo.labels" $dict | nindent 4 }}
  {{- with $.memcachedConfig.service.annotations }}
  annotations:
    {{- tpl (toYaml . | nindent 4) $.ctx }}
  {{- end }}
spec:
  ipFamilies: {{ $.ctx.Values.tempo.service.ipFamilies }}
  ipFamilyPolicy: {{ $.ctx.Values.tempo.service.ipFamilyPolicy }}
  ports:
  - name: memcached-client
    port: 11211
    targetPort: client
  - name: http-metrics
    port: 9150
    targetPort: http-metrics
  selector:
    {{- include "tempo.selectorLabels" $dict | nindent 4 }}
{{- end }}
{{- end -}}

{{/*
Render a PodDisruptionBudget for a per-role memcached cluster.
Params:
  ctx            = root context ($)
  memcachedConfig = per-role values section (e.g. .Values.memcachedBloom)
  component      = K8s component name (e.g. "memcached-bloom")
*/}}
{{- define "tempo.memcached.pdb" -}}
{{- if and $.memcachedConfig.enabled (gt (int $.memcachedConfig.replicas) 1) $.memcachedConfig.podDisruptionBudget.enabled }}
{{ $dict := dict "ctx" $.ctx "component" $.component }}
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ include "tempo.resourceName" $dict }}
  namespace: {{ $.ctx.Release.Namespace }}
  labels:
    {{- include "tempo.labels" $dict | nindent 4 }}
spec:
  selector:
    matchLabels:
      {{- include "tempo.selectorLabels" $dict | nindent 6 }}
  maxUnavailable: {{ $.memcachedConfig.maxUnavailable }}
{{- end }}
{{- end -}}
