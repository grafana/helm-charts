{{/*
ingester fullname
*/}}
{{- define "mimir.ingesterFullname" -}}
{{ include "mimir.fullname" . }}-ingester
{{- end }}

{{/*
ingester common labels
*/}}
{{- define "mimir.ingesterLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-ingester
{{- else }}
app.kubernetes.io/component: ingester
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
ingester selector labels
*/}}
{{- define "mimir.ingesterSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-ingester
{{- else }}
app.kubernetes.io/component: ingester
{{- end }}
{{- end -}}

{{/*
GEM ingester Pod labels
*/}}
{{- define "mimir.gemIngesterPodLabels" -}}
name: ingester
target: ingester
gossip_ring_member: "true"
{{- end -}}

{{/*
ingester POD disruption budget template
*/}}
{{- define "mimir.ingesterPDB" -}}
{{- if .Values.ingester.podDisruptionBudget -}}
apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: {{ template "mimir.ingesterFullname" . }}
  labels:
    {{- include "mimir.ingesterLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
spec:
  selector:
    matchLabels:
      {{- include "mimir.ingesterSelectorLabels" . | nindent 6 }}
{{ toYaml .Values.ingester.podDisruptionBudget | indent 2 }}
{{- end -}}
{{- end -}}

{{/*
ingester Service Monitor template
*/}}
{{- define "mimir.ingesterServiceMonitor" -}}
{{- with .Values.serviceMonitor }}
{{- if .enabled }}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ template "mimir.ingesterFullname" $ }}
  {{- with .namespace }}
  namespace: {{ . }}
  {{- end }}
  labels:
    {{- include "mimir.ingesterLabels" $ | nindent 4 }}
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
      {{- include "mimir.ingesterSelectorLabels" $ | nindent 6 }}
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
ingester StatefulSet template
*/}}
{{- define "mimir.ingesterStatefulSet" -}}
{{- if .Values.ingester.statefulSet.enabled -}}
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ include "mimir.ingesterFullname" . }}
  labels:
    {{- include "mimir.ingesterLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
  annotations:
    {{- toYaml .Values.ingester.annotations | nindent 4 }}
spec:
  podManagementPolicy: {{ .Values.ingester.podManagementPolicy }}
  replicas: {{ .Values.ingester.replicas }}
  selector:
    matchLabels:
      {{- include "mimir.ingesterSelectorLabels" . | nindent 6 }}
  updateStrategy:
    {{- toYaml .Values.ingester.statefulStrategy | nindent 4 }}
  serviceName: {{ template "mimir.fullname" . }}-ingester-headless
  {{- if .Values.ingester.persistentVolume.enabled }}
  volumeClaimTemplates:
    - metadata:
        name: storage
        {{- if .Values.ingester.persistentVolume.annotations }}
        annotations:
          {{ toYaml .Values.ingester.persistentVolume.annotations | nindent 10 }}
        {{- end }}
      spec:
        {{- if .Values.ingester.persistentVolume.storageClass }}
        {{- if (eq "-" .Values.ingester.persistentVolume.storageClass) }}
        storageClassName: ""
        {{- else }}
        storageClassName: "{{ .Values.ingester.persistentVolume.storageClass }}"
        {{- end }}
        {{- end }}
        accessModes:
          {{ toYaml .Values.ingester.persistentVolume.accessModes | nindent 10 }}
        resources:
          requests:
            storage: "{{ .Values.ingester.persistentVolume.size }}"
  {{- end }}
  template:
    metadata:
      labels:
        {{- include "mimir.ingesterLabels" . | nindent 8 }}
        {{- if .Values.useGEMLabels }}{{- include "mimir.gemIngesterPodLabels" . | nindent 8 }}{{- end }}
        {{- with .Values.ingester.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      annotations:
        {{- if .Values.useExternalConfig }}
        checksum/config: {{ .Values.externalConfigVersion }}
        {{- else }}
        checksum/config: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
        {{- end }}
        {{- with .Values.ingester.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      serviceAccountName: {{ template "mimir.serviceAccountName" . }}
      {{- if .Values.ingester.priorityClassName }}
      priorityClassName: {{ .Values.ingester.priorityClassName }}
      {{- end }}
      securityContext:
        {{- toYaml .Values.ingester.securityContext | nindent 8 }}
      initContainers:
        {{- toYaml .Values.ingester.initContainers | nindent 8 }}
      {{- if .Values.image.pullSecrets }}
      imagePullSecrets:
      {{- range .Values.image.pullSecrets }}
        - name: {{ . }}
      {{- end }}
      {{- end }}
      nodeSelector:
        {{- toYaml .Values.ingester.nodeSelector | nindent 8 }}
      affinity:
        {{- toYaml .Values.ingester.affinity | nindent 8 }}
      tolerations:
        {{- toYaml .Values.ingester.tolerations | nindent 8 }}
      terminationGracePeriodSeconds: {{ .Values.ingester.terminationGracePeriodSeconds }}
      volumes:
        - name: config
          secret:
            secretName: {{ .Values.externalConfigSecretName }}
        - name: runtime-config
          configMap:
            name: {{ template "mimir.fullname" . }}-runtime
        {{- if not .Values.ingester.persistentVolume.enabled }}
        - name: storage
          emptyDir: {}
        {{- end }}
        {{- if .Values.ingester.extraVolumes }}
        {{ toYaml .Values.ingester.extraVolumes | nindent 8 }}
        {{- end }}
      containers:
        {{- if .Values.ingester.extraContainers }}
        {{ toYaml .Values.ingester.extraContainers | nindent 8 }}
        {{- end }}
        - name: ingester
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          args:
            - "-target=ingester"
            - -activity-tracker.filepath=
            - "-config.file=/etc/mimir/mimir.yaml"
            {{- range $key, $value := .Values.ingester.extraArgs }}
            - "-{{ $key }}={{ $value }}"
            {{- end }}
          volumeMounts:
            {{- if .Values.ingester.extraVolumeMounts }}
            {{ toYaml .Values.ingester.extraVolumeMounts | nindent 12}}
            {{- end }}
            - name: config
              mountPath: /etc/mimir
            - name: runtime-config
              mountPath: /var/mimir
            - name: storage
              mountPath: "/data"
              {{- if .Values.ingester.persistentVolume.subPath }}
              subPath: {{ .Values.ingester.persistentVolume.subPath }}
              {{- else }}
              {{- end }}
          ports:
            - name: http-metrics
              containerPort: {{ include "mimir.serverHttpListenPort" . }}
              protocol: TCP
            - name: grpc
              containerPort: {{ include "mimir.serverGrpcListenPort" . }}
              protocol: TCP
          livenessProbe:
            {{- toYaml .Values.ingester.livenessProbe | nindent 12 }}
          readinessProbe:
            {{- toYaml .Values.ingester.readinessProbe | nindent 12 }}
          resources:
            {{- toYaml .Values.ingester.resources | nindent 12 }}
          securityContext:
            readOnlyRootFilesystem: true
          env:
            {{- if .Values.ingester.env }}
              {{- toYaml .Values.ingester.env | nindent 12 }}
            {{- end }}
{{- end -}}
{{- end -}}

{{/*
ingester Headless Service template
*/}}
{{- define "mimir.ingesterHeadless" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "mimir.ingesterFullname" . }}-headless
  labels:
    {{- include "mimir.ingesterLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
    {{- with .Values.ingester.service.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- toYaml .Values.ingester.service.annotations | nindent 4 }}
spec:
  type: ClusterIP
  clusterIP: None
  ports:
    - port: {{ include "mimir.serverGrpcListenPort" . }}
      protocol: TCP
      name: grpc
      targetPort: grpc
  selector:
    {{- include "mimir.ingesterSelectorLabels" . | nindent 4 }}
{{- end -}}

{{/*
ingester Service template
*/}}
{{- define "mimir.ingesterService" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "mimir.ingesterFullname" . }}
  labels:
    {{- include "mimir.ingesterLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
    {{- with .Values.ingester.service.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- toYaml .Values.ingester.service.annotations | nindent 4 }}
spec:
  type: ClusterIP
  ports:
    - port: {{ include "mimir.serverHttpListenPort" .}}
      protocol: TCP
      name: http-metrics
      targetPort: http-metrics
    - port: {{ include "mimir.serverGrpcListenPort" . }}
      protocol: TCP
      name: grpc
      targetPort: grpc
  selector:
    {{- include "mimir.ingesterSelectorLabels" . | nindent 4 }}
{{- end -}}