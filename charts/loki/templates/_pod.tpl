{{- define "loki.initContainers" }}
{{- if .Values.initContainers }}
  {{- toYaml .Values.initContainers | nindent 8 }}
{{- end }}
{{- if ( and .Values.persistence.enabled .Values.initChownData.enabled ) }}
- name: init-chown-data
  {{- if .Values.initChownData.image.sha }}
  image: "{{ .Values.initChownData.image.repository }}:{{ .Values.initChownData.image.tag }}@sha256:{{ .Values.initChownData.image.sha }}"
  {{- else }}
  image: "{{ .Values.initChownData.image.repository }}:{{ .Values.initChownData.image.tag }}"
  {{- end }}
  imagePullPolicy: {{ .Values.initChownData.image.pullPolicy }}
  securityContext:
    runAsNonRoot: false
    runAsUser: 0
  command: ["chown", "-R", "{{ .Values.securityContext.runAsUser }}:{{ .Values.securityContext.runAsGroup }}", "/data"]
  resources:
{{ toYaml .Values.initChownData.resources | indent 6 }}
  volumeMounts:
    - name: storage
      mountPath: "/data"
{{- if .Values.persistence.subPath }}
      subPath: {{ .Values.persistence.subPath }}
{{- end }}
{{- end }}
{{- end }}
