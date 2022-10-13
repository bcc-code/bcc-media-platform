package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"

	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/api/model"
)

func (r *applicationResolver) Page(ctx context.Context, obj *gqlmodel.Application) (*gqlmodel.Page, error) {
	if obj.Page != nil {
		return r.QueryRoot().Page(ctx, &obj.Page.ID, nil)
	}
	return nil, nil
}

// Application returns generated.ApplicationResolver implementation.
func (r *Resolver) Application() generated.ApplicationResolver { return &applicationResolver{r} }

type applicationResolver struct{ *Resolver }
