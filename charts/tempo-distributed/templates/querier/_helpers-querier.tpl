{{/*
querier fullname
*/}}
{{- define "tempo.querierFullname" -}}
{{ include "tempo.fullname" . }}-querier
{{- end }}

{{/*
querier common labels
*/}}
{{- define "tempo.querierLabels" -}}
{{ include "tempo.labels" . }}
app.kubernetes.io/component: querier
{{- end }}

{{/*
querier selector labels
*/}}
{{- define "tempo.querierSelectorLabels" -}}
{{ include "tempo.selectorLabels" . }}
app.kubernetes.io/component: querier
{{- end }}

{{/*
querier image
*/}}
{{- define "tempo.querierImage" -}}
{{- $dict := dict "tempo" .Values.tempo.image "service" .Values.querier.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}
