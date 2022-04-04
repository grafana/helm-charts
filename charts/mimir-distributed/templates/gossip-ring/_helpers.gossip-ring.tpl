{{/*
gossip-ring fullname
*/}}
{{- define "mimir.gossipRingFullname" -}}
{{ include "mimir.fullname" . }}-gossip-ring
{{- end }}

{{/*
gossip-ring common labels
*/}}
{{- define "mimir.gossipRingLabels" -}}
{{ include "mimir.labels" . }}
{{- if .Values.useGEMLabels }}
app: {{ template "mimir.name" . }}-gossip-ring
{{- else }}
app.kubernetes.io/component: gossip-ring
{{- end }}
{{- end -}}

{{/*
gossip-ring selector labels
*/}}
{{- define "mimir.gossipRingSelectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
{{- if .Values.useGEMLabels }}
gossip_ring_member: "true"
{{- else }}
app.kubernetes.io/part-of: memberlist
{{- end }}
{{- end -}}

{{/*
gossip-ring Service template
*/}}
{{- define "mimir.gossipRingService" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ template "mimir.fullname" . }}-gossip-ring
  labels:
    {{- include "mimir.gossipRingLabels" . | nindent 4 }}
    {{- if .Values.useGEMLabels }}{{- include "mimir.gemExtraLabels" . | nindent 4 }}{{- end }}
spec:
  type: ClusterIP
  clusterIP: None
  ports:
    - name: gossip-ring
      port: {{ include "mimir.memberlistBindPort" . }}
      protocol: TCP
      targetPort: {{ include "mimir.memberlistBindPort" . }}
  publishNotReadyAddresses: true
  selector:
    {{- include "mimir.gossipRingSelectorLabels" . | nindent 4 }}
{{- end -}}