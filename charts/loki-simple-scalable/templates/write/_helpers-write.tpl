{{/*
write fullname
*/}}
{{- define "loki.writeFullname" -}}
{{ include "loki.fullname" . }}-write
{{- end }}

{{/*
write common labels
*/}}
{{- define "loki.writeLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: write
{{- end }}

{{/*
write selector labels
*/}}
{{- define "loki.writeSelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: write
{{- end }}

{{/*
write image
*/}}
{{- define "loki.writeImage" -}}
{{- $dict := dict "loki" .Values.loki.image "service" .Values.write.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "loki.lokiImage" $dict -}}
{{- end }}

{{/*
write priority class name
*/}}
{{- define "loki.writePriorityClassName" -}}
{{- $pcn := coalesce .Values.global.priorityClassName .Values.write.priorityClassName -}}
{{- if $pcn }}
priorityClassName: {{ $pcn }}
{{- end }}
{{- end }}
