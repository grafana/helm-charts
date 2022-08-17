{{/*
distributor fullname
*/}}
{{- define "tempo.distributorFullname" -}}
{{ include "tempo.fullname" . }}-distributor
{{- end }}

{{/*
distributor image
*/}}
{{- define "tempo.distributorImage" -}}
{{- $dict := dict "tempo" .Values.tempo.image "service" .Values.distributor.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}
