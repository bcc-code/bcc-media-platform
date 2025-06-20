package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.
// Code generated by github.com/99designs/gqlgen version v0.17.74

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/graph/api/generated"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
)

// Show is the resolver for the show field.
func (r *episodeSearchItemResolver) Show(ctx context.Context, obj *model.EpisodeSearchItem) (*model.Show, error) {
	if obj.Show != nil {
		return r.QueryRoot().Show(ctx, obj.Show.ID)
	}
	return nil, nil
}

// Season is the resolver for the season field.
func (r *episodeSearchItemResolver) Season(ctx context.Context, obj *model.EpisodeSearchItem) (*model.Season, error) {
	if obj.Season != nil {
		return r.QueryRoot().Season(ctx, obj.Season.ID)
	}
	return nil, nil
}

// Show is the resolver for the show field.
func (r *seasonSearchItemResolver) Show(ctx context.Context, obj *model.SeasonSearchItem) (*model.Show, error) {
	return r.QueryRoot().Show(ctx, obj.Show.ID)
}

// Show is the resolver for the show field.
func (r *showSearchItemResolver) Show(ctx context.Context, obj *model.ShowSearchItem) (*model.Show, error) {
	return r.QueryRoot().Show(ctx, obj.ID)
}

// EpisodeSearchItem returns generated.EpisodeSearchItemResolver implementation.
func (r *Resolver) EpisodeSearchItem() generated.EpisodeSearchItemResolver {
	return &episodeSearchItemResolver{r}
}

// SeasonSearchItem returns generated.SeasonSearchItemResolver implementation.
func (r *Resolver) SeasonSearchItem() generated.SeasonSearchItemResolver {
	return &seasonSearchItemResolver{r}
}

// ShowSearchItem returns generated.ShowSearchItemResolver implementation.
func (r *Resolver) ShowSearchItem() generated.ShowSearchItemResolver {
	return &showSearchItemResolver{r}
}

type episodeSearchItemResolver struct{ *Resolver }
type seasonSearchItemResolver struct{ *Resolver }
type showSearchItemResolver struct{ *Resolver }
