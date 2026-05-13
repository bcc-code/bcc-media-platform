package loaders

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"reflect"

	"github.com/graph-gophers/dataloader/v7"
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

// HasKey interface for items with keys
type HasKey[k comparable] interface {
	GetKey() k
}

type keyFunc[K comparable, V any] func(V) K

func (kf keyFunc[K, V]) isOption() {

}

type loaderName string

func (loaderName) isOption() {

}

// WithName assigns the specified name to the tracer
func WithName(name string) Option {
	return loaderName(name)
}

// WithKeyFunc specifies that the key should be retrieved with this function.
func WithKeyFunc[K comparable, V any](getKey func(V) K) Option {
	return keyFunc[K, V](getKey)
}

// Option is the interface for all options
type Option interface {
	isOption()
}

// New creates a single-value batch loader. The factory returns []V; the key
// used to index each value is either supplied via WithKeyFunc or, if V
// implements HasKey[K], extracted via GetKey.
func New[K comparable, V any](
	ctx context.Context,
	factory func(ctx context.Context, ids []K) ([]V, error),
	opts ...Option,
) *Loader[K, *V] {
	var getKey func(V) K
	for _, opt := range opts {
		if kf, ok := opt.(keyFunc[K, V]); ok {
			getKey = kf
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

	batchLoadItems := func(ctx context.Context, keys []K) []*dataloader.Result[*V] {
		res, err := factory(ctx, keys)
		resMap := map[K]*V{}
		if err == nil {
			for _, r := range res {
				item := r
				resMap[getKey(r)] = &item
			}
		}
		return assembleBatch(keys, resMap, err)
	}

	options := getOptions[K, *V](ctx, opts...)
	return &Loader[K, *V]{Loader: dataloader.NewBatchedLoader(batchLoadItems, options...)}
}

// Identity returns its argument unchanged. Useful as a WithKeyFunc argument for
// loaders whose factory returns the key values directly (filtering / ACL checks).
func Identity[T any](v T) T { return v }

// assembleBatch turns a resolved map and a per-batch error into the ordered
// []*dataloader.Result slice the dataloader library expects.
func assembleBatch[K comparable, T any](keys []K, resMap map[K]T, err error) []*dataloader.Result[T] {
	results := make([]*dataloader.Result[T], 0, len(keys))
	for _, key := range keys {
		r := &dataloader.Result[T]{Error: err}
		if val, ok := resMap[key]; ok {
			r.Data = val
		}
		results = append(results, r)
	}
	return results
}

// GetByID returns the object from the loader
func GetByID[k comparable, t any](ctx context.Context, loader *dataloader.Loader[k, t], id k) (t, error) {
	thunk := loader.Load(ctx, id)
	result, err := thunk()
	if err != nil {
		var empty t
		log.L.Error().Err(err).Send()
		return empty, err
	}
	return result, nil
}

// GetMany retrieves multiple items from specified loader
func GetMany[k comparable, t any](ctx context.Context, loader *dataloader.Loader[k, t], ids []k) ([]t, error) {
	thunk := loader.LoadMany(ctx, ids)
	result, errs := thunk()
	if len(errs) > 0 {
		log.L.Error().Err(errs[0]).Send()
		return nil, errs[0]
	}

	var items []t
	for _, i := range result {
		// don't add nil items
		if v := reflect.ValueOf(i); v.Kind() == reflect.Ptr && v.IsNil() {
			continue
		}
		items = append(items, i)
	}
	return items, nil
}
