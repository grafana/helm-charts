{{/*
admin-api fullname
*/}}
{{- define "mimir.adminApiFullname" -}}
{{ include "mimir.fullname" . }}-admin-api
{{- end }}

{{/*
admin-api common labels
*/}}
{{- define "mimir.adminApiLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-admin-api
{{- else }}
app.kubernetes.io/component: admin-api
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
admin-api selector labels
*/}}
{{- define "mimir.adminApiSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-admin-api
{{- else }}
app.kubernetes.io/component: admin-api
{{- end }}
{{- end -}}

{{/*
GEM admin-api Pod labels
*/}}
{{- define "mimir.gemAdminApiPodLabels" -}}
name: admin-api
target: admin-api
gossip_ring_member: "true"
{{- end -}}
