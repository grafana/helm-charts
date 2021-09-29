{{/*
compactor fullname
*/}}
{{- define "enterprise-metrics.compactorFullname" -}}
{{ include "enterprise-metrics.fullname" . }}-compactor
{{- end }}

{{/*
compactor common labels
*/}}
{{- define "enterprise-metrics.compactorLabels" -}}
{{ include "enterprise-metrics.labels" . }}
app.kubernetes.io/component: compactor
target: compactor
{{- end }}

{{/*
compactor selector labels
*/}}
{{- define "enterprise-metrics.compactorSelectorLabels" -}}
{{ include "enterprise-metrics.selectorLabels" . }}
app.kubernetes.io/component: compactor
name: compactor
target: compactor
{{- end }}
