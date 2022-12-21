package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"

	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/samber/lo"
)

// Achieved is the resolver for the achieved field.
func (r *achievementResolver) Achieved(ctx context.Context, obj *model.Achievement) (bool, error) {
	p, err := getProfile(ctx)
	if err != nil {
		return false, err
	}
	achievedIDs, err := r.Loaders.AchievementsLoader.Get(ctx, p.ID)
	if err != nil {
		return false, err
	}
	return lo.Contains(utils.PointerArrayToArray(achievedIDs), utils.AsUuid(obj.ID)), nil
}

// Group is the resolver for the group field.
func (r *achievementResolver) Group(ctx context.Context, obj *model.Achievement) (*model.AchievementGroup, error) {
	if obj.Group != nil {
		// Ignore errors, as this field should just be null if they occur
		g, _ := r.QueryRoot().AchievementGroup(ctx, obj.Group.ID)
		return g, nil
	}
	return nil, nil
}

// Achievements is the resolver for the achievements field.
func (r *achievementGroupResolver) Achievements(ctx context.Context, obj *model.AchievementGroup, first *int, offset *int) (*model.AchievementPagination, error) {
	ids, err := r.GetLoaders().AchievementGroupAchievementsLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return nil, err
	}
	page := utils.Paginate(ids, first, offset, nil)
	items, err := r.GetLoaders().AchievementLoader.GetMany(ctx, utils.PointerArrayToArray(page.Items))
	if err != nil {
		return nil, err
	}
	return &model.AchievementPagination{
		Offset: page.Offset,
		First:  page.First,
		Total:  page.Total,
		Items:  utils.MapWithCtx(ctx, items, model.AchievementFrom),
	}, nil
}

// Achievement returns generated.AchievementResolver implementation.
func (r *Resolver) Achievement() generated.AchievementResolver { return &achievementResolver{r} }

// AchievementGroup returns generated.AchievementGroupResolver implementation.
func (r *Resolver) AchievementGroup() generated.AchievementGroupResolver {
	return &achievementGroupResolver{r}
}

type achievementResolver struct{ *Resolver }
type achievementGroupResolver struct{ *Resolver }