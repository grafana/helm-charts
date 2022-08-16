local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  grafana: helm.template('enterprise-metrics', '../../', {
    namespace: 'enterprise-metrics',
    values: std.native('parseYaml')(importstr '../../large.yaml')[0],
  }),
}
