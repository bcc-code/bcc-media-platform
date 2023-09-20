package sqlc

import (
	"context"
	"encoding/json"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

// GetAchievements retrieves achievements from database
func (q *Queries) GetAchievements(ctx context.Context, ids []uuid.UUID) ([]common.Achievement, error) {
	rows, err := q.getAchievements(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getAchievementsRow, _ int) common.Achievement {
		var images = common.LocaleMap[null.String]{}
		_ = json.Unmarshal(i.Images.RawMessage, &images)

		var res = common.LocaleMap[null.String]{}
		for key, img := range images {
			if img.Valid {
				res[key] = null.StringFrom(q.filenameToImageURL(img.String))
			}
		}

		return common.Achievement{
			ID:          i.ID,
			GroupID:     i.GroupID,
			Title:       toLocaleString(i.Title.RawMessage, i.OriginalTitle),
			Description: toLocaleString(i.Description.RawMessage, i.OriginalDescription.String),
			Conditions:  unmarshalTo[[]common.AchievementCondition](i.Conditions.RawMessage),
			Images:      res,
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
func (cq *CollectionQueries) GetAchievementsForActions(ctx context.Context, actions []string) ([]loaders.Relation[uuid.UUID, string], error) {
	rows, err := cq.getAchievementsForActions(ctx, getAchievementsForActionsParams{
		Column1: cq.collection,
		Column2: actions,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getAchievementsForActionsRow, _ int) loaders.Relation[uuid.UUID, string] {
		return relation[uuid.UUID, string](i)
	}), nil
}

// GetAchievementsForGroups retrieves achievementIDs for actions
func (q *Queries) GetAchievementsForGroups(ctx context.Context, groupIDs []uuid.UUID) ([]loaders.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := q.getAchievementsForGroups(ctx, groupIDs)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getAchievementsForGroupsRow, _ int) loaders.Relation[uuid.UUID, uuid.UUID] {
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
			Title: toLocaleString(i.Title.RawMessage, i.OriginalTitle.String),
		}
	}), nil
}

// GetAchievementsForProfiles returns achievements achieved for profiles
func (q *Queries) GetAchievementsForProfiles(ctx context.Context, ids []uuid.UUID) ([]loaders.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := q.getAchievedAchievementsForProfiles(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getAchievedAchievementsForProfilesRow, _ int) loaders.Relation[uuid.UUID, uuid.UUID] {
		return relation[uuid.UUID, uuid.UUID](i)
	}), nil
}

// GetUnconfirmedAchievementsForProfiles returns achievements achieved for profiles
func (q *Queries) GetUnconfirmedAchievementsForProfiles(ctx context.Context, ids []uuid.UUID) ([]loaders.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := q.getUnconfirmedAchievedAchievementsForProfiles(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getUnconfirmedAchievedAchievementsForProfilesRow, _ int) loaders.Relation[uuid.UUID, uuid.UUID] {
		return relation[uuid.UUID, uuid.UUID](i)
	}), nil
}

// GetAchievementsAchievedAt returns when achievements has been achieved
func (pq *ProfileQueries) GetAchievementsAchievedAt(ctx context.Context, ids []uuid.UUID) ([]common.Achieved, error) {
	rows, err := pq.queries.achievementAchievedAt(ctx, achievementAchievedAtParams{ProfileID: pq.profileID, Column2: ids})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i achievementAchievedAtRow, _ int) common.Achieved {
		return common.Achieved{
			ID:          i.AchievementID,
			AchievedAt:  i.AchievedAt,
			ConfirmedAt: i.ConfirmedAt,
		}
	}), nil
}
