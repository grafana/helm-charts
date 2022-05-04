package main

import (
	"bytes"
	"flag"
	"fmt"
	"k8s-diff/pkg/differ"
	"k8s-diff/pkg/process"
	"os"
	"path/filepath"
	"strings"

	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/client-go/kubernetes/scheme"
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

	extractor := NewConfigExtractor()
	_, err = differ.MapObjects(objects, extractor, nil)
	if err != nil {
		fmt.Fprintln(os.Stderr, "failed to map objects:", err)
		os.Exit(1)
	}

	configs, err := extractor.ResolveConfigs()
	if err != nil {
		fmt.Fprintln(os.Stderr, "failed to resolve configs:", err)
		os.Exit(1)
	}

	err = differ.WriteStateToDirectory(configs, config.OutputDir, "")
	if err != nil {
		fmt.Fprintln(os.Stderr, "failed to write configs:", err)
		os.Exit(1)
	}
}

type ConfigExtractor struct {
	pods       map[differ.ResourceKey]corev1.PodSpec
	configMaps []corev1.ConfigMap
	secrets    []corev1.Secret
}

func NewConfigExtractor() *ConfigExtractor {
	return &ConfigExtractor{
		pods: make(map[differ.ResourceKey]corev1.PodSpec),
	}
}

func (c *ConfigExtractor) Describe() differ.ObjectRuleDescription {
	return differ.ObjectRuleDescription{
		Name: "Config Extractor",
	}
}

func (c *ConfigExtractor) MapObject(obj *differ.YamlObject, debugInfo *differ.RuleDebugInfo) (*differ.YamlObject, error) {
	typedObj, err := decodeTypedObject(obj)
	if err != nil {
		return nil, err
	}

	switch v := typedObj.(type) {
	case *appsv1.Deployment:
		c.pods[differ.ResourceKeyForObject(obj)] = v.Spec.Template.Spec
	case *appsv1.StatefulSet:
		c.pods[differ.ResourceKeyForObject(obj)] = v.Spec.Template.Spec
	case *corev1.ConfigMap:
		c.configMaps = append(c.configMaps, *v)
	case *corev1.Secret:
		c.secrets = append(c.secrets, *v)
	}

	return nil, nil
}

func (c *ConfigExtractor) ResolveConfigs() ([]*differ.YamlObject, error) {
	var processConfigs = map[differ.ResourceKey]process.ProcessConfiguration{}
	for key, pod := range c.pods {
		for _, container := range pod.Containers {
			if !strings.HasPrefix(container.Image, MimirImage) {
				continue
			}
			var processConfig process.ProcessConfiguration
			mountPath, restArgs := findConfigPath(container.Args)
			processConfig.Image = container.Image
			processConfig.Args = restArgs

			if mountPath != "" {
				for _, vm := range container.VolumeMounts {
					if strings.HasPrefix(mountPath, vm.MountPath) {
						content, err := c.resolveVolumeText(vm.Name, filepath.Base(mountPath), pod)
						if err != nil {
							return nil, fmt.Errorf("failed to resolve volume mount %s in pod %s: %v", vm.Name, key, err)
						}

						processConfig.ConfigFileText = content
					}
				}
			}

			processConfigs[key] = processConfig
		}
	}

	var rawConfigs = []*differ.YamlObject{}
	for key, pc := range processConfigs {
		configObj, err := process.RunMimirAndCaptureConfigOutput(pc, key.Source)
		if err != nil {
			return nil, fmt.Errorf("failed to generate config for %s: %v", key, err)
		}

		rawConfigs = append(rawConfigs, configObj)
	}

	return rawConfigs, nil
}

func findConfigPath(args []string) (string, []string) {
	for i, arg := range args {
		if strings.Contains(arg, "config.file") {
			return strings.TrimPrefix(arg, "-config.file="), append(args[:i], args[i+1:]...)
		}
	}
	return "", args
}

func (c *ConfigExtractor) resolveVolumeText(volumeName, fileName string, spec corev1.PodSpec) (string, error) {
	for _, volume := range spec.Volumes {
		if volume.Name == volumeName {
			if volume.ConfigMap != nil {
				text, err := c.resolveConfigMap(volume.ConfigMap.Name, fileName)
				if err != nil {
					return "", fmt.Errorf("failed to resolve config map %s: %v", volume.ConfigMap.Name, err)
				}
				return text, nil
			}
			if volume.Secret != nil {
				text, err := c.resolveSecret(volume.Secret.SecretName, fileName)
				if err != nil {
					return "", fmt.Errorf("failed to resolve secret %s: %v", volume.Secret.SecretName, err)
				}
				return text, nil
			}
			if volume.EmptyDir != nil {
				return "", nil
			}

			return "", fmt.Errorf("unsupported volume type: %v", volume)
		}
	}

	return "", nil
}

func (c *ConfigExtractor) resolveConfigMap(name string, fileName string) (string, error) {
	for _, configMap := range c.configMaps {
		if configMap.Name == name {
			return string(configMap.Data[fileName]), nil
		}
	}

	return "", fmt.Errorf("config map %s not found", name)
}

func (c *ConfigExtractor) resolveSecret(name string, fileName string) (string, error) {
	for _, secret := range c.secrets {
		if secret.Name == name {
			return string(secret.Data[fileName]), nil
		}
	}

	return "", fmt.Errorf("secret %s not found", name)
}

func decodeTypedObject(obj *differ.YamlObject) (runtime.Object, error) {
	buf := new(bytes.Buffer)
	err := differ.EncodeYamlObject(buf, obj)
	if err != nil {
		return nil, err
	}

	result, _, err := scheme.Codecs.UniversalDeserializer().Decode(buf.Bytes(), nil, nil)
	return result, err
}
