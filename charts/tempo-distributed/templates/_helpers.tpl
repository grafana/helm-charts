{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "tempo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tempo.fullname" -}}
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
Docker image name for Tempo
*/}}
{{- define "tempo.tempoImage" -}}
{{- $registry := coalesce .global.registry .service.registry .tempo.registry -}}
{{- $repository := coalesce .service.repository .tempo.repository -}}
{{- $tag := coalesce .service.tag .tempo.tag .defaultVersion | toString -}}
{{- printf "%s/%s:%s" $registry $repository $tag -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tempo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "tempo.labels" -}}
helm.sh/chart: {{ include "tempo.chart" . }}
{{ include "tempo.selectorLabels" . }}
{{- if or .Chart.AppVersion .Values.tempo.tag }}
app.kubernetes.io/version: {{ .Values.tempo.tag | default .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "tempo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tempo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "tempo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "tempo.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Gossip ring name
*/}}
{{- define "tempo.gossipRing.name" -}}
{{ include "tempo.fullname" . }}-gossip-ring
{{- end -}}

{{/*
Gossip ring  Selector labels
*/}}
{{- define "tempo.gossipRing.selectorLabels" -}}
tempo-gossip-member: "true"
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "tempo.ingress.apiVersion" -}}
  {{- if and (.Capabilities.APIVersions.Has "networking.k8s.io/v1") (semverCompare ">= 1.19-0" .Capabilities.KubeVersion.Version) -}}
      {{- print "networking.k8s.io/v1" -}}
  {{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" -}}
    {{- print "networking.k8s.io/v1beta1" -}}
  {{- else -}}
    {{- print "extensions/v1beta1" -}}
  {{- end -}}
{{- end -}}

{{/*
Return if ingress is stable.
*/}}
{{- define "tempo.ingress.isStable" -}}
  {{- eq (include "tempo.ingress.apiVersion" .) "networking.k8s.io/v1" -}}
{{- end -}}

{{/*
Return if ingress supports ingressClassName.
*/}}
{{- define "tempo.ingress.supportsIngressClassName" -}}
  {{- or (eq (include "tempo.ingress.isStable" .) "true") (and (eq (include "tempo.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18-0" .Capabilities.KubeVersion.Version)) -}}
{{- end -}}

{{/*
Return if ingress supports pathType.
*/}}
{{- define "tempo.ingress.supportsPathType" -}}
  {{- or (eq (include "tempo.ingress.isStable" .) "true") (and (eq (include "tempo.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18-0" .Capabilities.KubeVersion.Version)) -}}
{{- end -}}
