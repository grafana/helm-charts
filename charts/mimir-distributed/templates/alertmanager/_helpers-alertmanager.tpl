{{/*
Alertmanager fullname
*/}}
{{- define "mimir.alertmanagerFullname" -}}
{{ include "mimir.fullname" . }}-alertmanager
{{- end }}

{{/*
Alertmanager common labels
*/}}
{{- define "mimir.alertmanagerLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-alertmanager
{{- else }}
app.kubernetes.io/component: alertmanager
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
Alertmanager selector labels
*/}}
{{- define "mimir.alertmanagerSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-alertmanager
{{- else }}
app.kubernetes.io/component: alertmanager
{{- end }}
{{- end -}}

{{/*
GEM Alertmanager Pod labels
*/}}
{{- define "mimir.gemAlertmanagerPodLabels" -}}
name: alertmanager
gossip_ring_member: "true"
target: alertmanager
{{- end -}}

{{/*
Alertmanager deployment template
*/}}
{{- define "mimir.alertmanagerDeployment" -}}
{{- if not .Values.alertmanager.statefulSet.enabled -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "mimir.alertmanagerFullname" . }}
  labels:
    {{- include "mimir.alertmanagerLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
  annotations:
    {{- toYaml .Values.alertmanager.annotations | nindent 4 }}
spec:
  replicas: {{ .Values.alertmanager.replicas }}
  selector:
    matchLabels:
      {{- include "mimir.alertmanagerSelectorLabels" . | nindent 6 }}
  strategy:
    {{- toYaml .Values.alertmanager.strategy | nindent 4 }}
  template:
    metadata:
      labels:
        {{- include "mimir.alertmanagerLabels" . | nindent 8 }}
        {{- if .Values.useGEMLabels }}{{- include "mimir.gemAlertmanagerPodLabels" . | nindent 8 }}{{- end }}
        {{- with .Values.alertmanager.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      annotations:
{{- if .Values.useExternalConfig }}
        checksum/config: {{ .Values.externalConfigVersion }}
{{- else }}
        checksum/config: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
{{- end}}
        {{- with .Values.alertmanager.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      serviceAccountName: {{ template "mimir.serviceAccountName" . }}
    {{- if .Values.alertmanager.priorityClassName }}
      priorityClassName: {{ .Values.query_frontend.priorityClassName }}
    {{- end }}
      securityContext:
        {{- toYaml .Values.alertmanager.securityContext | nindent 8 }}
      initContainers:
        {{- toYaml .Values.alertmanager.initContainers | nindent 8 }}
      {{- if .Values.image.pullSecrets }}
      imagePullSecrets:
      {{- range .Values.image.pullSecrets }}
        - name: {{ . }}
      {{- end}}
      {{- end }}
      containers:
        - name: alertmanager
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          args:
            - "-target=alertmanager"
            - -activity-tracker.filepath=
            - "-config.file=/etc/mimir/mimir.yaml"
          {{- range $key, $value := .Values.alertmanager.extraArgs }}
            - "-{{ $key }}={{ $value }}"
          {{- end }}
          volumeMounts:
            {{- if .Values.alertmanager.extraVolumeMounts }}
              {{ toYaml .Values.alertmanager.extraVolumeMounts | nindent 12}}
            {{- end }}
            - name: config
              mountPath: /etc/mimir
            - name: storage
              mountPath: "/data"
              subPath: {{ .Values.alertmanager.persistence.subPath }}
            - name: tmp
              mountPath: /tmp
          ports:
            - name: http-metrics
              containerPort: {{ include "mimir.serverHttpListenPort" . }}
              protocol: TCP
            - name: grpc
              containerPort: {{ include "mimir.serverGrpcListenPort" . }}
              protocol: TCP
          livenessProbe:
            {{- toYaml .Values.alertmanager.livenessProbe | nindent 12 }}
          readinessProbe:
            {{- toYaml .Values.alertmanager.readinessProbe | nindent 12 }}
          resources:
            {{- toYaml .Values.alertmanager.resources | nindent 12 }}
          securityContext:
            readOnlyRootFilesystem: true
          env:
            {{- if .Values.alertmanager.env }}
              {{- toYaml .Values.alertmanager.env | nindent 12 }}
            {{- end }}
{{- if .Values.alertmanager.extraContainers }}
{{ toYaml .Values.alertmanager.extraContainers | indent 8}}
{{- end }}
      nodeSelector:
        {{- toYaml .Values.alertmanager.nodeSelector | nindent 8 }}
      affinity:
        {{- toYaml .Values.alertmanager.affinity | nindent 8 }}
      tolerations:
        {{- toYaml .Values.alertmanager.tolerations | nindent 8 }}
      terminationGracePeriodSeconds: {{ .Values.alertmanager.terminationGracePeriodSeconds }}
      volumes:
        - name: config
          secret:
            secretName: {{ .Values.externalConfigSecretName }}
{{- if .Values.alertmanager.extraVolumes }}
{{ toYaml .Values.alertmanager.extraVolumes | indent 8}}
{{- end }}
        - name: storage
          emptyDir: {}
        - name: tmp
          emptyDir: {}
{{- end -}}
{{- end -}}

{{/*
Alertmanager POD disruption limit template
*/}}
{{- define "mimir.alertmanagerPDB" -}}
{{- if .Values.alertmanager.podDisruptionBudget -}}
apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: {{ template "mimir.alertmanagerFullname" . }}
  labels:
    {{- include "mimir.alertmanagerLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
spec:
  selector:
    matchLabels:
      {{- include "mimir.alertmanagerSelectorLabels" . | nindent 6 }}
{{ toYaml .Values.alertmanager.podDisruptionBudget | indent 2 }}
{{- end -}}
{{- end -}}

{{/*
Alertmanager Service Monitor template
*/}}
{{- define "mimir.alertmanagerServiceMonitor" -}}
{{- with .Values.serviceMonitor }}
{{- if .enabled }}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ template "mimir.alertmanagerFullname" $ }}
  {{- with .namespace }}
  namespace: {{ . }}
  {{- end }}
  labels:
    {{- include "mimir.alertmanagerLabels" $ | nindent 4 }}
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
      {{- include "mimir.alertmanagerSelectorLabels" $ | nindent 6 }}
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
Alertmanager StatefulSet template
*/}}
{{- define "mimir.alertmanagerStatefulSet" -}}
{{- if .Values.alertmanager.statefulSet.enabled -}}
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ include "mimir.alertmanagerFullname" . }}
  labels:
    {{- include "mimir.alertmanagerLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
  annotations:
    {{- toYaml .Values.alertmanager.annotations | nindent 4 }}
spec:
  replicas: {{ .Values.alertmanager.replicas }}
  selector:
    matchLabels:
      {{- include "mimir.alertmanagerSelectorLabels" . | nindent 6 }}
  updateStrategy:
    {{- toYaml .Values.alertmanager.statefulStrategy | nindent 4 }}
  serviceName: {{ template "mimir.fullname" . }}-alertmanager
  {{- if .Values.alertmanager.persistentVolume.enabled }}
  volumeClaimTemplates:
    - metadata:
        name: storage
        {{- if .Values.alertmanager.persistentVolume.annotations }}
        annotations:
          {{ toYaml .Values.alertmanager.persistentVolume.annotations | nindent 10 }}
        {{- end }}
      spec:
        {{- if .Values.alertmanager.persistentVolume.storageClass }}
        {{- if (eq "-" .Values.alertmanager.persistentVolume.storageClass) }}
        storageClassName: ""
        {{- else }}
        storageClassName: "{{ .Values.alertmanager.persistentVolume.storageClass }}"
        {{- end }}
        {{- end }}
        accessModes:
          {{ toYaml .Values.alertmanager.persistentVolume.accessModes | nindent 10 }}
        resources:
          requests:
            storage: "{{ .Values.alertmanager.persistentVolume.size }}"
  {{- end }}
  template:
    metadata:
      labels:
        {{- include "mimir.alertmanagerLabels" . | nindent 8 }}
        {{- if .Values.useGEMLabels }}{{- include "mimir.gemAlertmanagerPodLabels" . | nindent 8 }}{{- end }}
        {{- with .Values.alertmanager.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      annotations:
        {{- if .Values.useExternalConfig }}
        checksum/config: {{ .Values.externalConfigVersion }}
        {{- else }}
        checksum/config: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
        {{- end }}
        {{- with .Values.alertmanager.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      serviceAccountName: {{ template "mimir.serviceAccountName" . }}
      {{- if .Values.alertmanager.priorityClassName }}
      priorityClassName: {{ .Values.alertmanager.priorityClassName }}
      {{- end }}
      securityContext:
        {{- toYaml .Values.alertmanager.securityContext | nindent 8 }}
      initContainers:
        {{- toYaml .Values.alertmanager.initContainers | nindent 8 }}
      {{- if .Values.image.pullSecrets }}
      imagePullSecrets:
      {{- range .Values.image.pullSecrets }}
        - name: {{ . }}
      {{- end }}
      {{- end }}
      nodeSelector:
        {{- toYaml .Values.alertmanager.nodeSelector | nindent 8 }}
      affinity:
        {{- toYaml .Values.alertmanager.affinity | nindent 8 }}
      tolerations:
        {{- toYaml .Values.alertmanager.tolerations | nindent 8 }}
      terminationGracePeriodSeconds: {{ .Values.alertmanager.terminationGracePeriodSeconds }}
      volumes:
        - name: config
          secret:
            secretName: {{ .Values.externalConfigSecretName }}
        - name: runtime-config
          configMap:
            name: {{ template "mimir.fullname" . }}-runtime
        {{- if not .Values.alertmanager.persistentVolume.enabled }}
        - name: storage
          emptyDir: {}
        {{- end }}
        - name: tmp
          emptyDir: {}
        {{- if .Values.alertmanager.extraVolumes }}
        {{ toYaml .Values.alertmanager.extraVolumes | nindent 8 }}
        {{- end }}
      containers:
        {{- if .Values.alertmanager.extraContainers }}
        {{ toYaml .Values.alertmanager.extraContainers | nindent 8 }}
        {{- end }}
        - name: alertmanager
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          args:
            - "-target=alertmanager"
            - -activity-tracker.filepath=
            - "-config.file=/etc/mimir/mimir.yaml"
            {{- range $key, $value := .Values.alertmanager.extraArgs }}
            - "-{{ $key }}={{ $value }}"
            {{- end }}
          volumeMounts:
            {{- if .Values.alertmanager.extraVolumeMounts }}
            {{ toYaml .Values.alertmanager.extraVolumeMounts | nindent 12}}
            {{- end }}
            - name: config
              mountPath: /etc/mimir
            - name: runtime-config
              mountPath: /var/mimir
            - name: storage
              mountPath: "/data"
              {{- if .Values.alertmanager.persistentVolume.subPath }}
              subPath: {{ .Values.alertmanager.persistentVolume.subPath }}
              {{- else }}
              {{- end }}
            - name: tmp
              mountPath: /tmp
          ports:
            - name: http-metrics
              containerPort: {{ include "mimir.serverHttpListenPort" . }}
              protocol: TCP
            - name: grpc
              containerPort: {{ include "mimir.serverGrpcListenPort" . }}
              protocol: TCP
          livenessProbe:
            {{- toYaml .Values.alertmanager.livenessProbe | nindent 12 }}
          readinessProbe:
            {{- toYaml .Values.alertmanager.readinessProbe | nindent 12 }}
          resources:
            {{- toYaml .Values.alertmanager.resources | nindent 12 }}
          securityContext:
            readOnlyRootFilesystem: true
          env:
            {{- if .Values.alertmanager.env }}
              {{- toYaml .Values.alertmanager.env | nindent 12 }}
            {{- end }}
{{- end -}}
{{- end -}}

{{/*
Alertmanager Headless template
*/}}
{{- define "mimir.alertmanagerHeadless" -}}
{{- $clusterPort := regexReplaceAll ".+[:]" (default "0.0.0.0:9094" (include "mimir.alertmanagerClusterBindAddress" .) ) "" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ template "mimir.fullname" . }}-alertmanager-headless
  labels:
    {{- include "mimir.alertmanagerLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
    {{- with .Values.alertmanager.service.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- toYaml .Values.alertmanager.service.annotations | nindent 4 }}
spec:
  type: ClusterIP
  clusterIP: None
  publishNotReadyAddresses: true
  ports:
    - port: {{ include "mimir.serverHttpListenPort" . }}
      protocol: TCP
      name: http-metrics
      targetPort: http-metrics
    - port: {{ include "mimir.serverGrpcListenPort" . }}
      protocol: TCP
      name: grpc
      targetPort: grpc
    - port: {{ $clusterPort }}
      protocol: TCP
      name: cluster
  selector:
    {{- include "mimir.alertmanagerSelectorLabels" . | nindent 4 }}
{{- end -}}

{{/*
Alertmanager Service template
*/}}
{{- define "mimir.alertmanagerService" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "mimir.alertmanagerFullname" . }}
  labels:
    {{- include "mimir.alertmanagerLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
    {{- with .Values.alertmanager.service.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- toYaml .Values.alertmanager.service.annotations | nindent 4 }}
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
    {{- include "mimir.alertmanagerSelectorLabels" . | nindent 4 }}
{{- end -}}