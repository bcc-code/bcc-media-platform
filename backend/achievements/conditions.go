package achievements

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// Constants for string keys
const (
	ActionCompleted = "completed"

	CollectionLessons = "lessons"
	CollectionTasks   = "tasks"
)

type Condition struct {
	Collection string
	Action     string
}

// CheckAchievements achieved since last check
func CheckAchievements(ctx context.Context, queries *sqlc.Queries, loaders *common.BatchLoaders, condition Condition) error {
	ginCtx, _ := utils.GinCtx(ctx)
	p := user.GetProfileFromCtx(ginCtx)
	if p == nil {
		return nil
	}

	var amount int
	switch condition.Collection {
	case CollectionLessons:
		switch condition.Action {
		case ActionCompleted:
			ids, err := loaders.CompletedLessonsLoader.Get(ctx, p.ID)
			if err != nil {
				return err
			}
			amount = len(ids)
		}
	case CollectionTasks:
		switch condition.Action {
		case ActionCompleted:
			ids, err := loaders.CompletedTasksLoader.Get(ctx, p.ID)
			if err != nil {
				return err
			}
			amount = len(ids)
		}
	}

	ids, err := queries.ConditionAchieved(ctx, sqlc.ConditionAchievedParams{
		ProfileID:  p.ID,
		Action:     condition.Action,
		Collection: condition.Collection,
		Amount:     int32(amount),
	})
	if err != nil {
		return err
	}
	for _, aID := range ids {
		err = queries.AchievedAchievement(ctx, sqlc.AchievedAchievementParams{
			AchievementID: aID,
			ProfileID:     p.ID,
		})
		if err != nil {
			return err
		}
	}
	return nil
}
