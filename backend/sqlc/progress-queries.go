package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"github.com/tabbed/pqtype"
	"gopkg.in/guregu/null.v4"
)

// GetProgressForEpisodes returns progress for the specified episodes
func (pq *ProfileQueries) GetProgressForEpisodes(ctx context.Context, episodeIDs []int) ([]common.Progress, error) {
	progress, err := pq.queries.getProgressForProfile(ctx, getProgressForProfileParams{
		Column1: pq.profileID,
		Column2: intToInt32(episodeIDs),
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(progress, func(row getProgressForProfileRow, _ int) common.Progress {
		var episodeContext common.EpisodeContext

		_ = json.Unmarshal(row.Context.RawMessage, &episodeContext)

		return common.Progress{
			EpisodeID: int(row.EpisodeID),
			Progress:  int(row.Progress),
			Duration:  int(row.Duration),
			UpdatedAt: row.UpdatedAt,
			ShowID:    row.ShowID,
			WatchedAt: row.WatchedAt,
			Watched:   int(row.Watched.ValueOrZero()),
			Context:   episodeContext,
		}
	}), nil
}

// GetEpisodeIDsWithProgress returns episodeIDs ordered by date progressed.
func (q *Queries) GetEpisodeIDsWithProgress(ctx context.Context, profileIDs []uuid.UUID) ([]batchloaders.Relation[int, uuid.UUID], error) {
	rows, err := q.getEpisodeIDsWithProgress(ctx, profileIDs)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getEpisodeIDsWithProgressRow, _ int) batchloaders.Relation[int, uuid.UUID] {
		return batchloaders.RelationItem[int, uuid.UUID]{
			Key:        int(i.EpisodeID),
			RelationID: i.ProfileID,
		}
	}), nil
}

// SaveProgress stores the progress
func (pq *ProfileQueries) SaveProgress(ctx context.Context, progress common.Progress) error {
	episodeContext, _ := json.Marshal(progress.Context)

	return pq.queries.saveProgress(ctx, saveProgressParams{
		ProfileID: pq.profileID,
		EpisodeID: int32(progress.EpisodeID),
		Progress:  int32(progress.Progress),
		Duration:  int32(progress.Duration),
		ShowID:    progress.ShowID,
		WatchedAt: progress.WatchedAt,
		Watched:   null.IntFrom(int64(progress.Watched)),
		Context: pqtype.NullRawMessage{
			RawMessage: episodeContext,
		},
	})
}

// ClearProgress removes the progress from database
func (pq *ProfileQueries) ClearProgress(ctx context.Context, episodeID int) error {
	return pq.queries.deleteProgress(ctx, deleteProgressParams{
		ProfileID: pq.profileID,
		EpisodeID: int32(episodeID),
	})
}
