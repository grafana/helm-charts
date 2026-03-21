{{/*
Service helper
*/}}

{{- define "loki.service" }}
{{- $target := .target }}
{{- $ctx := .ctx }}
{{- $component := .component }}
{{- $name := .name }}
{{- $headlessName := .headlessName }}
{{- with $ctx }}
apiVersion: v1
kind: Service
metadata:
  {{- if $name }}
  name: {{ $name }}
  {{- else }}
  name: "{{ include "loki.fullname" . }}-{{ $target }}"
  {{- end }}
  namespace: "{{ include "loki.namespace" . }}"
  labels:
    {{- include "loki.labels" . | nindent 4 }}
    app.kubernetes.io/component: {{ $target | quote }}
    {{- with (mergeOverwrite (dict) .Values.defaults.service.labels ($component.serviceLabels | default dict) $component.service.labels) }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- with (mergeOverwrite (dict) .Values.loki.serviceAnnotations .Values.defaults.service.annotations ($component.serviceAnnotations | default dict) $component.service.annotations) }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  type: {{ $component.serviceType | default $component.service.type | default "ClusterIP" }}
  publishNotReadyAddresses: true
  ports:
    - name: http-metrics
      port: 3100
      targetPort: http-metrics
      protocol: TCP
    - name: grpc
      port: 9095
      targetPort: grpc
      protocol: TCP
      {{- with (dig "appProtocol" "grpc" $component.service.appProtocol.grpc $component) }}
      appProtocol: {{ . }}
      {{- end }}
    - name: grpclb
      port: 9096
      targetPort: grpc
      protocol: TCP
      {{- with (dig "appProtocol" "grpc" $component.service.appProtocol.grpc $component) }}
      appProtocol: {{ . }}
      {{- end }}
  selector:
    {{ include "loki.selectorLabels" . | nindent 4 }}
    app.kubernetes.io/component: {{ $target | quote }}
{{- with (coalesce $component.trafficDistribution $component.service.trafficDistribution .Values.defaults.service.trafficDistribution .Values.loki.service.trafficDistribution) }}
  trafficDistribution: {{ . }}
{{- end }}
{{- with $component.service.sessionAffinity }}
  sessionAffinity: {{ . }}
{{- end }}
{{- with $component.service.sessionAffinityConfig }}
  sessionAffinityConfig:
    {{- toYaml . | nindent 4 }}
{{- end }}
---
apiVersion: v1
kind: Service
metadata:
  {{ if $headlessName }}
  name: {{ $headlessName }}
  {{ else }}
  name: "{{ include "loki.fullname" . }}-{{ $target }}-headless"
  {{- end }}
  namespace: {{ include "loki.namespace" . }}
  labels:
    {{- include "loki.labels" . | nindent 4 }}
    app.kubernetes.io/component: {{ $target | quote }}
    prometheus.io/service-monitor: "false"
    variant: headless
    {{- with (mergeOverwrite (dict) .Values.defaults.service.labels ($component.serviceLabels | default dict) $component.service.labels) }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- with (mergeOverwrite (dict) .Values.loki.serviceAnnotations .Values.defaults.service.annotations ($component.serviceAnnotations | default dict) $component.service.annotations) }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  clusterIP: None
  type: ClusterIP
  publishNotReadyAddresses: true
  ports:
    - name: http-metrics
      port: 3100
      targetPort: http-metrics
      protocol: TCP
    - name: grpc
      port: 9095
      targetPort: grpc
      protocol: TCP
      {{- with (dig "appProtocol" "grpc" $component.service.appProtocol.grpc $component) }}
      appProtocol: {{ . }}
      {{- end }}
    - name: grpclb
      port: 9096
      targetPort: grpc
      protocol: TCP
      {{- with (dig "appProtocol" "grpc" $component.service.appProtocol.grpc $component) }}
      appProtocol: {{ . }}
      {{- end }}
  selector:
    {{ include "loki.selectorLabels" . | nindent 4 }}
    app.kubernetes.io/component: {{ $target | quote }}
{{- end }}
{{- end }}
