package differ

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestDesugaring(t *testing.T) {
	t.Run("remove_field desugars to a remove operation", func(t *testing.T) {
		rule := Json6902PatchRule{
			RemoveField: "/spec/replicas",
		}
		rule = Desugar(rule)

		// We use a remove operation in the Match to check that the field exists first
		require.Len(t, rule.Match, 1)
		require.Equal(t, "remove", rule.Match[0].Op)
		require.Equal(t, "/spec/replicas", rule.Match[0].Path)

		// Then we use a remove operation again in the Steps to remove the field
		require.Len(t, rule.Steps, 1)
		require.Equal(t, "remove", rule.Steps[0].Op)
		require.Equal(t, "/spec/replicas", rule.Steps[0].Path)
	})

	t.Run("rename_field desugars to a move operation", func(t *testing.T) {
		rule := Json6902PatchRule{
			RenameField: &RenameRule{
				From: "/metadata/labels/app.kubernetes.io~1name",
				To:   "/metadata/labels/name",
			},
		}
		rule = Desugar(rule)

		// We use a remove operation in the Match to check that the field exists first
		require.Len(t, rule.Match, 1)
		require.Equal(t, "remove", rule.Match[0].Op)
		require.Equal(t, "/metadata/labels/app.kubernetes.io~1name", rule.Match[0].Path)

		// Then we use a move operation again in the Steps to rename the field
		require.Len(t, rule.Steps, 1)
		require.Equal(t, "move", rule.Steps[0].Op)
		require.Equal(t, "/metadata/labels/name", rule.Steps[0].Path)
		require.Equal(t, "/metadata/labels/app.kubernetes.io~1name", rule.Steps[0].From)
	})

	t.Run("rename_object desugars to a replace operation", func(t *testing.T) {
		rule := Json6902PatchRule{
			RenameObject: &RenameRule{
				From: "mimir-querier",
				To:   "querier",
			},
		}
		rule = Desugar(rule)

		// We use a test operation to find objects of the old name
		require.Len(t, rule.Match, 1)
		require.Equal(t, "test", rule.Match[0].Op)
		require.Equal(t, "/metadata/name", rule.Match[0].Path)
		require.Equal(t, "mimir-querier", rule.Match[0].Value)

		// Then we use a replace operation to rename the object
		require.Len(t, rule.Steps, 1)
		require.Equal(t, "replace", rule.Steps[0].Op)
		require.Equal(t, "/metadata/name", rule.Steps[0].Path)
		require.Equal(t, "querier", rule.Steps[0].Value)
	})

	t.Run("match_kind desugars to a test operation", func(t *testing.T) {
		rule := Json6902PatchRule{
			MatchKind: "Deployment",
		}
		rule = Desugar(rule)

		// We use a test operation to find objects with the correct kind
		require.Len(t, rule.Match, 1)
		require.Equal(t, "test", rule.Match[0].Op)
		require.Equal(t, "/kind", rule.Match[0].Path)
		require.Equal(t, "Deployment", rule.Match[0].Value)
	})

	t.Run("complex desugaring appends to match and patch steps", func(t *testing.T) {
		rule := Json6902PatchRule{
			Name: "Mixed desugaring operations",
			Match: Json6902Patch{
				{Op: "test", Path: "/metadata/labels/part-of", Value: "memberlist"},
			},
			Steps: Json6902Patch{
				{Op: "remove", Path: "/spec/strategy"},
			},

			MatchKind: "Deployment",
			RenameObject: &RenameRule{
				From: "mimir-querier",
				To:   "querier",
			},
			RemoveField: "/spec/replicas",
		}
		rule = Desugar(rule)

		// There should be one match operation for each of the following:
		// - test /metadata/labels/part-of memberlist
		// - test /kind Deployment
		// - test /metadata/name mimir-querier
		// - remove /spec/replicas
		require.Len(t, rule.Match, 4)

		// There should be one patch operation for each of the following:
		// - remove /spec/strategy
		// - replace /metadata/name querier
		// - remove /spec/replicas
		require.Len(t, rule.Steps, 3)
	})
}
