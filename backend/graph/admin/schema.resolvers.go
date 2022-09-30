package gqladmin

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"encoding/json"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/common"
	gqladmingenerated "github.com/bcc-code/brunstadtv/backend/graph/admin/generated"
	gqladminmodel "github.com/bcc-code/brunstadtv/backend/graph/admin/model"
	"github.com/samber/lo"
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

// Asset is the resolver for the asset field.
func (r *previewResolver) Asset(ctx context.Context, obj *gqladminmodel.Preview, id string) (*gqladminmodel.PreviewAsset, error) {
	ctx = context.WithValue(ctx, "preview", true)

	intID, err := strconv.ParseInt(id, 10, 32)
	if err != nil {
		return nil, err
	}

	streams, err := r.Queries.GetStreamsForAssets(ctx, []int{int(intID)})
	if err != nil || len(streams) == 0 {
		return nil, err
	}

	stream, found := lo.Find(streams, func(s common.Stream) bool {
		return s.Type == "hls_cmaf"
	})
	if !found {
		stream = streams[0]
	}
	return &gqladminmodel.PreviewAsset{
		URL:  stream.Url,
		Type: stream.Type,
	}, nil
}

// Preview is the resolver for the preview field.
func (r *queryRootResolver) Preview(ctx context.Context) (*gqladminmodel.Preview, error) {
	return &gqladminmodel.Preview{}, nil
}

// Preview returns gqladmingenerated.PreviewResolver implementation.
func (r *Resolver) Preview() gqladmingenerated.PreviewResolver { return &previewResolver{r} }

// QueryRoot returns gqladmingenerated.QueryRootResolver implementation.
func (r *Resolver) QueryRoot() gqladmingenerated.QueryRootResolver { return &queryRootResolver{r} }

type previewResolver struct{ *Resolver }
type queryRootResolver struct{ *Resolver }
