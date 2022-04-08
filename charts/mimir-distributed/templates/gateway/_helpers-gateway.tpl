{{/*
gateway fullname
*/}}
{{- define "mimir.gatewayFullname" -}}
{{ include "mimir.fullname" . }}-gateway
{{- end }}

{{/*
gateway common labels
*/}}
{{- define "mimir.gatewayLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-gateway
{{- else }}
app.kubernetes.io/component: gateway
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
gateway selector labels
*/}}
{{- define "mimir.gatewaySelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-gateway
{{- else }}
app.kubernetes.io/component: gateway
{{- end }}
{{- end -}}

{{/*
GEM gateway Pod labels
*/}}
{{- define "mimir.gemGatewayPodLabels" -}}
name: gateway
target: gateway
{{- end -}}
