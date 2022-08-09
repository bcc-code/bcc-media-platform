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

		_ = json.Unmarshal(e.Title, &title)
		_ = json.Unmarshal(e.Description, &description)
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
			TagIDs: lo.Map(e.TagIds, func(id int32, _ int) int {
				return int(id)
			}),
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

// GetFilesForEpisodes returns files for the specified episodes
func (q *Queries) GetFilesForEpisodes(ctx context.Context, ids []int) ([]common.File, error) {
	files, err := q.getFilesForEpisodes(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(files, func(f getFilesForEpisodesRow, _ int) common.File {
		return common.File{
			ID:               int(f.ID),
			Type:             f.Type,
			EpisodeID:        int(f.EpisodesID),
			AssetID:          int(f.AssetID),
			AudioLanguage:    f.AudioLanguageID,
			SubtitleLanguage: f.SubtitleLanguageID,
			Path:             f.Path,
			Storage:          f.Storage,
			MimeType:         f.MimeType,
		}
	}), nil
}

// GetStreamsForEpisodes returns files for the specified episodes
func (q *Queries) GetStreamsForEpisodes(ctx context.Context, ids []int) ([]common.Stream, error) {
	streams, err := q.getStreamsForEpisodes(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(streams, func(f getStreamsForEpisodesRow, _ int) common.Stream {
		return common.Stream{
			ID:                int(f.ID),
			Type:              f.Type,
			EpisodeID:         int(f.EpisodesID),
			AssetID:           int(f.AssetID),
			AudioLanguages:    f.AudioLanguages,
			SubtitleLanguages: f.SubtitleLanguages,
			Path:              f.Path,
			Service:           f.Service,
			Url:               f.Url,
			EncryptionKeyID:   f.EncryptionKeyID,
		}
	}), nil
}
