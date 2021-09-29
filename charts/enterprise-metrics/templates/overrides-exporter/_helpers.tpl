{{/*
overrides-exporter fullname
*/}}
{{- define "enterprise-metrics.overridesExporterFullname" -}}
{{ include "enterprise-metrics.fullname" . }}-overrides-exporter
{{- end }}

{{/*
overrides-exporter common labels
*/}}
{{- define "enterprise-metrics.overridesExporterLabels" -}}
{{ include "enterprise-metrics.labels" . }}
app.kubernetes.io/component: overrides-exporter
target: overrides-exporter
{{- end }}

{{/*
overrides-exporter selector labels
*/}}
{{- define "enterprise-metrics.overridesExporterSelectorLabels" -}}
{{ include "enterprise-metrics.selectorLabels" . }}
app.kubernetes.io/component: overrides-exporter
name: overrides-exporter
target: overrides-exporter
{{- end }}
