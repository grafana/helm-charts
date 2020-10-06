{{/*
canary fullname
*/}}
{{- define "loki.canaryFullname" -}}
{{ include "loki.fullname" . }}-canary
{{- end }}

{{/*
canary common labels
*/}}
{{- define "loki.canaryLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: canary
{{- end }}

{{/*
canary selector labels
*/}}
{{- define "loki.canarySelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: canary
{{- end }}
