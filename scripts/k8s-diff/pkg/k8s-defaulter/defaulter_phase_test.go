package k8s_defaulter

import (
	"bytes"
	"encoding/json"
	"k8s-diff/pkg/differ"
	"testing"

	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"github.com/stretchr/testify/require"
)

func newDeploymentWithLabels(name string, labels map[string]string) *differ.YamlObject {
	dep := appsv1.Deployment{
		TypeMeta: metav1.TypeMeta{
			Kind:       "Deployment",
			APIVersion: "apps/v1",
		},
		ObjectMeta: metav1.ObjectMeta{
			Namespace: "default",
			Name:      name,
			Labels:    labels,
		},
		Spec: appsv1.DeploymentSpec{
			Selector: &metav1.LabelSelector{
				MatchLabels: labels,
			},
			Template: corev1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{
					Labels: labels,
				},
				Spec: corev1.PodSpec{
					Containers: []corev1.Container{
						{
							Name:  "querier",
							Image: "gcr.io/nginx/nginx:1.7.9",
						},
					},
				},
			},
		},
	}

	buf := new(bytes.Buffer)
	err := json.NewEncoder(buf).Encode(dep)
	if err != nil {
		panic(err)
	}

	output := differ.NewYamlObject("test-data")
	err = differ.DecodeYamlObject(buf, output)
	if err != nil {
		panic(err)
	}
	return output
}

func TestDefaultMapper(t *testing.T) {
	dep := newDeploymentWithLabels("querier", map[string]string{
		"app": "querier",
	})

	cli, err := NewDryRunK8sClient()
	require.NoError(t, err)

	defaulter := DefaultSettingRule{client: cli}
	result, err := defaulter.MapObject(dep, nil)
	require.NoError(t, err)
	strategy, err := result.Get("/spec/strategy/type")
	require.NoError(t, err)
	require.Equal(t, "RollingUpdate", strategy)
}

func TestDefaultMapperSetsNamespace(t *testing.T) {
	// The defaulter will internally set a namespace if it's missing, but we
	// don't want to impact the final output, so it should not be set in the
	// output.
	dep := newDeploymentWithLabels("querier", map[string]string{
		"app": "querier",
	})
	err := dep.Set("/metadata/namespace", "")
	require.NoError(t, err)

	cli, err := NewDryRunK8sClient()
	require.NoError(t, err)

	defaulter := DefaultSettingRule{client: cli}
	result, err := defaulter.MapObject(dep, nil)
	require.NoError(t, err)
	ns, err := result.Get("/metadata/namespace")
	require.NoError(t, err)
	require.Equal(t, "", ns)
}
