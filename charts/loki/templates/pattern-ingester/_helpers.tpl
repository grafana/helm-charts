{{/*
pattern ingester fullname
*/}}
{{- define "loki.patternIngesterFullname" -}}
{{ include "loki.fullname" . }}-pattern-ingester
{{- end }}

{{/*
pattern ingester common labels
*/}}
{{- define "loki.patternIngesterLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: pattern-ingester
{{- end }}

{{/*
pattern ingester selector labels
*/}}
{{- define "loki.patternIngesterSelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: pattern-ingester
{{- end }}
