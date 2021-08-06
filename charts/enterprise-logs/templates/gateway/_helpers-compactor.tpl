{{/*
gateway fullname
*/}}
{{- define "gel.gatewayFullname" -}}
{{ include "gel.fullname" . }}-gateway
{{- end }}

{{/*
gateway common labels
*/}}
{{- define "gel.gatewayLabels" -}}
{{ include "gel.labels" . }}
app.kubernetes.io/component: gateway
{{- end }}

{{/*
gateway selector labels
*/}}
{{- define "gel.gatewaySelectorLabels" -}}
{{ include "gel.selectorLabels" . }}
app.kubernetes.io/component: gateway
{{- end }}