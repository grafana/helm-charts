{{/*
federationFrontend imagePullSecrets
*/}}
{{- define "tempo.federationFrontendImagePullSecrets" -}}
{{- $dict := dict "tempo" .Values.tempo.image "component" .Values.federationFrontend.image "global" .Values.global.image -}}
{{- include "tempo.imagePullSecrets" $dict -}}
{{- end }}
