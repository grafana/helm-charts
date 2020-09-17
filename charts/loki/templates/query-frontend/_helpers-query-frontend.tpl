{{/*
Common query-frontend labels
*/}}
{{- define "loki.queryFrontendFullname" -}}
{{ include "loki.fullname" . }}-query-frontend
{{- end }}

{{/*
Common query-frontend labels
*/}}
{{- define "loki.queryFrontendLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: query-frontend
{{- end }}

{{/*
Selector query-frontend labels
*/}}
{{- define "loki.queryFrontendSelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: query-frontend
{{- end }}
