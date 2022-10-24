package sqlc

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"time"
)

// ProfileQueries contains methods for retrieving profile specific queries
type ProfileQueries struct {
	*Queries
	profileID uuid.UUID
}

// ProfileQueries returns queries for profile
func (q *Queries) ProfileQueries(profileID uuid.UUID) *ProfileQueries {
	return &ProfileQueries{
		Queries:   q,
		profileID: profileID,
	}
}

// GetProgressForEpisodes returns progress for the specified episodes
func (q *ProfileQueries) GetProgressForEpisodes(ctx context.Context, episodeIDs []int) ([]common.Progress, error) {
	progress, err := q.getProgressForProfile(ctx, getProgressForProfileParams{
		Column1: q.profileID,
		Column2: intToInt32(episodeIDs),
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(progress, func(row getProgressForProfileRow, _ int) common.Progress {
		return common.Progress{
			EpisodeID: int(row.EpisodeID),
			Progress:  row.Progress,
		}
	}), nil
}

// SaveProgress stores the progress
func (q *ProfileQueries) SaveProgress(ctx context.Context, episodeID int, progress time.Time) error {
	return q.saveProgress(ctx, saveProgressParams{
		Column1: q.profileID,
		Column2: int32(episodeID),
		Column3: progress,
	})
}

// ClearProgress removes the progress from database
func (q *ProfileQueries) ClearProgress(ctx context.Context, episodeID int) error {
	return q.deleteProgress(ctx, deleteProgressParams{
		Column1: q.profileID,
		Column2: int32(episodeID),
	})
}
