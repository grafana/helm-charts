{{/*
KEDA ScaledObject helper
*/}}

{{/*
Validate that HPA and KEDA autoscaling are not both enabled for a component.
Params: .component (values object), .name (string for error message)
*/}}
{{- define "loki.validateAutoscaling" -}}
{{- if and (dig "kedaAutoscaling" "enabled" false .component) (dig "autoscaling" "enabled" false .component) }}
{{- fail (printf "Cannot enable both HPA and Keda based autoscaling for %s at the same time." .name) }}
{{- end }}
{{- end -}}

{{- define "loki.keda" }}
{{- if .component.kedaAutoscaling.enabled }}
  {{- $target := .target }}
  {{- $kind := .component.kind | default .kind | default "StatefulSet" }}
  {{- $ctx := .ctx }}
  {{- $component := .component }}
  {{- $suffix := .suffix | default "" }}
  {{- with $ctx }}
---
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
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
  minReplicaCount: {{ $component.kedaAutoscaling.minReplicas }}
  maxReplicaCount: {{ $component.kedaAutoscaling.maxReplicas }}
  pollingInterval: {{ coalesce $component.kedaAutoscaling.pollingInterval .Values.defaults.kedaAutoscaling.pollingInterval }}
  {{- if kindIs "int" $component.kedaAutoscaling.cooldownPeriod }}
  cooldownPeriod: {{ $component.kedaAutoscaling.cooldownPeriod }}
  {{- else }}
  cooldownPeriod: {{ .Values.defaults.kedaAutoscaling.cooldownPeriod }}
  {{- end }}
  {{- with $component.kedaAutoscaling.fallback }}
  fallback:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $component.kedaAutoscaling.behavior }}
  advanced:
    horizontalPodAutoscalerConfig:
      behavior:
        {{- toYaml . | nindent 8 }}
  {{- end }}
  triggers:
    {{- tpl ($component.kedaAutoscaling.triggers | toYaml) . | nindent 4 }}
  {{- end }}
{{- end }}
{{- end }}
