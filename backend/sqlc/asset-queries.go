package sqlc

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/samber/lo"
)

func toFiles(items []getFilesForAssetsRow) []common.File {
	return lo.Map(items, func(f getFilesForAssetsRow, _ int) common.File {
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
			Size:             int(f.Size),
			Resolution:       f.Resolution.String,
		}
	})
}

// GetFilesForAssets returns files for assets
func (q *Queries) GetFilesForAssets(ctx context.Context, ids []int) ([]common.File, error) {
	files, err := q.getFilesForAssets(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return toFiles(files), nil
}

// GetFilesForEpisodes returns files for the specified episodes
func (q *Queries) GetFilesForEpisodes(ctx context.Context, ids []int) ([]common.File, error) {
	files, err := q.getFilesForEpisodes(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return toFiles(lo.Map(files, func(f getFilesForEpisodesRow, _ int) getFilesForAssetsRow {
		return getFilesForAssetsRow(f)
	})), nil
}

func toStreams(items []getStreamsForAssetsRow) []common.Stream {
	return lo.Map(items, func(s getStreamsForAssetsRow, _ int) common.Stream {
		return common.Stream{
			ID:                int(s.ID),
			Type:              s.Type,
			EpisodeID:         int(s.EpisodesID),
			AssetID:           int(s.AssetID),
			AudioLanguages:    s.AudioLanguages,
			SubtitleLanguages: s.SubtitleLanguages,
			Path:              s.Path,
			Service:           s.Service,
			Url:               s.Url,
			EncryptionKeyID:   s.EncryptionKeyID,
			ConfigurationId:   s.ConfigurationID,
		}
	})
}

// GetStreamsForEpisodes returns files for the specified episodes
func (q *Queries) GetStreamsForEpisodes(ctx context.Context, ids []int) ([]common.Stream, error) {
	streams, err := q.getStreamsForEpisodes(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return toStreams(lo.Map(streams, func(f getStreamsForEpisodesRow, _ int) getStreamsForAssetsRow {
		return getStreamsForAssetsRow(f)
	})), nil
}

// GetStreamsForAssets returns streams by assetId
func (q *Queries) GetStreamsForAssets(ctx context.Context, ids []int) ([]common.Stream, error) {
	streams, err := q.getStreamsForAssets(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return toStreams(streams), nil
}
