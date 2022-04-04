{{/*
gossip-ring fullname
*/}}
{{- define "mimir.gossipRingFullname" -}}
{{ include "mimir.fullname" . }}-gossip-ring
{{- end }}

{{/*
gossip-ring common labels
*/}}
{{- define "mimir.gossipRingLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-gossip-ring
{{- else }}
app.kubernetes.io/component: gossip-ring
{{- end }}
{{- end -}}

{{/*
gossip-ring selector labels
*/}}
{{- define "mimir.gossipRingSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
gossip_ring_member: "true"
{{- else }}
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}
