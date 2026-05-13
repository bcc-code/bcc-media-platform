package sqlc

import (
	"context"
	"encoding/json"
	"time"

	"github.com/google/uuid"

	"github.com/bcc-code/bcc-media-platform/backend/common"
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
			CopyrightHolderID:     e.CopyrightHolderID,
			MediaItemID:           e.MediaitemID,
			TagIDs: lo.Map(e.TagIds, func(id int32, _ int) int {
				return int(id)
			}),
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
			CopyrightHolderID:     e.CopyrightHolderID,
			MediaItemID:           e.MediaitemID,
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
	return q.mapListToEpisodes(items), nil
}

// GetEpisodeIDsForSeasonsWithRoles returns episodeIDs for season filtered by roles
func (rq *RoleQueries) GetEpisodeIDsForSeasonsWithRoles(ctx context.Context, ids []int) ([]common.Mapping[int, int], error) {
	rows, err := rq.queries.getEpisodeIDsForSeasonsWithRoles(ctx, getEpisodeIDsForSeasonsWithRolesParams{
		Column1: intToInt32(ids),
		Column2: rq.roles,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getEpisodeIDsForSeasonsWithRolesRow, _ int) common.Mapping[int, int] {
		return common.Mapping[int, int]{Key: int(i.SeasonID.Int64), Value: int(i.ID)}
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

// GetEpisodeIDsForLegacyIDs returns ids for the requested codes
func (q *Queries) GetEpisodeIDsForLegacyIDs(ctx context.Context, ids []int) ([]common.Mapping[int, int], error) {
	rows, err := q.getEpisodeIDsForLegacyIDs(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getEpisodeIDsForLegacyIDsRow, _ int) common.Mapping[int, int] {
		return common.Mapping[int, int]{Key: int(i.LegacyID.ValueOrZero()), Value: int(i.ID)}
	}), nil
}

// GetEpisodeIDsForLegacyProgramIDs returns ids for the requested codes
func (q *Queries) GetEpisodeIDsForLegacyProgramIDs(ctx context.Context, ids []int) ([]common.Mapping[int, int], error) {
	rows, err := q.getEpisodeIDsForLegacyProgramIDs(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getEpisodeIDsForLegacyProgramIDsRow, _ int) common.Mapping[int, int] {
		return common.Mapping[int, int]{Key: int(i.LegacyID.ValueOrZero()), Value: int(i.ID)}
	}), nil
}

// GetEpisodeIDsForUuids returns episodeIds for specified uuids
func (q *Queries) GetEpisodeIDsForUuids(ctx context.Context, uuids []uuid.UUID) ([]common.Mapping[uuid.UUID, int], error) {
	rows, err := q.getEpisodeIDsForUuids(ctx, uuids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getEpisodeIDsForUuidsRow, _ int) common.Mapping[uuid.UUID, int] {
		return common.Mapping[uuid.UUID, int]{Key: i.Original, Value: int(i.Result)}
	}), nil
}

// GetEpisodeIDsWithTagIDs returns episodeIDs with the specified tags.
func (pq *PersonalizedQueries) GetEpisodeIDsWithTagIDs(ctx context.Context, ids []int) ([]common.Mapping[int, int], error) {
	rows, err := pq.queries.getEpisodeIDsWithTagIDs(ctx, getEpisodeIDsWithTagIDsParams{
		Roles:                      pq.roles,
		TagIds:                     intToInt32(ids),
		OnlyPreferredLanguages:     pq.languagePreferences.ContentOnlyInPreferredLanguage,
		PreferredAudioLanguages:    pq.languagePreferences.PreferredAudioLanguages,
		PreferredSubtitleLanguages: pq.languagePreferences.PreferredSubtitlesLanguages,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getEpisodeIDsWithTagIDsRow, _ int) common.Mapping[int, int] {
		return common.Mapping[int, int]{Key: int(i.ParentID), Value: int(i.ID)}
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
