package main

import (
	"flag"
	"fmt"
	"k8s-diff/pkg/differ"
	k8s_defaulter "k8s-diff/pkg/k8s-defaulter"
	"os"
)

type Config struct {
	InputDir  string
	OutputDir string
}

func (c *Config) RegisterFlags(f *flag.FlagSet) {
	f.StringVar(&c.InputDir, "input-dir", "", "Input directory")
	f.StringVar(&c.OutputDir, "output-dir", "", "Output directory")
}

func main() {
	var config = &Config{}
	config.RegisterFlags(flag.CommandLine)

	flag.Parse()

	if config.InputDir == "" || config.OutputDir == "" {
		fmt.Println("input-dir and output-dir are required")
		flag.Usage()
		os.Exit(1)
	}

	objects, err := differ.ReadStateFromDirectory(config.InputDir)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	client, err := k8s_defaulter.NewDryRunK8sClient()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	rule := k8s_defaulter.NewDefaultSettingRule(client)
	objects, err = differ.MapObjects(objects, rule, nil)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	err = differ.WriteStateToDirectory(objects, config.OutputDir, "")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
