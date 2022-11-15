package sqlc

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
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
		return common.Progress{
			EpisodeID: int(row.EpisodeID),
			Progress:  int(row.Progress),
			Duration:  int(row.Duration),
			Watched:   row.Watched,
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
	return pq.queries.saveProgress(ctx, saveProgressParams{
		ProfileID: pq.profileID,
		EpisodeID: int32(progress.EpisodeID),
		Progress:  int32(progress.Progress),
		Duration:  int32(progress.Duration),
		ShowID:    progress.ShowID,
	})
}

// ClearProgress removes the progress from database
func (pq *ProfileQueries) ClearProgress(ctx context.Context, episodeID int) error {
	return pq.queries.deleteProgress(ctx, deleteProgressParams{
		Column1: pq.profileID,
		Column2: int32(episodeID),
	})
}
