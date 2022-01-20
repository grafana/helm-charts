{{/*
read fullname
*/}}
{{- define "loki.readFullname" -}}
{{ include "loki.fullname" . }}-read
{{- end }}

{{/*
read common labels
*/}}
{{- define "loki.readLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: read
{{- end }}

{{/*
read selector labels
*/}}
{{- define "loki.readSelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: read
{{- end }}

{{/*
read image
*/}}
{{- define "loki.readImage" -}}
{{- $dict := dict "loki" .Values.loki.image "service" .Values.read.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "loki.lokiImage" $dict -}}
{{- end }}

{{/*
read priority class name
*/}}
{{- define "loki.readPriorityClassName" -}}
{{- $pcn := coalesce .Values.global.priorityClassName .Values.read.priorityClassName -}}
{{- if $pcn }}
priorityClassName: {{ $pcn }}
{{- end }}
{{- end }}
