{{/*
memcached fullname
*/}}
{{- define "tempo.memcachedFullname" -}}
{{ include "tempo.fullname" . }}-memcached
{{- end }}

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

{{/*
memcached image
*/}}
{{- define "tempo.memcachedImage" -}}
{{- $dict := dict "service" .Values.memcached.image "global" .Values.global.image "tempo" (dict) -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}

{{/*
memcachedExporter image
*/}}
{{- define "tempo.memcachedExporterImage" -}}
{{- $dict := dict "service" .Values.memcachedExporter.image "global" .Values.global.image "tempo" (dict) -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}
