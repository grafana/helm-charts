{{/*
distributor fullname
*/}}
{{- define "enterprise-metrics.distributorFullname" -}}
{{ include "enterprise-metrics.fullname" . }}-distributor
{{- end }}

{{/*
distributor common labels
*/}}
{{- define "enterprise-metrics.distributorLabels" -}}
{{ include "enterprise-metrics.labels" . }}
app.kubernetes.io/component: distributor
target: distributor
{{- end }}

{{/*
distributor selector labels
*/}}
{{- define "enterprise-metrics.distributorSelectorLabels" -}}
{{ include "enterprise-metrics.selectorLabels" . }}
app.kubernetes.io/component: distributor
name: distributor
target: distributor
{{- end }}
