{{/*
query image
*/}}
{{- define "tempo.queryImage" -}}
{{- $dict := dict "tempo" .Values.tempo.image "component" .Values.queryFrontend.query.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}
