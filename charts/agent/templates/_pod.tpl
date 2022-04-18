{{- define "agent.pod" -}}
serviceAccountName: {{ template "agent.serviceAccountName" . }}
containers:
- name: grafana-agent
  imagePullPolicy: {{.Values.image.pullPolicy}}
  image: "{{ .Values.image.registry }}/{{ .Values.image.repository }}:{{ .Values.image.tag }}"
  command: [{{.Values.command}}]
  ports:
    - containerPort: 12345
      name: http-metrics
  args:
{{- with .Values.args }}
    {{- toYaml . | nindent 4 }}
{{- end }}
  env:
  - name: HOSTNAME
    valueFrom:
      fieldRef:
        fieldPath: spec.nodeName
{{- range $key, $value := .Values.env }}
  - name: "{{ tpl $key $ }}"
    value: "{{ tpl (print $value) $ }}"
{{- end }}
{{- if .Values.envFromSecrets }}
  envFrom:
{{- range .Values.envFromSecrets }}
  - secretRef:
      name: {{ .name }}
      optional: {{ .optional | default false }}
{{- end }}
{{- end }}
  volumeMounts:
  - mountPath: /etc/agent
    name: agent-config
volumes:
- configMap:
    name: {{ include "agent.fullname" . }}
  name: agent-config
{{- end }}
