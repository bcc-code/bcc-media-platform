package sqlc

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
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
		return common.Progress{
			EpisodeID: int(row.EpisodeID),
			Progress:  int(row.Progress),
			Duration:  int(row.Duration),
			UpdatedAt: row.UpdatedAt,
			ShowID:    row.ShowID,
			WatchedAt: row.WatchedAt,
			Watched:   int(row.Watched.ValueOrZero()),
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
		WatchedAt: progress.WatchedAt,
		Watched:   null.IntFrom(int64(progress.Watched)),
	})
}

// ClearProgress removes the progress from database
func (pq *ProfileQueries) ClearProgress(ctx context.Context, episodeID int) error {
	return pq.queries.deleteProgress(ctx, deleteProgressParams{
		ProfileID: pq.profileID,
		EpisodeID: int32(episodeID),
	})
}
