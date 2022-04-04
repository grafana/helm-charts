{{/*
overrides-exporter fullname
*/}}
{{- define "mimir.overridesExporterFullname" -}}
{{ include "mimir.fullname" . }}-overrides-exporter
{{- end }}

{{/*
overrides-exporter common labels
*/}}
{{- define "mimir.overridesExporterLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-overrides-exporter
{{- else }}
app.kubernetes.io/component: overrides-exporter
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
overrides-exporter selector labels
*/}}
{{- define "mimir.overridesExporterSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-overrides-exporter
{{- else }}
app.kubernetes.io/component: overrides-exporter
{{- end }}
{{- end -}}

{{/*
GEM overrides-exporter Pod labels
*/}}
{{- define "mimir.gemOverridesExporterPodLabels" -}}
name: overrides-exporter
target: overrides-exporter
{{- end -}}

{{/*
overrides-exporter deployment template
*/}}
{{- define "mimir.overridesExporterDeployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    {{- toYaml .Values.overrides_exporter.annotations | nindent 4 }}
  labels:
    {{- include "mimir.overridesExporterLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
  name: {{ include "mimir.overridesExporterFullname" . }}
spec:
  replicas: {{ .Values.overrides_exporter.replicas }}
  selector:
    matchLabels:
      {{- include "mimir.overridesExporterSelectorLabels" . | nindent 6 }}
  strategy:
    {{- toYaml .Values.overrides_exporter.strategy | nindent 4 }}
  template:
    metadata:
      labels:
        {{- include "mimir.overridesExporterLabels" . | nindent 8 }}
        {{- if .Values.useGEMLabels }}{{- include "mimir.gemOverridesExporterPodLabels" . | nindent 8 }}{{- end }}
        {{- with .Values.overrides_exporter.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      annotations:
        {{- if .Values.useExternalConfig }}
        checksum/config: {{ .Values.externalConfigVersion }}
        {{- else }}
        checksum/config: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
        {{- end}}
        {{- with .Values.overrides_exporter.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      serviceAccountName: {{ template "mimir.serviceAccountName" . }}
      {{- if .Values.overrides_exporter.priorityClassName }}
      priorityClassName: {{ .Values.overrides_exporter.priorityClassName }}
      {{- end }}
      securityContext:
        {{- toYaml .Values.overrides_exporter.securityContext | nindent 8 }}
      {{- if .Values.image.pullSecrets }}
      imagePullSecrets:
      {{- range .Values.image.pullSecrets }}
        - name: {{ . }}
      {{- end }}
      {{- end }}
      initContainers:
        {{- toYaml .Values.overrides_exporter.initContainers | nindent 8 }}
      containers:
        - name: overrides-exporter
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          args:
            - "-target=overrides-exporter"
            - -activity-tracker.filepath=
            - "-config.file=/etc/mimir/mimir.yaml"
            {{- range $key, $value := .Values.overrides_exporter.extraArgs }}
            - "-{{ $key }}={{ $value }}"
            {{- end }}
          volumeMounts:
            {{- if .Values.overrides_exporter.extraVolumeMounts }}
              {{ toYaml .Values.overrides_exporter.extraVolumeMounts | nindent 12}}
            {{- end }}
            - name: config
              mountPath: /etc/mimir
            - name: runtime-config
              mountPath: /var/mimir
            - name: storage
              mountPath: "/data"
              subPath: {{ .Values.overrides_exporter.persistence.subPath }}
          ports:
            - name: http-metrics
              containerPort: {{ include "mimir.serverHttpListenPort" . }}
              protocol: TCP
            - name: grpc
              containerPort: {{ include "mimir.serverGrpcListenPort" . }}
              protocol: TCP
          livenessProbe:
            {{- toYaml .Values.overrides_exporter.livenessProbe | nindent 12 }}
          readinessProbe:
            {{- toYaml .Values.overrides_exporter.readinessProbe | nindent 12 }}
          resources:
            {{- toYaml .Values.overrides_exporter.resources | nindent 12 }}
          securityContext:
            readOnlyRootFilesystem: true
          env:
            {{- if .Values.overrides_exporter.env }}
            {{ toYaml .Values.overrides_exporter.env | nindent 12 }}
            {{- end }}
        {{- with .Values.overrides_exporter.extraContainers }}
        {{ toYaml . | nindent 8 }}
        {{- end }}
      nodeSelector:
        {{- toYaml .Values.overrides_exporter.nodeSelector | nindent 8 }}
      affinity:
        {{- toYaml .Values.overrides_exporter.affinity | nindent 8 }}
      tolerations:
        {{- toYaml .Values.overrides_exporter.tolerations | nindent 8 }}
      terminationGracePeriodSeconds: {{ .Values.overrides_exporter.terminationGracePeriodSeconds }}
      volumes:
        - name: config
          secret:
            secretName: {{ .Values.externalConfigSecretName }}
        - name: runtime-config
          configMap:
            name: {{ template "mimir.fullname" . }}-runtime
        {{- if .Values.overrides_exporter.extraVolumes }}
        {{ toYaml .Values.overrides_exporter.extraVolumes | nindent 8}}
        {{- end }}
        - name: storage
          emptyDir: {}
{{- end -}}

{{/*
overrides-exporter POD disruption budget template
*/}}
{{- define "mimir.overridesExporterPDB" -}}
{{- if .Values.overrides_exporter.podDisruptionBudget -}}
apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: {{ template "mimir.overridesExporterFullname" . }}
  labels:
    {{- include "mimir.overridesExporterLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
spec:
  selector:
    matchLabels:
      {{- include "mimir.overridesExporterSelectorLabels" . | nindent 6 }}
{{ toYaml .Values.overrides_exporter.podDisruptionBudget | indent 2 }}
{{- end -}}
{{- end -}}

{{/*
overrides-exporter POD disruption budget template
*/}}
{{- define "mimir.overridesExporterService" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "mimir.overridesExporterFullname" . }}
  labels:
    {{- include "mimir.overridesExporterLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
    {{- with .Values.overrides_exporter.service.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- toYaml .Values.overrides_exporter.service.annotations | nindent 4 }}
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
    {{- include "mimir.overridesExporterSelectorLabels" . | nindent 4 }}
{{- end -}}