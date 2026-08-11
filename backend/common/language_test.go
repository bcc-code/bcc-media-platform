package common

import (
	"slices"
	"testing"
)

func TestPreferredLanguagesCombinesBothLists(t *testing.T) {
	lp := LanguagePreferences{
		PreferredAudioLanguages:     []string{"no", "en"},
		PreferredSubtitlesLanguages: []string{"en", "de"},
	}

	got := lp.PreferredLanguages()
	want := []string{"no", "en", "de"}

	if !slices.Equal(got, want) {
		t.Errorf("PreferredLanguages() = %v, want %v", got, want)
	}
}

// PreferredLanguages used to append the subtitle languages onto the audio slice.
// When that slice has spare capacity — which it does whenever it was itself built
// with append, as the cached application-group defaults are — the append writes
// into the shared backing array and corrupts whatever else is reading it.
func TestPreferredLanguagesDoesNotWriteThroughToItsInputs(t *testing.T) {
	backing := make([]string, 2, 4)
	backing[0] = "no"
	backing[1] = "en"

	// Another view of the same array, standing in for the cached default that
	// this slice was sliced out of.
	shared := backing[:cap(backing)]
	shared[2] = "untouched-2"
	shared[3] = "untouched-3"

	lp := LanguagePreferences{
		PreferredAudioLanguages:     backing,
		PreferredSubtitlesLanguages: []string{"de", "nl"},
	}

	if got := lp.PreferredLanguages(); len(got) != 4 {
		t.Fatalf("PreferredLanguages() = %v, want 4 entries", got)
	}

	if shared[2] != "untouched-2" || shared[3] != "untouched-3" {
		t.Errorf("PreferredLanguages() wrote through to the shared backing array: %v", shared)
	}
}
