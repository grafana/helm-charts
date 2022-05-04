package main

import (
	"bytes"
	"flag"
	"fmt"
	"k8s-diff/pkg/differ"
	"k8s-diff/pkg/process"
	"os"

	jsonpatch "github.com/evanphx/json-patch"
)

type Config struct {
	InputDir  string
	OutputDir string
}

const MimirImage = "grafana/mimir"

func (c *Config) RegisterFlags(f *flag.FlagSet) {
	f.StringVar(&c.InputDir, "input-dir", "", "Input directory")
	f.StringVar(&c.OutputDir, "output-dir", "", "Output directory")
}

func main() {
	config := &Config{}
	config.RegisterFlags(flag.CommandLine)
	flag.Parse()

	if config.InputDir == "" || config.OutputDir == "" {
		fmt.Fprintln(os.Stderr, "--input-dir and --output-dir are required")
		flag.Usage()
		os.Exit(1)
	}

	objects, err := differ.ReadStateFromDirectory(config.InputDir)
	if err != nil {
		fmt.Fprintln(os.Stderr, "failed to read state:", err)
		os.Exit(1)
	}

	defaults, err := LoadDefaults()
	if err != nil {
		fmt.Fprintln(os.Stderr, "failed to load defaults:", err)
		os.Exit(1)
	}

	for i, yo := range objects {
		objects[i], err = removeDefaults(defaults, yo)
		if err != nil {
			fmt.Fprintln(os.Stderr, "failed to remove defaults:", err)
			os.Exit(1)
		}

		objects[i] = objects[i].Flatten()
	}

	err = differ.WriteStateToDirectory(objects, config.OutputDir, "")
	if err != nil {
		fmt.Fprintln(os.Stderr, "failed to write configs:", err)
		os.Exit(1)
	}
}

func removeDefaults(defaults, config *differ.YamlObject) (*differ.YamlObject, error) {
	defaultsBuf := new(bytes.Buffer)
	err := differ.EncodeYamlObjectAsJson(defaultsBuf, defaults)
	if err != nil {
		return nil, err
	}

	configBuf := new(bytes.Buffer)
	err = differ.EncodeYamlObjectAsJson(configBuf, config)
	if err != nil {
		return nil, err
	}

	patchResult, err := jsonpatch.CreateMergePatch(defaultsBuf.Bytes(), configBuf.Bytes())
	if err != nil {
		return nil, err
	}

	var finalConfig = differ.NewYamlObject(config.ResourceKey.Source)
	err = differ.DecodeYamlObject(bytes.NewReader(patchResult), finalConfig)
	if err != nil {
		return nil, err
	}

	return finalConfig, nil
}

func LoadDefaults() (*differ.YamlObject, error) {
	configObj, err := process.RunMimirAndCaptureConfigOutput(process.ProcessConfiguration{
		Image:          MimirImage + ":2.0.0",
		Args:           []string{},
		ConfigFileText: ``,
	}, "default")
	if err != nil {
		return nil, err
	}

	return configObj, nil
}
