{{/*
ruler fullname
*/}}
{{- define "mimir.rulerFullname" -}}
{{ include "mimir.fullname" . }}-ruler
{{- end }}

{{/*
ruler common labels
*/}}
{{- define "mimir.rulerLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-ruler
{{- else }}
app.kubernetes.io/component: ruler
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
ruler selector labels
*/}}
{{- define "mimir.rulerSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-ruler
{{- else }}
app.kubernetes.io/component: ruler
{{- end }}
{{- end -}}

{{/*
GEM ruler Pod labels
*/}}
{{- define "mimir.gemRulerPodLabels" -}}
name: ruler
target: ruler
gossip_ring_member: "true"
{{- end -}}

{{/*
ruler deployment template
*/}}
{{- define "mimir.rulerDeployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "mimir.rulerFullname" . }}
  labels:
    {{- include "mimir.rulerLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
  annotations:
    {{- toYaml .Values.ruler.annotations | nindent 4 }}
spec:
  replicas: {{ .Values.ruler.replicas }}
  selector:
    matchLabels:
      {{- include "mimir.rulerSelectorLabels" . | nindent 6 }}
  strategy:
    {{- toYaml .Values.ruler.strategy | nindent 4 }}
  template:
    metadata:
      labels:
        {{- include "mimir.rulerLabels" . | nindent 8 }}
        {{- if .Values.useGEMLabels }}{{- include "mimir.gemRulerPodLabels" . | nindent 8 }}{{- end }}
        {{- with .Values.ruler.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      annotations:
{{- if .Values.useExternalConfig }}
        checksum/config: {{ .Values.externalConfigVersion }}
{{- else }}
        checksum/config: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
{{- end}}
        {{- with .Values.ruler.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      serviceAccountName: {{ template "mimir.serviceAccountName" . }}
    {{- if .Values.ruler.priorityClassName }}
      priorityClassName: {{ .Values.ruler.priorityClassName }}
    {{- end }}
      securityContext:
        {{- toYaml .Values.ruler.securityContext | nindent 8 }}
      initContainers:
        {{- toYaml .Values.ruler.initContainers | nindent 8 }}
      {{- if .Values.image.pullSecrets }}
      imagePullSecrets:
      {{- range .Values.image.pullSecrets }}
        - name: {{ . }}
      {{- end}}
      {{- end }}
      containers:
        - name: ruler
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          args:
            - "-target=ruler"
            - -activity-tracker.filepath=/active-query-tracker/activity.log
            - "-config.file=/etc/mimir/mimir.yaml"
          {{- range $key, $value := .Values.ruler.extraArgs }}
            - "-{{ $key }}={{ $value }}"
          {{- end }}
          volumeMounts:
            {{- if .Values.ruler.extraVolumeMounts }}
              {{ toYaml .Values.ruler.extraVolumeMounts | nindent 12}}
            {{- end }}
            - name: config
              mountPath: /etc/mimir
            - name: runtime-config
              mountPath: /var/mimir
            - name: storage
              mountPath: "/data"
              subPath: {{ .Values.ruler.persistence.subPath }}
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
            {{- toYaml .Values.ruler.livenessProbe | nindent 12 }}
          readinessProbe:
            {{- toYaml .Values.ruler.readinessProbe | nindent 12 }}
          resources:
            {{- toYaml .Values.ruler.resources | nindent 12 }}
          securityContext:
            readOnlyRootFilesystem: true
          env:
            {{- if .Values.ruler.env }}
              {{- toYaml .Values.ruler.env | nindent 12 }}
            {{- end }}
{{- if .Values.ruler.extraContainers }}
{{ toYaml .Values.ruler.extraContainers | indent 8}}
{{- end }}
      nodeSelector:
        {{- toYaml .Values.ruler.nodeSelector | nindent 8 }}
      affinity:
        {{- toYaml .Values.ruler.affinity | nindent 8 }}
      tolerations:
        {{- toYaml .Values.ruler.tolerations | nindent 8 }}
      terminationGracePeriodSeconds: {{ .Values.ruler.terminationGracePeriodSeconds }}
      volumes:
        - name: config
          secret:
            secretName: {{ .Values.externalConfigSecretName }}
        - name: runtime-config
          configMap:
            name: {{ template "mimir.fullname" . }}-runtime
{{- if .Values.ruler.extraVolumes }}
{{ toYaml .Values.ruler.extraVolumes | indent 8}}
{{- end }}
        - name: storage
          emptyDir: {}
        - name: active-queries
          emptyDir: {}
{{- end -}}

{{/*
ruler POD disruption budget template
*/}}
{{- define "mimir.rulerPDB" -}}
{{- if .Values.ruler.podDisruptionBudget -}}
apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: {{ template "mimir.rulerFullname" . }}
  labels:
    {{- include "mimir.rulerLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
spec:
  selector:
    matchLabels:
      {{- include "mimir.rulerSelectorLabels" . | nindent 6 }}
{{ toYaml .Values.ruler.podDisruptionBudget | indent 2 }}
{{- end -}}
{{- end -}}

{{/*
ruler Service Monitor template
*/}}
{{- define "mimir.rulerServiceMonitor" -}}
{{- with .Values.serviceMonitor }}
{{- if .enabled }}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ template "mimir.rulerFullname" $ }}
  {{- with .namespace }}
  namespace: {{ . }}
  {{- end }}
  labels:
    {{- include "mimir.rulerLabels" $ | nindent 4 }}
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
      {{- include "mimir.rulerSelectorLabels" $ | nindent 6 }}
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
ruler Service template
*/}}
{{- define "mimir.rulerService" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "mimir.rulerFullname" . }}
  labels:
    {{- include "mimir.rulerLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
    {{- with .Values.ruler.service.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- toYaml .Values.ruler.service.annotations | nindent 4 }}
spec:
  type: ClusterIP
  ports:
    - port: {{ include "mimir.serverHttpListenPort" . }}
      protocol: TCP
      name: http-metrics
      targetPort: http-metrics
  selector:
    {{- include "mimir.rulerSelectorLabels" . | nindent 4 }}
{{- end -}}