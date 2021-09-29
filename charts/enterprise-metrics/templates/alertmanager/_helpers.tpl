{{/*
alertmanager fullname
*/}}
{{- define "enterprise-metrics.alertmanagerFullname" -}}
{{ include "enterprise-metrics.fullname" . }}-alertmanager
{{- end }}

{{/*
alertmanager common labels
*/}}
{{- define "enterprise-metrics.alertmanagerLabels" -}}
{{ include "enterprise-metrics.labels" . }}
app.kubernetes.io/component: alertmanager
target: alertmanager
{{- end }}

{{/*
alertmanager selector labels
*/}}
{{- define "enterprise-metrics.alertmanagerSelectorLabels" -}}
{{ include "enterprise-metrics.selectorLabels" . }}
app.kubernetes.io/component: alertmanager
name: alertmanager
target: alertmanager
{{- end }}
