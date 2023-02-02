package loaders

import (
	"context"
	"github.com/graph-gophers/dataloader/v7"
	"reflect"
	"time"
)

func getOptions[K comparable, V any](ctx context.Context, opts ...Option) []dataloader.Option[K, V] {
	var options []dataloader.Option[K, V]

	var cache *LoaderCache[K, V]
	var name string

	for _, opt := range opts {
		switch t := opt.(type) {
		case loaderName:
			name = string(t)
		}
	}

	if name == "" {
		var t V
		tp := reflect.TypeOf(t)
		n := tp.String()
		if n != "" {
			name = n
		}
	}

	for _, opt := range opts {
		switch t := opt.(type) {
		case MemoryCache:
			cache = NewMemoryLoaderCache[K, V](ctx, name, t.expiration)
		}
	}

	if name == "" {
		var t V
		tp := reflect.TypeOf(t)
		n := tp.String()
		if n != "" {
			name = n
		}
	}

	if cache == nil {
		cache = NewMemoryLoaderCache[K, V](ctx, name, time.Minute*5)
	}

	options = append(options, dataloader.WithCache[K, V](cache))
	options = append(options, dataloader.WithTracer[K, V](newTracer[K, V](name)))

	return options
}
