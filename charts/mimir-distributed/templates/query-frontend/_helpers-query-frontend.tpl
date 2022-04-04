{{/*
query-frontend fullname
*/}}
{{- define "mimir.queryFrontendFullname" -}}
{{ include "mimir.fullname" . }}-query-frontend
{{- end }}

{{/*
query-frontend common labels
*/}}
{{- define "mimir.queryFrontendLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-query-frontend
{{- else }}
app.kubernetes.io/component: query-frontend
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
query-frontend selector labels
*/}}
{{- define "mimir.queryFrontendSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-query-frontend
{{- else }}
app.kubernetes.io/component: query-frontend
{{- end }}
{{- end -}}

{{/*
GEM query-frontend Pod labels
*/}}
{{- define "mimir.gemQueryFrontendPodLabels" -}}
name: query-frontend
target: query-frontend
{{- end -}}

{{/*
query-frontend deployment template
*/}}
{{- define "mimir.queryFrontendDeployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "mimir.queryFrontendFullname" . }}
  labels:
    {{- include "mimir.queryFrontendLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
  annotations:
    {{- toYaml .Values.query_frontend.annotations | nindent 4 }}
spec:
  replicas: {{ .Values.query_frontend.replicas }}
  selector:
    matchLabels:
      {{- include "mimir.queryFrontendSelectorLabels" . | nindent 6 }}
  strategy:
    {{- toYaml .Values.query_frontend.strategy | nindent 4 }}
  template:
    metadata:
      labels:
        {{- include "mimir.queryFrontendLabels" . | nindent 8 }}
        {{- if .Values.useGEMLabels }}{{- include "mimir.gemQueryFrontendPodLabels" . | nindent 8 }}{{- end }}
        {{- with .Values.query_frontend.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      annotations:
{{- if .Values.useExternalConfig }}
        checksum/config: {{ .Values.externalConfigVersion }}
{{- else }}
        checksum/config: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
{{- end}}
        {{- with .Values.query_frontend.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      serviceAccountName: {{ template "mimir.serviceAccountName" . }}
    {{- if .Values.query_frontend.priorityClassName }}
      priorityClassName: {{ .Values.query_frontend.priorityClassName }}
    {{- end }}
      securityContext:
        {{- toYaml .Values.query_frontend.securityContext | nindent 8 }}
      initContainers:
        {{- toYaml .Values.query_frontend.initContainers | nindent 8 }}
      {{- if .Values.image.pullSecrets }}
      imagePullSecrets:
      {{- range .Values.image.pullSecrets }}
        - name: {{ . }}
      {{- end}}
      {{- end }}
      containers:
        - name: query-frontend
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          args:
            - -activity-tracker.filepath=/active-query-tracker/activity.log
            - "-target=query-frontend"
            - "-config.file=/etc/mimir/mimir.yaml"
          {{- range $key, $value := .Values.query_frontend.extraArgs }}
            - "-{{ $key }}={{ $value }}"
          {{- end }}
          volumeMounts:
            {{- if .Values.query_frontend.extraVolumeMounts }}
              {{ toYaml .Values.query_frontend.extraVolumeMounts | nindent 12}}
            {{- end }}
            - name: runtime-config
              mountPath: /var/mimir
            - name: config
              mountPath: /etc/mimir
            - name: storage
              mountPath: /data
              {{- if .Values.query_frontend.persistence.subPath }}
              subPath: {{ .Values.query_frontend.persistence.subPath }}
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
            {{- toYaml .Values.query_frontend.livenessProbe | nindent 12 }}
          readinessProbe:
            {{- toYaml .Values.query_frontend.readinessProbe | nindent 12 }}
          resources:
            {{- toYaml .Values.query_frontend.resources | nindent 12 }}
          securityContext:
            readOnlyRootFilesystem: true
          env:
            {{- if .Values.query_frontend.env }}
              {{- toYaml .Values.query_frontend.env | nindent 12 }}
            {{- end }}
{{- if .Values.query_frontend.extraContainers }}
{{ toYaml .Values.query_frontend.extraContainers | indent 8}}
{{- end }}
      nodeSelector:
        {{- toYaml .Values.query_frontend.nodeSelector | nindent 8 }}
      affinity:
        {{- toYaml .Values.query_frontend.affinity | nindent 8 }}
      tolerations:
        {{- toYaml .Values.query_frontend.tolerations | nindent 8 }}
      terminationGracePeriodSeconds: {{ .Values.query_frontend.terminationGracePeriodSeconds }}
      volumes:
        - name: config
          secret:
            secretName: {{ .Values.externalConfigSecretName }}
        - name: runtime-config
          configMap:
            name: {{ template "mimir.fullname" . }}-runtime
{{- if .Values.query_frontend.extraVolumes }}
{{ toYaml .Values.query_frontend.extraVolumes | indent 8}}
{{- end }}
        - name: storage
          emptyDir: {}
        - name: active-queries
          emptyDir: {}
{{- end -}}

{{/*
query-frontend POD disruption budget template
*/}}
{{- define "mimir.queryFrontendPDB" -}}
{{- if .Values.query_frontend.podDisruptionBudget -}}
apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: {{ template "mimir.queryFrontendFullname" . }}
  labels:
    {{- include "mimir.queryFrontendLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
spec:
  selector:
    matchLabels:
      {{- include "mimir.queryFrontendSelectorLabels" . | nindent 6 }}
{{ toYaml .Values.query_frontend.podDisruptionBudget | indent 2 }}
{{- end -}}
{{- end -}}

{{/*
query-frontend Service Monitor template
*/}}
{{- define "mimir.queryFrontendServiceMonitor" -}}
{{- with .Values.serviceMonitor }}
{{- if .enabled }}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ template "mimir.queryFrontendFullname" $ }}
  {{- with .namespace }}
  namespace: {{ . }}
  {{- end }}
  labels:
    {{- include "mimir.queryFrontendLabels" $ | nindent 4 }}
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
      {{- include "mimir.queryFrontendSelectorLabels" $ | nindent 6 }}
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
query-frontend Headless template
*/}}
{{- define "mimir.queryFrontendHeadless" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ template "mimir.fullname" . }}-query-frontend-headless
  labels:
    {{- include "mimir.queryFrontendLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
    {{- with .Values.query_frontend.service.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- toYaml .Values.query_frontend.service.annotations | nindent 4 }}
spec:
  type: ClusterIP
  clusterIP: None
  publishNotReadyAddresses: true
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
    {{- include "mimir.queryFrontendSelectorLabels" . | nindent 4 }}
{{- end -}}

{{/*
query-frontend Service template
*/}}
{{- define "mimir.queryFrontendService" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "mimir.queryFrontendFullname" . }}
  labels:
    {{- include "mimir.queryFrontendLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
    {{- with .Values.query_frontend.service.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- toYaml .Values.query_frontend.service.annotations | nindent 4 }}
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
    {{- include "mimir.queryFrontendSelectorLabels" . | nindent 4 }}
{{- end -}}