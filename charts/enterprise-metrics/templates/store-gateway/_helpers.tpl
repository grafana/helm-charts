{{/*
storeGateway fullname
*/}}
{{- define "enterprise-metrics.storeGatewayFullname" -}}
{{ include "enterprise-metrics.fullname" . }}-store-gateway
{{- end }}

{{/*
storeGateway common labels
*/}}
{{- define "enterprise-metrics.storeGatewayLabels" -}}
{{ include "enterprise-metrics.labels" . }}
app.kubernetes.io/component: store-gateway
target: store-gateway
{{- end }}

{{/*
storeGateway selector labels
*/}}
{{- define "enterprise-metrics.storeGatewaySelectorLabels" -}}
{{ include "enterprise-metrics.selectorLabels" . }}
app.kubernetes.io/component: store-gateway
name: store-gateway
target: store-gateway
{{- end }}
