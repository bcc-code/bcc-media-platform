package utils

import (
	"reflect"
	"testing"
)

// TestParseAcceptLanguageSkipsEmptySegments guards against the regression where
// a malformed/empty segment caused the parser to abandon every language that
// followed it (it used to `return` instead of `continue`).
func TestParseAcceptLanguageSkipsEmptySegments(t *testing.T) {
	got := ParseAcceptLanguage("en, , de")
	want := []string{"en", "de"}
	if !reflect.DeepEqual(got, want) {
		t.Errorf("ParseAcceptLanguage(\"en, , de\") = %v, want %v", got, want)
	}
}

// TestParseAcceptLanguageFallsBackToEnglish ensures an empty or fully malformed
// header still yields the english fallback, so callers (e.g. the audio/subtitle
// language-preference middleware) never receive an empty preference list.
func TestParseAcceptLanguageFallsBackToEnglish(t *testing.T) {
	for _, header := range []string{"", "   ", ",", "-"} {
		got := ParseAcceptLanguage(header)
		want := []string{"en"}
		if !reflect.DeepEqual(got, want) {
			t.Errorf("ParseAcceptLanguage(%q) = %v, want %v", header, got, want)
		}
	}
}

func TestParseAcceptLanguage(t *testing.T) {
	t.Log("da, en-gb;q=0.8, en;q=0.7")
	lqs := ParseAcceptLanguage("da, en-gb;q=0.8, en;q=0.7")
	if lqs[0] != "da" {
		t.Error(lqs[0])
	}
	if lqs[1] != "en" {
		t.Error(lqs[1])
	}
	if lqs[2] != "en" {
		t.Error(lqs[2])
	}
	t.Log(lqs)

	t.Log("zh, en-us; q=0.8, en; q=0.6")
	lqs2 := ParseAcceptLanguage("zh, en-us; q=0.8, en; q=0.6")
	t.Log(lqs2)

	t.Log("es-mx, es, en")
	lqs3 := ParseAcceptLanguage("es-mx, es, en")
	t.Log(lqs3)

	t.Log("de; q=1.0, en; q=0.5")
	lqs4 := ParseAcceptLanguage("de; q=1.0, en; q=0.5")
	t.Log(lqs4)
}
