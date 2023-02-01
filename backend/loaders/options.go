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
	var tracerName string

	for _, opt := range opts {
		switch t := opt.(type) {
		case MemoryCache:
			cache = NewMemoryLoaderCache[K, V](ctx, t.expiration)
		case traceName:
			tracerName = string(t)
		}
	}

	if cache == nil {
		cache = NewMemoryLoaderCache[K, V](ctx, time.Minute*5)
	}

	if tracerName == "" {
		var t V
		tp := reflect.TypeOf(t)
		n := tp.String()
		if n != "" {
			tracerName = n
		}
	}

	options = append(options, dataloader.WithCache[K, V](cache))
	options = append(options, dataloader.WithTracer[K, V](newTracer[K, V](tracerName)))

	return options
}
