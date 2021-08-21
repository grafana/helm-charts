## helm upgrade

upgrade a release

### Synopsis


This command upgrades a release to a new version of a chart.

The upgrade arguments must be a release and chart. The chart
argument can be either: a chart reference('example/mariadb'), a path to a chart directory,
a packaged chart, or a fully qualified URL. For chart references, the latest
version will be specified unless the '--version' flag is set.

To override values in a chart, use either the '--values' flag and pass in a file
or use the '--set' flag and pass configuration from the command line, to force string
values, use '--set-string'. In case a value is large and therefore
you want not to use neither '--values' nor '--set', use '--set-file' to read the
single large value from file.

You can specify the '--values'/'-f' flag multiple times. The priority will be given to the
last (right-most) file specified. For example, if both myvalues.yaml and override.yaml
contained a key called 'Test', the value set in override.yaml would take precedence:

    $ helm upgrade -f myvalues.yaml -f override.yaml redis ./redis

You can specify the '--set' flag multiple times. The priority will be given to the
last (right-most) set specified. For example, if both 'bar' and 'newbar' values are
set for a key called 'foo', the 'newbar' value would take precedence:

    $ helm upgrade --set foo=bar --set foo=newbar redis ./redis


```
helm upgrade [RELEASE] [CHART] [flags]
```

### Options

```
      --atomic                       if set, upgrade process rolls back changes made in case of failed upgrade. The --wait flag will be set automatically if --atomic is used
      --ca-file string               verify certificates of HTTPS-enabled servers using this CA bundle
      --cert-file string             identify HTTPS client using this SSL certificate file
      --cleanup-on-fail              allow deletion of new resources created in this upgrade when upgrade fails
      --create-namespace             if --install is set, create the release namespace if not present
      --description string           add a custom description
      --devel                        use development versions, too. Equivalent to version '>0.0.0-0'. If --version is set, this is ignored
      --disable-openapi-validation   if set, the upgrade process will not validate rendered templates against the Kubernetes OpenAPI Schema
      --dry-run                      simulate an upgrade
      --force                        force resource updates through a replacement strategy
  -h, --help                         help for upgrade
      --history-max int              limit the maximum number of revisions saved per release. Use 0 for no limit (default 10)
      --insecure-skip-tls-verify     skip tls certificate checks for the chart download
  -i, --install                      if a release by this name doesn't already exist, run an install
      --key-file string              identify HTTPS client using this SSL key file
      --keyring string               location of public keys used for verification (default "/Users/cmooney/.gnupg/pubring.gpg")
      --no-hooks                     disable pre/post upgrade hooks
  -o, --output format                prints the output in the specified format. Allowed values: table, json, yaml (default table)
      --password string              chart repository password where to locate the requested chart
      --post-renderer postrenderer   the path to an executable to be used for post rendering. If it exists in $PATH, the binary will be used, otherwise it will try to look for the executable at the given path (default exec)
      --render-subchart-notes        if set, render subchart notes along with the parent
      --repo string                  chart repository url where to locate the requested chart
      --reset-values                 when upgrading, reset the values to the ones built into the chart
      --reuse-values                 when upgrading, reuse the last release's values and merge in any overrides from the command line via --set and -f. If '--reset-values' is specified, this is ignored
      --set stringArray              set values on the command line (can specify multiple or separate values with commas: key1=val1,key2=val2)
      --set-file stringArray         set values from respective files specified via the command line (can specify multiple or separate values with commas: key1=path1,key2=path2)
      --set-string stringArray       set STRING values on the command line (can specify multiple or separate values with commas: key1=val1,key2=val2)
      --skip-crds                    if set, no CRDs will be installed when an upgrade is performed with install flag enabled. By default, CRDs are installed if not already present, when an upgrade is performed with install flag enabled
      --timeout duration             time to wait for any individual Kubernetes operation (like Jobs for hooks) (default 5m0s)
      --username string              chart repository username where to locate the requested chart
  -f, --values strings               specify values in a YAML file or a URL (can specify multiple)
      --verify                       verify the package before using it
      --version string               specify the exact chart version to use. If this is not specified, the latest version is used
      --wait                         if set, will wait until all Pods, PVCs, Services, and minimum number of Pods of a Deployment, StatefulSet, or ReplicaSet are in a ready state before marking the release as successful. It will wait for as long as --timeout
```

### Options inherited from parent commands

```
      --add-dir-header                   If true, adds the file directory to the header
      --alsologtostderr                  log to standard error as well as files
      --debug                            enable verbose output
      --kube-apiserver string            the address and the port for the Kubernetes API server
      --kube-context string              name of the kubeconfig context to use
      --kube-token string                bearer token used for authentication
      --kubeconfig string                path to the kubeconfig file
      --log-backtrace-at traceLocation   when logging hits line file:N, emit a stack trace (default :0)
      --log-dir string                   If non-empty, write log files in this directory
      --log-file string                  If non-empty, use this log file
      --log-file-max-size uint           Defines the maximum size a log file can grow to. Unit is megabytes. If the value is 0, the maximum file size is unlimited. (default 1800)
      --logtostderr                      log to standard error instead of files (default true)
  -n, --namespace string                 namespace scope for this request
      --registry-config string           path to the registry config file (default "/Users/cmooney/Library/Preferences/helm/registry.json")
      --repository-cache string          path to the file containing cached repository indexes (default "/Users/cmooney/Library/Caches/helm/repository")
      --repository-config string         path to the file containing repository names and URLs (default "/Users/cmooney/Library/Preferences/helm/repositories.yaml")
      --skip-headers                     If true, avoid header prefixes in the log messages
      --skip-log-headers                 If true, avoid headers when opening log files
      --stderrthreshold severity         logs at or above this threshold go to stderr (default 2)
  -v, --v Level                          number for the log level verbosity
      --vmodule moduleSpec               comma-separated list of pattern=N settings for file-filtered logging
```

### SEE ALSO

* [helm](helm.md)	 - The Helm package manager for Kubernetes.

###### Auto generated by spf13/cobra on 20-Aug-2021
