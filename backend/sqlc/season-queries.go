package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

func mapToSeasons(seasons []SeasonExpanded) []common.Season {
	return lo.Map(seasons, func(e SeasonExpanded, _ int) common.Season {
		var title common.LocaleString
		var description common.LocaleString

		_ = json.Unmarshal(e.Title, &title)
		_ = json.Unmarshal(e.Description, &description)

		return common.Season{
			ID:       int(e.ID),
			LegacyID: e.LegacyID,
			Availability: common.Availability{
				Published: e.Published,
				From:      e.AvailableFrom,
				To:        e.AvailableTo,
			},
			Title:       title,
			Description: description,
			Roles: common.Roles{
				Access:      e.Usergroups,
				Download:    e.DownloadGroups,
				EarlyAccess: e.EarlyAccessGroups,
			},
			Number:  int(e.SeasonNumber),
			ImageID: e.ImageFileID,
			ShowID:  int(e.ShowID),
		}
	})
}

// ListSeasons returns a list of common.Season retrieved from the database
func (q *Queries) ListSeasons(ctx context.Context) ([]common.Season, error) {
	seasons, err := q.listSeasons(ctx)
	if err != nil {
		return nil, err
	}
	return mapToSeasons(seasons), nil
}

// GetSeasons returns a list of common.Season specified by ids
func (q *Queries) GetSeasons(ctx context.Context, ids []int) ([]common.Season, error) {
	seasons, err := q.getSeasons(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToSeasons(seasons), nil
}

// GetSeasonsForShows returns a list of seasons specified by seasons
func (q *Queries) GetSeasonsForShows(ctx context.Context, ids []int) ([]common.Season, error) {
	seasons, err := q.getSeasonsForShows(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToSeasons(seasons), nil
}
