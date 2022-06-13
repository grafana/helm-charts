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
{{- define "tempo.mamcachedImage" -}}
{{- $dict := dict "tempo" .Values.tempo.image "service" .Values.memcached.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}

{{/*
memcachedExporter image
*/}}
{{- define "tempo.mamcachedExporterImage" -}}
{{- $dict := dict "tempo" .Values.tempo.image "service" .Values.memcachedExporter.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}
