{{/*
queryFrontend fullname
*/}}
{{- define "tempo.queryFrontendFullname" -}}
{{ include "tempo.fullname" . }}-query-frontend
{{- end }}

{{/*
query fullname
*/}}
{{- define "tempo.queryFullname" -}}
{{ include "tempo.fullname" . }}-query
{{- end }}


{{/*
queryFrontend common labels
*/}}
{{- define "tempo.queryFrontendLabels" -}}
{{ include "tempo.labels" . }}
app.kubernetes.io/component: query-frontend
{{- end }}

{{/*
query common labels
*/}}
{{- define "tempo.queryLabels" -}}
{{ include "tempo.labels" . }}
app.kubernetes.io/component: query
{{- end }}


{{/*
queryFrontend selector labels
*/}}
{{- define "tempo.queryFrontendSelectorLabels" -}}
{{ include "tempo.selectorLabels" . }}
app.kubernetes.io/component: query-frontend
{{- end }}

{{/*
queryFrontend image
*/}}
{{- define "tempo.queryFrontendImage" -}}
{{- $dict := dict "tempo" .Values.tempo.image "service" .Values.queryFrontend.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}

{{/*
query image
*/}}
{{- define "tempo.queryImage" -}}
{{- $dict := dict "tempo" .Values.tempo.image "service" .Values.queryFrontend.query.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end }}
