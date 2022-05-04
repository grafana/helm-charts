package k8s_defaulter

import (
	"bytes"
	"context"
	"k8s-diff/pkg/differ"
	"log"

	"github.com/fluxcd/pkg/ssa"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/client-go/scale/scheme"
	"k8s.io/client-go/tools/clientcmd"
	"sigs.k8s.io/controller-runtime/pkg/client"
)

func NewDryRunK8sClient() (client.Client, error) {
	sch := runtime.NewScheme()
	scheme.AddToScheme(sch)
	config, err := clientcmd.NewDefaultClientConfigLoadingRules().Load()
	if err != nil {
		log.Fatal(err)
	}

	clientConfig := clientcmd.NewDefaultClientConfig(*config, nil)
	restConfig, err := clientConfig.ClientConfig()
	if err != nil {
		log.Fatal(err)
	}

	cli, err := client.New(restConfig, client.Options{
		Scheme: sch,
	})
	if err != nil {
		log.Fatal(err)
	}

	return client.NewDryRunClient(cli), nil
}

type DefaultSettingRule struct {
	client client.Client
}

func NewDefaultSettingRule(client client.Client) *DefaultSettingRule {
	return &DefaultSettingRule{client: client}
}

func (d *DefaultSettingRule) Describe() differ.ObjectRuleDescription {
	return differ.ObjectRuleDescription{
		Name:       "Fill in default values",
		MatchRules: nil,
		PatchRules: differ.Json6902Patch{{Op: "set_defaults"}},
	}
}

func (d *DefaultSettingRule) MapObject(obj *differ.YamlObject, debug *differ.RuleDebugInfo) (*differ.YamlObject, error) {
	oldObj := obj.DeepCopy()
	didSetNamespace := false
	if ns, err := obj.Get("/metadata/namespace"); err != nil || ns == "" {
		didSetNamespace = true
		obj.Set("/metadata/namespace", "default")
	}

	var jsonBuf = new(bytes.Buffer)
	err := differ.EncodeYamlObjectAsJson(jsonBuf, obj)
	if err != nil {
		return nil, err
	}

	k8sObj, err := ssa.ReadObject(jsonBuf)
	if err != nil {
		return nil, err
	}

	err = d.client.Create(context.Background(), k8sObj)
	if err != nil {
		return nil, err
	}

	jsonBuf.Reset()
	err = unstructured.UnstructuredJSONScheme.Encode(k8sObj, jsonBuf)
	if err != nil {
		return nil, err
	}

	err = differ.DecodeYamlObject(jsonBuf, obj)
	if err != nil {
		return nil, err
	}

	// These fields are added by the server-side dry-run. They are unique to the
	// object, so they will always appear as different
	patch := differ.Json6902Patch{
		{Op: "remove", Path: "/metadata/creationTimestamp"},
		{Op: "remove", Path: "/metadata/managedFields"},
		{Op: "remove", Path: "/metadata/uid"},
	}
	err = patch.ApplyToObject(obj, nil)
	if err != nil {
		return nil, err
	}
	if didSetNamespace {
		err = obj.Set("/metadata/namespace", "")
		if err != nil {
			return nil, err
		}
	}
	// We don't need to record each individual step change in the debug info,
	// instead we just record the whole patch as one step.
	debug.RecordIncrementalPatch(0, oldObj, obj)

	return obj, nil
}
