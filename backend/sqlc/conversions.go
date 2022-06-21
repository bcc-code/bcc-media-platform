package sqlc

import "github.com/bcc-code/brunstadtv/backend/common"

// VISIBILITY

func (row GetVisibilityForEpisodeRow) ToVisibility() (v common.Visibility) {
	v.Status = row.Status
	v.PublishDate = row.PublishDate
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

func (row GetVisibilityForSeasonRow) ToVisibility() (v common.Visibility) {
	v.Status = row.Status
	v.PublishDate = row.PublishDate
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

func (row GetVisibilityForShowRow) ToVisibility() (v common.Visibility) {
	v.Status = row.Status
	v.PublishDate = row.PublishDate
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

func (row GetVisibilityForEpisodesRow) ToVisibility() (v common.Visibility) {
	v.Status = row.Status
	v.PublishDate = row.PublishDate
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

func (row GetVisibilityForSeasonsRow) ToVisibility() (v common.Visibility) {
	v.Status = row.Status
	v.PublishDate = row.PublishDate
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

func (row GetVisibilityForShowsRow) ToVisibility() (v common.Visibility) {
	v.Status = row.Status
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

func (row ShowsTranslation) ToTranslation() (v common.Translation) {
	v.Language = row.LanguagesCode
	if value := row.Title.ValueOrZero(); value != "" {
		v.Title = value
	}
	if value := row.Description.ValueOrZero(); value != "" {
		v.Description = value
	}
	return
}

func (row SeasonsTranslation) ToTranslation() (v common.Translation) {
	v.Language = row.LanguagesCode
	if value := row.Title.ValueOrZero(); value != "" {
		v.Title = value
	}
	if value := row.Description.ValueOrZero(); value != "" {
		v.Description = value
	}
	return
}

func (row EpisodesTranslation) ToTranslation() (v common.Translation) {
	v.Language = row.LanguagesCode
	if value := row.Title.ValueOrZero(); value != "" {
		v.Title = value
	}
	if value := row.Description.ValueOrZero(); value != "" {
		v.Description = value
	}
	if value := row.ExtraDescription.ValueOrZero(); value != "" {
		v.Details = value
	}
	return
}
