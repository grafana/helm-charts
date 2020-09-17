{{/*
Common table-manager labels
*/}}
{{- define "loki.tableManagerFullname" -}}
{{ include "loki.fullname" . }}-table-manager
{{- end }}

{{/*
Common table-manager labels
*/}}
{{- define "loki.tableManagerLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: table-manager
{{- end }}

{{/*
Selector table-manager labels
*/}}
{{- define "loki.tableManagerSelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: table-manager
{{- end }}
