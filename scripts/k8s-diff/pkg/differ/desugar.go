package differ

import (
	"fmt"

	"github.com/mitchellh/copystructure"
)

func Desugar(rule Json6902PatchRule) []Json6902PatchRule {
	if rule.RenameObject != nil {
		rule.Match = append(rule.Match, Json6902Operation{
			Op:    "test",
			Path:  "/metadata/name",
			Value: rule.RenameObject.From,
		})
		rule.Steps = append(rule.Steps, Json6902Operation{
			Op:    "replace",
			Path:  "/metadata/name",
			Value: rule.RenameObject.To,
		})
		if rule.Name == "" {
			rule.Name = fmt.Sprintf("Rename %s to %s", rule.RenameObject.From, rule.RenameObject.To)
		}
		rule.RenameObject = nil
	}

	if rule.RemoveField != "" {
		rule.Match = append(rule.Match, Json6902Operation{
			Op:   "remove",
			Path: rule.RemoveField,
		})
		rule.Steps = append(rule.Steps, Json6902Operation{
			Op:   "remove",
			Path: rule.RemoveField,
		})
		if rule.Name == "" {
			rule.Name = fmt.Sprintf("Remove %s", rule.RemoveField)
		}
		rule.RemoveField = ""
	}

	if rule.RenameField != nil {
		rule.Match = append(rule.Match, Json6902Operation{
			Op:   "remove",
			Path: rule.RenameField.From,
		})
		rule.Steps = append(rule.Steps, Json6902Operation{
			Op:   "move",
			Path: rule.RenameField.To,
			From: rule.RenameField.From,
		})
		if rule.Name == "" {
			rule.Name = fmt.Sprintf("Rename %s to %s", rule.RenameField.From, rule.RenameField.To)
		}
		rule.RenameField = nil
	}

	finalRules := []Json6902PatchRule{rule}

	for path, values := range rule.Matchers {
		finalRules = addMatchRulesToAll(finalRules, path, values)
	}

	return finalRules
}

func addMatchRulesToAll(rules []Json6902PatchRule, path string, values []interface{}) []Json6902PatchRule {
	output := []Json6902PatchRule{}

	for _, jpr := range rules {
		output = append(output, addMatchRules(jpr, path, values)...)
	}

	return output
}

func addMatchRules(rule Json6902PatchRule, path string, values []interface{}) []Json6902PatchRule {
	var output = []Json6902PatchRule{}
	for _, value := range values {
		copy, err := copystructure.Copy(rule)
		if err != nil {
			panic(err)
		}
		newRule := copy.(Json6902PatchRule)
		newRule.Match = append(newRule.Match, Json6902Operation{
			Op:    "test",
			Path:  path,
			Value: value,
		})
		output = append(output, newRule)
	}
	return output
}
