package differ

// ResourceKey represents a unique identifier for any object
type ResourceKey struct {
	Source string
}

func (r ResourceKey) String() string {
	return r.Source
}

func ResourceKeyForObject(obj *YamlObject) ResourceKey {
	return obj.ResourceKey
}

func ApplyRuleSet(objects []*YamlObject, ruleSet RuleSet, debugInfo *DebugInfo) ([]*YamlObject, error) {
	var err error
	for i, ir := range ruleSet.IgnoreRules {
		objects, err = MapObjects(objects, ir, debugInfo.NewRuleDebugInfo(i, ir))
		if err != nil {
			return nil, err
		}
	}

	for i, pr := range ruleSet.PatchRules {
		objects, err = MapObjects(objects, pr, debugInfo.NewRuleDebugInfo(len(ruleSet.IgnoreRules)+i, pr))
		if err != nil {
			return nil, err
		}
	}

	return objects, nil
}

func MapObjects(state []*YamlObject, mapper ObjectRule, ruleDebugInfo *RuleDebugInfo) ([]*YamlObject, error) {
	result := []*YamlObject{}
	for _, obj := range state {
		mapped, err := mapper.MapObject(obj, ruleDebugInfo)
		if err != nil {
			return nil, err
		}
		if mapped != nil {
			result = append(result, mapped)
		}
	}
	return result, nil
}
