{{/*
queryFrontend fullname
*/}}
{{- define "enterprise-metrics.queryFrontendFullname" -}}
{{ include "enterprise-metrics.fullname" . }}-query-frontend
{{- end }}

{{/*
queryFrontend common labels
*/}}
{{- define "enterprise-metrics.queryFrontendLabels" -}}
{{ include "enterprise-metrics.labels" . }}
app.kubernetes.io/component: query-frontend
target: query-frontend
{{- end }}

{{/*
queryFrontend selector labels
*/}}
{{- define "enterprise-metrics.queryFrontendSelectorLabels" -}}
{{ include "enterprise-metrics.selectorLabels" . }}
app.kubernetes.io/component: query-frontend
name: query-frontend
target: query-frontend
{{- end }}
