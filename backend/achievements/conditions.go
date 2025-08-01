package achievements

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

// Constants for string keys
const (
	ActionCompleted      = "completed"
	ActionCompletedItems = "completed_items"

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

func amountToAchievedResult[T any](ctx context.Context, queries *sqlc.Queries, action Action, profileID uuid.UUID, factory func(ctx context.Context, id uuid.UUID) ([]T, error)) ([]achievedResult, error) {
	rows, err := factory(ctx, profileID)
	if err != nil {
		return nil, err
	}
	achieved, err := queries.GetAchievementsWithConditionAmountAchieved(ctx, sqlc.GetAchievementsWithConditionAmountAchievedParams{
		ProfileID:  profileID,
		Collection: action.Collection,
		Action:     action.Action,
		Amount:     null.IntFrom(int64(len(rows))),
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(achieved, func(i sqlc.GetAchievementsWithConditionAmountAchievedRow, _ int) achievedResult {
		return achievedResult{
			ID:           i.ID,
			ConditionIDs: i.ConditionIds,
		}
	}), nil
}

func completedTopicIDsToAchievedResult(ctx context.Context, queries *sqlc.Queries, profileID uuid.UUID, factory func(ctx context.Context, id uuid.UUID) ([]*uuid.UUID, error)) ([]achievedResult, error) {
	rows, err := factory(ctx, profileID)
	if err != nil {
		return nil, err
	}
	achieved, err := queries.GetAchievementsWithTopicsCompletedAchieved(ctx, sqlc.GetAchievementsWithTopicsCompletedAchievedParams{
		ProfileID: profileID,
		TopicIds:  utils.PointerArrayToArray(rows),
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(achieved, func(i sqlc.GetAchievementsWithTopicsCompletedAchievedRow, _ int) achievedResult {
		return achievedResult{
			ID:           i.ID,
			ConditionIDs: i.ConditionIds,
		}
	}), nil
}

// CheckNewAchievements achieved since last check
func CheckNewAchievements(ctx context.Context, queries *sqlc.Queries, loaders *loaders.BatchLoaders, action Action) error {
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
			achieved, err = amountToAchievedResult(ctx, queries, action, p.ID, loaders.CompletedTopicsLoader.Get)
		case ActionCompletedItems:
			achieved, err = completedTopicIDsToAchievedResult(ctx, queries, p.ID, loaders.CompletedTopicsLoader.Get)
		}
	case CollectionLessons:
		switch action.Action {
		case ActionCompleted:
			achieved, err = CheckCompletedLessonAchivements(ctx, queries, loaders, p.ID)
		}
	case CollectionTasks:
		switch action.Action {
		case ActionCompleted:
			achieved, err = amountToAchievedResult(ctx, queries, action, p.ID, loaders.CompletedTasksLoader.Get)
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

func CheckCompletedLessonAchivements(ctx context.Context, queries *sqlc.Queries, loaders *loaders.BatchLoaders, profileID uuid.UUID) ([]achievedResult, error) {
	lessons, err := loaders.CompletedLessonsLoader.Get(ctx, profileID)

	if err != nil {
		return nil, err
	}

	l := utils.PointerArrayToArray(lessons)
	completedLessons, err := loaders.StudyLessonLoader.GetMany(ctx, l)

	if err != nil {
		return nil, err
	}

	completedCount := map[uuid.UUID]int32{}
	totalCompletedLessons := int32(len(completedLessons))
	for _, l := range completedLessons {
		if _, ok := completedCount[l.TopicID]; !ok {
			completedCount[l.TopicID] = 0
		}

		completedCount[l.TopicID]++
	}

	conds, err := queries.GetNewConditionsForProfile(ctx, profileID)
	if err != nil {
		return nil, err
	}

	counts := map[uuid.UUID]int32{}
	achieved := []achievedResult{}
	// Count completed for each condition
	for _, c := range conds {
		if _, ok := counts[c.ConditionID]; !ok {
			counts[c.ConditionID] = 0
		}

		if len(c.Studytopics) == 0 {
			counts[c.ConditionID] = totalCompletedLessons
			if counts[c.ConditionID] >= c.Amount {
				achieved = append(achieved, achievedResult{
					ID: c.AchievementID,
					ConditionIDs: []uuid.UUID{
						c.ConditionID,
					},
				})
			}
			continue
		}

		for _, t := range c.Studytopics {
			counts[c.ConditionID] += completedCount[t]
			if counts[c.ConditionID] >= c.Amount {
				achieved = append(achieved, achievedResult{
					ID: c.AchievementID,
					ConditionIDs: []uuid.UUID{
						c.ConditionID,
					},
				})
				continue
			}
		}
	}

	return achieved, nil
}

// CheckAllAchievements checks if any achievement has been achieved
func CheckAllAchievements(ctx context.Context, queries *sqlc.Queries, loaders *loaders.BatchLoaders) error {
	actions := []Action{
		{
			Collection: CollectionTopics,
			Action:     ActionCompletedItems,
		},
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
