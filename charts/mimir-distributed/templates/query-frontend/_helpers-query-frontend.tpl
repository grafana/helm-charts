{{/*
query-frontend fullname
*/}}
{{- define "mimir.queryFrontendFullname" -}}
{{ include "mimir.fullname" . }}-query-frontend
{{- end }}

{{/*
query-frontend common labels
*/}}
{{- define "mimir.queryFrontendLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-query-frontend
{{- else }}
app.kubernetes.io/component: query-frontend
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
query-frontend selector labels
*/}}
{{- define "mimir.queryFrontendSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-query-frontend
{{- else }}
app.kubernetes.io/component: query-frontend
{{- end }}
{{- end -}}

{{/*
GEM query-frontend Pod labels
*/}}
{{- define "mimir.gemQueryFrontendPodLabels" -}}
name: query-frontend
target: query-frontend
{{- end -}}
