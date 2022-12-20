package sqlc

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// GetAchievements retrieves achievements from database
func (q *Queries) GetAchievements(ctx context.Context, ids []uuid.UUID) ([]common.Achievement, error) {
	rows, err := q.getAchievements(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getAchievementsRow, _ int) common.Achievement {
		return common.Achievement{
			ID:         i.ID,
			GroupID:    i.GroupID,
			Title:      toLocaleString(i.Title.RawMessage, i.OriginalTitle),
			Conditions: unmarshalTo[[]common.AchievementCondition](i.Conditions.RawMessage),
		}
	}), nil
}

// CollectionQueries contains collection specific queries
type CollectionQueries struct {
	collection string
	*Queries
}

// Collection retrieves specific methods for the given collection
func (q *Queries) Collection(collection string) CollectionQueries {
	return CollectionQueries{
		collection: collection,
		Queries:    q,
	}
}

// GetAchievementsForActions retrieves achievementIDs for actions
func (cq *CollectionQueries) GetAchievementsForActions(ctx context.Context, actions []string) ([]batchloaders.Relation[uuid.UUID, string], error) {
	rows, err := cq.getAchievementsForActions(ctx, getAchievementsForActionsParams{
		Column1: cq.collection,
		Column2: actions,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getAchievementsForActionsRow, _ int) batchloaders.Relation[uuid.UUID, string] {
		return relation[uuid.UUID, string](i)
	}), nil
}

// GetAchievementsForGroups retrieves achievementIDs for actions
func (cq *CollectionQueries) GetAchievementsForGroups(ctx context.Context, groupIDs []uuid.UUID) ([]batchloaders.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := cq.getAchievementsForGroups(ctx, groupIDs)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getAchievementsForGroupsRow, _ int) batchloaders.Relation[uuid.UUID, uuid.UUID] {
		return relation[uuid.UUID, uuid.UUID](i)
	}), nil
}

// GetAchievementGroups returns achievement-groups
func (q *Queries) GetAchievementGroups(ctx context.Context, ids []uuid.UUID) ([]common.AchievementGroup, error) {
	rows, err := q.getAchievementGroups(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getAchievementGroupsRow, _ int) common.AchievementGroup {
		return common.AchievementGroup{
			ID:    i.ID,
			Title: toLocaleString(i.Title.RawMessage, i.OriginalTitle),
		}
	}), nil
}

// GetAchievementsForProfiles returns achievements achieved for profiles
func (q *Queries) GetAchievementsForProfiles(ctx context.Context, ids []uuid.UUID) ([]batchloaders.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := q.getAchievedAchievementsForProfiles(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getAchievedAchievementsForProfilesRow, _ int) batchloaders.Relation[uuid.UUID, uuid.UUID] {
		return relation[uuid.UUID, uuid.UUID](i)
	}), nil
}

// GetUnconfirmedAchievementsForProfiles returns achievements achieved for profiles
func (q *Queries) GetUnconfirmedAchievementsForProfiles(ctx context.Context, ids []uuid.UUID) ([]batchloaders.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := q.getUnconfirmedAchievedAchievementsForProfiles(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getUnconfirmedAchievedAchievementsForProfilesRow, _ int) batchloaders.Relation[uuid.UUID, uuid.UUID] {
		return relation[uuid.UUID, uuid.UUID](i)
	}), nil
}
