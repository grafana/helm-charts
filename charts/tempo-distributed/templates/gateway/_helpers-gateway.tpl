{{/*
gateway auth secret name
*/}}
{{- define "tempo.gatewayAuthSecret" -}}
{{ .Values.gateway.basicAuth.existingSecret | default (include "tempo.resourceName" (dict "ctx" . "component" "gateway")) }}
{{- end }}


{{/*
gateway image
*/}}
{{- define "tempo.gatewayImage" -}}
{{- $dict := dict "tempo" (dict) "service" .Values.gateway.image "global" .Values.global.image -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}
