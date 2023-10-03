 {{/*
Create a default fully qualified app name without trimming it at all.
If release name contains chart name it will be used as a full name.
This value is essentially the same as "mimir.fullname" in the upstream chart.
*/}}
{{- define "mimir.fullname" -}}
{{- if .Values.mimir.fullnameOverride -}}
{{- .Values.mimir.fullnameOverride | trunc 25 | trimSuffix "-" -}}
{{- else -}}
{{- $name := .Values.mimir.nameOverride | default ( include "mimir.infixName" . ) | trunc 25 | trimSuffix "-" -}}
{{- $releasename := .Release.Name | trunc 25 | trimSuffix "-" -}}
{{- if contains $name .Release.Name -}}
{{- $releasename -}}
{{- else -}}
{{- printf "%s-%s" $releasename $name -}}
{{- end -}}
{{- end -}}
{{- end -}}
