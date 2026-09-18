{{/*
Expand the name of the chart.
*/}}
{{- define "tempo-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tempo-operator.fullname" -}}
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
{{- define "tempo-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tempo-operator.labels" -}}
helm.sh/chart: {{ include "tempo-operator.chart" . }}
{{ include "tempo-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tempo-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tempo-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "tempo-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tempo-operator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generate certificates for tempo operator webhook service
*/}}
{{- define "tempo-operator.WebhookCert" -}}
{{- $altNames := list ( printf "%s-webhook-service.%s.svc" (include "tempo-operator.fullname" .) .Release.Namespace ) ( printf "%s-webhook-service.%s.svc.cluster.local" (include "tempo-operator.fullname" .) .Release.Namespace ) -}}
{{- $cert := genSelfSignedCert "tempo-operator-cert" nil $altNames 365 -}}
{{- $certCrtEnc := b64enc $cert.Cert }}
{{- $certKeyEnc := b64enc $cert.Key }}
{{- $caCertEnc := b64enc $cert.Cert }}
{{- $result := dict "crt" $certCrtEnc "key" $certKeyEnc "ca" $caCertEnc }}
{{- $result | toYaml }}
{{- end -}}

