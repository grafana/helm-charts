{{/*
ruler fullname
*/}}
{{- define "loki.rulerFullname" -}}
{{ include "loki.fullname" . }}-ruler
{{- end }}

{{/*
ruler common labels
*/}}
{{- define "loki.rulerLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: ruler
{{- end }}

{{/*
ruler selector labels
*/}}
{{- define "loki.rulerSelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: ruler
{{- end }}

{{/*
format rules dir
*/}}
{{- define "loki.rulerRulesDirName" -}}
rules-{{ . | replace "_" "-" | trimSuffix "-" | lower }}
{{- end }}
