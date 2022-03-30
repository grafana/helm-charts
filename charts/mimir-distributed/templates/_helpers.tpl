{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mimir.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mimir.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mimir.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account
*/}}
{{- define "mimir.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "mimir.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the app name for clients. Defaults to the same logic as "mimir.fullname", and default client expects "prometheus".
*/}}
{{- define "client.name" -}}
{{- if .Values.client.name -}}
{{- .Values.client.name -}}
{{- else if .Values.client.fullnameOverride -}}
{{- .Values.client.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "prometheus" .Values.client.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate the config from structured and unstructred text input
*/}}
{{- define "mimir.calculatedConfig" -}}
{{ include (print $.Template.BasePath "/_config-render.tpl") . }}
{{- end -}}

{{/*
Internal servers http listen port - derived from Mimir default
*/}}
{{- define "mimir.serverHttpListenPort" -}}
8080
{{- end -}}

{{/*
Internal servers grpc listen port - derived from Mimir default
*/}}
{{- define "mimir.serverGrpcListenPort" -}}
9095
{{- end -}}

{{/*
Alertmanager cluster bind address
*/}}
{{- define "mimir.alertmanagerClusterBindAddress" -}}
{{- if (include "mimir.calculatedConfig" . | fromYaml).alertmanager -}}
{{ (include "mimir.calculatedConfig" . | fromYaml).alertmanager.cluster_bind_address | default "" }}
{{- end -}}
{{- end -}}

{{/*
Memberlist bind port
*/}}
{{- define "mimir.memberlistBindPort" -}}
{{- if (include "mimir.calculatedConfig" . | fromYaml).memberlist -}}
{{ (include "mimir.calculatedConfig" . | fromYaml).memberlist.bind_port | default "7946" }}
{{- else -}}
{{- print "7946" -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "mimir.labels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if not .Values.useGEMLabels }}
helm.sh/chart: {{ include "mimir.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "mimir.selectorLabels" -}}
{{- if .Values.useGEMLabels }}
release: {{ .Release.Name }}
{{- else -}}
app.kubernetes.io/name: {{ include "mimir.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- end -}}

{{/*
GEM extra labels, included in non-Pod resources
*/}}
{{- define "mimir.gemExtraLabels" -}}
chart: {{ template "mimir.chart" . }}
heritage: {{ .Release.Service }}
{{- end -}}


{{/*
Alertmanager http prefix
*/}}
{{- define "mimir.alertmanagerHttpPrefix" -}}
{{- if (include "mimir.calculatedConfig" . | fromYaml).api }}
{{ (include "mimir.calculatedConfig" . | fromYaml).api.alertmanager_http_prefix | default "/alertmanager" }}
{{- else -}}
{{- print "/alertmanager" -}}
{{- end -}}
{{- end -}}


{{/*
Prometheus http prefix
*/}}
{{- define "mimir.prometheusHttpPrefix" -}}
{{- if (include "mimir.calculatedConfig" . | fromYaml).api }}
{{ (include "mimir.calculatedConfig" . | fromYaml).api.prometheus_http_prefix | default "/prometheus" }}
{{- else -}}
{{- print "/prometheus" -}}
{{- end -}}
{{- end -}}
