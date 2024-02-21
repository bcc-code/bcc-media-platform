package graph

import (
	"context"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"gopkg.in/guregu/null.v4"
)

func withTimestampExpiration(ctx context.Context, key string, timestamp *string, onExpire func()) {
	_, _ = withCacheAndTimestamp(ctx, key, func(ctx context.Context) (bool, error) {
		onExpire()
		return true, nil
	}, time.Minute, timestamp)
}

// stores and retrieves the progress for the specified media
func (r *Resolver) storeMediaProgress(ctx context.Context, mediaID uuid.UUID, watchedThreshold float64, progress, duration *float64) (*common.MediaProgress, error) {
	p, err := getProfile(ctx)
	if err != nil {
		return nil, err
	}

	loader := r.GetProfileLoaders(ctx).MediaProgressLoader
	pr, err := loader.Get(ctx, mediaID)
	if err != nil {
		return nil, err
	}
	if pr == nil {
		pr = &common.MediaProgress{
			ProfileID: p.ID,
			MediaID:   mediaID,
		}
	}
	pr.UpdatedAt = time.Now()

	if duration != nil {
		pr.Duration = *duration
	} else {
		// avoid a 0.0 value
		pr.Duration = 100.0
	}

	if progress != nil {
		pr.Progress = *progress
	} else {
		pr.Progress = 0.0
	}

	if pr.Progress == 0.0 || pr.Duration == 0.0 || pr.Progress/pr.Duration < 0.1 {
		pr.FromStart = true
	}

	// check if progress and duration can be divided and if the result is larger than the threshold
	if pr.Progress != 0.0 && pr.Duration != 0.0 && pr.Progress/pr.Duration > watchedThreshold && pr.FromStart {
		pr.FromStart = false
		if !pr.WatchedAt.Valid || pr.WatchedAt.Time.After(time.Now().Add(time.Minute*60*-1)) {
			pr.Watched++
			pr.WatchedAt = null.TimeFrom(time.Now())
		}
	}

	err = r.GetQueries().SaveMediaProgress(ctx, sqlc.SaveMediaProgressParams{
		ProfileID: pr.ProfileID,
		Progress:  float32(pr.Progress),
		FromStart: pr.FromStart,
		Watched:   int32(pr.Watched),
		Duration:  float32(pr.Duration),
		ItemID:    pr.MediaID,
		WatchedAt: pr.WatchedAt,
	})
	if err != nil {
		return nil, err
	}
	loader.Clear(ctx, mediaID).
		Prime(ctx, mediaID, pr)
	return pr, nil
}
