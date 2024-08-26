{{/* use the release name as the serviceAccount name for deployment and statefulset collectors */}}
{{- define "alloy.serviceAccountName" -}}
{{- default .Release.Name }}
{{- end }}

{{/* Calculate name of image ID to use for "alloy". */}}
{{- define "alloy.imageId" -}}
{{- printf ":%s" .Chart.AppVersion }}
{{- end }}
