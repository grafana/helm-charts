{{/*
distributor fullname
*/}}
{{- define "tempo.distributorFullname" -}}
{{ include "tempo.fullname" . }}-distributor
{{- end }}

{{/*
distributor common labels
*/}}
{{- define "tempo.distributorLabels" -}}
{{ include "tempo.labels" . }}
app.kubernetes.io/component: distributor
{{- end }}

{{/*
distributor selector labels
*/}}
{{- define "tempo.distributorSelectorLabels" -}}
{{ include "tempo.selectorLabels" . }}
app.kubernetes.io/component: distributor
{{- end }}

{{/*
distributor image
*/}}
{{- define "tempo.distributorImage" -}}
{{- $dict := dict "tempo" .Values.tempo.image "service" .Values.distributor.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}
