{{/*
store-gateway zonename
*/}}
{{- define "mimir.storeGatewayZonename" -}}
{{ include "mimir.resourceName" (dict "ctx" . "component" "store-gateway") }}{{- if .Values.store_gateway.zone_aware_replication.enabled }}-{{ .rolloutZoneName }}{{- end }}
{{- end }}


{{/*
store-gateway multi zone specific labels
*/}}
{{- define "mimir.storeGatewayZoneLabels" -}}
{{- include "mimir.labels" (dict "ctx" . "component" "store-gateway" "memberlist" true) }}
{{- if .Values.store_gateway.zone_aware_replication.enabled }}
rollout-group: store-gateway
zone: {{ .rolloutZoneName }}
{{- end }}
{{- end -}}


{{/*
store-gateway multi zone selector labels
*/}}
{{- define "mimir.storeGatewayZoneSelectorLabels" -}}
{{- include "mimir.selectorLabels" (dict "ctx" . "component" "store-gateway" "memberlist" true) }}
{{- if .Values.store_gateway.zone_aware_replication.enabled }}
rollout-group: store-gateway
zone: {{ .rolloutZoneName }}
{{- end }}
{{- end -}}


{{/*
store-gateway multi zone pod labels
*/}}
{{- define "mimir.storeGatewayZonePodLabels" -}}
{{- include "mimir.podLabels" (dict "ctx" . "component" "store-gateway" "memberlist" true) }}
{{- if .Values.store_gateway.zone_aware_replication.enabled }}
rollout-group: store-gateway
zone: {{ .rolloutZoneName }}
{{- end }}
{{- end -}}


{{/*
store-gateway common annotations
*/}}
{{- define "mimir.storeGatewayAnnotations" -}}
{{- if .Values.store_gateway.zone_aware_replication.enabled }}
{{- $map := dict "rollout-max-unavailable" (default .Values.zone_aware_replication.max_unavailable .Values.store_gateway.zone_aware_replication.max_unavailable | toString) -}}
{{- toYaml (deepCopy $map | mergeOverwrite .Values.store_gateway.annotations) }}
{{- else -}}
{{ toYaml .Values.store_gateway.annotations }}
{{- end -}}
{{- end -}}
