{{/*
ingester fullname
*/}}
{{- define "mimir.ingesterFullname" -}}
{{ include "mimir.fullname" . }}-ingester
{{- end }}

{{/*
ingester common labels
*/}}
{{- define "mimir.ingesterLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-ingester
{{- else }}
app.kubernetes.io/component: ingester
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
ingester selector labels
*/}}
{{- define "mimir.ingesterSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-ingester
{{- else }}
app.kubernetes.io/component: ingester
{{- end }}
{{- end -}}

{{/*
GEM ingester Pod labels
*/}}
{{- define "mimir.gemIngesterPodLabels" -}}
name: ingester
target: ingester
gossip_ring_member: "true"
{{- end -}}
