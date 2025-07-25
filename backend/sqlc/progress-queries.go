package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"github.com/sqlc-dev/pqtype"
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
func (q *Queries) GetEpisodeIDsWithProgress(ctx context.Context, profileIDs []uuid.UUID) ([]common.Relation[int, uuid.UUID], error) {
	rows, err := q.getEpisodeIDsWithProgress(ctx, profileIDs)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getEpisodeIDsWithProgressRow, _ int) common.Relation[int, uuid.UUID] {
		return common.RelationItem[int, uuid.UUID]{
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

// DefaultEpisodeIDForSeasonIDs returns the default episodeIDs for the specified keys
func (pq *ProfileQueries) DefaultEpisodeIDForSeasonIDs(ctx context.Context, seasonIDs []int) ([]common.Conversion[int, int], error) {
	rows, err := pq.queries.getDefaultEpisodeIDForSeasonIDs(ctx, getDefaultEpisodeIDForSeasonIDsParams{
		ProfileID: pq.profileID,
		SeasonIds: intToInt32(seasonIDs),
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(row getDefaultEpisodeIDForSeasonIDsRow, _ int) common.Conversion[int, int] {
		return conversion[int, int]{
			source: int(row.ParentID),
			result: int(row.ID),
		}
	}), nil
}

// DefaultEpisodeIDForShowIDs returns the default episodeIDs for the specified keys
func (pq *ProfileQueries) DefaultEpisodeIDForShowIDs(ctx context.Context, seasonIDs []int) ([]common.Conversion[int, int], error) {
	rows, err := pq.queries.getDefaultEpisodeIDForShowIDs(ctx, getDefaultEpisodeIDForShowIDsParams{
		ProfileID: pq.profileID,
		ShowIds:   intToInt32(seasonIDs),
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(row getDefaultEpisodeIDForShowIDsRow, _ int) common.Conversion[int, int] {
		return conversion[int, int]{
			source: int(row.ParentID),
			result: int(row.ID),
		}
	}), nil
}
