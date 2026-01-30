{{/*
enterpriseGateway imagePullSecrets
*/}}
{{- define "tempo.enterpriseGatewayImagePullSecrets" -}}
{{- $dict := dict "tempo" .Values.tempo.image "component" .Values.enterpriseGateway.image "global" .Values.global.image -}}
{{- include "tempo.imagePullSecrets" $dict -}}
{{- end }}
