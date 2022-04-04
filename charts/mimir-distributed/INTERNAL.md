# Developer notes

## Notes on the kube manifest templates and configuration

Why do we generate Kubernetes resource definitions from named templates, and not directly? That is, why do we have
```yaml
{{- if not .Values.skipResourceRendering -}}
{{- include "mimir.querierDeployment" . -}}
{{- end -}}
```
instead of just writing the Deployment template directly?

[PR #1182](https://github.com/grafana/helm-charts/pull/1182) commit message:
> When `mimir-distributed` is used as a subchart, the rendering of the annotation "checksum/config" on Pods is wrong. This is important to trigger service restart when the config is changed.\
> There are two options:\
> a) config is in `mimir-distributed` or shared with `mimir-distributed` in which case it can contain templates and values of the parent chart, making it impossible to evaluate in the subchart.\
> b) config lives in the parent chart, but then it is not possible to reach it in `mimir-distributed` as subchart and the checksum is the checksum of an empty string. See: "few important details" in [Helm subcharts and globals](https://helm.sh/docs/chart_template_guide/subcharts_and_globals/)\
> This patch makes the manifest templates global named templates and thus able to be rendered in the parent context. It is one step short of merging the mimir-distributed chart with enterprise-metrics.


### Background

Why do we need to have `checksum/config`? In order to keep this mimir-distributed chart up to date and tested, it is important that it can be reused in the enterprise-metrics chart since Grafana uses Grafana Enterprise Metrics (GEM) internally and for its cloud offering. This means that the chart must support all required features of future and past GEM chart releases. One such feature is that in case of configuration change the affected services must be restarted when `helm upgrade` is executed. The [best practice](https://helm.sh/docs/howto/charts_tips_and_tricks/#automatically-roll-deployments) to achieve that is to use the `checksum/config` annotation.

Why not just merge the Mimir and GEM charts? Having to use an `enterprise-metrics` chart for the open source Grafana Mimir would sow confusion about its licensing status and how it can be used and what features are available. On the other hand, having to use `mimir-distributed` for the enterprise version would potentially slow the development of the open source version as enterprise has stricter rules - not to mention confusion again.

## Notes on testing mimir-distributed

These instructions are for testing the chart before Mimir release.

### Pulling mimir image

Mimir image is stored in a private Docker Hub repository, so in order to pull it, first we'll need to create a secret within our test cluster containing our docker credentials:

```sh
kubectl create secret docker-registry <your-secret-name> --docker-username <your-docker-user> --docker-password <your-docker-password> --docker-email <your-docker-email>
```

Next, specify the name of the recently created secret under the `image.pullSecrets` key in you custom values file, or on the command line.

```sh
helm install ... --set 'image.pullSecrets={<your-secret-name>}'
```

### Install instructions

While the chart is in development and in a private repository, it is more useful to install from files instead of Helm repo feature.

Once the repository is checked out and correct branch is set, let helm download dependencies (i.e. sub-charts):

```sh
cd charts/mimir-distributed
helm repo add helm.min.io https://helm.min.io
helm repo add bitnami https://charts.bitnami.com/bitnami
helm dependency update
cd ../..
```

Next, you can customize the chart using additional values and install it:

```sh
helm install <name-of-cluster> ./charts/mimir-distributed/
# or
helm install <name-of-cluster> ./charts/mimir-distributed/ -f <path-to-your-values-file>
# or
helm install <name-of-cluster> ./charts/mimir-distributed/ -f ci/test-values.yaml
# to turn off persistency - untested
```

### Upgrade

Upgrade if changes are made can be installed with
```sh
helm upgrade <name-of-cluster> ./charts/mimir-distributed/
```
Supply the same arguments as in install, but use the command `upgrade`.

### Diff
Install helm diff plugin so you can do
```sh
helm diff upgrade <name-of-cluster> ./charts/mimir-distributed/
```
Which is pretty much the same as `tk diff`.

### Remove
To delete the whole thing (wait a minute for stuff to terminate):
```sh
helm delete <name-of-cluster>
```

### Migration from Cortex

Untested. In theory: take the Cortex configuration yaml and go through it's migration. Set the config in the value `mimir.config`.

_Note_ that the value should be a string, not structured data. On the other hand, helm template expressions can be used in the value, see the default in `values.yaml` for inspiration.
