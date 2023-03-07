package loaders

import (
	"context"
	"fmt"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/trace"
)

type tracer[K comparable, V any] struct {
	t trace.Tracer
}

func newTracer[K comparable, V any](name string) *tracer[K, V] {
	return &tracer[K, V]{
		t: otel.Tracer(name),
	}
}

// TraceLoad traces a load operation
func (t tracer[K, V]) TraceLoad(ctx context.Context, key K) (context.Context, dataloader.TraceLoadFinishFunc[V]) {
	ctx, span := t.t.Start(ctx, "trace-load")
	span.SetAttributes(attribute.String("key", fmt.Sprint(key)))
	return ctx, func(r dataloader.Thunk[V]) {
		span.End()
	}
}

// TraceLoadMany traces a call to loading multiple entries
func (t tracer[K, V]) TraceLoadMany(ctx context.Context, keys []K) (context.Context, dataloader.TraceLoadManyFinishFunc[V]) {
	ctx, span := t.t.Start(ctx, "trace-load-many")
	span.SetAttributes(attribute.StringSlice("keys", lo.Map(keys, func(i K, _ int) string {
		return fmt.Sprint(i)
	})))
	return ctx, func(r dataloader.ThunkMany[V]) {
		span.End()
	}
}

// TraceBatch traces a batch of retrievals
func (t tracer[K, V]) TraceBatch(ctx context.Context, keys []K) (context.Context, dataloader.TraceBatchFinishFunc[V]) {
	ctx, span := t.t.Start(ctx, "trace-batch")
	span.SetAttributes(attribute.StringSlice("keys", lo.Map(keys, func(i K, _ int) string {
		return fmt.Sprint(i)
	})))
	return ctx, func(r []*dataloader.Result[V]) {
		span.End()
	}
}
