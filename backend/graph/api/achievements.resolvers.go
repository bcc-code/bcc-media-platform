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

// Group is the resolver for the group field.
func (r *achievementResolver) Group(ctx context.Context, obj *model.Achievement) (*model.AchievementGroup, error) {
	panic(fmt.Errorf("not implemented: Group - group"))
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
