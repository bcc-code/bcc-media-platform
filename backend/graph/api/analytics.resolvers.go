package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"

	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
)

// AnonymousID is the resolver for the anonymousId field.
func (r *analyticsResolver) AnonymousID(ctx context.Context, obj *model.Analytics) (string, error) {
	return r.AnalyticsIDFactory(ctx), nil
}

// Analytics returns generated.AnalyticsResolver implementation.
func (r *Resolver) Analytics() generated.AnalyticsResolver { return &analyticsResolver{r} }

type analyticsResolver struct{ *Resolver }
