package collection

import (
	"testing"

	"github.com/Masterminds/squirrel"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/jsonlogic"
	"github.com/stretchr/testify/assert"
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
	assert.Equal(t, 4, len(args))

	// Check joins are preserved
	assert.Equal(t, query.Joins, result.Joins)
}
