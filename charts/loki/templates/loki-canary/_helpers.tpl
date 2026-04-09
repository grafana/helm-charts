{{/*
canary fullname
*/}}
{{- define "loki-canary.fullname" -}}
{{ include "loki.name" . }}-canary
{{- end }}

{{/*
canary common labels
*/}}
{{- define "loki-canary.labels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: canary
{{- end }}

{{/*
canary selector labels
*/}}
{{- define "loki-canary.selectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: canary
{{- end }}

{{/*
canary pod args
*/}}
{{- define "loki-canary.args" -}}
- -addr={{- default (include "loki.host" $) .Values.lokiCanary.lokiurl }}
- -labelname={{ .Values.lokiCanary.labelname }}
- -labelvalue=$(POD_NAME)
{{- if $.Values.loki.auth_enabled }}
- -user={{ dig "selfMonitoring" "tenant" "name" .Values.lokiCanary.tenant.name .Values.monitoring }}
- -tenant-id={{ dig "selfMonitoring" "tenant" "name" .Values.lokiCanary.tenant.name .Values.monitoring }}
- -pass={{ dig "selfMonitoring" "tenant" "password" .Values.lokiCanary.tenant.password .Values.monitoring }}
{{- end }}
- -push={{ $.Values.lokiCanary.push }}
{{- end }}
