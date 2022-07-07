package sqlc

import "github.com/bcc-code/brunstadtv/backend/common"

// VISIBILITY

// ToVisibility convert to common.Visibility
func (row GetVisibilityForEpisodeRow) ToVisibility() (v common.Visibility) {
	v.Status = common.StatusFrom(row.Status)
	v.PublishDate = row.PublishDate
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

// ToVisibility convert to common.Visibility
func (row GetVisibilityForSeasonRow) ToVisibility() (v common.Visibility) {
	v.Status = common.StatusFrom(row.Status)
	v.PublishDate = row.PublishDate
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

// ToVisibility convert to common.Visibility
func (row GetVisibilityForShowRow) ToVisibility() (v common.Visibility) {
	v.Status = common.StatusFrom(row.Status)
	v.PublishDate = row.PublishDate
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

// ToVisibility convert to common.Visibility
func (row GetVisibilityForEpisodesRow) ToVisibility() (v common.Visibility) {
	v.Status = common.StatusFrom(row.Status)
	v.PublishDate = row.PublishDate
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

// ToVisibility convert to common.Visibility
func (row GetVisibilityForSeasonsRow) ToVisibility() (v common.Visibility) {
	v.Status = common.StatusFrom(row.Status)
	v.PublishDate = row.PublishDate
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

// ToVisibility convert to common.Visibility
func (row GetVisibilityForShowsRow) ToVisibility() (v common.Visibility) {
	v.Status = common.StatusFrom(row.Status)
	v.PublishDate = row.PublishDate
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

// TRANSLATIONS

// ToTranslation convert to common.Translation
func (row ShowsTranslation) ToTranslation() (v common.Translation) {
	v.Language = row.LanguagesCode
	v.Title = row.Title
	v.Description = row.Description
	return
}

// ToTranslation convert to common.Translation
func (row SeasonsTranslation) ToTranslation() (v common.Translation) {
	v.Language = row.LanguagesCode
	v.Title = row.Title
	v.Description = row.Description
	return
}

// ToTranslation convert to common.Translation
func (row EpisodesTranslation) ToTranslation() (v common.Translation) {
	v.Language = row.LanguagesCode
	v.Title = row.Title
	v.Description = row.Description
	v.Details = row.ExtraDescription
	return
}
