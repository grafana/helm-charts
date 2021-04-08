{{/*
memcached common labels
*/}}
{{- define "tempo.memcachedLabels" -}}
{{ include "tempo.labels" . }}
app.kubernetes.io/component: memcached
{{- end }}

{{/*
memcached selector labels
*/}}
{{- define "tempo.memcachedSelectorLabels" -}}
{{ include "tempo.selectorLabels" . }}
app.kubernetes.io/component: memcached
{{- end }}
