{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "tempo.name" -}}
{{- default "tempo" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
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
{{- $name := default "tempo" .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Docker image selector for Tempo. Hierarchy based on global, component, and tempo values.
*/}}
{{- define "tempo.tempoImage" -}}
{{- $registry := coalesce .global.registry .component.registry .tempo.registry -}}
{{- $repository := coalesce .component.repository .tempo.repository -}}
{{- $tag := coalesce .component.tag .tempo.tag .defaultVersion | toString -}}
{{- printf "%s/%s:%s" $registry $repository $tag -}}
{{- end -}}

{{/*
Optional list of imagePullSecrets for Tempo docker images
*/}}
{{- define "tempo.imagePullSecrets" -}}
{{- $imagePullSecrets := coalesce .component.pullSecrets .tempo.pullSecrets .global.pullSecrets -}}
{{- if $imagePullSecrets  -}}
imagePullSecrets:
{{- range $imagePullSecrets }}
  - name: {{ . }}
{{ end }}
{{- end }}
{{- end -}}

{{/*
Generic component imagePullSecrets. Resolves the component's values section
dynamically, following the same pattern as tempo.imageReference.
Params:
  ctx = root context (.)
  component = component name (e.g., "distributor", "query-frontend")
  noTempoFallback = optional, when true the tempo image is not used as fallback (for non-tempo images like gateway)
*/}}
{{- define "tempo.componentImagePullSecrets" -}}
{{- $componentSection := include "tempo.componentSectionFromName" . -}}
{{- if not (hasKey .ctx.Values $componentSection) -}}
{{- print "Component section " $componentSection " does not exist" | fail -}}
{{- end -}}
{{- $component := (index .ctx.Values $componentSection).image | default dict -}}
{{- $tempo := .ctx.Values.tempo.image -}}
{{- if .noTempoFallback -}}
{{- $tempo = dict -}}
{{- end -}}
{{- $dict := dict "tempo" $tempo "component" $component "global" .ctx.Values.global.image -}}
{{- include "tempo.imagePullSecrets" $dict -}}
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
{{- $component := (index .ctx.Values $componentSection).image | default dict }}
{{- $dict := dict "tempo" $tempo "component" $component "global" .ctx.Values.global.image "defaultVersion" .ctx.Chart.AppVersion -}}
{{- include "tempo.tempoImage" $dict -}}
{{- end -}}

{{/*
Simple resource labels
*/}}
{{- define "tempo.labels" -}}
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
{{- if .ctx.Values.global.commonLabels }}
{{ toYaml .ctx.Values.global.commonLabels | indent 0 }}
{{- end }}
{{- if .ctx.Values.global.labels }}
{{ toYaml .ctx.Values.global.labels | indent 0 }}
{{- end }}
{{- end -}}

{{/*
Simple service selector labels
*/}}
{{- define "tempo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tempo.name" .ctx }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
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
Return the appropriate apiVersion for HorizontalPodAutoscaler.
*/}}
{{- define "tempo.hpa.apiVersion" -}}
  {{- if and (.Capabilities.APIVersions.Has "autoscaling/v2") (semverCompare ">=1.23-0" .Capabilities.KubeVersion.Version) -}}
    {{- print "autoscaling/v2" -}}
  {{- else -}}
    {{- print "autoscaling/v2beta1" -}}
  {{- end -}}
{{- end -}}

{{/*
Resource name template
*/}}
{{- define "tempo.resourceName" -}}
{{ include "tempo.fullname" .ctx }}{{- if .component -}}-{{ .component }}{{- end -}}
{{- end -}}

{{/*
Calculate the config from structured and unstructured text input
*/}}
{{- define "tempo.calculatedConfig" -}}
{{ tpl (mergeOverwrite (tpl .Values.config . | fromYaml) .Values.tempo.structuredConfig | toYaml) . }}
{{- end -}}

{{/*
Build the cache section for tempo.yaml.
When memcached.enabled is true, auto-generates cache.caches from per-role memcached sections.
Roles without a dedicated per-role instance fall back to the shared memcached cluster.
When memcached.enabled is false, outputs the user-defined cache block from values.yaml verbatim.
*/}}
{{- define "tempo.cacheConfig" -}}
{{- $fullname := include "tempo.fullname" . -}}
{{- $roles := list "parquet-footer" "bloom" "frontend-search" -}}
{{- $perRoleMap := dict
    "parquet-footer"  (dict "section" "memcachedParquetFooter"  "component" "memcached-parquet-footer")
    "bloom"           (dict "section" "memcachedBloom"          "component" "memcached-bloom")
    "frontend-search" (dict "section" "memcachedFrontendSearch" "component" "memcached-frontend-search") -}}
{{- if .Values.memcached.enabled -}}
{{- $sharedRoles := list -}}
{{- range $role := $roles -}}
  {{- $mapping := get $perRoleMap $role -}}
  {{- $vals := index $.Values (get $mapping "section") -}}
  {{- if not (and $vals (index $vals "enabled")) -}}
    {{- $sharedRoles = append $sharedRoles $role -}}
  {{- end -}}
{{- end -}}
caches:
{{- if gt (len $sharedRoles) 0 }}
  - memcached:
      host: {{ $fullname }}-memcached
      service: memcached-client
      consistent_hash: {{ .Values.memcached.consistentHash }}
      timeout: {{ .Values.memcached.timeout }}
    roles:
    {{- range $sharedRoles }}
      - {{ . }}
    {{- end }}
{{- end }}
{{- range $role := $roles -}}
  {{- $mapping := get $perRoleMap $role -}}
  {{- $sectionName := get $mapping "section" -}}
  {{- $component   := get $mapping "component" -}}
  {{- $vals := index $.Values $sectionName -}}
  {{- if and $vals (index $vals "enabled") }}
  - memcached:
      host: {{ $fullname }}-{{ $component }}
      service: memcached-client
      consistent_hash: {{ index $vals "consistentHash" }}
      timeout: {{ index $vals "timeout" }}
    roles:
      - {{ $role }}
  {{- end -}}
{{- end }}
{{- else -}}
{{ toYaml .Values.cache }}
{{- end -}}
{{- end -}}

{{/*
Renders the overrides config
*/}}
{{- define "tempo.overridesConfig" -}}
overrides:
{{ toYaml .Values.per_tenant_overrides | indent 2 }}
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
{{- if .Values.queryFrontend.query.enabled }}
    - key: "tempo-query.yaml"
      path: "tempo-query.yaml"
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
The volume to mount for tempo runtime configuration
*/}}
{{- define "tempo.runtimeVolume" -}}
configMap:
  name: {{ tpl .Values.externalRuntimeConfigName . }}
  items:
    - key: "overrides.yaml"
      path: "overrides.yaml"
{{- end -}}

{{/*
Internal servers http listen port - derived from Loki default
*/}}
{{- define "tempo.serverHttpListenPort" -}}
{{ (((.Values.tempo).structuredConfig).server).http_listen_port | default "3200" }}
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
{{- end -}}
{{- if .ctx.Values.global.commonLabels }}
{{ toYaml .ctx.Values.global.commonLabels | indent 0 }}
{{- end }}
{{- if .ctx.Values.global.podLabels }}
{{ toYaml .ctx.Values.global.podLabels | indent 0 }}
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

{{- define "tempo.statefulset.recreateOnSizeChangeHook" -}}
  {{- $renderedStatefulSets := list -}}
  {{- range $renderedStatefulSet := include (print .context.Template.BasePath .pathToStatefulsetTemplate) .context | splitList "---" -}}
    {{- with $renderedStatefulSet | fromYaml -}}
      {{- $renderedStatefulSets = append $renderedStatefulSets . -}}
    {{- end }}
  {{- end -}}
  {{- if $renderedStatefulSets }}
    {{- range $newStatefulSet := $renderedStatefulSets -}}
      {{- $currentStatefulset := dict -}}
      {{- if $newStatefulSet.spec.volumeClaimTemplates }}
        {{- $currentStatefulset = lookup $newStatefulSet.apiVersion $newStatefulSet.kind $newStatefulSet.metadata.namespace $newStatefulSet.metadata.name -}}
        {{- $needsRecreation := false -}}
        {{- $templates := dict -}}
        {{- if $currentStatefulset -}}
          {{- if ne (len $newStatefulSet.spec.volumeClaimTemplates) (len $currentStatefulset.spec.volumeClaimTemplates) -}}
            {{- $needsRecreation = true -}}
          {{- end -}}
          {{- range $index, $newVolumeClaimTemplate := $newStatefulSet.spec.volumeClaimTemplates -}}
            {{- $currentVolumeClaimTemplateSpec := dict -}}
              {{- range $oldVolumeClaimTemplate := $currentStatefulset.spec.volumeClaimTemplates -}}
                {{- if eq $oldVolumeClaimTemplate.metadata.name $newVolumeClaimTemplate.metadata.name -}}
                  {{- $currentVolumeClaimTemplateSpec = $oldVolumeClaimTemplate.spec -}}
                {{- end -}}
              {{- end }}
              {{- $newVolumeClaimTemplateStorageSize := $newVolumeClaimTemplate.spec.resources.requests.storage -}}
              {{- if not $currentVolumeClaimTemplateSpec -}}
                {{- $needsRecreation = true -}}
              {{- else -}}
                {{- if ne $newVolumeClaimTemplateStorageSize $currentVolumeClaimTemplateSpec.resources.requests.storage -}}
                  {{- $needsRecreation = true -}}
                  {{- $templates = set $templates $newVolumeClaimTemplate.metadata.name $newVolumeClaimTemplateStorageSize -}}
              {{- end -}}
            {{- end -}}
          {{- end -}}
        {{- end -}}
        {{- if $needsRecreation }}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ $newStatefulSet.metadata.name }}-recreate
  namespace: {{ $newStatefulSet.metadata.namespace }}
  labels:
    {{- $newStatefulSet.metadata.labels | toYaml | nindent 4 }}
    app.kubernetes.io/component: statefulset-recreate-job
  annotations:
    "helm.sh/hook": pre-upgrade
    "helm.sh/hook-weight": "-5"
    "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
spec:
  ttlSecondsAfterFinished: 300
  template:
    metadata:
      name: {{ $newStatefulSet.metadata.name }}-recreate
      labels:
        {{- $newStatefulSet.metadata.labels | toYaml | nindent 8 }}
    spec:
      serviceAccountName: {{ $newStatefulSet.metadata.name }}-recreate
      restartPolicy: OnFailure
      containers:
        - name: recreate
          image: {{ printf "%s/kubectl:%s" (coalesce $.context.Values.global.image.registry "registry.k8s.io") $.context.Capabilities.KubeVersion.Version }}
          command:
            - kubectl
            - delete
            - statefulset
            - {{ $newStatefulSet.metadata.name }}
            - --cascade=orphan
        {{- range $index := until (int $currentStatefulset.spec.replicas) }}
          {{- range $template, $size := $templates }}
        - name: patch-pvc-{{ $template }}-{{ $index }}
          image: {{ printf "%s/kubectl:%s" (coalesce $.context.Values.global.image.registry "registry.k8s.io") $.context.Capabilities.KubeVersion.Version }}
          command:
            - kubectl
            - patch
            - pvc
            - --namespace={{ $newStatefulSet.metadata.namespace }}
            - {{ printf "%s-%s-%d" $template $newStatefulSet.metadata.name $index }}
            - --type='json'
            - '-p=[{"op": "replace", "path": "/spec/resources/requests/storage", "value": "{{ $size }}"}]'
          {{- end }}
        {{- end }}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ $newStatefulSet.metadata.name }}-recreate
  namespace: {{ $newStatefulSet.metadata.namespace }}
  labels:
    {{- $newStatefulSet.metadata.labels | toYaml | nindent 4 }}
    app.kubernetes.io/component: statefulset-recreate-job
  annotations:
    "helm.sh/hook": pre-upgrade
    "helm.sh/hook-weight": "-10"
    "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: {{ $newStatefulSet.metadata.name }}-recreate
  namespace: {{ $newStatefulSet.metadata.namespace }}
  labels:
    {{- $newStatefulSet.metadata.labels | toYaml | nindent 4 }}
    app.kubernetes.io/component: statefulset-recreate-job
  annotations:
    "helm.sh/hook": pre-upgrade
    "helm.sh/hook-weight": "-10"
    "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
rules:
  - apiGroups:
      - apps
    resources:
      - statefulsets
    resourceNames:
      - {{ $newStatefulSet.metadata.name }}
    verbs:
      - delete
  {{- if $templates }}
  - apiGroups:
      - v1
    resources:
      - persistentvolumeclaims
    resourceNames:
    {{- range $index := until (int $currentStatefulset.spec.replicas) }}
      {{- range $template := $templates | keys }}
      - {{ printf "%s-%s-%d" $template $newStatefulSet.metadata.name $index }}
      {{- end }}
    {{- end }}
    verbs:
      - patch
  {{- end }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ $newStatefulSet.metadata.name }}-recreate
  namespace: {{ $newStatefulSet.metadata.namespace }}
  labels:
    {{- $newStatefulSet.metadata.labels | toYaml | nindent 4 }}
    app.kubernetes.io/component: statefulset-recreate-job
  annotations:
    "helm.sh/hook": pre-upgrade
    "helm.sh/hook-weight": "-10"
    "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
subjects:
  - kind: ServiceAccount
    name: {{ $newStatefulSet.metadata.name }}-recreate
    namespace: {{ $newStatefulSet.metadata.namespace }}
roleRef:
  kind: Role
  name: {{ $newStatefulSet.metadata.name }}-recreate
  apiGroup: rbac.authorization.k8s.io
---
        {{- end }}
      {{ end }}
    {{ end }}
  {{ end }}
{{- end -}}
