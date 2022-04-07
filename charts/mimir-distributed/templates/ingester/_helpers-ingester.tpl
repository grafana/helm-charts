{{/*
ingester zonename
*/}}
{{- define "mimir.ingesterZonename" -}}
{{ include "mimir.resourceName" (dict "ctx" . "component" "ingester") }}{{- if .Values.ingester.zone_aware_replication.enabled }}-{{ .rolloutZoneName }}{{- end }}
{{- end }}


{{/*
ingester multi zone specific labels
*/}}
{{- define "mimir.ingesterZoneLabels" -}}
{{- include "mimir.labels" (dict "ctx" . "component" "ingester" "memberlist" true) }}
{{- if .Values.ingester.zone_aware_replication.enabled }}
rollout-group: ingester
zone: {{ .rolloutZoneName }}
{{- end }}
{{- end -}}


{{/*
ingester multi zone selector labels
*/}}
{{- define "mimir.ingesterZoneSelectorLabels" -}}
{{- include "mimir.selectorLabels" (dict "ctx" . "component" "ingester" "memberlist" true) }}
{{- if .Values.ingester.zone_aware_replication.enabled }}
rollout-group: ingester
zone: {{ .rolloutZoneName }}
{{- end }}
{{- end -}}


{{/*
ingester multi zone pod labels
*/}}
{{- define "mimir.ingesterZonePodLabels" -}}
{{- include "mimir.podLabels" (dict "ctx" . "component" "ingester" "memberlist" true) }}
{{- if .Values.ingester.zone_aware_replication.enabled }}
rollout-group: ingester
zone: {{ .rolloutZoneName }}
{{- end }}
{{- end -}}


{{/*
ingester common annotations
*/}}
{{- define "mimir.ingesterAnnotations" -}}
{{- if .Values.ingester.zone_aware_replication.enabled }}
{{- $map := dict "rollout-max-unavailable" (default .Values.zone_aware_replication.max_unavailable .Values.ingester.zone_aware_replication.max_unavailable | toString) -}}
{{- toYaml (deepCopy $map | mergeOverwrite .Values.ingester.annotations) }}
{{- else -}}
{{ toYaml .Values.ingester.annotations }}
{{- end -}}
{{- end -}}
