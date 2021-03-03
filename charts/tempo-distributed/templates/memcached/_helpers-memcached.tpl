{{/*
memcached common labels
*/}}
{{- define "tempo.memcachedLabels" -}}
{{ include "tempo.labels" . }}
app.kubernetes.io/component: {{ include "tempo.name" . }}-memcached
{{- end }}

{{/*
memcached selector labels
*/}}
{{- define "tempo.memcachedSelectorLabels" -}}
{{ include "tempo.selectorLabels" . }}
app.kubernetes.io/component: {{ include "tempo.name" . }}-memcached
{{- end }}
