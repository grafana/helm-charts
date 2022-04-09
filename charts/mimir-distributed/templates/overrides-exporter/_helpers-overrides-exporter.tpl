{{/*
overrides-exporter fullname
*/}}
{{- define "mimir.overridesExporterFullname" -}}
{{ include "mimir.fullname" . }}-overrides-exporter
{{- end }}

{{/*
overrides-exporter common labels
*/}}
{{- define "mimir.overridesExporterLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-overrides-exporter
{{- else }}
app.kubernetes.io/component: overrides-exporter
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
overrides-exporter selector labels
*/}}
{{- define "mimir.overridesExporterSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-overrides-exporter
{{- else }}
app.kubernetes.io/component: overrides-exporter
{{- end }}
{{- end -}}

{{/*
GEM overrides-exporter Pod labels
*/}}
{{- define "mimir.gemOverridesExporterPodLabels" -}}
name: overrides-exporter
target: overrides-exporter
{{- end -}}
