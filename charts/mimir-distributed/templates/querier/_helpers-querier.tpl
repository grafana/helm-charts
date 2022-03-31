{{/*
querier fullname
*/}}
{{- define "mimir.querierFullname" -}}
{{ include "mimir.fullname" . }}-querier
{{- end }}

{{/*
querier common labels
*/}}
{{- define "mimir.querierLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-querier
{{- else }}
app.kubernetes.io/component: querier
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
querier selector labels
*/}}
{{- define "mimir.querierSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-querier
{{- else }}
app.kubernetes.io/component: querier
{{- end }}
{{- end -}}

{{/*
GEM querier Pod labels
*/}}
{{- define "mimir.gemQuerierPodLabels" -}}
name: querier
target: querier
{{- end -}}
