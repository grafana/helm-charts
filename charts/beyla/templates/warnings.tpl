{{/* this file is for generating warnings about incorrect usage of the chart */}}

{{- if not .Values.otlp.endpoint }}
  {{ fail ".Values.otlp.endpoint must be set" }}
{{- end }}