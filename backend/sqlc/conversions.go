package sqlc

import "github.com/bcc-code/brunstadtv/backend/common"

func (row *GetVisibilityForEpisodeRow) ToVisibility() (v common.Visibility) {
	v = common.Visibility{
		Status:      row.Status,
		PublishDate: row.PublishDate.UTC(),
	}
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

func (row *GetVisibilityForSeasonRow) ToVisibility() (v common.Visibility) {
	v = common.Visibility{
		Status:      row.Status,
		PublishDate: row.PublishDate.UTC(),
	}
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

func (row *GetVisibilityForShowRow) ToVisibility() (v common.Visibility) {
	v = common.Visibility{
		Status:      row.Status,
		PublishDate: row.PublishDate.UTC(),
	}
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

func (row *GetVisibilityForEpisodesRow) ToVisibility() (v common.Visibility) {
	v = common.Visibility{
		Status:      row.Status,
		PublishDate: row.PublishDate.UTC(),
	}
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

func (row *GetVisibilityForSeasonsRow) ToVisibility() (v common.Visibility) {
	v = common.Visibility{
		Status:      row.Status,
		PublishDate: row.PublishDate.UTC(),
	}
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}

func (row *GetVisibilityForShowsRow) ToVisibility() (v common.Visibility) {
	v = common.Visibility{
		Status:      row.Status,
		PublishDate: row.PublishDate.UTC(),
	}
	if value := row.AvailableFrom.ValueOrZero(); row.AvailableFrom.Valid {
		v.AvailableFrom = &value
	}
	if value := row.AvailableTo.ValueOrZero(); row.AvailableTo.Valid {
		v.AvailableTo = &value
	}
	return
}
