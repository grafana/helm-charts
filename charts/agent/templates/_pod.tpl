{{- define "agent.pod" -}}
serviceAccountName: {{ template "agent.serviceAccountName" . }}
containers:
- name: grafana-agent
  imagePullPolicy: {{.Values.image.pullPolicy}}
  image: "{{ .Values.image.registry }}/{{ .Values.image.repository }}:{{ .Values.image.tag }}"
  command: [{{.Values.command}}]
  ports:
    - containerPort: 12345
      name: http
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
{{- if .Values.volumes.addNodeExporterVolumes }}
  - name: rootfs
    mountPath: /host/root
    readOnly: true
  - name: sysfs
    mountPath: /host/sys
    readOnly: true
  - name: procfs
    mountPath: /host/proc
    readOnly: true
{{- end }}
  securityContext:
    privileged: {{.Values.security.privileged}}
    runAsUser: {{.Values.security.runAsUser}}
    capabilities:
      add: {{.Values.security.capabilities}}
volumes:
- configMap:
    name: {{ include "agent.fullname" . }}
  name: agent-config
{{- if .Values.volumes.addNodeExporterVolumes }}
- name: rootfs
  hostPath:
    path: /
- name: sysfs
  hostPath:
    path: /sys
- name: procfs
  hostPath:
    path: /proc
{{- end }}
{{- end }}
