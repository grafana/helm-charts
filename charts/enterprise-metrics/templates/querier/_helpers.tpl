{{/*
querier fullname
*/}}
{{- define "enterprise-metrics.querierFullname" -}}
{{ include "enterprise-metrics.fullname" . }}-querier
{{- end }}

{{/*
querier common labels
*/}}
{{- define "enterprise-metrics.querierLabels" -}}
{{ include "enterprise-metrics.labels" . }}
app.kubernetes.io/component: querier
target: querier
{{- end }}

{{/*
querier selector labels
*/}}
{{- define "enterprise-metrics.querierSelectorLabels" -}}
{{ include "enterprise-metrics.selectorLabels" . }}
app.kubernetes.io/component: querier
name: querier
target: querier
{{- end }}
