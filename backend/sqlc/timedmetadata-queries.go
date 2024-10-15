package sqlc

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// GetTimedMetadata returns metadata items for the specified ids
func (q *Queries) GetTimedMetadata(ctx context.Context, ids []uuid.UUID) ([]common.TimedMetadata, error) {
	rows, err := q.getTimedMetadata(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getTimedMetadataRow, _ int) common.TimedMetadata {
		title := toLocaleString(i.Title, i.OriginalTitle.String)
		description := toLocaleString(i.Description, i.OriginalDescription.String)
		contentType := common.ContentTypes.Parse(i.ContentType.String)
		if contentType == nil {
			contentType = &common.ContentTypeSpeech
		}

		return common.TimedMetadata{
			ID:          i.ID,
			Type:        i.Type,
			ContentType: *contentType,
			PersonIDs:   i.PersonIds,
			SongID:      i.SongID,
			Timestamp:   float64(i.Seconds),
			Duration:    i.Duration,
			Title:       title,
			Description: description,
			MediaItemID: i.MediaitemID,
			Images:      q.getImages(i.Images),
		}
	}), nil
}

// GetChaptersForEpisodeID returns chapters for the specified episode id
func (q *Queries) GetChaptersForEpisodeID(ctx context.Context, ids []int) ([]common.TimedMetadata, error) {
	idsInt32 := lo.Map(ids, func(i int, _ int) int32 {
		return int32(i)
	})
	rows, err := q.getChaptesFromEpisode(ctx, idsInt32)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getChaptesFromEpisodeRow, _ int) common.TimedMetadata {
		title := toLocaleString(i.Title, i.OriginalTitle.String)
		description := toLocaleString(i.Description, i.OriginalDescription.String)
		contentType := common.ContentTypes.Parse(i.ContentType.String)
		if contentType == nil {
			contentType = &common.ContentTypeSpeech
		}
		return common.TimedMetadata{
			ID:              i.ID,
			Type:            i.Type,
			ContentType:     *contentType,
			PersonIDs:       i.PersonIds,
			SongID:          i.SongID,
			Timestamp:       float64(i.Seconds),
			Duration:        i.Duration,
			Title:           title,
			Description:     description,
			MediaItemID:     i.MediaitemID,
			Images:          q.getImages(i.Images),
			ParentEpisodeID: int(i.EpisodeID),
		}
	}), nil
}
