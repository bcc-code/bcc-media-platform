package search

import (
	"bytes"
	"encoding/json"
	"html/template"
	"testing"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/stretchr/testify/assert"
)

func Test_assignVisibility(t *testing.T) {
	now := time.Now()
	future := now.Add(time.Hour * 24)
	past := now.Add(-time.Hour * 24)

	tests := []struct {
		name         string
		availability common.Availability
		expected     searchItem
	}{
		{
			name: "zero times map to zero",
			availability: common.Availability{
				Published: true,
			},
			expected: searchItem{
				Published:     true,
				AvailableFrom: 0,
				AvailableTo:   0,
				PublishedOn:   0,
			},
		},
		{
			name: "set times map to unix seconds",
			availability: common.Availability{
				Published:   true,
				From:        past,
				To:          future,
				PublishedOn: past,
			},
			expected: searchItem{
				Published:     true,
				AvailableFrom: int(past.Unix()),
				AvailableTo:   int(future.Unix()),
				PublishedOn:   int(past.Unix()),
			},
		},
		{
			name: "future publishedOn is preserved",
			availability: common.Availability{
				Published:   true,
				From:        past,
				To:          future,
				PublishedOn: future,
			},
			expected: searchItem{
				Published:     true,
				AvailableFrom: int(past.Unix()),
				AvailableTo:   int(future.Unix()),
				PublishedOn:   int(future.Unix()),
			},
		},
		{
			name: "unpublished stays unpublished",
			availability: common.Availability{
				Published:   false,
				PublishedOn: past,
			},
			expected: searchItem{
				Published:   false,
				PublishedOn: int(past.Unix()),
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			item := searchItem{}
			item.assignVisibility(tt.availability)
			assert.Equal(t, tt.expected, item)
		})
	}
}

func Test_toSearchObject_publishedOn(t *testing.T) {
	now := time.Now()

	item := searchItem{
		ID:   "episodes-1",
		Type: "episode",
	}
	item.assignVisibility(common.Availability{
		Published:   true,
		From:        now.Add(-time.Hour),
		To:          now.Add(time.Hour),
		PublishedOn: now.Add(time.Hour * 48),
	})

	object := item.toSearchObject()

	assert.Equal(t, int(now.Add(time.Hour*48).Unix()), object[publishedOnField])
	assert.Equal(t, int(now.Add(-time.Hour).Unix()), object[availableFromField])
	assert.Equal(t, int(now.Add(time.Hour).Unix()), object[availableToField])
	assert.Equal(t, true, object[publishedField])
}

func Test_mainElasticTemplate_publishedOnFilter(t *testing.T) {
	now := time.Now().Unix()

	params := &elasticQueryParams{
		Roles:        []string{"bcc-members"},
		QueryString:  template.HTML("test"),
		Limit:        10,
		Offset:       0,
		TimeNow:      now,
		Languages:    []string{"no", "en"},
		AuxLanguages: []string{"de"},
	}

	jsonQuery := &bytes.Buffer{}
	err := templates.ExecuteTemplate(jsonQuery, "main-elastic.json.tmpl", params)
	assert.NoError(t, err)

	var query map[string]any
	err = json.Unmarshal(jsonQuery.Bytes(), &query)
	assert.NoError(t, err, "rendered query must be valid JSON")

	filters := query["query"].(map[string]any)["bool"].(map[string]any)["filter"].([]any)

	var found bool
	for _, f := range filters {
		b, ok := f.(map[string]any)["bool"].(map[string]any)
		if !ok {
			continue
		}
		mustNot, ok := b["must_not"].([]any)
		if !ok {
			continue
		}
		for _, mn := range mustNot {
			r, ok := mn.(map[string]any)["range"].(map[string]any)
			if !ok {
				continue
			}
			if p, ok := r["publishedOn"].(map[string]any); ok {
				found = true
				assert.EqualValues(t, now, p["gt"])
			}
		}
	}
	assert.True(t, found, "expected a must_not range filter on publishedOn")
}
