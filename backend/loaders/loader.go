package loaders

import (
	"context"
	"github.com/graph-gophers/dataloader/v7"
	"go.opentelemetry.io/otel"
	"time"
)

// Loader contains loader and additional functions to retrieve data easily
type Loader[K comparable, V any] struct {
	*dataloader.Loader[K, V]
}

// Get retrieves a specific entry from the loader
func (bl *Loader[K, V]) Get(ctx context.Context, key K) (V, error) {
	return GetByID(ctx, bl.Loader, key)
}

// GetMany retrieves the specified entries from the loader
func (bl *Loader[K, V]) GetMany(ctx context.Context, keys []K) ([]V, error) {
	return GetMany(ctx, bl.Loader, keys)
}

func getOptions[K comparable, V any](opts ...Option) []dataloader.Option[K, V] {
	var options []dataloader.Option[K, V]

	memoryCacheAdded := false

	for _, opt := range opts {
		switch t := opt.(type) {
		case MemoryCache:
			options = append(options, dataloader.WithCache[K, V](NewMemoryLoaderCache[K, V](t.expiration)))
			memoryCacheAdded = true
		}
	}

	// We want a TTL for everything.
	if !memoryCacheAdded {
		options = append(options, dataloader.WithCache[K, V](NewMemoryLoaderCache[K, V](time.Minute*5)))
	}

	return options
}

// NewListLoader returns a configured batch loader for Lists
func NewListLoader[K comparable, V any](
	factory func(ctx context.Context, ids []K) ([]V, error),
	getKey func(item V) K,
	opts ...Option,
) *Loader[K, []*V] {
	batchLoadLists := func(ctx context.Context, keys []K) []*dataloader.Result[[]*V] {
		var results []*dataloader.Result[[]*V]

		res, err := factory(ctx, keys)

		resMap := map[K][]*V{}

		if err == nil {
			for _, r := range res {
				key := getKey(r)

				if _, ok := resMap[key]; !ok {
					resMap[key] = []*V{}
				}
				item := r
				resMap[key] = append(resMap[key], &item)
			}
		}

		for _, key := range keys {
			r := &dataloader.Result[[]*V]{
				Error: err,
			}

			if val, ok := resMap[key]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}

	options := getOptions[K, []*V](opts...)

	return &Loader[K, []*V]{Loader: dataloader.NewBatchedLoader(batchLoadLists, options...)}
}

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

	options := getOptions[R, []*K](opts...)

	return &Loader[R, []*K]{Loader: dataloader.NewBatchedLoader(batchLoadLists, options...)}
}

// Conversion contains the original and converted value
type Conversion[o comparable, r comparable] interface {
	GetOriginal() o
	GetResult() r
}

// NewConversionLoader returns a configured batch loader for Lists
func NewConversionLoader[o comparable, rt comparable](
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

	options := getOptions[o, *rt](opts...)

	return &Loader[o, *rt]{Loader: dataloader.NewBatchedLoader(batchLoadLists, options...)}
}

// HasKey interface for items with keys
type HasKey[k comparable] interface {
	GetKey() k
}

type keyFunc[K comparable, V any] func(V) K

func (kf keyFunc[K, V]) isOption() {

}

// WithKeyFunc specifies that the key should be retrieved with this function.
func WithKeyFunc[K comparable, V any](getKey func(V) K) Option {
	return keyFunc[K, V](getKey)
}

// Option is the interface for all options
type Option interface {
	isOption()
}

// New creates a new batch loader
func New[K comparable, V any](
	factory func(ctx context.Context, ids []K) ([]V, error),
	opts ...Option,
) *Loader[K, *V] {
	var getKey func(V) K
	for _, opt := range opts {
		switch t := opt.(type) {
		case keyFunc[K, V]:
			getKey = t
		}
	}
	if getKey == nil {
		var i V
		if _, ok := any(i).(HasKey[K]); !ok {
			panic("Couldn't determine key for item")
		}
		getKey = func(i V) K {
			return any(i).(HasKey[K]).GetKey()
		}
	}
	return NewCustomLoader(factory, getKey, opts...)
}

// NewLoader returns a configured batch loader for items
func NewLoader[K comparable, V HasKey[K]](
	factory func(ctx context.Context, ids []K) ([]V, error),
	opts ...Option,
) *Loader[K, *V] {
	return NewCustomLoader(factory, func(i V) K {
		return i.GetKey()
	}, opts...)
}

// NewFilterLoader is just for filtering a list of keys or checking if user has access to a specific id
func NewFilterLoader[K comparable](factory func(ctx context.Context, keys []K) ([]K, error), opts ...Option) *Loader[K, *K] {
	return NewCustomLoader(factory, func(key K) K {
		return key
	}, opts...)
}

// NewCustomLoader returns a configured batch loader for items
func NewCustomLoader[K comparable, V any](
	factory func(ctx context.Context, ids []K) ([]V, error),
	getKey func(V) K,
	opts ...Option,
) *Loader[K, *V] {
	batchLoadItems := func(ctx context.Context, keys []K) []*dataloader.Result[*V] {
		var results []*dataloader.Result[*V]

		res, err := factory(ctx, keys)

		resMap := map[K]*V{}

		if err == nil {
			for _, r := range res {
				item := r
				resMap[getKey(r)] = &item
			}
		}

		for _, key := range keys {
			r := &dataloader.Result[*V]{
				Error: err,
			}

			if val, ok := resMap[key]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}

	options := getOptions[K, *V](opts...)

	// Currently we do not want to cache at the GQL level
	return &Loader[K, *V]{Loader: dataloader.NewBatchedLoader(batchLoadItems, options...)}
}

// GetByID returns the object from the loader
func GetByID[k comparable, t any](ctx context.Context, loader *dataloader.Loader[k, t], id k) (t, error) {
	ctx, span := otel.Tracer("loader").Start(ctx, "single")
	defer span.End()
	thunk := loader.Load(ctx, id)
	result, err := thunk()
	if err != nil {
		var empty t
		return empty, err
	}
	return result, nil
}

// GetMany retrieves multiple items from specified loader
func GetMany[k comparable, t any](ctx context.Context, loader *dataloader.Loader[k, t], ids []k) ([]t, error) {
	ctx, span := otel.Tracer("loader").Start(ctx, "multiple")
	defer span.End()
	thunk := loader.LoadMany(ctx, ids)
	result, errs := thunk()
	if len(errs) > 0 {
		return nil, errs[0]
	}

	var items []t
	for _, i := range result {
		items = append(items, i)
	}
	return items, nil
}
