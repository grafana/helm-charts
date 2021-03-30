{{/*
compactor fullname
*/}}
{{- define "tempo.compactorFullname" -}}
{{ include "tempo.fullname" . }}-compactor
{{- end }}

{{/*
compactor common labels
*/}}
{{- define "tempo.compactorLabels" -}}
{{ include "tempo.labels" . }}
app.kubernetes.io/component: compactor
{{- end }}

{{/*
compactor selector labels
*/}}
{{- define "tempo.compactorSelectorLabels" -}}
{{ include "tempo.selectorLabels" . }}
app.kubernetes.io/component: compactor
{{- end }}

{{/*
compactor image
*/}}
{{- define "tempo.compactorImage" -}}
{{- $dict := dict "tempo" .Values.tempo.image "service" .Values.compactor.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}
