{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "this.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "this.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "this.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "this.fullnameDeployment" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s-deployment" (.Values.fullnameOverride | trunc 52 | trimSuffix "-") -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-deployment" .Release.Name | trunc 52 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-deployment" (printf "%s-%s" .Release.Name $name | trunc 52 | trimSuffix "-") -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "this.labels" -}}
helm.sh/chart: {{ include "this.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "this.selectorLabels" . }}
{{- end }}

{{- define "this.labelsDeployment" -}}
helm.sh/chart: {{ include "this.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "this.selectorLabelsDeployment" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "this.selectorLabels" -}}
app.kubernetes.io/name: {{ include "this.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "this.selectorLabelsDeployment" -}}
{{ include "this.selectorLabels" . }}
app.kubernetes.io/component: deployment
{{- end }}

{{/*
Create the name of the service account
*/}}
{{- define "this.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "this.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
