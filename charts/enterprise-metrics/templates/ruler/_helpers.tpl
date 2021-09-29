{{/*
ruler fullname
*/}}
{{- define "enterprise-metrics.rulerFullname" -}}
{{ include "enterprise-metrics.fullname" . }}-ruler
{{- end }}

{{/*
ruler common labels
*/}}
{{- define "enterprise-metrics.rulerLabels" -}}
{{ include "enterprise-metrics.labels" . }}
app.kubernetes.io/component: ruler
target: ruler
{{- end }}

{{/*
ruler selector labels
*/}}
{{- define "enterprise-metrics.rulerSelectorLabels" -}}
{{ include "enterprise-metrics.selectorLabels" . }}
app.kubernetes.io/component: ruler
name: ruler
target: ruler
{{- end }}
