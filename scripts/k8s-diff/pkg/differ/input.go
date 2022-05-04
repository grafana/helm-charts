package differ

import (
	"bytes"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"text/template"
)

func ReadStateFromDirectory(path string) ([]*YamlObject, error) {
	state := []*YamlObject{}
	err := filepath.WalkDir(path, func(path string, d fs.DirEntry, err error) error {
		if d.IsDir() {
			return nil
		}

		if filepath.Ext(path) != ".yaml" {
			fmt.Printf("%s: skipping non-yaml file\n", path)
			return nil
		}

		f, err := os.Open(path)
		if err != nil {
			return fmt.Errorf("failed to read k8s resource from yaml: %w", err)
		}

		var obj = NewYamlObject(filepath.Base(path))
		err = DecodeYamlObject(f, obj)
		if err != nil {
			fmt.Printf("%s: failed to decode k8s resource from yaml: %v\n", path, err)
			return nil
		}

		state = append(state, obj)
		return nil
	})
	if err != nil {
		return nil, err
	}
	return state, nil
}

func WriteStateToDirectory(objects []*YamlObject, path, outputTemplate string) error {
	var generateFileName = func(obj *YamlObject) string {
		return obj.ResourceKey.Source
	}

	if outputTemplate != "" {
		var tmpl *template.Template
		var err error
		if tmpl, err = template.New("output").Parse(outputTemplate); err != nil {
			return fmt.Errorf("failed to parse output template: %w", err)
		}
		generateFileName = func(obj *YamlObject) string {
			var buf = &bytes.Buffer{}
			err := tmpl.Execute(buf, obj.Object)
			if err != nil {
				panic(err)
			}
			return buf.String()
		}
	}

	err := os.MkdirAll(path, 0755)
	if err != nil {
		return err
	}

	for _, obj := range objects {
		f, err := os.Create(filepath.Join(path, generateFileName(obj)))
		if err != nil {
			return err
		}
		defer f.Close()
		err = EncodeYamlObject(f, obj)
		if err != nil {
			return err
		}
	}
	return nil
}
