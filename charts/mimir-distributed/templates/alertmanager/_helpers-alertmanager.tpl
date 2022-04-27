{{/*
alertmanager zonename
*/}}
{{- define "mimir.alertmanagerZonename" -}}
{{- if .Values.alertmanager.zone_aware_replication.enabled -}}
{{- $zoneNameCharLimit := sub 64 (len "alertmanager-") -}}
{{- if gt (len .rolloutZoneName) $zoneNameCharLimit -}}
{{- fail (printf "Zone Name (%s) exceeds character limit (%d)" .rolloutZoneName $zoneNameCharLimit ) -}}
{{- end -}}
{{- end -}}
{{ include "mimir.resourceName" (dict "ctx" . "component" "alertmanager") }}{{- if .Values.alertmanager.zone_aware_replication.enabled }}-{{ .rolloutZoneName }}{{- end }}
{{- end }}


{{/*
alertmanager multi zone specific labels
*/}}
{{- define "mimir.alertmanagerZoneLabels" -}}
{{- include "mimir.labels" (dict "ctx" . "component" "alertmanager" "memberlist" true) }}
{{- if .Values.alertmanager.zone_aware_replication.enabled }}
rollout-group: alertmanager
zone: {{ .rolloutZoneName }}
{{- end }}
{{- end -}}


{{/*
alertmanager multi zone selector labels
*/}}
{{- define "mimir.alertmanagerZoneSelectorLabels" -}}
{{- include "mimir.selectorLabels" (dict "ctx" . "component" "alertmanager" "memberlist" true) }}
{{- if .Values.alertmanager.zone_aware_replication.enabled }}
rollout-group: alertmanager
zone: {{ .rolloutZoneName }}
{{- end }}
{{- end -}}


{{/*
alertmanager multi zone pod labels
*/}}
{{- define "mimir.alertmanagerZonePodLabels" -}}
{{- include "mimir.podLabels" (dict "ctx" . "component" "alertmanager" "memberlist" true) }}
{{- if .Values.alertmanager.zone_aware_replication.enabled }}
rollout-group: alertmanager
zone: {{ .rolloutZoneName }}
{{- end }}
{{- end -}}


{{/*
alertmanager common annotations
*/}}
{{- define "mimir.alertmanagerAnnotations" -}}
{{- if .Values.alertmanager.zone_aware_replication.enabled }}
{{- $map := dict "rollout-max-unavailable" (default .Values.zone_aware_replication.max_unavailable .Values.alertmanager.zone_aware_replication.max_unavailable | toString) -}}
{{- toYaml (deepCopy $map | mergeOverwrite .Values.alertmanager.annotations) }}
{{- else -}}
{{ toYaml .Values.alertmanager.annotations }}
{{- end -}}
{{- end -}}
