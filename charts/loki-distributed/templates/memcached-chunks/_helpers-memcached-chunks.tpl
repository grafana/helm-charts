{{/*
memcached-chunks fullname
*/}}
{{- define "loki.memcachedChunksFullname" -}}
{{ include "loki.fullname" . }}-memcached-chunks
{{- end }}

{{/*
memcached-chunks fullname
*/}}
{{- define "loki.memcachedChunksLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: memcached-chunks
{{- end }}

{{/*
memcached-chunks selector labels
*/}}
{{- define "loki.memcachedChunksSelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: memcached-chunks
{{- end }}
