package sqlc

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

func (q *Queries) mapToEpisodes(episodes []getEpisodesRow) []common.Episode {
	return lo.Map(episodes, func(e getEpisodesRow, _ int) common.Episode {
		var title common.LocaleString
		var description common.LocaleString
		var extraDescription common.LocaleString

		_ = json.Unmarshal(e.Title.RawMessage, &title)
		_ = json.Unmarshal(e.Description.RawMessage, &description)
		_ = json.Unmarshal(e.ExtraDescription.RawMessage, &extraDescription)

		var image null.String
		if e.ImageFileName.Valid {
			image = null.StringFrom(fmt.Sprintf("https://%s/%s", q.getImageCDNDomain(), e.ImageFileName.String))
		}

		return common.Episode{
			ID:                 int(e.ID),
			Type:               e.Type,
			LegacyID:           e.LegacyID,
			LegacyProgramID:    e.LegacyProgramID,
			Title:              title,
			Description:        description,
			ExtraDescription:   extraDescription,
			PublishDateInTitle: e.PublishDateInTitle,
			PublishDate:        e.PublishDate,
			AvailableFrom:      e.AvailableFrom,
			AvailableTo:        e.AvailableTo,
			Number:             e.EpisodeNumber,
			SeasonID:           e.SeasonID,
			AssetID:            e.AssetID,
			Image:              image,
			Images:             q.getImages(e.Images),
			AgeRating:          e.Agerating,
			Duration:           int(e.Duration.ValueOrZero()),
			TagIDs: lo.Map(e.TagIds, func(id int32, _ int) int {
				return int(id)
			}),
		}
	})
}

// GetEpisodes returns a list of common.Episode specified by ids
func (q *Queries) GetEpisodes(ctx context.Context, ids []int) ([]common.Episode, error) {
	episodes, err := q.getEpisodes(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return q.mapToEpisodes(episodes), nil
}

// ListEpisodes returns a list of common.Episode
func (q *Queries) ListEpisodes(ctx context.Context) ([]common.Episode, error) {
	items, err := q.listEpisodes(ctx)
	if err != nil {
		return nil, err
	}
	return q.mapToEpisodes(lo.Map(items, func(i listEpisodesRow, _ int) getEpisodesRow {
		return getEpisodesRow(i)
	})), nil
}

// GetKey returns the id for this row
func (row getEpisodeIDsForSeasonsRow) GetKey() int {
	return int(row.ID)
}

// GetRelationID returns the relation id for this row
func (row getEpisodeIDsForSeasonsRow) GetRelationID() int {
	return int(row.SeasonID.Int64)
}

// GetEpisodeIDsForSeasonsWithRoles returns episodeIDs for season filtered by roles
func (rq *RoleQueries) GetEpisodeIDsForSeasonsWithRoles(ctx context.Context, ids []int) ([]batchloaders.Relation[int, int], error) {
	rows, err := rq.queries.getEpisodeIDsForSeasonsWithRoles(ctx, getEpisodeIDsForSeasonsWithRolesParams{
		Column1: intToInt32(ids),
		Column2: rq.roles,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getEpisodeIDsForSeasonsWithRolesRow, _ int) batchloaders.Relation[int, int] {
		return getEpisodeIDsForSeasonsRow(i)
	}), nil
}

// GetEpisodeIDsWithRoles returns episodeIDs for season filtered by roles
func (rq *RoleQueries) GetEpisodeIDsWithRoles(ctx context.Context, ids []int) ([]int, error) {
	rows, err := rq.queries.getEpisodeIDsWithRoles(ctx, getEpisodeIDsWithRolesParams{
		Column1: intToInt32(ids),
		Column2: rq.roles,
	})
	if err != nil {
		return nil, err
	}
	return int32ToInt(rows), nil
}

// GetPermissionsForEpisodes returns permissions for specified episodes
func (q *Queries) GetPermissionsForEpisodes(ctx context.Context, ids []int) ([]common.Permissions[int], error) {
	items, err := q.getPermissionsForEpisodes(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(items, func(i getPermissionsForEpisodesRow, _ int) common.Permissions[int] {
		return common.Permissions[int]{
			ItemID: int(i.ID),
			Type:   common.TypeEpisode,
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
