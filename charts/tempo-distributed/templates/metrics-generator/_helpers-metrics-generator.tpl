{{/*
metrics-generator fullname
*/}}
{{- define "tempo.metricsGeneratorFullname" -}}
{{ include "tempo.fullname" . }}-metrics-generator
{{- end }}

{{/*
metrics-generator image
*/}}
{{- define "tempo.metricsGeneratorImage" -}}
{{- $dict := dict "tempo" .Values.tempo.image "service" .Values.metricsGenerator.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}
