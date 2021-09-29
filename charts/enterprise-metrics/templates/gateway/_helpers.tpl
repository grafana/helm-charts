{{/*
gateway fullname
*/}}
{{- define "enterprise-metrics.gatewayFullname" -}}
{{ include "enterprise-metrics.fullname" . }}-gateway
{{- end }}

{{/*
gateway common labels
*/}}
{{- define "enterprise-metrics.gatewayLabels" -}}
{{ include "enterprise-metrics.labels" . }}
app.kubernetes.io/component: gateway
target: gateway
{{- end }}

{{/*
gateway selector labels
*/}}
{{- define "enterprise-metrics.gatewaySelectorLabels" -}}
{{ include "enterprise-metrics.selectorLabels" . }}
app.kubernetes.io/component: gateway
name: gateway
target: gateway
{{- end }}
