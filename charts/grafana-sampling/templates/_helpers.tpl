{{/* use the release name as the serviceAccount name for deployment and statefulset agents */}}
{{- define "grafana-agent.serviceAccountName" -}}
{{- default .Release.Name }}
{{- end }}

{{/* Calculate name of image ID to use for "grafana-agent". */}}
{{- define "grafana-agent.imageId" -}}
{{- printf ":%s" .Chart.AppVersion }}
{{- end }}
