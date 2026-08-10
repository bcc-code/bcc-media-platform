package memorycache

import (
	"context"
	"errors"
	"testing"
)

func TestGetRoundTripsValue(t *testing.T) {
	Set("round-trip", []string{"a", "b"})
	defer Delete("round-trip")

	got, ok := Get[[]string]("round-trip")
	if !ok {
		t.Fatal("Get() reported a miss for a key that was just set")
	}
	if len(got) != 2 || got[0] != "a" {
		t.Errorf("Get() = %v, want [a b]", got)
	}
}

// The cache holds `any` and is shared across packages, so the same key can be
// read as the wrong type. That used to be an unchecked assertion, which panicked
// the calling goroutine.
func TestGetTypeMismatchIsAMissNotAPanic(t *testing.T) {
	Set("mismatch", "a string")
	defer Delete("mismatch")

	defer func() {
		if r := recover(); r != nil {
			t.Fatalf("Get() panicked on a type mismatch: %v", r)
		}
	}()

	got, ok := Get[int]("mismatch")
	if ok {
		t.Errorf("Get[int]() on a string entry returned ok=true (value %v), want a miss", got)
	}
	if got != 0 {
		t.Errorf("Get[int]() = %v, want the zero value", got)
	}
}

// A miss must let the caller refetch rather than poisoning the entry.
func TestGetOrSetRecoversFromATypeMismatch(t *testing.T) {
	Set("reload", "wrong type")
	defer Delete("reload")

	got, err := GetOrSet(context.Background(), "reload", func(ctx context.Context) (int, error) {
		return 42, nil
	})
	if err != nil {
		t.Fatalf("GetOrSet() error = %v", err)
	}
	if got != 42 {
		t.Errorf("GetOrSet() = %v, want 42 from the factory", got)
	}
}

func TestGetOrSetPropagatesFactoryErrors(t *testing.T) {
	want := errors.New("factory failed")
	_, err := GetOrSet(context.Background(), "failing", func(ctx context.Context) (int, error) {
		return 0, want
	})
	if !errors.Is(err, want) {
		t.Errorf("GetOrSet() error = %v, want %v", err, want)
	}
	if _, ok := Get[int]("failing"); ok {
		t.Error("a failed factory result was cached")
	}
}
