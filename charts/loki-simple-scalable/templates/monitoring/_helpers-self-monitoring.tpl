{{/*
Client definition for LogsInstance
*/}}
{{- define "loki.logsInstanceClient" -}}
{{- $url := printf "http://%s.%s.svc.%s:3100/loki/api/v1/push" (include "loki.writeFullname" .) .Release.Namespace .Values.global.clusterDomain }}
{{- if .Values.gateway.enabled -}}
{{- $url := printf "http://%s.%s.svc.%s/loki/api/v1/push" (include "loki.gatewayFullname" .) .Release.Namespace .Values.global.clusterDomain }}
{{- end -}}
- url: {{ $url }}
  externalLabels:
    cluster: {{ include "loki.fullname" . -}}
{{- end -}}
