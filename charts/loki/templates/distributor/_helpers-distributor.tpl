{{/*
Common distributor labels
*/}}
{{- define "loki.distributorFullname" -}}
{{ include "loki.fullname" . }}-distributor
{{- end }}

{{/*
Common distributor labels
*/}}
{{- define "loki.distributorLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: distributor
{{- end }}

{{/*
Selector distributor labels
*/}}
{{- define "loki.distributorSelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: distributor
{{- end }}
