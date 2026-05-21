package loaders

import (
	"context"
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

type identityKeyOpt struct{}

func (identityKeyOpt) isOption() {}

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

// WithIdentityKey signals that the factory's items already _are_ the keys
// (typical for filter / ACL loaders that return the subset of input keys the
// caller has access to). Equivalent to WithKeyFunc(func(v V) K { return v.(K) }),
// but without forcing the call site to spell the type. Panics at first batch
// if V is not assignable to K.
func WithIdentityKey() Option { return identityKeyOpt{} }

// Option is the interface for all options
type Option interface {
	isOption()
}

// resolveKeyFunc picks a key extractor for V from the options, falling back to
// HasKey[K] if V implements it. Panics at construction time when no rule
// applies — same failure mode as a missing required argument.
func resolveKeyFunc[K comparable, V any](opts ...Option) func(V) K {
	for _, opt := range opts {
		switch t := opt.(type) {
		case keyFunc[K, V]:
			return t
		case identityKeyOpt:
			return func(v V) K { return any(v).(K) }
		}
	}
	var zero V
	if _, ok := any(zero).(HasKey[K]); ok {
		return func(v V) K { return any(v).(HasKey[K]).GetKey() }
	}
	panic("Couldn't determine key for item")
}

// New creates a single-value batch loader. The factory returns []V; the key
// used to index each value is supplied via WithKeyFunc, WithIdentityKey, or
// V implementing HasKey[K].
func New[K comparable, V any](
	ctx context.Context,
	factory func(ctx context.Context, ids []K) ([]V, error),
	opts ...Option,
) *Loader[K, *V] {
	getKey := resolveKeyFunc[K, V](opts...)

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
		return empty, err
	}
	return result, nil
}

// GetMany retrieves multiple items from specified loader
func GetMany[k comparable, t any](ctx context.Context, loader *dataloader.Loader[k, t], ids []k) ([]t, error) {
	thunk := loader.LoadMany(ctx, ids)
	result, errs := thunk()
	if len(errs) > 0 {
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
