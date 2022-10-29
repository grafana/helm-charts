{{/*
gateway auth secret name
*/}}
{{- define "tempo.gatewayAuthSecret" -}}
{{ .Values.gateway.basicAuth.existingSecret | default (include "tempo.gatewayFullname" . ) }}
{{- end }}


{{/*
gateway image
*/}}
{{- define "tempo.gatewayImage" -}}
{{- $dict := dict "tempo" (dict) "service" .Values.gateway.image "global" .Values.global.image -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}
