package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

func mapToSeasons(seasons []getSeasonsRow) []common.Season {
	return lo.Map(seasons, func(e getSeasonsRow, _ int) common.Season {
		var title common.LocaleString
		var description common.LocaleString

		_ = json.Unmarshal(e.Title, &title)
		_ = json.Unmarshal(e.Description, &description)

		return common.Season{
			ID:          int(e.ID),
			LegacyID:    e.LegacyID,
			Title:       title,
			Description: description,
			Number:      int(e.SeasonNumber),
			ImageID:     e.ImageFileID,
			ShowID:      int(e.ShowID),
		}
	})
}

// GetSeasons returns a list of common.Season specified by ids
func (q *Queries) GetSeasons(ctx context.Context, ids []int) ([]common.Season, error) {
	seasons, err := q.getSeasons(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToSeasons(seasons), nil
}

// ListSeasons returns a list of common.Season
func (q *Queries) ListSeasons(ctx context.Context) ([]common.Season, error) {
	items, err := q.listSeasons(ctx)
	if err != nil {
		return nil, err
	}
	return mapToSeasons(lo.Map(items, func(i listSeasonsRow, _ int) getSeasonsRow {
		return getSeasonsRow(i)
	})), nil
}

// GetKey returns the id for this row
func (row getSeasonIDsForShowsRow) GetKey() int {
	return int(row.ID)
}

// GetRelationID returns the relation id for this row
func (row getSeasonIDsForShowsRow) GetRelationID() int {
	return int(row.ShowID)
}

// GetSeasonIDsForShows returns a list of episodes specified by seasons
func (q *Queries) GetSeasonIDsForShows(ctx context.Context, ids []int) ([]common.Relation[int, int], error) {
	rows, err := q.getSeasonIDsForShows(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getSeasonIDsForShowsRow, _ int) common.Relation[int, int] {
		return i
	}), nil
}

// GetPermissionsForSeasons returns permissions for specified episodes
func (q *Queries) GetPermissionsForSeasons(ctx context.Context, ids []int) ([]common.Permissions[int], error) {
	items, err := q.getPermissionsForSeasons(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(items, func(i getPermissionsForSeasonsRow, _ int) common.Permissions[int] {
		return common.Permissions[int]{
			ItemID: int(i.ID),
			Type:   common.TypeSeason,
			Availability: common.Availability{
				Published: i.Published,
				From:      i.AvailableFrom,
				To:        i.AvailableTo,
			},
			Roles: common.Roles{
				Access:      i.Usergroups,
				Download:    i.UsergroupsDownloads,
				EarlyAccess: i.UsergroupsEarlyaccess,
			},
		}
	}), nil
}
