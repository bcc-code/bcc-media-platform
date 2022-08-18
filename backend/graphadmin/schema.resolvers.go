package gqladmin

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"encoding/json"

	"github.com/bcc-code/brunstadtv/backend/common"
	gqladmingenerated "github.com/bcc-code/brunstadtv/backend/graphadmin/generated"
	gqladminmodel "github.com/bcc-code/brunstadtv/backend/graphadmin/model"
)

// Collection is the resolver for the collection field.
func (r *previewResolver) Collection(ctx context.Context, obj *gqladminmodel.Preview, collection string, filter string) (*gqladminmodel.PreviewCollection, error) {
	ctx = context.WithValue(ctx, "preview", true)

	var f common.Filter

	_ = json.Unmarshal([]byte(filter), &f)

	items, err := r.getItemsForFilter(ctx, collection, f)
	if err != nil {
		return nil, err
	}

	return &gqladminmodel.PreviewCollection{
		Items: items,
	}, nil
}

// Preview is the resolver for the Preview field.
func (r *queryRootResolver) Preview(ctx context.Context) (*gqladminmodel.Preview, error) {
	return &gqladminmodel.Preview{}, nil
}

// Preview returns gqladmingenerated.PreviewResolver implementation.
func (r *Resolver) Preview() gqladmingenerated.PreviewResolver { return &previewResolver{r} }

// QueryRoot returns gqladmingenerated.QueryRootResolver implementation.
func (r *Resolver) QueryRoot() gqladmingenerated.QueryRootResolver { return &queryRootResolver{r} }

type previewResolver struct{ *Resolver }
type queryRootResolver struct{ *Resolver }
