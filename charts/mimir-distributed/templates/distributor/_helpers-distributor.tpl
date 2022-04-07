{{/*
distributor fullname
*/}}
{{- define "mimir.distributorFullname" -}}
{{ include "mimir.fullname" . }}-distributor
{{- end }}

{{/*
distributor common labels
*/}}
{{- define "mimir.distributorLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-distributor
{{- else }}
app.kubernetes.io/component: distributor
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
distributor selector labels
*/}}
{{- define "mimir.distributorSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-distributor
{{- else }}
app.kubernetes.io/component: distributor
{{- end }}
{{- end -}}

{{/*
GEM distributor Pod labels
*/}}
{{- define "mimir.gemDistributorPodLabels" -}}
name: distributor
target: distributor
gossip_ring_member: "true"
{{- end -}}
