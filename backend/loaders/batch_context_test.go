package loaders

import (
	"context"
	"testing"
	"time"
)

type batchCtxItem struct {
	ID int
}

// TestBatchSurvivesCallerCancellation asserts that a batch keeps running when
// the request that opened the batch window goes away. dataloader hands the
// batch the context of that first caller, but the batch usually serves keys
// from several concurrent requests - if it inherited the cancellation, one
// client disconnecting would cancel the query (and the Postgres statement) that
// the others are still waiting for.
func TestBatchSurvivesCallerCancellation(t *testing.T) {
	started := make(chan struct{})
	batchErr := make(chan error, 1)

	factory := func(ctx context.Context, ids []int) ([]batchCtxItem, error) {
		close(started)
		// Give the caller time to cancel while we are "querying".
		time.Sleep(50 * time.Millisecond)
		batchErr <- ctx.Err()

		items := make([]batchCtxItem, 0, len(ids))
		for _, id := range ids {
			items = append(items, batchCtxItem{ID: id})
		}
		return items, nil
	}

	loader := New(context.Background(), factory, WithKeyFunc(func(i batchCtxItem) int {
		return i.ID
	}))

	callerCtx, cancel := context.WithCancel(context.Background())
	thunk := loader.Load(callerCtx, 1)

	select {
	case <-started:
	case <-time.After(time.Second):
		t.Fatal("batch never started")
	}
	cancel()

	res, err := thunk()
	if err != nil {
		t.Fatalf("batch failed after caller cancellation: %v", err)
	}
	if res == nil || res.ID != 1 {
		t.Fatalf("unexpected result: %+v", res)
	}

	if err := <-batchErr; err != nil {
		t.Fatalf("batch context was cancelled with the caller: %v", err)
	}
}

// TestBatchContextKeepsValues verifies that detaching the batch does not drop
// request-scoped values (trace spans and the like) from the context.
func TestBatchContextKeepsValues(t *testing.T) {
	type ctxKey struct{}

	ctx, cancel := batchContext(context.WithValue(context.Background(), ctxKey{}, "value"))
	defer cancel()

	if v, _ := ctx.Value(ctxKey{}).(string); v != "value" {
		t.Fatalf("value lost from batch context: %q", v)
	}
	if _, ok := ctx.Deadline(); !ok {
		t.Fatal("batch context has no deadline")
	}
}
