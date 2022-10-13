package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"encoding/json"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/admin/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/admin/model"
	"github.com/samber/lo"
)

func (r *previewResolver) Collection(ctx context.Context, obj *model.Preview, collection string, filter string) (*model.PreviewCollection, error) {
	ctx = context.WithValue(ctx, "preview", true)

	var f common.Filter

	_ = json.Unmarshal([]byte(filter), &f)

	items, err := r.getItemsForFilter(ctx, collection, f)
	if err != nil {
		return nil, err
	}

	return &model.PreviewCollection{
		Items: items,
	}, nil
}

func (r *previewResolver) Asset(ctx context.Context, obj *model.Preview, id string) (*model.PreviewAsset, error) {
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
	return &model.PreviewAsset{
		URL:  stream.Url,
		Type: stream.Type,
	}, nil
}

func (r *queryRootResolver) Preview(ctx context.Context) (*model.Preview, error) {
	return &model.Preview{}, nil
}

// Preview returns generated.PreviewResolver implementation.
func (r *Resolver) Preview() generated.PreviewResolver { return &previewResolver{r} }

// QueryRoot returns generated.QueryRootResolver implementation.
func (r *Resolver) QueryRoot() generated.QueryRootResolver { return &queryRootResolver{r} }

type previewResolver struct{ *Resolver }
type queryRootResolver struct{ *Resolver }
