{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mimir.name" -}}
{{- default ( include "mimir.chartName" . ) .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
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
{{- $name := default ( include "mimir.chartName" . ) .Values.nameOverride -}}
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
{{- printf "%s-%s" ( include "mimir.chartName" . ) .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
For compatiblity and to support upgrade from enterprise-metrics chart redefine .Chart.Name
*/}}
{{- define "mimir.chartName" -}}
{{- if .Values.enterprise.legacyLabels -}}enterprise-metrics{{- else -}}{{ .Chart.Name }}{{- end -}}
{{- end -}}

{{/*
Calculate image name based on whether enterprise features are requested
*/}}
{{- define "mimir.imageReference" -}}
{{- if .Values.enterprise.legacyLabels -}}{{ .Values.enterprise.image.repository }}:{{ .Values.enterprise.image.tag }}{{- else -}}{{ .Values.image.repository }}:{{ .Values.image.tag }}{{- end -}}
{{- end -}}

{{/*
For compatiblity and to support upgrade from enterprise-metrics chart calculate minio bucket name
*/}}
{{- define "mimir.minioBucketPrefix" -}}
{{- if .Values.enterprise.legacyLabels -}}enterprise-metrics{{- else -}}mimir{{- end -}}
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
Resource name template
*/}}
{{- define "mimir.resourceName" -}}
{{ include "mimir.fullname" .ctx }}{{- if .component -}}-{{ .component }}{{- end -}}
{{- end -}}

{{/*
Simple resource labels
*/}}
{{- define "mimir.labels" -}}
{{- if .ctx.Values.enterprise.legacyLabels }}
{{- if .component -}}
app: {{ include "mimir.name" .ctx }}-{{ .component }}
{{- end }}
chart: {{ template "mimir.chart" .ctx }}
release: {{ .ctx.Release.Name }}
heritage: {{ .ctx.Release.Service }}

{{- else -}}

{{- if .component -}}
app.kubernetes.io/component: {{ .component }}
{{- end }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
app.kubernetes.io/name: {{ include "mimir.name" .ctx }}
app.kubernetes.io/managed-by: {{ .ctx.Release.Service }}
{{- if .ctx.Chart.AppVersion }}
{{- if .memberlist }}
app.kubernetes.io/part-of: memberlist
{{- end }}
app.kubernetes.io/version: {{ .ctx.Chart.AppVersion | quote }}
{{- end }}
helm.sh/chart: {{ include "mimir.chart" .ctx }}
{{- end }}
{{- end -}}

{{/*
POD labels
*/}}
{{/*
POD labels
*/}}
{{- define "mimir.podLabels" -}}
{{- if .ctx.Values.enterprise.legacyLabels }}
{{- if .component -}}
app: {{ include "mimir.name" .ctx }}-{{ .component }}
name: {{ .component }}
{{- end }}
{{- if .memberlist }}
gossip_ring_member: "true"
{{- end -}}
{{- if .component }}
target: {{ .component }}
release: {{ .ctx.Release.Name }}
{{- end }}
{{- else -}}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
app.kubernetes.io/name: {{ include "mimir.name" .ctx }}
{{- end }}
{{- end -}}

{{/*
Simple service selector labels
*/}}
{{- define "mimir.selectorLabels" -}}
{{- if .ctx.Values.enterprise.legacyLabels }}
{{- if .component -}}
app: {{ include "mimir.name" .ctx }}-{{ .component }}
{{- end }}
release: {{ .ctx.Release.Name }}
{{- else -}}
{{- if .component -}}
app.kubernetes.io/component: {{ .component }}
{{- end }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
app.kubernetes.io/name: {{ include "mimir.name" .ctx }}
{{- end }}
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

{{/*
Cluster name that shows up in dashboard metrics
*/}}
{{- define "mimir.clusterName" -}}
{{ (include "mimir.calculatedConfig" . | fromYaml).cluster_name | default .Release.Name }}
{{- end -}}
