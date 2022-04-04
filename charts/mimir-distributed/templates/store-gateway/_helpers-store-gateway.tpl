{{/*
store-gateway fullname
*/}}
{{- define "mimir.storeGatewayFullname" -}}
{{ include "mimir.fullname" . }}-store-gateway
{{- end }}

{{/*
store-gateway common labels
*/}}
{{- define "mimir.storeGatewayLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-store-gateway
{{- else }}
app.kubernetes.io/component: store-gateway
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
store-gateway selector labels
*/}}
{{- define "mimir.storeGatewaySelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-store-gateway
{{- else }}
app.kubernetes.io/component: store-gateway
{{- end }}
{{- end -}}

{{/*
GEM store-gateway Pod labels
*/}}
{{- define "mimir.gemStoreGatewayPodLabels" -}}
name: store-gateway
target: store-gateway
gossip_ring_member: "true"
{{- end -}}

{{/*
store-gateway POD disruption budget template
*/}}
{{- define "mimir.storeGatewayPDB" -}}
{{- if .Values.store_gateway.podDisruptionBudget -}}
apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: {{ template "mimir.storeGatewayFullname" . }}
  labels:
    {{- include "mimir.storeGatewayLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
spec:
  selector:
    matchLabels:
      {{- include "mimir.storeGatewaySelectorLabels" . | nindent 6 }}
{{ toYaml .Values.store_gateway.podDisruptionBudget | indent 2 }}
{{- end -}}
{{- end -}}

{{/*
store-gateway Service Monitor template
*/}}
{{- define "mimir.storeGatewayServiceMonitor" -}}
{{- with .Values.serviceMonitor }}
{{- if .enabled }}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ template "mimir.storeGatewayFullname" $ }}
  {{- with .namespace }}
  namespace: {{ . }}
  {{- end }}
  labels:
    {{- include "mimir.storeGatewayLabels" $ | nindent 4 }}
    {{- if $.Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" $ | nindent 4 }}{{- end }}
    {{- with .labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with .annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- with .namespaceSelector }}
  namespaceSelector:
  {{- toYaml . | nindent 4 }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "mimir.storeGatewaySelectorLabels" $ | nindent 6 }}
  endpoints:
    - port: http-metrics
      {{- with .interval }}
      interval: {{ . }}
      {{- end }}
      {{- with .scrapeTimeout }}
      scrapeTimeout: {{ . }}
      {{- end }}
      {{- with .relabelings }}
      relabelings:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .scheme }}
      scheme: {{ . }}
      {{- end }}
      {{- with .tlsConfig }}
      tlsConfig:
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
store-gateway StatefulSet template
*/}}
{{- define "mimir.storeGatewayStatefulSet" -}}
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ include "mimir.storeGatewayFullname" . }}
  labels:
    {{- include "mimir.storeGatewayLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
  annotations:
    {{- toYaml .Values.store_gateway.annotations | nindent 4 }}
spec:
  replicas: {{ .Values.store_gateway.replicas }}
  selector:
    matchLabels:
      {{- include "mimir.storeGatewaySelectorLabels" . | nindent 6 }}
  updateStrategy:
    {{- toYaml .Values.store_gateway.strategy | nindent 4 }}
  serviceName: {{ template "mimir.fullname" . }}-store-gateway-headless
  {{- if .Values.store_gateway.persistentVolume.enabled }}
  volumeClaimTemplates:
    - metadata:
        name: storage
        {{- if .Values.store_gateway.persistentVolume.annotations }}
        annotations:
          {{ toYaml .Values.store_gateway.persistentVolume.annotations | nindent 10 }}
        {{- end }}
      spec:
        {{- if .Values.store_gateway.persistentVolume.storageClass }}
        {{- if (eq "-" .Values.store_gateway.persistentVolume.storageClass) }}
        storageClassName: ""
        {{- else }}
        storageClassName: "{{ .Values.store_gateway.persistentVolume.storageClass }}"
        {{- end }}
        {{- end }}
        accessModes:
          {{ toYaml .Values.store_gateway.persistentVolume.accessModes | nindent 10 }}
        resources:
          requests:
            storage: "{{ .Values.store_gateway.persistentVolume.size }}"
  {{- end }}
  template:
    metadata:
      labels:
        {{- include "mimir.storeGatewayLabels" . | nindent 8 }}
        {{- if .Values.useGEMLabels }}{{- include "mimir.gemStoreGatewayPodLabels" . | nindent 8 }}{{- end }}
        {{- with .Values.store_gateway.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      annotations:
        {{- if .Values.useExternalConfig }}
        checksum/config: {{ .Values.externalConfigVersion }}
        {{- else }}
        checksum/config: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
        {{- end }}
        {{- with .Values.store_gateway.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      serviceAccountName: {{ template "mimir.serviceAccountName" . }}
      {{- if .Values.store_gateway.priorityClassName }}
      priorityClassName: {{ .Values.store_gateway.priorityClassName }}
      {{- end }}
      securityContext:
        {{- toYaml .Values.store_gateway.securityContext | nindent 8 }}
      initContainers:
        {{- toYaml .Values.store_gateway.initContainers | nindent 8 }}
      {{- if .Values.image.pullSecrets }}
      imagePullSecrets:
      {{- range .Values.image.pullSecrets }}
        - name: {{ . }}
      {{- end }}
      {{- end }}
      nodeSelector:
        {{- toYaml .Values.store_gateway.nodeSelector | nindent 8 }}
      affinity:
        {{- toYaml .Values.store_gateway.affinity | nindent 8 }}
      tolerations:
        {{- toYaml .Values.store_gateway.tolerations | nindent 8 }}
      terminationGracePeriodSeconds: {{ .Values.store_gateway.terminationGracePeriodSeconds }}
      volumes:
        - name: config
          secret:
            secretName: {{ .Values.externalConfigSecretName }}
        - name: runtime-config
          configMap:
            name: {{ template "mimir.fullname" . }}-runtime
        {{- if not .Values.store_gateway.persistentVolume.enabled }}
        - name: storage
          emptyDir: {}
        {{- end }}
        - name: active-queries
          emptyDir: {}
        {{- if .Values.store_gateway.extraVolumes }}
        {{ toYaml .Values.store_gateway.extraVolumes | nindent 8 }}
        {{- end }}
      containers:
        {{- if .Values.store_gateway.extraContainers }}
        {{ toYaml .Values.store_gateway.extraContainers | nindent 8 }}
        {{- end }}
        - name: store-gateway
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          args:
            - "-target=store-gateway"
            - -activity-tracker.filepath=/active-query-tracker/activity.log
            - "-config.file=/etc/mimir/mimir.yaml"
            {{- range $key, $value := .Values.store_gateway.extraArgs }}
            - "-{{ $key }}={{ $value }}"
            {{- end }}
          volumeMounts:
            {{- if .Values.store_gateway.extraVolumeMounts }}
            {{ toYaml .Values.store_gateway.extraVolumeMounts | nindent 12}}
            {{- end }}
            - name: config
              mountPath: /etc/mimir
            - name: runtime-config
              mountPath: /var/mimir
            - name: storage
              mountPath: "/data"
              {{- if .Values.store_gateway.persistentVolume.subPath }}
              subPath: {{ .Values.store_gateway.persistentVolume.subPath }}             
              {{- end }}
            - name: active-queries
              mountPath: /active-query-tracker
          ports:
            - name: http-metrics
              containerPort: {{ include "mimir.serverHttpListenPort" . }}
              protocol: TCP
            - name: grpc
              containerPort: {{ include "mimir.serverGrpcListenPort" . }}
              protocol: TCP            
          livenessProbe:
            {{- toYaml .Values.store_gateway.livenessProbe | nindent 12 }}
          readinessProbe:
            {{- toYaml .Values.store_gateway.readinessProbe | nindent 12 }}
          resources:
            {{- toYaml .Values.store_gateway.resources | nindent 12 }}
          securityContext:
            readOnlyRootFilesystem: true
          env:
            {{- if .Values.store_gateway.env }}
              {{- toYaml .Values.store_gateway.env | nindent 12 }}
            {{- end }}
{{- end -}}

{{/*
store-gateway StatefulSet template
*/}}
{{- define "mimir.storeGatewayHeadless" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "mimir.storeGatewayFullname" . }}-headless
  labels:
    {{- include "mimir.storeGatewayLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
    {{- with .Values.store_gateway.service.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- toYaml .Values.store_gateway.service.annotations | nindent 4 }}
spec:
  type: ClusterIP
  clusterIP: None
  ports:
    - port: {{ include "mimir.serverGrpcListenPort" . }}
      protocol: TCP
      name: grpc
      targetPort: grpc
  selector:
    {{- include "mimir.storeGatewaySelectorLabels" . | nindent 4 }}
{{- end -}}

{{/*
store-gateway Service template
*/}}
{{- define "mimir.storeGatewayService" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "mimir.storeGatewayFullname" . }}
  labels:
    {{- include "mimir.storeGatewayLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
    {{- with .Values.store_gateway.service.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- toYaml .Values.store_gateway.service.annotations | nindent 4 }}
spec:
  type: ClusterIP
  ports:
    - port: {{ include "mimir.serverHttpListenPort" . }}
      protocol: TCP
      name: http-metrics
      targetPort: http-metrics
    - port: {{ include "mimir.serverGrpcListenPort" . }}
      protocol: TCP
      name: grpc
      targetPort: grpc
  selector:
    {{- include "mimir.storeGatewaySelectorLabels" . | nindent 4 }}
{{- end -}}