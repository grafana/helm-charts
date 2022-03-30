{{/*
compactor fullname
*/}}
{{- define "mimir.compactorFullname" -}}
{{ include "mimir.fullname" . }}-compactor
{{- end }}

{{/*
compactor common labels
*/}}
{{- define "mimir.compactorLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-compactor
{{- else }}
app.kubernetes.io/component: compactor
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
compactor selector labels
*/}}
{{- define "mimir.compactorSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-compactor
{{- else }}
app.kubernetes.io/component: compactor
{{- end }}
{{- end -}}

{{/*
GEM compactor Pod labels
*/}}
{{- define "mimir.gemCompactorPodLabels" -}}
name: compactor
target: compactor
gossip_ring_member: "true"
{{- end -}}
