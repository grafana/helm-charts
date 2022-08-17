{{/*
gossip-ring selector labels
*/}}
{{- define "tempo.gossipRingSelectorLabels" -}}
{{ include "tempo.selectorLabels" . }}
{{- if .ctx.Values.enterprise.legacyLabels }}
tempo-gossip-member: "true"
{{- else }}
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

