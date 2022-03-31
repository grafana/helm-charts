{{/*
tokengen fullname
*/}}
{{- define "mimir.tokengenFullname" -}}
{{ include "mimir.fullname" . }}-tokengen
{{- end }}

{{/*
tokengen common labels
*/}}
{{- define "mimir.tokengenJobLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-tokengen
{{- else }}
app.kubernetes.io/component: tokengen
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
tokengen selector labels
*/}}
{{- define "mimir.tokengenJobSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-tokengen
{{- else }}
app.kubernetes.io/component: tokengen
{{- end }}
{{- end -}}

{{/*
GEM tokengen Pod labels
*/}}
{{- define "mimir.gemTokengenJobPodLabels" -}}
name: tokengen
target: tokengen
{{- end -}}
