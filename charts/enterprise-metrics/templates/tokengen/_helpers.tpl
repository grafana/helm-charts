{{/*
tokengen fullname
*/}}
{{- define "enterprise-metrics.tokengenFullname" -}}
{{ include "enterprise-metrics.fullname" . }}-tokengen
{{- end }}

{{/*
tokengen common labels
*/}}
{{- define "enterprise-metrics.tokengenLabels" -}}
{{ include "enterprise-metrics.labels" . }}
app.kubernetes.io/component: tokengen
target: tokengen
{{- end }}

{{/*
tokengen selector labels
*/}}
{{- define "enterprise-metrics.tokengenSelectorLabels" -}}
{{ include "enterprise-metrics.selectorLabels" . }}
app.kubernetes.io/component: tokengen
name: tokengen
target: tokengen
{{- end }}
