{{/*
Return the appropriate apiVersion for Gateway API resources.
*/}}
{{- define "tempo.gatewayApi.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "gateway.networking.k8s.io/v1" }}
{{- print "gateway.networking.k8s.io/v1" }}
{{- else if .Capabilities.APIVersions.Has "gateway.networking.k8s.io/v1beta1" }}
{{- print "gateway.networking.k8s.io/v1beta1" }}
{{- else }}
{{- print "gateway.networking.k8s.io/v1" }}
{{- end }}
{{- end }}

{{/*
Gateway API route resource.
Params:
  ctx       = root context (.)
  route     = route values (e.g. .Values.route.main, .Values.gateway.route.main)
  component = component name for labels (e.g. "gateway", "query-frontend")
  name      = optional override for resource name (defaults to tempo.resourceName)
  serviceName = backend service name (single-service mode, omit for multi-service paths mode)
  servicePort = backend service port (single-service mode)
*/}}
{{- define "tempo.route" -}}
{{- $route := .route -}}
{{- $ctx := .ctx -}}
{{- $component := .component -}}
{{- $dict := dict "ctx" $ctx "component" $component -}}
apiVersion: {{ $route.apiVersion | default (include "tempo.gatewayApi.apiVersion" $ctx) }}
kind: {{ $route.kind | default "HTTPRoute" }}
metadata:
  name: {{ .name | default (include "tempo.resourceName" $dict) }}
  namespace: {{ $ctx.Release.Namespace }}
  labels:
    {{- include "tempo.labels" $dict | nindent 4 }}
    {{- with $route.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with $route.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- with $route.parentRefs }}
  parentRefs:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $route.hostnames }}
  hostnames:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  rules:
    {{- if $route.paths }}
    {{- range $svcName, $paths := $route.paths }}
    {{- range $paths }}
    - matches:
        - path:
            type: {{ .pathType | default "PathPrefix" }}
            value: {{ .path }}
      backendRefs:
        - name: {{ include "tempo.fullname" $ctx }}-{{ $svcName }}
          port: {{ .port | default (include "tempo.serverHttpListenPort" $ctx | trim | int) }}
    {{- end }}
    {{- end }}
    {{- else }}
    {{- with $route.additionalRules }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
    - backendRefs:
        - name: {{ .serviceName }}
          port: {{ .servicePort }}
      {{- with $route.filters }}
      filters:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $route.matches }}
      matches:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $route.timeouts }}
      timeouts:
        {{- toYaml . | nindent 8 }}
      {{- end }}
    {{- end }}
{{- end -}}
