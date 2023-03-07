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

	CollectionTopics  = "topics"
	CollectionLessons = "lessons"
	CollectionTasks   = "tasks"
)

// Action defines what type of activity has happened that might trigger a new Achievement
type Action struct {
	Collection string
	Action     string
}

// CheckNewAchievements achieved since last check
func CheckNewAchievements(ctx context.Context, queries *sqlc.Queries, loaders *common.BatchLoaders, action Action) error {
	ginCtx, _ := utils.GinCtx(ctx)
	p := user.GetProfileFromCtx(ginCtx)
	if p == nil {
		return nil
	}

	var amount int
	switch action.Collection {
	case CollectionTopics:
		switch action.Action {
		case ActionCompleted:
			ids, err := loaders.CompletedTopicsLoader.Get(ctx, p.ID)
			if err != nil {
				return err
			}
			amount = len(ids)
		}
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

	achieved, err := queries.GetAchievementsWithConditionAchieved(ctx, sqlc.GetAchievementsWithConditionAchievedParams{
		ProfileID:  p.ID,
		Action:     action.Action,
		Collection: action.Collection,
		Amount:     int32(amount),
	})
	if err != nil {
		return err
	}
	for _, a := range achieved {
		err = queries.SetAchievementAchieved(ctx, sqlc.SetAchievementAchievedParams{
			AchievementID: a.ID,
			ProfileID:     p.ID,
			ConditionIds:  a.ConditionIds,
		})
		if err != nil {
			return err
		}
	}
	return nil
}

// CheckAllAchievements checks if any achievement has been achieved
func CheckAllAchievements(ctx context.Context, queries *sqlc.Queries, loaders *common.BatchLoaders) error {
	actions := []Action{
		{
			Collection: CollectionLessons,
			Action:     ActionCompleted,
		},
		{
			Collection: CollectionTasks,
			Action:     ActionCompleted,
		},
	}
	for _, a := range actions {
		err := CheckNewAchievements(ctx, queries, loaders, a)
		if err != nil {
			return err
		}
	}
	return nil
}
