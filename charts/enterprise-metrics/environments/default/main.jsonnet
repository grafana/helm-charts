local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile) {
  // TODO(jdb): Understand why k8s.patchLabels is causing a runtime error.
  // Error: evaluating jsonnet: RUNTIME ERROR: Unexpected type null
  //	During manifestation
  template(name, chart, conf={})::
    std.native('helmTemplate')(name, chart, conf { calledFrom: std.thisFile }),
};

{
  grafana: helm.template('enterprise-metrics', '../../', {
    namespace: 'enterprise-metrics',
  }),
}
