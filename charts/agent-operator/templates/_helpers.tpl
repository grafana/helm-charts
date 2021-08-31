{{/*
Expand the name of the chart.
*/}}
{{- define "ga-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ga-operator.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/* Fullname suffixed with grafanaAgent */}}
{{- define "ga-operator.grafanaAgent.fullname" -}}
{{- printf "%s-agent" (include "ga-operator.fullname" .) -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ga-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ga-operator.labels" -}}
app.kubernetes.io/name: {{ include "ga-operator.name" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
helm.sh/chart: {{ include "ga-operator.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ga-operator.operator.serviceAccountName" -}}
{{- if .Values.operator.serviceAccount.create }}
{{- default (include "ga-operator.fullname" .) .Values.operator.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.operator.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ga-operator.grafanaAgent.serviceAccountName" -}}
{{- if .Values.grafanaAgent.serviceAccount.create }}
{{- default (include "ga-operator.grafanaAgent.fullname" .) .Values.grafanaAgent.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.grafanaAgent.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "ga-operator.grafanaAgent.metricsInstance.apiKeySecretName" -}}
{{- $secretName := printf "%s-metrics" (include "ga-operator.fullname" .) -}}
{{- default $secretName .Values.grafanaAgent.metrics.existingSecret | quote -}}
{{- end -}}