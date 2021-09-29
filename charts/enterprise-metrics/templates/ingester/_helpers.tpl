{{/*
ingester fullname
*/}}
{{- define "enterprise-metrics.ingesterFullname" -}}
{{ include "enterprise-metrics.fullname" . }}-ingester
{{- end }}

{{/*
ingester common labels
*/}}
{{- define "enterprise-metrics.ingesterLabels" -}}
{{ include "enterprise-metrics.labels" . }}
app.kubernetes.io/component: ingester
target: ingester
{{- end }}

{{/*
ingester selector labels
*/}}
{{- define "enterprise-metrics.ingesterSelectorLabels" -}}
{{ include "enterprise-metrics.selectorLabels" . }}
app.kubernetes.io/component: ingester
name: ingester
target: ingester
{{- end }}
