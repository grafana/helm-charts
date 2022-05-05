package differ

import (
	"fmt"
	"io"

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

// RemoveNulls removes all null values from the object. This is useful because
// the default removal process leaves null values for fields that are not set.
func (y *YamlObject) RemoveNulls() {
	removeNulls(y.Object)
}

func removeNulls(obj interface{}) interface{} {
	switch value := obj.(type) {
	case map[interface{}]interface{}:
		for k := range value {
			value[k] = removeNulls(value[k])
			if value[k] == nil {
				delete(value, k)
			}
		}
		if len(value) == 0 {
			return nil
		}
	case map[string]interface{}:
		for k := range value {
			value[k] = removeNulls(value[k])
			if value[k] == nil {
				delete(value, k)
			}
		}
		if len(value) == 0 {
			return nil
		}
	case []interface{}:
		for i := range value {
			value[i] = removeNulls(value[i])
		}
	}

	return obj
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
