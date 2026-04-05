{{/*
HPA helper
*/}}

{{- define "loki.hpa" }}
{{- if .component.autoscaling.enabled }}
  {{- $target := .target }}
  {{- $kind := .component.kind | default .kind | default "StatefulSet" }}
  {{- $ctx := .ctx }}
  {{- $component := .component }}
  {{- $suffix := .suffix | default "" }}
  {{- with $ctx }}
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "loki.resourceName" (dict "ctx" . "component" $target "suffix" $suffix) }}
  namespace: {{ include "loki.namespace" . }}
  labels:
    {{- include "loki.labels" . | nindent 4 }}
    app.kubernetes.io/component: {{ $target }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: {{ $kind }}
    name: {{ include "loki.resourceName" (dict "ctx" . "component" $target "suffix" $suffix) }}
  minReplicas: {{ $component.autoscaling.minReplicas }}
  maxReplicas: {{ $component.autoscaling.maxReplicas }}
  {{- if hasKey ($component.autoscaling.behavior | default dict) "enabled" }}
  {{- if $component.autoscaling.behavior.enabled }}
  behavior:
    {{- with $component.autoscaling.behavior.scaleDown }}
    scaleDown: {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $component.autoscaling.behavior.scaleUp }}
    scaleUp: {{- toYaml . | nindent 6 }}
    {{- end }}
  {{- end }}
  {{- else }}
  {{- with $component.autoscaling.behavior }}
  behavior:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- end }}
  metrics:
  {{- with $component.autoscaling.targetMemoryUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: {{ . }}
  {{- end }}
  {{- with $component.autoscaling.targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {{ . }}
  {{- end }}
  {{- with $component.autoscaling.customMetrics }}
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- end }}
{{- end }}
{{- end }}
