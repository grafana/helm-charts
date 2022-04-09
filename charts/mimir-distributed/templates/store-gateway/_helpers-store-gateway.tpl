{{/*
store-gateway fullname
*/}}
{{- define "mimir.storeGatewayFullname" -}}
{{ include "mimir.fullname" . }}-store-gateway
{{- end }}

{{/*
store-gateway common labels
*/}}
{{- define "mimir.storeGatewayLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-store-gateway
{{- else }}
app.kubernetes.io/component: store-gateway
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
store-gateway selector labels
*/}}
{{- define "mimir.storeGatewaySelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-store-gateway
{{- else }}
app.kubernetes.io/component: store-gateway
{{- end }}
{{- end -}}

{{/*
GEM store-gateway Pod labels
*/}}
{{- define "mimir.gemStoreGatewayPodLabels" -}}
name: store-gateway
target: store-gateway
gossip_ring_member: "true"
{{- end -}}
