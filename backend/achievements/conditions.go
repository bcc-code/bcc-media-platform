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

type Action struct {
	Collection string
	Action     string
}

// CheckAchievements achieved since last check
func CheckAchievements(ctx context.Context, queries *sqlc.Queries, loaders *common.BatchLoaders, action Action) error {
	ginCtx, _ := utils.GinCtx(ctx)
	p := user.GetProfileFromCtx(ginCtx)
	if p == nil {
		return nil
	}

	var amount int
	switch action.Collection {
	case CollectionLessons:
		switch action.Action {
		case ActionCompleted:
			ids, err := loaders.CompletedLessonsLoader.Get(ctx, p.ID)
			if err != nil {
				return err
			}
			amount = len(ids)
		}
	case CollectionTasks:
		switch action.Action {
		case ActionCompleted:
			ids, err := loaders.CompletedTasksLoader.Get(ctx, p.ID)
			if err != nil {
				return err
			}
			amount = len(ids)
		}
	}

	ids, err := queries.GetAchievementsWithConditionAchieved(ctx, sqlc.GetAchievementsWithConditionAchievedParams{
		ProfileID:  p.ID,
		Action:     action.Action,
		Collection: action.Collection,
		Amount:     int32(amount),
	})
	if err != nil {
		return err
	}
	for _, aID := range ids {
		err = queries.SetAchievementAchieved(ctx, sqlc.SetAchievementAchievedParams{
			AchievementID: aID,
			ProfileID:     p.ID,
		})
		if err != nil {
			return err
		}
	}
	return nil
}
