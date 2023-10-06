package sqlc

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

func (q *Queries) mapToSeasons(seasons []getSeasonsRow) []common.Season {
	return lo.Map(seasons, func(e getSeasonsRow, _ int) common.Season {
		var title common.LocaleString
		var description common.LocaleString

		_ = json.Unmarshal(e.Title, &title)
		_ = json.Unmarshal(e.Description, &description)

		var image null.String
		if e.ImageFileName.Valid {
			image = null.StringFrom(fmt.Sprintf("https://%s/%s", q.getImageCDNDomain(), e.ImageFileName.String))
		}

		return common.Season{
			ID:          int(e.ID),
			Status:      common.StatusFrom(e.Status),
			LegacyID:    e.LegacyID,
			PublicTitle: e.PublicTitle,
			Title:       title,
			Description: description,
			Number:      int(e.SeasonNumber),
			Image:       image,
			Images:      q.getImages(e.Images),
			ShowID:      int(e.ShowID),
			AgeRating:   e.Agerating,
			TagIDs: lo.Map(e.TagIds, func(id int32, _ int) int {
				return int(id)
			}),
		}
	})
}

// GetSeasons returns a list of common.Season specified by ids
func (q *Queries) GetSeasons(ctx context.Context, ids []int) ([]common.Season, error) {
	seasons, err := q.getSeasons(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return q.mapToSeasons(seasons), nil
}

// ListSeasons returns a list of common.Season
func (q *Queries) ListSeasons(ctx context.Context) ([]common.Season, error) {
	items, err := q.listSeasons(ctx)
	if err != nil {
		return nil, err
	}
	return q.mapToSeasons(lo.Map(items, func(i listSeasonsRow, _ int) getSeasonsRow {
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

// GetSeasonIDsForShowsWithRoles returns episodeIDs for season filtered by roles
func (rq *RoleQueries) GetSeasonIDsForShowsWithRoles(ctx context.Context, ids []int) ([]loaders.Relation[int, int], error) {
	rows, err := rq.queries.getSeasonIDsForShowsWithRoles(ctx, getSeasonIDsForShowsWithRolesParams{
		Column1: intToInt32(ids),
		Column2: rq.roles,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getSeasonIDsForShowsWithRolesRow, _ int) loaders.Relation[int, int] {
		return getSeasonIDsForShowsRow(i)
	}), nil
}

// GetSeasonIDsWithRoles returns episodeIDs for season filtered by roles
func (rq *RoleQueries) GetSeasonIDsWithRoles(ctx context.Context, ids []int) ([]int, error) {
	rows, err := rq.queries.getSeasonIDsWithRoles(ctx, getSeasonIDsWithRolesParams{
		Column1: intToInt32(ids),
		Column2: rq.roles,
	})
	if err != nil {
		return nil, err
	}
	return int32ToInt(rows), nil
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
			Availability: common.Availability{
				Unlisted:  i.Unlisted,
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
