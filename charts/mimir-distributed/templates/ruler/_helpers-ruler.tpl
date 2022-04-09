{{/*
ruler fullname
*/}}
{{- define "mimir.rulerFullname" -}}
{{ include "mimir.fullname" . }}-ruler
{{- end }}

{{/*
ruler common labels
*/}}
{{- define "mimir.rulerLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-ruler
{{- else }}
app.kubernetes.io/component: ruler
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
ruler selector labels
*/}}
{{- define "mimir.rulerSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-ruler
{{- else }}
app.kubernetes.io/component: ruler
{{- end }}
{{- end -}}

{{/*
GEM ruler Pod labels
*/}}
{{- define "mimir.gemRulerPodLabels" -}}
name: ruler
target: ruler
gossip_ring_member: "true"
{{- end -}}
