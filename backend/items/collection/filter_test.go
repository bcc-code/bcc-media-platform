package collection

import (
	"encoding/json"
	"testing"

	"github.com/Masterminds/squirrel"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/jsonlogic"
	"github.com/stretchr/testify/assert"
	"gopkg.in/guregu/null.v4"
)

func TestAddLanguageFilterWhenFeatureDisabled(t *testing.T) {
	// Arrange
	originalFilter := squirrel.Eq{"id": 1}
	query := jsonlogic.Query{
		Filter: originalFilter,
		Joins:  []string{"join1"},
	}

	langPrefs := common.LanguagePreferences{
		ContentOnlyInPreferredLanguage: false,
		PreferredAudioLanguages:        []string{"en", "no"},
		PreferredSubtitlesLanguages:    []string{"en", "fr"},
	}

	// Act
	result := addLanguageFilter(query, langPrefs)

	// Assert
	assert.Equal(t, originalFilter, result.Filter)
	assert.Equal(t, query.Joins, result.Joins)
}

func TestAddLanguageFilterWithPreferredLanguages(t *testing.T) {
	// Arrange
	originalFilter := squirrel.Eq{"id": 1}
	query := jsonlogic.Query{
		Filter: originalFilter,
		Joins:  []string{},
	}

	langPrefs := common.LanguagePreferences{
		ContentOnlyInPreferredLanguage: true,
		PreferredAudioLanguages:        []string{"en", "no"},
		PreferredSubtitlesLanguages:    []string{"en", "fr"},
	}

	// Act
	result := addLanguageFilter(query, langPrefs)

	actual, params, err := result.Filter.ToSql()
	assert.NoError(t, err)
	assert.Equal(t, "(id = ? AND (audio && ? OR subtitles && ?))", actual)
	assert.Equal(t, 3, len(params))
	assert.Equal(t, query.Joins, result.Joins)
}

func TestAddLanguageFilterWithComplexOriginalFilter(t *testing.T) {
	// Arrange
	originalFilter := squirrel.And{
		squirrel.Eq{"type": "episode"},
		squirrel.GtOrEq{"release_date": "2023-01-01"},
	}
	query := jsonlogic.Query{
		Filter: originalFilter,
		Joins:  []string{"some_join"},
	}

	langPrefs := common.LanguagePreferences{
		ContentOnlyInPreferredLanguage: true,
		PreferredAudioLanguages:        []string{"en"},
		PreferredSubtitlesLanguages:    []string{"no"},
	}

	// Act
	result := addLanguageFilter(query, langPrefs)

	// Assert - Compare the number of conditions
	andFilter, ok := result.Filter.(squirrel.And)
	assert.True(t, ok, "Result filter should be of type squirrel.And")
	assert.Equal(t, 2, len(andFilter), "Should have 2 conditions in AND (original + (2 language filters combined with OR))")

	// Convert to SQL to check all conditions are preserved
	sql, args, err := result.Filter.ToSql()
	assert.NoError(t, err)

	// Verify SQL contains original filter conditions and new language conditions
	assert.Contains(t, sql, "type = ?")
	assert.Contains(t, sql, "release_date >= ?")
	assert.Contains(t, sql, "audio && ?")
	assert.Contains(t, sql, "subtitles && ?")

	// Check args include original values and language arrays
	assert.GreaterOrEqual(t, len(args), 4)

	// Check joins are preserved
	assert.Equal(t, query.Joins, result.Joins)
}

func TestGetSQLForFilter_NilFilter(t *testing.T) {
	// Test case when Filter.Filter is nil
	params := FilterParams{
		Filter: common.Filter{Filter: nil},
	}

	result := GetSQLForFilter(params)

	assert.Nil(t, result, "Should return nil when Filter.Filter is nil")
}

func TestGetSQLForFilter_WithSorting(t *testing.T) {
	// Test case with sorting parameters
	sortBy := "title"
	sortDir := "desc"
	filterJSON := `{"==": [{"var": "type"}, "show"]}`

	params := FilterParams{
		Filter: common.Filter{
			Filter:          json.RawMessage(filterJSON),
			SortBy:          sortBy,
			SortByDirection: sortDir,
		},
	}

	result := GetSQLForFilter(params)

	assert.NotNil(t, result)
	sql, _, _ := result.ToSql()
	assert.Contains(t, sql, "ORDER BY t.\"title\" DESC")
}

func TestGetSQLForFilter_WithRandomization(t *testing.T) {
	// Test case with randomization
	filterJSON := `{"==": [{"var": "type"}, "episode"]}`

	seed := int64(12345)
	params := FilterParams{
		Filter: common.Filter{
			Filter: json.RawMessage(filterJSON),
		},
		RandomSeed: null.IntFrom(seed),
	}

	result := GetSQLForFilter(params)

	assert.NotNil(t, result)
	sql, _, _ := result.ToSql()

	// Verify the SQL contains the expected randomization logic
	assert.Contains(t, sql, "SELECT setseed")
	assert.Contains(t, sql, "ORDER BY r")
}

func TestGetSQLForFilter_WithRoles(t *testing.T) {
	// Test case with role-based filtering
	filterJSON := `{"==": [{"var": "type"}, "page"]}`

	roles := []string{"user", "premium"}
	params := FilterParams{
		Filter: common.Filter{
			Filter: json.RawMessage(filterJSON),
		},
		Roles: roles,
	}

	result := GetSQLForFilter(params)

	assert.NotNil(t, result)
	sql, args, _ := result.ToSql()

	// Verify the SQL contains role-based filtering
	assert.Contains(t, sql, "roles && '{user,premium}'")
	assert.GreaterOrEqual(t, len(args), 1) // At least the roles parameter should be there
}

func TestGetSQLForFilter_WithDeboost(t *testing.T) {
	// Test case with deboost parameters
	filterJSON := `{"==": [{"var": "type"}, "episode"]}`

	deboostTag := "preview"
	deboostFactor := 50.0
	params := FilterParams{
		Filter: common.Filter{
			Filter:        json.RawMessage(filterJSON),
			DeboostTag:    deboostTag,
			DeboostFactor: deboostFactor,
		},
	}

	result := GetSQLForFilter(params)

	assert.NotNil(t, result)
	sql, _, _ := result.ToSql()

	// Verify the SQL contains deboost logic
	assert.Contains(t, sql, "WHEN t.tags @> ARRAY['preview']::varchar[] /* DeboostTag */ AND 0.500000 > 0.0 /* DeboostFactor */")
	assert.Contains(t, sql, "THEN CASE WHEN random() < 1.0 - 0.500000 /* DeboostFactor */ THEN random() ELSE random() + 1 END")
	assert.Contains(t, sql, "ELSE random()")
}

func TestGetSQLForFilter_WithLimit(t *testing.T) {
	// Test case with limit
	filterJSON := `{"==": [{"var": "type"}, "show"]}`

	limit := 10
	params := FilterParams{
		Filter: common.Filter{
			Filter: json.RawMessage(filterJSON),
			Limit:  &limit,
		},
	}

	result := GetSQLForFilter(params)

	assert.NotNil(t, result)
	sql, _, _ := result.ToSql()

	// Should include LIMIT
	assert.Contains(t, sql, "LIMIT 10")
}
