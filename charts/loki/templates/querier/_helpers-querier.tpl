{{/*
Common querier labels
*/}}
{{- define "loki.querierFullname" -}}
{{ include "loki.fullname" . }}-querier
{{- end }}

{{/*
Common querier labels
*/}}
{{- define "loki.querierLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: querier
{{- end }}

{{/*
Selector querier labels
*/}}
{{- define "loki.querierSelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: querier
{{- end }}
