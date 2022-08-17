{{/*
ingester fullname
*/}}
{{- define "tempo.ingesterFullname" -}}
{{ include "tempo.fullname" . }}-ingester
{{- end }}

{{/*
ingester image
*/}}
{{- define "tempo.ingesterImage" -}}
{{- $dict := dict "tempo" .Values.tempo.image "service" .Values.ingester.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}
