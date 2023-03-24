package achievements

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
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

type achievedResult struct {
	ID           uuid.UUID
	ConditionIDs []uuid.UUID
}

func listToAchievedResult[T any](ctx context.Context, queries *sqlc.Queries, action Action, profileID uuid.UUID, factory func(ctx context.Context, id uuid.UUID) ([]T, error)) ([]achievedResult, error) {
	rows, err := factory(ctx, profileID)
	if err != nil {
		return nil, err
	}
	achieved, err := queries.GetAchievementsWithConditionAchieved(ctx, sqlc.GetAchievementsWithConditionAchievedParams{
		ProfileID:  profileID,
		Action:     action.Action,
		Collection: action.Collection,
		Amount:     int32(len(rows)),
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(achieved, func(i sqlc.GetAchievementsWithConditionAchievedRow, _ int) achievedResult {
		return achievedResult{
			ID:           i.ID,
			ConditionIDs: i.ConditionIds,
		}
	}), nil
}

// CheckNewAchievements achieved since last check
func CheckNewAchievements(ctx context.Context, queries *sqlc.Queries, loaders *common.BatchLoaders, action Action) error {
	ginCtx, _ := utils.GinCtx(ctx)
	p := user.GetProfileFromCtx(ginCtx)
	if p == nil {
		return nil
	}

	var achieved []achievedResult
	var err error

	switch action.Collection {
	case CollectionTopics:
		switch action.Action {
		case ActionCompleted:
			achieved, err = listToAchievedResult(ctx, queries, action, p.ID, loaders.CompletedTopicsLoader.Get)
		}
	case CollectionLessons:
		switch action.Action {
		case ActionCompleted:
			achieved, err = listToAchievedResult(ctx, queries, action, p.ID, loaders.CompletedLessonsLoader.Get)
		}
	case CollectionTasks:
		switch action.Action {
		case ActionCompleted:
			achieved, err = listToAchievedResult(ctx, queries, action, p.ID, loaders.CompletedTasksLoader.Get)
		}
	}

	if err != nil {
		return err
	}
	for _, a := range achieved {
		err = queries.SetAchievementAchieved(ctx, sqlc.SetAchievementAchievedParams{
			AchievementID: a.ID,
			ProfileID:     p.ID,
			ConditionIds:  a.ConditionIDs,
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
