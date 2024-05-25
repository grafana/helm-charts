{{/*
ingester imagePullSecrets
*/}}
{{- define "tempo.ingesterImagePullSecrets" -}}
{{- $dict := dict "tempo" .Values.tempo.image "component" .Values.ingester.image "global" .Values.global.image -}}
{{- include "tempo.imagePullSecrets" $dict -}}
{{- end }}
{{- define "ingester.zoneAwareReplicationMap" -}}
{{- $zonesMap := (dict) -}}
{{- $defaultZone := (dict "affinity" .ctx.Values.ingester.affinity "nodeSelector" .ctx.Values.ingester.nodeSelector "replicas" .ctx.Values.ingester.replicas "storageClass" .ctx.Values.ingester.storageClass) -}}

{{- if .ctx.Values.ingester.zoneAwareReplication.enabled -}}
{{- $numberOfZones := len .ctx.Values.ingester.zoneAwareReplication.zones -}}
{{- if lt $numberOfZones 3 -}}
{{- fail "When zone-awareness is enabled, you must have at least 3 zones defined." -}}
{{- end -}}

{{- $requestedReplicas := .ctx.Values.ingester.replicas -}}
{{- $replicaPerZone := div (add $requestedReplicas $numberOfZones -1) $numberOfZones -}}

{{- range $idx, $rolloutZone := .ctx.Values.ingester.zoneAwareReplication.zones -}}
{{- $_ := set $zonesMap $rolloutZone.name (dict
  "affinity" (($rolloutZone.extraAffinity | default (dict)) | mergeOverwrite (include "ingester.zoneAntiAffinity" (dict "rolloutZoneName" $rolloutZone.name "topologyKey" $.ctx.Values.ingester.zoneAwareReplication.topologyKey) | fromYaml))
  "nodeSelector" ($rolloutZone.nodeSelector | default (dict) )
  "replicas" $replicaPerZone
  "storageClass" $rolloutZone.storageClass
  ) -}}
{{- end -}}
{{- if .ctx.Values.ingester.zoneAwareReplication.migration.enabled -}}
{{- if .ctx.Values.ingester.zoneAwareReplication.migration.scaleDownDefaultZone -}}
{{- $_ := set $defaultZone "replicas" 0 -}}
{{- end -}}
{{- $_ := set $zonesMap "" $defaultZone -}}
{{- end -}}

{{- else -}}
{{- $_ := set $zonesMap "" $defaultZone -}}
{{- end -}}
{{- $zonesMap | toYaml }}

{{- end -}}

{{/*
Calculate anti-affinity for a zone
Params:
  rolloutZoneName = name of the rollout zone
  topologyKey = topology key
*/}}
{{- define "ingester.zoneAntiAffinity" -}}
{{- if .topologyKey -}}
    podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
            - key: rollout-group
                operator: In
                values:
                - ingester
            - key: zone
                operator: NotIn
                values:
                - {{ .rolloutZoneName }}
        topologyKey: {{ .topologyKey | quote }}
{{- else -}}
{}
{{- end -}}
{{- end -}}

{{/*
Calculate annotations with zone-awareness
Params:
  ctx = . context
  component = component name
  rolloutZoneName = rollout zone name (optional)
*/}}
{{- define "ingester.componentAnnotations" -}}
{{- $componentSection := include "ingester.componentSectionFromName" . | fromYaml -}}
{{- if and (or $componentSection.zoneAwareReplication.enabled $componentSection.zoneAwareReplication.migration.enabled) .rolloutZoneName }}
{{- $map := dict "rollout-max-unavailable" ($componentSection.zoneAwareReplication.maxUnavailable | toString) -}}
{{- toYaml (deepCopy $map | mergeOverwrite $componentSection.annotations) }}
{{- else -}}
{{ toYaml $componentSection.annotations }}
{{- end -}}
{{- end -}}

{{/*
Resource name template
*/}}
{{- define "ingester.resourceName" -}}
{{- $resourceName := include "tempo.fullname" .ctx -}}
{{- if .component -}}{{- $resourceName = printf "%s-%s" $resourceName .component -}}{{- end -}}
{{- if .rolloutZoneName -}}{{- $resourceName = printf "%s-%s" $resourceName .rolloutZoneName -}}{{- end -}}
{{- $resourceName -}}
{{- end -}}
