package sqlc

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

func (q *Queries) mapToShows(shows []getShowsRow) []common.Show {
	return lo.Map(shows, func(e getShowsRow, _ int) common.Show {
		var title common.LocaleString
		var description common.LocaleString

		_ = json.Unmarshal(e.Title.RawMessage, &title)
		_ = json.Unmarshal(e.Description.RawMessage, &description)

		var image null.String
		if e.ImageFileName.Valid {
			image = null.StringFrom(fmt.Sprintf("https://%s/%s", q.getImageCDNDomain(), e.ImageFileName.String))
		}

		return common.Show{
			ID:          int(e.ID),
			Type:        e.Type,
			LegacyID:    e.LegacyID,
			PublicTitle: e.PublicTitle,
			Title:       title,
			Description: description,
			Image:       image,
			Images:      q.getImages(e.Images),
			TagIDs: lo.Map(e.TagIds, func(id int32, _ int) int {
				return int(id)
			}),
		}
	})
}

// GetShows returns shows
func (q *Queries) GetShows(ctx context.Context, ids []int) ([]common.Show, error) {
	shows, err := q.getShows(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return q.mapToShows(shows), nil
}

// ListShows returns a list of common.Show
func (q *Queries) ListShows(ctx context.Context) ([]common.Show, error) {
	items, err := q.listShows(ctx)
	if err != nil {
		return nil, err
	}
	return q.mapToShows(lo.Map(items, func(i listShowsRow, _ int) getShowsRow {
		return getShowsRow(i)
	})), nil
}

// ListAllPermittedShows returns a list of common.Show
func (q *Queries) ListAllPermittedShowIDs(ctx context.Context, permissions []string) ([]int, error) {
	ids, err := q.listAllPermittedShowIDs(ctx, permissions)
	if err != nil {
		return nil, err
	}

	return lo.Map(ids, func(i int32, _ int) int { return int(i) }), nil
}

// GetShowIDsWithRoles returns episodeIDs for season filtered by roles
func (rq *RoleQueries) GetShowIDsWithRoles(ctx context.Context, ids []int) ([]int, error) {
	rows, err := rq.queries.getShowIDsWithRoles(ctx, getShowIDsWithRolesParams{
		Column1: intToInt32(ids),
		Column2: rq.roles,
	})
	if err != nil {
		return nil, err
	}
	return int32ToInt(rows), nil
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
