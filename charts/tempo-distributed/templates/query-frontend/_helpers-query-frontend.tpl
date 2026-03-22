{{/*
query image
*/}}
{{- define "tempo.queryImage" -}}
{{- $dict := dict "tempo" .Values.tempo.image "component" .Values.queryFrontend.query.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}

{{/*
query sidecar imagePullSecrets (uses queryFrontend.query.image, not the standard component image path)
*/}}
{{- define "tempo.queryImagePullSecrets" -}}
{{- $dict := dict "tempo" .Values.tempo.image "component" .Values.queryFrontend.query.image "global" .Values.global.image -}}
{{- include "tempo.imagePullSecrets" $dict -}}
{{- end }}
