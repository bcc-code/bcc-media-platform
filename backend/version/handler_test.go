package version

import (
	"runtime/debug"
	"testing"
)

func Test_shaFromSettings(t *testing.T) {
	tests := []struct {
		name     string
		settings []debug.BuildSetting
		expected string
	}{
		{
			name:     "no settings",
			settings: nil,
			expected: "",
		},
		{
			name:     "no vcs.revision",
			settings: []debug.BuildSetting{{Key: "vcs.modified", Value: "true"}},
			expected: "",
		},
		{
			name: "full sha is shortened",
			settings: []debug.BuildSetting{
				{Key: "vcs.revision", Value: "3e4c8d3b1f2a4c5d6e7f8091a2b3c4d5e6f70819"},
				{Key: "vcs.modified", Value: "false"},
			},
			expected: "3e4c8d3",
		},
		{
			name: "modified tree is marked dirty",
			settings: []debug.BuildSetting{
				{Key: "vcs.revision", Value: "3e4c8d3b1f2a4c5d6e7f8091a2b3c4d5e6f70819"},
				{Key: "vcs.modified", Value: "true"},
			},
			expected: "3e4c8d3-dirty",
		},
		{
			name:     "short revision is left alone",
			settings: []debug.BuildSetting{{Key: "vcs.revision", Value: "3e4c8d"}},
			expected: "3e4c8d",
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			if got := shaFromSettings(test.settings); got != test.expected {
				t.Errorf("shaFromSettings() = %q, want %q", got, test.expected)
			}
		})
	}
}
