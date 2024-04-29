package sqlc

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func (rq *Queries) GetEpisodeIDForTimedMetadatas(ctx context.Context, ids []uuid.UUID) ([]loaders.Conversion[uuid.UUID, int], error) {
	rows, err := rq.getEpisodeIDsForTimedMetadatas(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(r getEpisodeIDsForTimedMetadatasRow, _ int) loaders.Conversion[uuid.UUID, int] {
		return conversion[uuid.UUID, int]{
			source: r.ID,
			result: int(r.PrimaryEpisodeID.Int64),
		}
	}), nil
}

// GetTimedMetadata returns metadata items for the specified ids
func (q *Queries) GetTimedMetadata(ctx context.Context, ids []uuid.UUID) ([]common.TimedMetadata, error) {
	rows, err := q.getTimedMetadata(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getTimedMetadataRow, _ int) common.TimedMetadata {
		title := toLocaleString(i.Title, i.OriginalTitle.String)
		description := toLocaleString(i.Description, i.OriginalDescription.String)
		chapterType := common.ChapterTypes.Parse(i.ChapterType.String)
		if chapterType == nil {
			chapterType = &common.ChapterTypeSpeech
		}
		return common.TimedMetadata{
			ID:          i.ID,
			Type:        i.Type,
			ChapterType: *chapterType,
			PersonIDs:   i.PersonIds,
			SongID:      i.SongID,
			Timestamp:   float64(i.Seconds),
			Duration:    float64(i.Duration),
			Title:       title,
			Description: description,
			MediaItemID: i.MediaitemID,
			Images:      q.getImages(i.Images),
		}
	}), nil
}
