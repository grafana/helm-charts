{{/*
backend fullname
*/}}
{{- define "loki.backendFullname" -}}
{{ include "loki.name" . }}-backend
{{- end }}

{{/*
backend common labels
*/}}
{{- define "loki.backendLabels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: backend
{{- end }}

{{/*
backend selector labels
*/}}
{{- define "loki.backendSelectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: backend
{{- end }}

{{/*
backend priority class name
*/}}
{{- define "loki.backendPriorityClassName" -}}
{{- $pcn := coalesce .Values.global.priorityClassName .Values.backend.priorityClassName -}}
{{- if $pcn }}
priorityClassName: {{ $pcn }}
{{- end }}
{{- end }}

{{/*
backend sidecar
*/}}
{{- define "loki.backendSidecar" -}}
{{- if .Values.sidecar.rules.enabled }}
- name: loki-sc-rules
  {{- $dict := dict "service" .Values.sidecar.image "global" .Values.global }}
  image: {{ include "loki.baseImage" $dict }}
  imagePullPolicy: {{ .Values.sidecar.image.pullPolicy }}
  {{- with .Values.sidecar.resources }}
  resources:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.sidecar.securityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.sidecar.livenessProbe }}
    {{- if .enabled | default true }}
  livenessProbe:
    {{- toYaml (omit . "enabled") | nindent 8 }}
    {{- end }}
  {{- end }}
  {{- with .Values.sidecar.readinessProbe }}
    {{- if .enabled | default true }}
  readinessProbe:
    {{- toYaml (omit . "enabled") | nindent 8 }}
    {{- end }}
  {{- end }}
  {{- with .Values.sidecar.startupProbe }}
    {{- if .enabled | default true }}
  startupProbe:
    {{- toYaml (omit . "enabled") | nindent 8 }}
    {{- end }}
  {{- end }}
  env:
    - name: METHOD
      value: {{ .Values.sidecar.rules.watchMethod }}
    - name: LABEL
      value: "{{ .Values.sidecar.rules.label }}"
    {{- if .Values.sidecar.rules.labelValue }}
    - name: LABEL_VALUE
      value: {{ quote .Values.sidecar.rules.labelValue }}
    {{- end }}
    - name: FOLDER
      value: "{{ .Values.sidecar.rules.folder }}"
    {{- if .Values.sidecar.rules.folderAnnotation }}
    - name: FOLDER_ANNOTATION
      value: "{{ .Values.sidecar.rules.folderAnnotation }}"
    {{- end }}
    - name: RESOURCE
      value: {{ quote .Values.sidecar.rules.resource }}
    {{- if .Values.sidecar.enableUniqueFilenames }}
    - name: UNIQUE_FILENAMES
      value: "{{ .Values.sidecar.enableUniqueFilenames }}"
    {{- end }}
    {{- if .Values.sidecar.rules.searchNamespace }}
    - name: NAMESPACE
      value: "{{ .Values.sidecar.rules.searchNamespace | join "," }}"
    {{- end }}
    {{- if .Values.sidecar.skipTlsVerify }}
    - name: SKIP_TLS_VERIFY
      value: "{{ .Values.sidecar.skipTlsVerify }}"
    {{- end }}
    {{- if .Values.sidecar.disableX509StrictVerification }}
    - name: DISABLE_X509_STRICT_VERIFICATION
      value: "{{ .Values.sidecar.disableX509StrictVerification }}"
    {{- end }}
    {{- if .Values.sidecar.rules.script }}
    - name: SCRIPT
      value: "{{ .Values.sidecar.rules.script }}"
    {{- end }}
    {{- if .Values.sidecar.rules.watchServerTimeout }}
    - name: WATCH_SERVER_TIMEOUT
      value: "{{ .Values.sidecar.rules.watchServerTimeout }}"
    {{- end }}
    {{- if .Values.sidecar.rules.watchClientTimeout }}
    - name: WATCH_CLIENT_TIMEOUT
      value: "{{ .Values.sidecar.rules.watchClientTimeout }}"
    {{- end }}
    {{- if .Values.sidecar.rules.logLevel }}
    - name: LOG_LEVEL
      value: "{{ .Values.sidecar.rules.logLevel }}"
    {{- end }}
{{- end }}
{{- end }}
