package differ

import (
	"fmt"
	"io"
	"strings"

	jsoniter "github.com/json-iterator/go"
	"github.com/mitchellh/copystructure"
	"github.com/mitchellh/pointerstructure"
	"gopkg.in/yaml.v2"
)

type YamlObject struct {
	Object      map[string]interface{}
	ResourceKey ResourceKey
}

func NewYamlObject(source string) *YamlObject {
	return &YamlObject{
		Object: make(map[string]interface{}),
		ResourceKey: ResourceKey{
			Source: source,
		},
	}
}

func (y *YamlObject) Flatten() *YamlObject {
	output := NewYamlObject(y.ResourceKey.Source)
	flatten([]string{""}, y.Object, output.Object)
	return output
}

func flatten(prefix []string, source interface{}, dest map[string]interface{}) {
	switch value := source.(type) {
	case map[string]interface{}:
		for k, v := range value {
			key := append(prefix, k)
			flatten(key, v, dest)
		}
	case map[interface{}]interface{}:
		for k, v := range value {
			key := append(prefix, fmt.Sprint(k))
			flatten(key, v, dest)
		}
	case []interface{}:
		for i, v := range value {
			key := append(prefix, fmt.Sprintf("%d", i))
			flatten(key, v, dest)
		}
	default:
		key := strings.Join(prefix, "/")
		dest[key] = value
	}
}

func (obj *YamlObject) Get(path string) (value interface{}, error error) {
	return pointerstructure.Get(obj.Object, path)
}

func (obj *YamlObject) Set(path string, value interface{}) (error error) {
	newObj, err := pointerstructure.Set(obj.Object, path, value)
	if err != nil {
		return err
	}
	obj.Object = newObj.(map[string]interface{})
	return nil
}

func (obj *YamlObject) DeepCopy() *YamlObject {
	newObj, err := copystructure.Copy(obj)
	if err != nil {
		panic(fmt.Sprintf("failed to deep copy object: %v", err))
	}
	return newObj.(*YamlObject)
}

func DecodeYamlObject(reader io.Reader, obj *YamlObject) error {
	return yaml.NewDecoder(reader).Decode(&obj.Object)
}

func EncodeYamlObject(writer io.Writer, obj *YamlObject) error {
	return yaml.NewEncoder(writer).Encode(obj.Object)
}

func EncodeYamlObjectAsJson(writer io.Writer, obj *YamlObject) error {
	return jsoniter.ConfigCompatibleWithStandardLibrary.NewEncoder(writer).Encode(obj.Object)
}
