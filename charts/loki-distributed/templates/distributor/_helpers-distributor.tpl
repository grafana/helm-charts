{{/*
distributor fullname
*/}}
{{- define "loki.distributorFullname" -}}
{{ include "loki.fullname" . }}-distributor
{{- end }}

{{/*
distributor common labels
*/}}
{{- define "loki.distributorLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: distributor
{{- end }}

{{/*
distributor selector labels
*/}}
{{- define "loki.distributorSelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: distributor
{{- end }}

{{/*
distributor image
*/}}
{{- define "loki.distributorImage" -}}
{{- $dict := dict "loki" .Values.loki.image "service" .Values.distributor.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "loki.lokiImage" $dict -}}
{{- end }}
