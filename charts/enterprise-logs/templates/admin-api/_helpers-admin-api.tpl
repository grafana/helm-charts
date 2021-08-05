{{/*
admin-api fullname
*/}}
{{- define "gel.adminApiFullname" -}}
{{ include "gel.fullname" . }}-admin-api
{{- end }}

{{/*
admin-api common labels
*/}}
{{- define "gel.adminApiLabels" -}}
{{ include "gel.labels" . }}
app.kubernetes.io/component: admin-api
{{- end }}

{{/*
admin-api selector labels
*/}}
{{- define "gel.adminApiSelectorLabels" -}}
{{ include "gel.selectorLabels" . }}
app.kubernetes.io/component: admin-api
{{- end }}
