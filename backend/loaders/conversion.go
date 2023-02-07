package loaders

import (
	"context"
	"github.com/graph-gophers/dataloader/v7"
)

// Conversion contains the original and converted value
type Conversion[O comparable, R comparable] interface {
	GetOriginal() O
	GetResult() R
}

// NewConversionLoader returns a configured batch loader for Lists
func NewConversionLoader[o comparable, rt comparable](
	ctx context.Context,
	factory func(ctx context.Context, ids []o) ([]Conversion[o, rt], error),
	opts ...Option,
) *Loader[o, *rt] {
	batchLoadLists := func(ctx context.Context, keys []o) []*dataloader.Result[*rt] {
		var results []*dataloader.Result[*rt]

		res, err := factory(ctx, keys)

		resMap := map[o]*rt{}

		if err == nil {
			for _, r := range res {
				v := r.GetResult()
				resMap[r.GetOriginal()] = &v
			}
		}

		for _, key := range keys {
			r := &dataloader.Result[*rt]{
				Error: err,
			}

			if val, ok := resMap[key]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}

	options := getOptions[o, *rt](ctx, opts...)

	return &Loader[o, *rt]{Loader: dataloader.NewBatchedLoader(batchLoadLists, options...)}
}
