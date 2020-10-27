{{/*
compactor fullname
*/}}
{{- define "loki.compactorFullname" -}}
{{ include "loki.fullname" . }}-compactor
{{- end }}

{{/*
compactor common labels
*/}}
{{- define "loki.compactorLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: compactor
{{- end }}

{{/*
compactor selector labels
*/}}
{{- define "loki.compactorSelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: compactor
{{- end }}
