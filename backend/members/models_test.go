package members

import (
	"testing"
	"time"
)

func TestAffiliation_IsActive(t *testing.T) {
	now := time.Now()
	past := now.Add(-24 * time.Hour)
	future := now.Add(24 * time.Hour)

	tests := []struct {
		name        string
		affiliation Affiliation
		want        bool
	}{
		{
			name: "active with no date constraints",
			affiliation: Affiliation{
				Active:    true,
				ValidFrom: nil,
				ValidTo:   nil,
			},
			want: true,
		},
		{
			name: "inactive flag",
			affiliation: Affiliation{
				Active:    false,
				ValidFrom: nil,
				ValidTo:   nil,
			},
			want: false,
		},
		{
			name: "active with valid date range",
			affiliation: Affiliation{
				Active:    true,
				ValidFrom: &past,
				ValidTo:   &future,
			},
			want: true,
		},
		{
			name: "active but not yet started",
			affiliation: Affiliation{
				Active:    true,
				ValidFrom: &future,
				ValidTo:   nil,
			},
			want: false,
		},
		{
			name: "active but expired",
			affiliation: Affiliation{
				Active:    true,
				ValidFrom: nil,
				ValidTo:   &past,
			},
			want: false,
		},
		{
			name: "active with only ValidFrom in past",
			affiliation: Affiliation{
				Active:    true,
				ValidFrom: &past,
				ValidTo:   nil,
			},
			want: true,
		},
		{
			name: "active with only ValidTo in future",
			affiliation: Affiliation{
				Active:    true,
				ValidFrom: nil,
				ValidTo:   &future,
			},
			want: true,
		},
		{
			name: "inactive despite valid date range",
			affiliation: Affiliation{
				Active:    false,
				ValidFrom: &past,
				ValidTo:   &future,
			},
			want: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := tt.affiliation.IsActive(); got != tt.want {
				t.Errorf("Affiliation.IsActive() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestHasActiveAffiliation(t *testing.T) {
	now := time.Now()
	past := now.Add(-24 * time.Hour)
	future := now.Add(24 * time.Hour)

	tests := []struct {
		name         string
		affiliations []Affiliation
		want         bool
	}{
		{
			name:         "empty slice",
			affiliations: []Affiliation{},
			want:         false,
		},
		{
			name:         "nil slice",
			affiliations: nil,
			want:         false,
		},
		{
			name: "single active affiliation",
			affiliations: []Affiliation{
				{Active: true, ValidFrom: &past, ValidTo: &future},
			},
			want: true,
		},
		{
			name: "single inactive affiliation",
			affiliations: []Affiliation{
				{Active: false, ValidFrom: &past, ValidTo: &future},
			},
			want: false,
		},
		{
			name: "multiple affiliations with one active",
			affiliations: []Affiliation{
				{Active: false, ValidFrom: &past, ValidTo: &future},
				{Active: true, ValidFrom: &past, ValidTo: &future},
				{Active: true, ValidFrom: nil, ValidTo: &past}, // expired
			},
			want: true,
		},
		{
			name: "multiple affiliations all inactive",
			affiliations: []Affiliation{
				{Active: false, ValidFrom: &past, ValidTo: &future},
				{Active: true, ValidFrom: &future, ValidTo: nil}, // not yet started
				{Active: true, ValidFrom: nil, ValidTo: &past},   // expired
			},
			want: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := HasActiveAffiliation(tt.affiliations); got != tt.want {
				t.Errorf("HasActiveAffiliation() = %v, want %v", got, tt.want)
			}
		})
	}
}
