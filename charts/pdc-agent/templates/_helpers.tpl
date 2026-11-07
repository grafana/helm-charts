{{/*
Expand the name of the chart.
*/}}
{{- define "pdc-agent.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pdc-agent.fullname" -}}
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
{{- define "pdc-agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "pdc-agent.labels" -}}
helm.sh/chart: {{ include "pdc-agent.chart" . }}
{{ include "pdc-agent.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Pod labels: the common labels without helm.sh/chart. That label carries the chart version, so
including it in the pod template changes the pod-template hash on every chart release, rolling
the Deployment even when neither the image nor the configuration changed.
app.kubernetes.io/version stays, since it is .Chart.AppVersion and so tracks the agent image.
*/}}
{{- define "pdc-agent.podLabels" -}}
{{- omit (include "pdc-agent.labels" . | fromYaml) "helm.sh/chart" | toYaml -}}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "pdc-agent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pdc-agent.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the pdc-agent service account to use
*/}}
{{- define "pdc-agent.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "pdc-agent.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}