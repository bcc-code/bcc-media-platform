package loaders

import (
	"context"
	"github.com/graph-gophers/dataloader/v7"
)

// Conversion is a generic interface that defines a conversion from one type to another.
// It's used by NewConversionLoader to convert between an original value (O) and a result value (R).
//
// Example:
//
//	type UUIDToStringConversion struct {
//		original uuid.UUID
//		result   string
//	}
//
//	func (c UUIDToStringConversion) GetOriginal() uuid.UUID { return c.original }
//	func (c UUIDToStringConversion) GetResult() string     { return c.result }
type Conversion[O comparable, R any] interface {
	// GetOriginal returns the original key used for the conversion
	GetOriginal() O
	// GetResult returns the converted result
	GetResult() R
}

// NewConversionLoader creates a new batch loader that converts between two types.
// It's particularly useful for when the query returns data of a different type than the object we want out.
//
// The function takes a `converter` function that knows how to convert a batch of input keys (type O)
// into a slice of Conversion[O, R] results. The loader handles batching, caching, and error
// propagation automatically.
//
// Parameters:
//   - ctx: Context for cancellation and timeouts
//   - factory: Function that converts a batch of input keys to Conversion results
//   - opts: Optional configuration (e.g., WithMemoryCache, WithName)
//
// Returns:
//   - *Loader[O, *R]: A loader that can be used to fetch individual or batched results
//
// Example:
//
//	loader := NewConversionLoader(
//		ctx,
//		func(ctx context.Context, ids []uuid.UUID) ([]Conversion[uuid.UUID, string], error) {
//			// Fetch and convert data here
//			return conversions, nil
//		},
//		WithMemoryCache(5*time.Minute),
//		WithName("my-loader"),
//	)
func NewConversionLoader[o comparable, rt any](
	ctx context.Context,
	converter func(ctx context.Context, ids []o) ([]Conversion[o, rt], error),
	opts ...Option,
) *Loader[o, *rt] {
	batchLoadLists := func(ctx context.Context, keys []o) []*dataloader.Result[*rt] {
		var results []*dataloader.Result[*rt]

		res, err := converter(ctx, keys)

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
