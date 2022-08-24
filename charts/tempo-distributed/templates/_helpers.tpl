{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "tempo.name" -}}
{{- default ( include "tempo.infixName" . ) .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
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
{{- $name := default ( include "tempo.infixName" . ) .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate the infix for naming
*/}}
{{- define "tempo.infixName" -}}
{{- if and .Values.enterprise.enabled .Values.enterprise.legacyLabels -}}enterprise-traces{{- else -}}tempo{{- end -}}
{{- end -}}

{{/*
Docker image selector for Tempo. Hierachy based on global, component, and tempo values.
*/}}
{{- define "tempo.tempoImage" -}}
{{- $registry := coalesce .global.registry .component.registry .tempo.registry -}}
{{- $repository := coalesce .component.repository .tempo.repository -}}
{{- $tag := coalesce .component.tag .tempo.tag .defaultVersion | toString -}}
{{- printf "%s/%s:%s" $registry $repository $tag -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tempo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Calculate image name based on whether enterprise features are requested.  Fallback to hierarchy handling in `tempo.tempoImage`.
*/}}
{{- define "tempo.imageReference" -}}
{{ $tempo := "" }}
{{- if .ctx.Values.enterprise.enabled -}}
{{ $tempo = merge .ctx.Values.enterprise.image .ctx.Values.tempo.image }}
{{- else -}}
{{ $tempo = .ctx.Values.tempo.image }}
{{- end -}}
{{- $componentSection := include "tempo.componentSectionFromName" . }}
{{- if not (hasKey .ctx.Values $componentSection) }}
{{- print "Component section " $componentSection " does not exist" | fail }}
{{- end }}
{{- $component := (index .ctx.Values $componentSection).image }}
{{- $dict := dict "tempo" $tempo "component" $component "global" .ctx.Values.global.image "defaultVersion" .ctx.Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end -}}

{{/*
Simple resource labels
*/}}
{{- define "tempo.labels" -}}
{{- if .ctx.Values.enterprise.legacyLabels }}
{{- if .component -}}
app: {{ include "tempo.name" .ctx }}-{{ .component }}
{{- else -}}
app: {{ include "tempo.name" .ctx }}
{{- end }}
chart: {{ template "tempo.chart" .ctx }}
heritage: {{ .ctx.Release.Service }}
release: {{ .ctx.Release.Name }}

{{- else -}}

helm.sh/chart: {{ include "tempo.chart" .ctx }}
app.kubernetes.io/name: {{ include "tempo.name" .ctx }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- if .memberlist }}
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- if .ctx.Chart.AppVersion }}
app.kubernetes.io/version: {{ .ctx.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .ctx.Release.Service }}
{{- end }}
{{- end -}}

{{/*
Simple service selector labels
*/}}
{{- define "tempo.selectorLabels" -}}
{{- if .ctx.Values.enterprise.legacyLabels }}
{{- if .component -}}
app: {{ include "tempo.name" .ctx }}-{{ .component }}
{{- end }}
release: {{ .ctx.Release.Name }}
{{- else -}}
app.kubernetes.io/name: {{ include "tempo.name" .ctx }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- end -}}
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

{{/*
Resource name template
*/}}
{{- define "tempo.resourceName" -}}
{{ include "tempo.fullname" .ctx }}{{- if .component -}}-{{ .component }}{{- end -}}
{{- end -}}

{{/*
Calculate the config from structured and unstructred text input
*/}}
{{- define "tempo.calculatedConfig" -}}
{{ tpl (mergeOverwrite (tpl .Values.config . | fromYaml) .Values.tempo.structuredConfig | toYaml) . }}
{{- end -}}

{{/*
Calculate the overrides config from structured and unstructred text input
*/}}
{{- define "tempo.calculatedOverridesConfig" -}}
{{ tpl .Values.overrides . }}
{{- end -}}

{{/*
The volume to mount for tempo configuration
*/}}
{{- define "tempo.configVolume" -}}
{{- if eq .Values.configStorageType "Secret" -}}
secret:
  secretName: {{ tpl .Values.externalConfigSecretName . }}
{{- else if eq .Values.configStorageType "ConfigMap" -}}
configMap:
  name: {{ tpl .Values.externalConfigSecretName . }}
  items:
    - key: "tempo.yaml"
      path: "tempo.yaml"
    - key: "overrides.yaml"
      path: "overrides.yaml"
{{- end -}}
{{- end -}}

{{/*
Internal servers http listen port - derived from Loki default
*/}}
{{- define "tempo.serverHttpListenPort" -}}
{{ (((.Values.tempo).structuredConfig).server).http_listen_port | default "3100" }}
{{- end -}}

{{/*
Internal servers grpc listen port - derived from Tempo default
*/}}
{{- define "tempo.serverGrpcListenPort" -}}
{{ (((.Values.tempo).structuredConfig).server).grpc_listen_port | default "9095" }}
{{- end -}}

{{/*
Memberlist bind port
*/}}
{{- define "tempo.memberlistBindPort" -}}
{{ (((.Values.tempo).structuredConfig).memberlist).bind_port | default "7946" }}
{{- end -}}

{{/*
Calculate values.yaml section name from component name
Expects the component name in .component on the passed context
*/}}
{{- define "tempo.componentSectionFromName" -}}
{{- .component | replace "-" "_" | camelcase | untitle -}}
{{- end -}}

{{/*
POD labels
*/}}
{{- define "tempo.podLabels" -}}
{{- if .ctx.Values.enterprise.legacyLabels }}
{{- if .component -}}
app: {{ include "tempo.name" .ctx }}-{{ .component }}
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
helm.sh/chart: {{ include "tempo.chart" .ctx }}
app.kubernetes.io/name: {{ include "tempo.name" .ctx }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
app.kubernetes.io/version: {{ .ctx.Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .ctx.Release.Service }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- if .memberlist }}
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end }}
{{- end -}}

{{/*
POD annotations
*/}}
{{- define "tempo.podAnnotations" -}}
{{- if .ctx.Values.useExternalConfig }}
checksum/config: {{ .ctx.Values.externalConfigVersion }}
{{- else -}}
checksum/config: {{ include (print .ctx.Template.BasePath "/configmap-tempo.yaml") .ctx | sha256sum }}
{{- end }}
{{- with .ctx.Values.global.podAnnotations }}
{{ toYaml . }}
{{- end }}
{{- if .component }}
{{- $componentSection := include "tempo.componentSectionFromName" . }}
{{- if not (hasKey .ctx.Values $componentSection) }}
{{- print "Component section " $componentSection " does not exist" | fail }}
{{- end }}
{{- with (index .ctx.Values $componentSection).podAnnotations }}
{{ toYaml . }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Cluster name that shows up in dashboard metrics
*/}}
{{- define "tempo.clusterName" -}}
{{ (include "tempo.calculatedConfig" . | fromYaml).cluster_name | default .Release.Name }}
{{- end -}}
