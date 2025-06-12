package common

import (
	"encoding/json"
	"github.com/stretchr/testify/require"
	"testing"
)

func TestFilter_UnmarshalJSON(t *testing.T) {
	jsonStr := `{
		"SortBy": "title",
		"SortByDirection": "asc",
		"Limit": 10,
		"deboostFactor": 0.42,
		"deboostTag": "serie"
	}`

	var f Filter
	err := json.Unmarshal([]byte(jsonStr), &f)
	require.NoError(t, err)

	require.Equal(t, 0.42, f.DeboostFactor)
	require.Equal(t, "serie", f.DeboostTag)
	require.Equal(t, "title", f.SortBy)
	require.Equal(t, "asc", f.SortByDirection)
	if f.Limit == nil || *f.Limit != 10 {
		t.Fatalf("Expected Limit=10, got %v", f.Limit)
	}
}

func TestFilter_UnmarshalJSON_EnptyDeboost(t *testing.T) {
	jsonStr := `{
		"SortBy": "title",
		"SortByDirection": "asc",
		"Limit": 10
	}`

	var f Filter
	err := json.Unmarshal([]byte(jsonStr), &f)
	require.NoError(t, err)

	require.Equal(t, 0.00, f.DeboostFactor)
	require.Equal(t, "", f.DeboostTag)
	require.Equal(t, "title", f.SortBy)
	require.Equal(t, "asc", f.SortByDirection)
	if f.Limit == nil || *f.Limit != 10 {
		t.Fatalf("Expected Limit=10, got %v", f.Limit)
	}
}
