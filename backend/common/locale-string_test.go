package common

import (
	"sync"
	"testing"

	"gopkg.in/guregu/null.v4"
)

// TestLocaleStringGetEmptyFallsThrough verifies that a valid-but-empty
// translation does not shadow a populated fallback language (B2).
func TestLocaleStringGetEmptyFallsThrough(t *testing.T) {
	ls := LocaleString{
		"de": null.StringFrom(""),
		"en": null.StringFrom("Welcome"),
	}

	if got := ls.Get([]string{"de"}); got != "Welcome" {
		t.Errorf("Get([de]) = %q, want %q", got, "Welcome")
	}

	if got := ls.GetValueOrNil([]string{"de"}); got == nil || *got != "Welcome" {
		t.Errorf("GetValueOrNil([de]) = %v, want pointer to %q", got, "Welcome")
	}
}

// TestLocaleStringGetAllEmpty verifies the final fallback is still "" when no
// language has a non-empty value.
func TestLocaleStringGetAllEmpty(t *testing.T) {
	ls := LocaleString{"de": null.StringFrom(""), "en": null.StringFrom("")}
	if got := ls.Get([]string{"de"}); got != "" {
		t.Errorf("Get([de]) = %q, want empty string", got)
	}
}

// TestLocaleStringGetDoesNotMutateInput guards against Get/GetValueOrNil
// appending DefaultLanguages onto the caller's slice (B1). The request-scoped
// languages slice is shared across concurrent resolvers, so it must never be
// mutated.
func TestLocaleStringGetDoesNotMutateInput(t *testing.T) {
	ls := LocaleString{"no": null.StringFrom("Hei")}

	// A slice with spare capacity is the dangerous case for append-aliasing.
	languages := make([]string, 1, 8)
	languages[0] = "de"

	_ = ls.Get(languages)
	_ = ls.GetValueOrNil(languages)

	if len(languages) != 1 || languages[0] != "de" {
		t.Fatalf("input slice was mutated: %v (len %d)", languages, len(languages))
	}
}

// TestLocaleStringGetConcurrent runs Get concurrently against the same shared
// languages slice; combined with `go test -race` this catches the data race
// from mutating the shared backing array (B1).
func TestLocaleStringGetConcurrent(t *testing.T) {
	ls := LocaleString{"en": null.StringFrom("Welcome"), "no": null.StringFrom("Hei")}
	languages := make([]string, 1, 8)
	languages[0] = "de"

	var wg sync.WaitGroup
	for range 50 {
		wg.Go(func() {
			if got := ls.Get(languages); got != "Welcome" {
				t.Errorf("Get = %q, want %q", got, "Welcome")
			}
		})
	}
	wg.Wait()
}
