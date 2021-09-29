{{/*
adminApi fullname
*/}}
{{- define "enterprise-metrics.adminApiFullname" -}}
{{ include "enterprise-metrics.fullname" . }}-admin-api
{{- end }}

{{/*
adminApi common labels
*/}}
{{- define "enterprise-metrics.adminApiLabels" -}}
{{ include "enterprise-metrics.labels" . }}
app.kubernetes.io/component: admin-api
target: admin-api
{{- end }}

{{/*
adminApi selector labels
*/}}
{{- define "enterprise-metrics.adminApiSelectorLabels" -}}
{{ include "enterprise-metrics.selectorLabels" . }}
app.kubernetes.io/component: admin-api
name: admin-api
target: admin-api
{{- end }}
