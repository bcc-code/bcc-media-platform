package graphpub

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"

	gqlpublicgenerated "github.com/bcc-code/brunstadtv/backend/graph/public/generated"
	publicmodel "github.com/bcc-code/brunstadtv/backend/graph/public/model"
)

// Show is the resolver for the show field.
func (r *seasonResolver) Show(ctx context.Context, obj *publicmodel.Season) (*publicmodel.Show, error) {
	return r.QueryRoot().Show(ctx, obj.Show.ID)
}

// Season returns gqlpublicgenerated.SeasonResolver implementation.
func (r *Resolver) Season() gqlpublicgenerated.SeasonResolver { return &seasonResolver{r} }

type seasonResolver struct{ *Resolver }
