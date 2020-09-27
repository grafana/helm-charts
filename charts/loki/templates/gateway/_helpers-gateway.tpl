{{/*
Common gateway labels
*/}}
{{- define "loki.gatewayFullname" -}}
{{ include "loki.fullname" . }}-gateway
{{- end }}

{{/*
Common gateway labels
*/}}
{{- define "loki.gatewayLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: gateway
{{- end }}

{{/*
Selector gateway labels
*/}}
{{- define "loki.gatewaySelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: gateway
{{- end }}

{{/*
Auth secret name
*/}}
{{- define "loki.gatewayAuthSecret" -}}
{{ .Values.gateway.basicauth.existingSecret | default (include "loki.gatewayFullname" . ) }}
{{- end }}
