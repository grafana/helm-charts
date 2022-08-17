{{/*
compactor fullname
*/}}
{{- define "tempo.compactorFullname" -}}
{{ include "tempo.fullname" . }}-compactor
{{- end }}

{{/*
compactor image
*/}}
{{- define "tempo.compactorImage" -}}
{{- $dict := dict "tempo" .Values.tempo.image "service" .Values.compactor.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}
