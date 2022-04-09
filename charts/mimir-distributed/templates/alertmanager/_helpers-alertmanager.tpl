{{/*
Alertmanager fullname
*/}}
{{- define "mimir.alertmanagerFullname" -}}
{{ include "mimir.fullname" . }}-alertmanager
{{- end }}

{{/*
Alertmanager common labels
*/}}
{{- define "mimir.alertmanagerLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-alertmanager
{{- else }}
app.kubernetes.io/component: alertmanager
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
Alertmanager selector labels
*/}}
{{- define "mimir.alertmanagerSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-alertmanager
{{- else }}
app.kubernetes.io/component: alertmanager
{{- end }}
{{- end -}}

{{/*
GEM Alertmanager Pod labels
*/}}
{{- define "mimir.gemAlertmanagerPodLabels" -}}
name: alertmanager
gossip_ring_member: "true"
target: alertmanager
{{- end -}}