package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"

	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
)

// Image is the resolver for the image field.
func (r *achievementResolver) Image(ctx context.Context, obj *model.Achievement) (*string, error) {
	panic(fmt.Errorf("not implemented: Image - image"))
}

// Achieved is the resolver for the achieved field.
func (r *achievementResolver) Achieved(ctx context.Context, obj *model.Achievement) (bool, error) {
	panic(fmt.Errorf("not implemented: Achieved - achieved"))
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
	panic(fmt.Errorf("not implemented: Achievements - achievements"))
}

// Achievement returns generated.AchievementResolver implementation.
func (r *Resolver) Achievement() generated.AchievementResolver { return &achievementResolver{r} }

// AchievementGroup returns generated.AchievementGroupResolver implementation.
func (r *Resolver) AchievementGroup() generated.AchievementGroupResolver {
	return &achievementGroupResolver{r}
}

type achievementResolver struct{ *Resolver }
type achievementGroupResolver struct{ *Resolver }
