{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "grafana-mcp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "grafana-mcp.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "grafana-mcp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name of the service account
*/}}
{{- define "grafana-mcp.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "grafana-mcp.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "grafana-mcp.namespace" -}}
{{- if .Values.namespaceOverride }}
{{- .Values.namespaceOverride }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "grafana-mcp.labels" -}}
helm.sh/chart: {{ include "grafana-mcp.chart" . }}
{{ include "grafana-mcp.selectorLabels" . }}
{{- if or .Chart.AppVersion .Values.image.tag }}
app.kubernetes.io/version: {{ mustRegexReplaceAllLiteral "@sha.*" .Values.image.tag "" | default .Chart.AppVersion | trunc 63 | trimSuffix "-" | quote }}
{{- end }}
{{- with .Values.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "grafana-mcp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "grafana-mcp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Formats imagePullSecrets. Input is (dict "root" . "imagePullSecrets" .{specific imagePullSecrets})
*/}}
{{- define "grafana.imagePullSecrets" -}}
{{- $root := .root }}
{{- range (concat .root.Values.global.imagePullSecrets .imagePullSecrets) }}
{{- if eq (typeOf .) "map[string]interface {}" }}
- {{ toYaml (dict "name" (tpl .name $root)) | trim }}
{{- else }}
- name: {{ tpl . $root }}
{{- end }}
{{- end }}
{{- end }}
