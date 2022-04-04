{{/*
querier fullname
*/}}
{{- define "mimir.querierFullname" -}}
{{ include "mimir.fullname" . }}-querier
{{- end }}

{{/*
querier common labels
*/}}
{{- define "mimir.querierLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-querier
{{- else }}
app.kubernetes.io/component: querier
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
querier selector labels
*/}}
{{- define "mimir.querierSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-querier
{{- else }}
app.kubernetes.io/component: querier
{{- end }}
{{- end -}}

{{/*
GEM querier Pod labels
*/}}
{{- define "mimir.gemQuerierPodLabels" -}}
name: querier
target: querier
{{- end -}}


{{/*
querier deployment template
*/}}
{{- define "mimir.querierDeployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "mimir.querierFullname" . }}
  labels:
    {{- include "mimir.querierLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
  annotations:
    {{- toYaml .Values.querier.annotations | nindent 4 }}
spec:
  replicas: {{ .Values.querier.replicas }}
  selector:
    matchLabels:
      {{- include "mimir.querierSelectorLabels" . | nindent 6 }}
  strategy:
    {{- toYaml .Values.querier.strategy | nindent 4 }}
  template:
    metadata:
      labels:
        {{- include "mimir.querierLabels" . | nindent 8 }}
        {{- if .Values.useGEMLabels }}{{- include "mimir.gemQuerierPodLabels" . | nindent 8 }}{{- end }}
        {{- with .Values.querier.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      annotations:
{{- if .Values.useExternalConfig }}
        checksum/config: {{ .Values.externalConfigVersion }}
{{- else }}
        checksum/config: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
{{- end}}
        {{- with .Values.querier.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      serviceAccountName: {{ template "mimir.serviceAccountName" . }}
    {{- if .Values.querier.priorityClassName }}
      priorityClassName: {{ .Values.querier.priorityClassName }}
    {{- end }}
      securityContext:
        {{- toYaml .Values.querier.securityContext | nindent 8 }}
      initContainers:
        {{- toYaml .Values.querier.initContainers | nindent 8 }}
      {{- if .Values.image.pullSecrets }}
      imagePullSecrets:
      {{- range .Values.image.pullSecrets }}
        - name: {{ . }}
      {{- end}}
      {{- end }}
      containers:
        - name: querier
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          args:
            - "-target=querier"
            - -activity-tracker.filepath=/active-query-tracker/activity.log
            - "-config.file=/etc/mimir/mimir.yaml"
          {{- range $key, $value := .Values.querier.extraArgs }}
            - "-{{ $key }}={{ $value }}"
          {{- end }}
          volumeMounts:
            {{- if .Values.querier.extraVolumeMounts }}
              {{ toYaml .Values.querier.extraVolumeMounts | nindent 12}}
            {{- end }}
            - name: config
              mountPath: /etc/mimir
            - name: runtime-config
              mountPath: /var/mimir
            - name: storage
              mountPath: "/data"
              subPath: {{ .Values.querier.persistence.subPath }}
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
            {{- toYaml .Values.querier.livenessProbe | nindent 12 }}
          readinessProbe:
            {{- toYaml .Values.querier.readinessProbe | nindent 12 }}
          resources:
            {{- toYaml .Values.querier.resources | nindent 12 }}
          securityContext:
            readOnlyRootFilesystem: true
          env:
            {{- if .Values.querier.env }}
              {{- toYaml .Values.querier.env | nindent 12 }}
            {{- end }}
{{- if .Values.querier.extraContainers }}
{{ toYaml .Values.querier.extraContainers | indent 8}}
{{- end }}
      nodeSelector:
        {{- toYaml .Values.querier.nodeSelector | nindent 8 }}
      affinity:
        {{- toYaml .Values.querier.affinity | nindent 8 }}
      tolerations:
        {{- toYaml .Values.querier.tolerations | nindent 8 }}
      terminationGracePeriodSeconds: {{ .Values.querier.terminationGracePeriodSeconds }}
      volumes:
        - name: config
          secret:
            secretName: {{ .Values.externalConfigSecretName }}
        - name: runtime-config
          configMap:
            name: {{ template "mimir.fullname" . }}-runtime
{{- if .Values.querier.extraVolumes }}
{{ toYaml .Values.querier.extraVolumes | indent 8}}
{{- end }}
        - name: storage
          emptyDir: {}
        - name: active-queries
          emptyDir: {}
{{- end -}}

{{/*
querier POD disruption budget template
*/}}
{{- define "mimir.querierPDB" -}}
{{- if .Values.querier.podDisruptionBudget -}}
apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: {{ template "mimir.querierFullname" . }}
  labels:
    {{- include "mimir.querierLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
spec:
  selector:
    matchLabels:
      {{- include "mimir.querierSelectorLabels" . | nindent 6 }}
{{ toYaml .Values.querier.podDisruptionBudget | indent 2 }}
{{- end -}}
{{- end -}}

{{/*
querier Service Monitor template
*/}}
{{- define "mimir.querierServiceMonitor" -}}
{{- with .Values.serviceMonitor }}
{{- if .enabled }}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ template "mimir.querierFullname" $ }}
  {{- with .namespace }}
  namespace: {{ . }}
  {{- end }}
  labels:
    {{- include "mimir.querierLabels" $ | nindent 4 }}
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
      {{- include "mimir.querierSelectorLabels" $ | nindent 6 }}
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
querier Service template
*/}}
{{- define "mimir.querierService" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "mimir.querierFullname" . }}
  labels:
    {{- include "mimir.querierLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
    {{- with .Values.querier.service.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- toYaml .Values.querier.service.annotations | nindent 4 }}
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
    {{- include "mimir.querierSelectorLabels" . | nindent 4 }}
{{- end -}}