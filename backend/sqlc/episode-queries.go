package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

func mapToEpisodes(episodes []EpisodeExpanded) []common.Episode {
	return lo.Map(episodes, func(e EpisodeExpanded, _ int) common.Episode {
		var title common.LocaleString
		var description common.LocaleString
		var extraDescription common.LocaleString

		_ = json.Unmarshal(e.Title.RawMessage, &title)
		_ = json.Unmarshal(e.Description.RawMessage, &description)
		_ = json.Unmarshal(e.ExtraDescription.RawMessage, &extraDescription)

		return common.Episode{
			ID: int(e.ID),
			Availability: common.Availability{
				Published: e.Published,
				From:      e.AvailableFrom,
				To:        e.AvailableTo,
			},
			Title:            title,
			Description:      description,
			ExtraDescription: extraDescription,
			Roles: common.Roles{
				Access:      e.Usergroups,
				Download:    e.DownloadGroups,
				EarlyAccess: e.EarlyAccessGroups,
			},
			Number:   e.EpisodeNumber,
			SeasonID: e.SeasonID,
			AssetID:  e.AssetID,
			ImageID:  e.ImageFileID,
			TagIDs:   e.TagIds,
		}
	})
}

// ListEpisodes returns a list of common.Episode retrieved from the database
func (q *Queries) ListEpisodes(ctx context.Context) ([]common.Episode, error) {
	episodes, err := q.listEpisodes(ctx)
	if err != nil {
		return nil, err
	}
	return mapToEpisodes(episodes), nil
}

// GetEpisodes returns a list of common.Episode specified by ids
func (q *Queries) GetEpisodes(ctx context.Context, ids []int) ([]common.Episode, error) {
	episodes, err := q.getEpisodes(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToEpisodes(episodes), nil
}

// GetEpisodesForSeasons returns a list of episodes specified by seasons
func (q *Queries) GetEpisodesForSeasons(ctx context.Context, ids []int) ([]common.Episode, error) {
	episodes, err := q.getEpisodesForSeasons(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToEpisodes(episodes), nil
}
