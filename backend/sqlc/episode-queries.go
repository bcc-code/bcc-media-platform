package sqlc

import (
	"context"
	"encoding/json"
	"time"

	"github.com/google/uuid"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/samber/lo"
)

func (q *Queries) mapToEpisodes(episodes []getEpisodesRow) []common.Episode {
	return lo.Map(episodes, func(e getEpisodesRow, _ int) common.Episode {
		var title = common.LocaleString{}
		var description = common.LocaleString{}
		var extraDescription = common.LocaleString{}

		_ = json.Unmarshal(e.Title, &title)
		_ = json.Unmarshal(e.Description, &description)
		_ = json.Unmarshal(e.ExtraDescription.RawMessage, &extraDescription)

		title["no"] = e.OriginalTitle
		description["no"] = e.OriginalDescription

		var assetIDs common.LocaleMap[int]
		_ = json.Unmarshal(e.Assets, &assetIDs)

		assetVersion := ""
		if e.AssetDateUpdated.Valid {
			assetVersion = e.AssetDateUpdated.Time.Format(time.RFC3339)
		}

		return common.Episode{
			ID:                    int(e.ID),
			UUID:                  e.Uuid,
			Status:                common.StatusFrom(e.Status),
			Type:                  e.Type,
			LegacyID:              e.LegacyID,
			LegacyProgramID:       e.LegacyProgramID,
			PublicTitle:           e.PublicTitle,
			PreventPublicIndexing: e.PreventPublicIndexing,
			NumberInTitle:         e.NumberInTitle.Bool,
			Title:                 title,
			Description:           description,
			ExtraDescription:      extraDescription,
			ProductionDateInTitle: e.PublishDateInTitle,
			PublishDate:           e.PublishedAt,
			ProductionDate:        e.ProductionDate,
			AvailableFrom:         e.AvailableFrom,
			AvailableTo:           e.AvailableTo,
			Number:                e.EpisodeNumber,
			SeasonID:              e.SeasonID,
			AssetID:               e.AssetID,
			Assets:                assetIDs,
			AssetVersion:          assetVersion,
			Images:                q.getImages(e.Images),
			AgeRating:             e.Agerating,
			Duration:              int(e.Duration.ValueOrZero()),
			Audience:              e.Audience,
			ContentType:           e.ContentType,
			TagIDs: lo.Map(e.TagIds, func(id int32, _ int) int {
				return int(id)
			}),
			TimedMetadataIDs: e.TimedmetadataIds,
		}
	})
}

func (q *Queries) mapListToEpisodes(episodes []listEpisodesRow) []common.Episode {
	return lo.Map(episodes, func(e listEpisodesRow, _ int) common.Episode {
		var title = common.LocaleString{}
		var description = common.LocaleString{}
		var extraDescription = common.LocaleString{}

		_ = json.Unmarshal(e.Title.RawMessage, &title)
		_ = json.Unmarshal(e.Description.RawMessage, &description)
		_ = json.Unmarshal(e.ExtraDescription.RawMessage, &extraDescription)

		title["no"] = e.OriginalTitle
		description["no"] = e.OriginalDescription

		var assetIDs common.LocaleMap[int]
		_ = json.Unmarshal(e.Assets.RawMessage, &assetIDs)

		assetVersion := ""
		if e.AssetDateUpdated.Valid {
			assetVersion = e.AssetDateUpdated.Time.Format(time.RFC3339)
		}

		return common.Episode{
			ID:                    int(e.ID),
			UUID:                  e.Uuid,
			Status:                common.StatusFrom(e.Status),
			Type:                  e.Type,
			LegacyID:              e.LegacyID,
			LegacyProgramID:       e.LegacyProgramID,
			PublicTitle:           e.PublicTitle,
			PreventPublicIndexing: e.PreventPublicIndexing,
			NumberInTitle:         e.NumberInTitle.Bool,
			Title:                 title,
			Description:           description,
			ExtraDescription:      extraDescription,
			ProductionDateInTitle: e.PublishDateInTitle,
			PublishDate:           e.PublishedAt.Time,
			ProductionDate:        e.ProductionDate.Time,
			AvailableFrom:         e.AvailableFrom,
			AvailableTo:           e.AvailableTo,
			Number:                e.EpisodeNumber,
			SeasonID:              e.SeasonID,
			AssetID:               e.AssetID,
			Assets:                assetIDs,
			AssetVersion:          assetVersion,
			Images:                q.getImages(e.Images.RawMessage),
			AgeRating:             e.Agerating,
			Duration:              int(e.Duration.ValueOrZero()),
			Audience:              e.Audience,
			ContentType:           e.ContentType,
			TagIDs: lo.Map(e.TagIds, func(id int32, _ int) int {
				return int(id)
			}),
			TimedMetadataIDs: e.TimedmetadataIds,
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
	return q.mapListToEpisodes(lo.Map(items, func(i listEpisodesRow, _ int) listEpisodesRow {
		return listEpisodesRow(i)
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
func (rq *RoleQueries) GetEpisodeIDsForSeasonsWithRoles(ctx context.Context, ids []int) ([]loaders.Relation[int, int], error) {
	rows, err := rq.queries.getEpisodeIDsForSeasonsWithRoles(ctx, getEpisodeIDsForSeasonsWithRolesParams{
		Column1: intToInt32(ids),
		Column2: rq.roles,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getEpisodeIDsForSeasonsWithRolesRow, _ int) loaders.Relation[int, int] {
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

// GetEpisodeUUIDsWithRoles returns ids for episodes filtered by roles
func (rq *RoleQueries) GetEpisodeUUIDsWithRoles(ctx context.Context, ids []uuid.UUID) ([]uuid.UUID, error) {
	rows, err := rq.queries.getEpisodeUUIDsWithRoles(ctx, getEpisodeUUIDsWithRolesParams{
		Column1: ids,
		Column2: rq.roles,
	})
	if err != nil {
		return nil, err
	}
	return rows, nil
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
			Availability: common.Availability{
				Unlisted:    i.Unlisted,
				Published:   i.Published,
				From:        i.AvailableFrom,
				To:          i.AvailableTo,
				PublishedOn: i.PublishedOn,
			},
			Roles: common.Roles{
				Access:      i.Usergroups,
				Download:    i.UsergroupsDownloads,
				EarlyAccess: i.UsergroupsEarlyaccess,
			},
		}
	}), nil
}

type conversion[S comparable, R comparable] struct {
	source S
	result R
}

// GetOriginal returns the requested string
func (c conversion[S, R]) GetOriginal() S {
	return c.source
}

// GetResult returns the id from the query
func (c conversion[S, R]) GetResult() R {
	return c.result
}

// GetEpisodeIDsForLegacyIDs returns ids for the requested codes
func (q *Queries) GetEpisodeIDsForLegacyIDs(ctx context.Context, ids []int) ([]loaders.Conversion[int, int], error) {
	rows, err := q.getEpisodeIDsForLegacyIDs(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getEpisodeIDsForLegacyIDsRow, _ int) loaders.Conversion[int, int] {
		return conversion[int, int]{
			source: int(i.LegacyID.ValueOrZero()),
			result: int(i.ID),
		}
	}), nil
}

// GetEpisodeIDsForLegacyProgramIDs returns ids for the requested codes
func (q *Queries) GetEpisodeIDsForLegacyProgramIDs(ctx context.Context, ids []int) ([]loaders.Conversion[int, int], error) {
	rows, err := q.getEpisodeIDsForLegacyProgramIDs(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getEpisodeIDsForLegacyProgramIDsRow, _ int) loaders.Conversion[int, int] {
		return conversion[int, int]{
			source: int(i.LegacyID.ValueOrZero()),
			result: int(i.ID),
		}
	}), nil
}

// GetEpisodeIDsForUuids returns episodeIds for specified uuids
func (q *Queries) GetEpisodeIDsForUuids(ctx context.Context, uuids []uuid.UUID) ([]loaders.Conversion[uuid.UUID, int], error) {
	rows, err := q.getEpisodeIDsForUuids(ctx, uuids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getEpisodeIDsForUuidsRow, _ int) loaders.Conversion[uuid.UUID, int] {
		return conversion[uuid.UUID, int]{
			source: i.Original,
			result: int(i.Result),
		}
	}), nil
}

// GetEpisodeIDsWithTagIDs returns episodeIDs with the specified tags.
func (rq *RoleQueries) GetEpisodeIDsWithTagIDs(ctx context.Context, ids []int) ([]loaders.Relation[int, int], error) {
	rows, err := rq.queries.getEpisodeIDsWithTagIDs(ctx, getEpisodeIDsWithTagIDsParams{
		Roles:  rq.roles,
		TagIds: intToInt32(ids),
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getEpisodeIDsWithTagIDsRow, _ int) loaders.Relation[int, int] {
		return relation[int, int]{
			ID:       int(i.ID),
			ParentID: int(i.ParentID),
		}
	}), nil
}

func (q *Queries) GetEpisodeIDsByMediaItemID(ctx context.Context, id uuid.UUID) ([]int, error) {
	rows, err := q.getEpisodeIDsByMediaItemID(ctx, id)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(id int32, _ int) int {
		return int(id)
	}), nil
}
