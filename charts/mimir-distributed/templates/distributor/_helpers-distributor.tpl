{{/*
distributor fullname
*/}}
{{- define "mimir.distributorFullname" -}}
{{ include "mimir.fullname" . }}-distributor
{{- end }}

{{/*
distributor common labels
*/}}
{{- define "mimir.distributorLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-distributor
{{- else }}
app.kubernetes.io/component: distributor
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
distributor selector labels
*/}}
{{- define "mimir.distributorSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-distributor
{{- else }}
app.kubernetes.io/component: distributor
{{- end }}
{{- end -}}

{{/*
GEM distributor Pod labels
*/}}
{{- define "mimir.gemDistributorPodLabels" -}}
name: distributor
target: distributor
gossip_ring_member: "true"
{{- end -}}

{{/*
Distributor deployment template
*/}}
{{- define "mimir.distributorDeployment" }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "mimir.distributorFullname" . }}
  labels:
    {{- include "mimir.distributorLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
  annotations:
    {{- toYaml .Values.distributor.annotations | nindent 4 }}
spec:
  replicas: {{ .Values.distributor.replicas }}
  selector:
    matchLabels:
      {{- include "mimir.distributorSelectorLabels" . | nindent 6 }}
  strategy:
    {{- toYaml .Values.distributor.strategy | nindent 4 }}
  template:
    metadata:
      labels:
        {{- include "mimir.distributorLabels" . | nindent 8 }}
        {{- if .Values.useGEMLabels }}{{- include "mimir.gemDistributorPodLabels" . | nindent 8 }}{{- end }}
        {{- with .Values.distributor.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      annotations:
{{- if .Values.useExternalConfig }}
        checksum/config: {{ .Values.externalConfigVersion }}
{{- else }}
        checksum/config: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
{{- end}}
        {{- with .Values.distributor.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      serviceAccountName: {{ template "mimir.serviceAccountName" . }}
    {{- if .Values.distributor.priorityClassName }}
      priorityClassName: {{ .Values.distributor.priorityClassName }}
    {{- end }}
      securityContext:
        {{- toYaml .Values.distributor.securityContext | nindent 8 }}
      initContainers:
        {{- toYaml .Values.distributor.initContainers | nindent 8 }}
      {{- if .Values.image.pullSecrets }}
      imagePullSecrets:
      {{- range .Values.image.pullSecrets }}
        - name: {{ . }}
      {{- end}}
      {{- end }}
      containers:
        - name: distributor
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          args:
            - "-target=distributor"
            - -activity-tracker.filepath=
            - "-config.file=/etc/mimir/mimir.yaml"
          {{- range $key, $value := .Values.distributor.extraArgs }}
            - "-{{ $key }}={{ $value }}"
          {{- end }}
          volumeMounts:
            {{- if .Values.distributor.extraVolumeMounts }}
              {{ toYaml .Values.distributor.extraVolumeMounts | nindent 12}}
            {{- end }}
            - name: config
              mountPath: /etc/mimir
            - name: runtime-config
              mountPath: /var/mimir
            - name: storage
              mountPath: "/data"
              subPath: {{ .Values.distributor.persistence.subPath }}
          ports:
            - name: http-metrics
              containerPort: {{ include "mimir.serverHttpListenPort" . }}
              protocol: TCP
            - name: grpc
              containerPort: {{ include "mimir.serverGrpcListenPort" . }}
              protocol: TCP
          livenessProbe:
            {{- toYaml .Values.distributor.livenessProbe | nindent 12 }}
          readinessProbe:
            {{- toYaml .Values.distributor.readinessProbe | nindent 12 }}
          resources:
            {{- toYaml .Values.distributor.resources | nindent 12 }}
          securityContext:
            readOnlyRootFilesystem: true
          env:
            {{- if .Values.distributor.env }}
              {{- toYaml .Values.distributor.env | nindent 12 }}
            {{- end }}
{{- if .Values.distributor.extraContainers }}
{{ toYaml .Values.distributor.extraContainers | indent 8}}
{{- end }}
      nodeSelector:
        {{- toYaml .Values.distributor.nodeSelector | nindent 8 }}
      affinity:
        {{- toYaml .Values.distributor.affinity | nindent 8 }}
      tolerations:
        {{- toYaml .Values.distributor.tolerations | nindent 8 }}
      terminationGracePeriodSeconds: {{ .Values.distributor.terminationGracePeriodSeconds }}
      volumes:
        - name: config
          secret:
            secretName: {{ .Values.externalConfigSecretName }}
        - name: runtime-config
          configMap:
            name: {{ template "mimir.fullname" . }}-runtime
{{- if .Values.distributor.extraVolumes }}
{{ toYaml .Values.distributor.extraVolumes | indent 8}}
{{- end }}
        - name: storage
          emptyDir: {}
{{- end -}}

{{/*
Distributor POD disruption budget template
*/}}
{{- define "mimir.distributorPDB" -}}
{{- if .Values.distributor.podDisruptionBudget -}}
apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: {{ template "mimir.distributorFullname" . }}
  labels:
    {{- include "mimir.distributorLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
spec:
  selector:
    matchLabels:
      {{- include "mimir.distributorSelectorLabels" . | nindent 6 }}
{{ toYaml .Values.distributor.podDisruptionBudget | indent 2 }}
{{- end -}}
{{- end -}}

{{/*
Distributor Service Monitor template
*/}}
{{- define "mimir.distributorServiceMonitor" -}}
{{- with .Values.serviceMonitor }}
{{- if .enabled }}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ template "mimir.distributorFullname" $ }}
  {{- with .namespace }}
  namespace: {{ . }}
  {{- end }}
  labels:
    {{- include "mimir.distributorLabels" $ | nindent 4 }}
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
      {{- include "mimir.distributorSelectorLabels" $ | nindent 6 }}
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
Distributor Service template
*/}}
{{- define "mimir.distributorService" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "mimir.distributorFullname" . }}
  labels:
    {{- include "mimir.distributorLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
    {{- with .Values.distributor.service.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- toYaml .Values.distributor.service.annotations | nindent 4 }}
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
    {{- include "mimir.distributorSelectorLabels" . | nindent 4 }}
{{- end -}}