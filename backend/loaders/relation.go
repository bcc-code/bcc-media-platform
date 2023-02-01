package loaders

import (
	"context"
	"github.com/graph-gophers/dataloader/v7"
)

// RelationItem implements Relation
type RelationItem[k comparable, kr comparable] struct {
	Key        k
	RelationID kr
}

// GetKey retrieves the key for the item
func (r RelationItem[k, kr]) GetKey() k {
	return r.Key
}

// GetRelationID returns the relation ID
func (r RelationItem[k, kr]) GetRelationID() kr {
	return r.RelationID
}

// Relation contains a simple id to relation struct
type Relation[k comparable, kr comparable] interface {
	GetKey() k
	GetRelationID() kr
}

// NewRelationLoader returns a configured batch loader for Lists
func NewRelationLoader[K comparable, R comparable](
	ctx context.Context,
	factory func(ctx context.Context, ids []R) ([]Relation[K, R], error),
	opts ...Option,
) *Loader[R, []*K] {
	batchLoadLists := func(ctx context.Context, keys []R) []*dataloader.Result[[]*K] {
		var results []*dataloader.Result[[]*K]

		res, err := factory(ctx, keys)

		resMap := map[R][]*K{}

		if err == nil {
			for _, r := range res {
				key := r.GetRelationID()

				if _, ok := resMap[key]; !ok {
					resMap[key] = []*K{}
				}
				id := r.GetKey()
				resMap[key] = append(resMap[key], &id)
			}
		}

		for _, key := range keys {
			r := &dataloader.Result[[]*K]{
				Error: err,
			}

			if val, ok := resMap[key]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}

	options := getOptions[R, []*K](ctx, opts...)

	return &Loader[R, []*K]{Loader: dataloader.NewBatchedLoader(batchLoadLists, options...)}
}
