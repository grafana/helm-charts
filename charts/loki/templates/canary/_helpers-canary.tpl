{{/*
Common canary labels
*/}}
{{- define "loki.canaryFullname" -}}
{{ include "loki.fullname" . }}-canary
{{- end }}

{{/*
Common canary labels
*/}}
{{- define "loki.canaryLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: canary
{{- end }}

{{/*
Selector canary labels
*/}}
{{- define "loki.canarySelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: canary
{{- end }}
