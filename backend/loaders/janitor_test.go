// Copied from: https://github.com/Code-Hex/go-generics-cache/blob/main/janitor_test.go
// Author: Code-Hex

package loaders

import (
	"context"
	"testing"
	"time"
)

func TestJanitor(t *testing.T) {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	janitor := newJanitor(ctx, time.Millisecond)

	checkDone := make(chan struct{})
	janitor.done = checkDone

	calledClean := 0
	janitor.run(func() { calledClean++ })

	// waiting for cleanup
	time.Sleep(10 * time.Millisecond)
	cancel()

	select {
	case <-checkDone:
	case <-time.After(time.Second):
		t.Fatalf("failed to call done channel")
	}

	if calledClean <= 1 {
		t.Fatalf("failed to call clean callback in janitor: %d", calledClean)
	}
}
