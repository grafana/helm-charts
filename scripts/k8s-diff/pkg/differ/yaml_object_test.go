package differ

import (
	"bytes"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestFlatten(t *testing.T) {
	obj := NewYamlObject("test")
	err := DecodeYamlObject(bytes.NewReader([]byte(`
apiVersion: v1
kind: Pod
metadata:
  name: querier
spec:
  containers:
  - name: querier
`)), obj)

	require.NoError(t, err)
	obj = obj.Flatten()

	require.Equal(t, "v1", obj.Object["/apiVersion"])
	require.Equal(t, "Pod", obj.Object["/kind"])
	require.Equal(t, "querier", obj.Object["/metadata/name"])
	require.Equal(t, "querier", obj.Object["/spec/containers/0/name"])
}
