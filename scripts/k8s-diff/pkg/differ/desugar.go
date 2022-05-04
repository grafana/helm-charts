package differ

import "fmt"

func Desugar(rule Json6902PatchRule) Json6902PatchRule {
	if rule.MatchKind != "" {
		rule.Match = append(rule.Match, Json6902Operation{
			Op:    "test",
			Path:  "/kind",
			Value: rule.MatchKind,
		})
		rule.MatchKind = ""
	}

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

	return rule
}
