{{/*
gateway fullname
*/}}
{{- define "tempo.gatewayFullname" -}}
{{ include "tempo.fullname" . }}-gateway
{{- end }}

{{/*
gateway common labels
*/}}
{{- define "tempo.gatewayLabels" -}}
{{ include "tempo.labels" . }}
app.kubernetes.io/component: gateway
{{- end }}

{{/*
gateway selector labels
*/}}
{{- define "tempo.gatewaySelectorLabels" -}}
{{ include "tempo.selectorLabels" . }}
app.kubernetes.io/component: gateway
{{- end }}

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
{{- $dict := dict "tempo" .Values.tempo.image "service" .Values.gateway.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}
