package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

func mapToShows(shows []getShowsRow) []common.Show {
	return lo.Map(shows, func(e getShowsRow, _ int) common.Show {
		var title common.LocaleString
		var description common.LocaleString

		_ = json.Unmarshal(e.Title.RawMessage, &title)
		_ = json.Unmarshal(e.Description.RawMessage, &description)

		return common.Show{
			ID:          int(e.ID),
			LegacyID:    e.LegacyID,
			Title:       title,
			Description: description,
			Image:       e.ImageFileName,
		}
	})
}

// GetShows returns shows
func (q *Queries) GetShows(ctx context.Context, ids []int) ([]common.Show, error) {
	shows, err := q.getShows(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToShows(shows), nil
}

// ListShows returns a list of common.Show
func (q *Queries) ListShows(ctx context.Context) ([]common.Show, error) {
	items, err := q.listShows(ctx)
	if err != nil {
		return nil, err
	}
	return mapToShows(lo.Map(items, func(i listShowsRow, _ int) getShowsRow {
		return getShowsRow(i)
	})), nil
}

// GetPermissionsForShows returns permissions for specified episodes
func (q *Queries) GetPermissionsForShows(ctx context.Context, ids []int) ([]common.Permissions[int], error) {
	items, err := q.getPermissionsForShows(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(items, func(i getPermissionsForShowsRow, _ int) common.Permissions[int] {
		return common.Permissions[int]{
			ItemID: int(i.ID),
			Type:   common.TypeShow,
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
