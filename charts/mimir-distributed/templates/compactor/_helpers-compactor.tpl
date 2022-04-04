{{/*
compactor fullname
*/}}
{{- define "mimir.compactorFullname" -}}
{{ include "mimir.fullname" . }}-compactor
{{- end }}

{{/*
compactor common labels
*/}}
{{- define "mimir.compactorLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-compactor
{{- else }}
app.kubernetes.io/component: compactor
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
compactor selector labels
*/}}
{{- define "mimir.compactorSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-compactor
{{- else }}
app.kubernetes.io/component: compactor
{{- end }}
{{- end -}}

{{/*
GEM compactor Pod labels
*/}}
{{- define "mimir.gemCompactorPodLabels" -}}
name: compactor
target: compactor
gossip_ring_member: "true"
{{- end -}}

{{/*
Compactor POD disruption budget template
*/}}
{{- define "mimir.compactorPDB" -}}
{{- if .Values.compactor.enabled -}}
{{- if .Values.compactor.podDisruptionBudget -}}
apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: {{ template "mimir.compactorFullname" . }}
  labels:
    {{- include "mimir.compactorLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
spec:
  selector:
    matchLabels:
      {{- include "mimir.compactorSelectorLabels" . | nindent 6 }}
{{ toYaml .Values.compactor.podDisruptionBudget | indent 2 }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Compactor Service Monitor template
*/}}
{{- define "mimir.compactorServiceMonitor" -}}
{{- if .Values.compactor.enabled -}}
{{- with .Values.serviceMonitor }}
{{- if .enabled }}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ template "mimir.compactorFullname" $ }}
  {{- with .namespace }}
  namespace: {{ . }}
  {{- end }}
  labels:
    {{- include "mimir.compactorLabels" $ | nindent 4 }}
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
      {{- include "mimir.compactorSelectorLabels" $ | nindent 6 }}
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
{{- end -}}

{{/*
Compactor StatefulSet template
*/}}
{{- define "mimir.compactorStatefulSet" -}}
{{- if .Values.compactor.enabled -}}
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ include "mimir.compactorFullname" . }}
  labels:
    {{- include "mimir.compactorLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
  annotations:
    {{- toYaml .Values.compactor.annotations | nindent 4 }}
spec:
  replicas: {{ .Values.compactor.replicas }}
  selector:
    matchLabels:
      {{- include "mimir.compactorSelectorLabels" . | nindent 6 }}
  updateStrategy:
    {{- toYaml .Values.compactor.strategy | nindent 4 }}
  serviceName: {{ template "mimir.fullname" . }}-compactor
  {{- if .Values.compactor.persistentVolume.enabled }}
  volumeClaimTemplates:
    - metadata:
        name: storage
        {{- if .Values.compactor.persistentVolume.annotations }}
        annotations:
          {{ toYaml .Values.compactor.persistentVolume.annotations | nindent 10 }}
        {{- end }}
      spec:
        {{- if .Values.compactor.persistentVolume.storageClass }}
        {{- if (eq "-" .Values.compactor.persistentVolume.storageClass) }}
        storageClassName: ""
        {{- else }}
        storageClassName: "{{ .Values.compactor.persistentVolume.storageClass }}"
        {{- end }}
        {{- end }}
        accessModes:
          {{ toYaml .Values.compactor.persistentVolume.accessModes | nindent 10 }}
        resources:
          requests:
            storage: "{{ .Values.compactor.persistentVolume.size }}"
  {{- end }}
  template:
    metadata:
      labels:
        {{- include "mimir.compactorLabels" . | nindent 8 }}
        {{- if .Values.useGEMLabels }}{{- include "mimir.gemCompactorPodLabels" . | nindent 8 }}{{- end }}
        {{- with .Values.compactor.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      annotations:
        {{- if .Values.useExternalConfig }}
        checksum/config: {{ .Values.externalConfigVersion }}
        {{- else }}
        checksum/config: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
        {{- end }}
        {{- with .Values.compactor.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      serviceAccountName: {{ template "mimir.serviceAccountName" . }}
      {{- if .Values.compactor.priorityClassName }}
      priorityClassName: {{ .Values.compactor.priorityClassName }}
      {{- end }}
      securityContext:
        {{- toYaml .Values.compactor.securityContext | nindent 8 }}
      initContainers:
        {{- toYaml .Values.compactor.initContainers | nindent 8 }}
      {{- if .Values.image.pullSecrets }}
      imagePullSecrets:
      {{- range .Values.image.pullSecrets }}
        - name: {{ . }}
      {{- end }}
      {{- end }}
      nodeSelector:
        {{- toYaml .Values.compactor.nodeSelector | nindent 8 }}
      affinity:
        {{- toYaml .Values.compactor.affinity | nindent 8 }}
      tolerations:
        {{- toYaml .Values.compactor.tolerations | nindent 8 }}
      terminationGracePeriodSeconds: {{ .Values.compactor.terminationGracePeriodSeconds }}
      volumes:
        - name: config
          secret:
            secretName: {{ .Values.externalConfigSecretName }}
        - name: runtime-config
          configMap:
            name: {{ template "mimir.fullname" . }}-runtime
        {{- if not .Values.compactor.persistentVolume.enabled }}
        - name: storage
          emptyDir: {}
        {{- end }}
        {{- if .Values.compactor.extraVolumes }}
        {{ toYaml .Values.compactor.extraVolumes | nindent 8 }}
        {{- end }}
      containers:
        {{- if .Values.compactor.extraContainers }}
        {{ toYaml .Values.compactor.extraContainers | nindent 8 }}
        {{- end }}
        - name: compactor
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          args:
            - "-target=compactor"
            - -activity-tracker.filepath=
            - "-config.file=/etc/mimir/mimir.yaml"
            {{- range $key, $value := .Values.compactor.extraArgs }}
            - "-{{ $key }}={{ $value }}"
            {{- end }}
          volumeMounts:
            {{- if .Values.compactor.extraVolumeMounts }}
            {{ toYaml .Values.compactor.extraVolumeMounts | nindent 12}}
            {{- end }}
            - name: config
              mountPath: /etc/mimir
            - name: runtime-config
              mountPath: /var/mimir
            - name: storage
              mountPath: "/data"
              {{- if .Values.compactor.persistentVolume.subPath }}
              subPath: {{ .Values.compactor.persistentVolume.subPath }}
              {{- end }}
          ports:
            - name: http-metrics
              containerPort: {{ include "mimir.serverHttpListenPort" . }}
              protocol: TCP
            - name: grpc
              containerPort: {{ include "mimir.serverGrpcListenPort" . }}
              protocol: TCP
          livenessProbe:
            {{- toYaml .Values.compactor.livenessProbe | nindent 12 }}
          readinessProbe:
            {{- toYaml .Values.compactor.readinessProbe | nindent 12 }}
          resources:
            {{- toYaml .Values.compactor.resources | nindent 12 }}
          securityContext:
            readOnlyRootFilesystem: true
          env:
            {{- if .Values.compactor.env }}
              {{- toYaml .Values.compactor.env | nindent 12 }}
            {{- end }}
{{- end -}}
{{- end -}}

{{/*
Compactor Service template
*/}}
{{- define "mimir.compactorService" -}}
{{- if .Values.compactor.enabled -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "mimir.compactorFullname" . }}
  labels:
    {{- include "mimir.compactorLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
    {{- with .Values.compactor.service.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- toYaml .Values.compactor.service.annotations | nindent 4 }}
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
    {{- include "mimir.compactorSelectorLabels" . | nindent 4 }}
{{- end -}}
{{- end -}}