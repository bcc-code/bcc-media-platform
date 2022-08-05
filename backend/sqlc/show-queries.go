package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

func mapToShows(shows []ShowExpanded) []common.Show {
	return lo.Map(shows, func(e ShowExpanded, _ int) common.Show {
		var title common.LocaleString
		var description common.LocaleString

		_ = json.Unmarshal(e.Title, &title)
		_ = json.Unmarshal(e.Description, &description)

		return common.Show{
			ID: int(e.ID),
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
			ImageID: e.ImageFileID,
		}
	})
}

// ListShows returns a list of shows
func (q *Queries) ListShows(ctx context.Context) ([]common.Show, error) {
	shows, err := q.listShows(ctx)
	if err != nil {
		return nil, err
	}
	return mapToShows(shows), nil
}

// GetShows returns shows
func (q *Queries) GetShows(ctx context.Context, ids []int) ([]common.Show, error) {
	shows, err := q.getShows(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToShows(shows), nil
}
