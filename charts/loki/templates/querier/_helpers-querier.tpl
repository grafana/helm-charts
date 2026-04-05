{{/*
querier fullname
*/}}
{{- define "loki.querierFullname" -}}
{{ include "loki.fullname" . }}-querier
{{- end }}

{{/*
querier common labels
*/}}
{{- define "loki.querierLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: querier
{{- end }}

{{/*
querier selector labels
*/}}
{{- define "loki.querierSelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: querier
{{- end }}
