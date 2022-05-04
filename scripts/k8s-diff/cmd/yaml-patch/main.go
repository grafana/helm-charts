package main

import (
	"flag"
	"fmt"
	"k8s-diff/pkg/differ"
	"os"

	"github.com/grafana/dskit/flagext"
	"gopkg.in/yaml.v2"
)

type Config struct {
	RuleFiles      flagext.StringSlice
	InputDir       flagext.StringSlice
	OutputDir      flagext.StringSlice
	OutputTemplate string
}

func (c *Config) RegisterFlags(f *flag.FlagSet) {
	f.Var(&c.RuleFiles, "rules", "Rule file to load, can be specified multiple times")
	f.Var(&c.InputDir, "input-dir", "Input directory, can be specified multiple times - must have the same number of elements as output-dir")
	f.Var(&c.OutputDir, "output-dir", "Output directory, can be specified multiple times - must have the same number of elements as input-dir")
	f.StringVar(&c.OutputTemplate, "output-template", "", "Template used to generate output file names.")
}

func (c *Config) LoadRuleSet() (differ.RuleSet, error) {
	ruleSet := differ.RuleSet{}
	for _, v := range c.RuleFiles {
		subRules := &differ.RuleSet{}
		ruleFile, err := os.Open(v)
		if err != nil {
			return ruleSet, fmt.Errorf("failed to open rule file: %v", err)
		}
		defer ruleFile.Close()
		err = yaml.NewDecoder(ruleFile).Decode(subRules)
		if err != nil {
			return ruleSet, fmt.Errorf("failed to decode rule file: %v", err)
		}

		ruleSet.Merge(subRules)
	}
	ruleSet.Desugar()
	return ruleSet, nil
}

func main() {
	var config = &Config{}
	config.RegisterFlags(flag.CommandLine)

	flag.Parse()

	if len(config.InputDir) != len(config.OutputDir) {
		fmt.Fprintln(os.Stderr, "--input-dir and --output-dir must have the same number of elements")
		flag.Usage()
		os.Exit(1)
	}

	if len(config.InputDir) == 0 || len(config.OutputDir) == 0 {
		fmt.Println("input-dir and output-dir are required")
		flag.Usage()
		os.Exit(1)
	}

	ruleSet, err := config.LoadRuleSet()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	var debugInfo = differ.NewDebugInfo(ruleSet)

	for i, inputDir := range config.InputDir {
		outputDir := config.OutputDir[i]

		objects, err := differ.ReadStateFromDirectory(inputDir)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		debugInfo.AddInitialObjects(objects)

		objects, err = differ.ApplyRuleSet(objects, ruleSet, debugInfo)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		err = differ.WriteStateToDirectory(objects, outputDir, config.OutputTemplate)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
	}

	err = debugInfo.ValidateAllRulesWereEffective()
	if err != nil {
		fmt.Println(err)
	}

}
