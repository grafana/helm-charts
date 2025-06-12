{{/* ~=~=~ Partial Templates of exposed Ports ~=~=~ */}}

{{/* UDP sockets */}}
{{- define "tempo.udp"}}
{{- $endpoint := .Values.tempo.receivers.jaeger.protocols.thrift_compact }}
{{- with $endpoint.endpoint }}
{{- $port := regexSplit ":" . -1 | last }}
- name: tempo-jaeger-thrift-compact
  port: {{ $port }}
  protocol: UDP
  targetPort: 6831
{{- end }}
{{- $endpoint := .Values.tempo.receivers.jaeger.protocols.thrift_binary }}
{{- with $endpoint.endpoint }}
{{- $port := regexSplit ":" . -1 | last }}
- name: tempo-jaeger-thrift-binary
  port: {{ $port }}
  protocol: UDP
  targetPort: 6832
{{- end }}
{{- /* end of define */}}
{{- end }}

{{/* TCP sockets */}}
{{- define "tempo.tcp"}}
- name: tempo-prom-metrics
  port: 3200
  protocol: TCP
  targetPort: 3200
{{- if .Values.tempoQuery.enabled }}
- name: jaeger-metrics
  port: 16687
  protocol: TCP
  targetPort: 16687
- name: tempo-query-jaeger-ui
  port: {{ .Values.tempoQuery.service.port }}
  targetPort: {{ .Values.tempoQuery.service.port }}
{{- end }}
{{- $endpoint := .Values.tempo.receivers.jaeger.protocols.thrift_http }}
{{- with $endpoint.endpoint }}
{{- $port := regexSplit ":" . -1 | last }}
- name: tempo-jaeger-thrift-http
  port: {{ $port }}
  protocol: TCP
  targetPort: 14268
{{- end }}
{{- $endpoint := .Values.tempo.receivers.jaeger.protocols.grpc }}
{{- with $endpoint.endpoint }}
{{- $port := regexSplit ":" . -1 | last }}
- name: grpc-tempo-jaeger
  port: {{ $port }}
  protocol: TCP
  targetPort: 14250
{{- end }}
- name: tempo-zipkin
  port: 9411
  protocol: TCP
  targetPort: 9411
- name: tempo-otlp-legacy
  port: 55680
  protocol: TCP
  targetPort: 55680
- name: tempo-otlp-http-legacy
  port: 55681
  protocol: TCP
  targetPort: 55681
{{- $endpoint := .Values.tempo.receivers.otlp.protocols.grpc }}
{{- with $endpoint.endpoint }}
{{- $port := regexSplit ":" . -1 | last }}
- name: grpc-tempo-otlp
  port: {{ $port }}
  protocol: TCP
  targetPort: 4317
{{- end }}
{{- $endpoint := .Values.tempo.receivers.otlp.protocols.http }}
{{- with $endpoint.endpoint }}
{{- $port := regexSplit ":" . -1 | last }}
- name: tempo-otlp-http
  port: {{ $port }}
  protocol: TCP
  targetPort: 4318
{{- end }}
- name: tempo-opencensus
  port: 55678
  protocol: TCP
  targetPort: 55678
{{- /* end of define */}}
{{- end  }}
