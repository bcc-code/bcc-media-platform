package graphpub

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"

	gqlpublicgenerated "github.com/bcc-code/brunstadtv/backend/graph/public/generated"
	publicmodel "github.com/bcc-code/brunstadtv/backend/graph/public/model"
)

// Season is the resolver for the season field.
func (r *episodeResolver) Season(ctx context.Context, obj *publicmodel.Episode) (*publicmodel.Season, error) {
	if obj.Season == nil {
		return nil, nil
	}
	return r.QueryRoot().Season(ctx, obj.Season.ID)
}

// Episode returns gqlpublicgenerated.EpisodeResolver implementation.
func (r *Resolver) Episode() gqlpublicgenerated.EpisodeResolver { return &episodeResolver{r} }

type episodeResolver struct{ *Resolver }
