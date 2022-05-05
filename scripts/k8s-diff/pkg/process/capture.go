package process

import (
	"bytes"
	"fmt"
	"io"
	"k8s-diff/pkg/differ"
	"os"
	"os/exec"
)

var pulledImages = map[string]bool{}

type ProcessConfiguration struct {
	Image          string
	Args           []string
	ConfigFileText string
}

func RunMimirAndCaptureConfigOutput(pc ProcessConfiguration, source string) (*differ.YamlObject, error) {
	// write temp config file
	tmpConfigFile, err := os.CreateTemp("", "")
	if err != nil {
		return nil, fmt.Errorf("failed to create temp config file: %v", err)
	}
	defer os.Remove(tmpConfigFile.Name())

	_, err = io.WriteString(tmpConfigFile, pc.ConfigFileText)
	if err != nil {
		return nil, fmt.Errorf("failed to write temp config file: %v", err)
	}
	err = tmpConfigFile.Close()
	if err != nil {
		return nil, fmt.Errorf("failed to close temp config file: %v", err)
	}

	if _, ok := pulledImages[pc.Image]; !ok {
		pullCommand := exec.Command("docker", "pull", pc.Image)
		pullCommand.Stdout = os.Stderr
		pullCommand.Stderr = os.Stderr
		err = pullCommand.Run()
		if err != nil {
			return nil, fmt.Errorf("failed to pull image %s: %v", pc.Image, err)
		}
		pulledImages[pc.Image] = true
	}

	finalArgs := []string{}
	finalArgs = append(finalArgs, "run", "--hostname", "docker", "-v", tmpConfigFile.Name()+":/config.yml", pc.Image)
	finalArgs = append(finalArgs, pc.Args...)
	finalArgs = append(finalArgs, "-print.config", "-config.file", "/config.yml")

	// run command
	mimirOutput, err := exec.Command("docker", finalArgs...).CombinedOutput()
	if err != nil {
		return nil, fmt.Errorf("failed to run mimir: %v\n%s", err, string(mimirOutput))
	}

	// parse output
	var configObj = differ.NewYamlObject("config-" + source)
	err = differ.DecodeYamlObject(bytes.NewReader(mimirOutput), configObj)
	if err != nil {
		return nil, fmt.Errorf("failed to decode config output: %v\n%s", err, string(mimirOutput))
	}

	return configObj, nil
}
