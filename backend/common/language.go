package common

import (
	"fmt"
	"slices"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/samber/lo"
)

const (
	// CtxLanguagePreferences is the context key for language preferences
	CtxLanguagePreferences = "ctx-language-preferences"
)

// LanguagePreferences encapsulates the user's language preferences
type LanguagePreferences struct {
	ContentOnlyInPreferredLanguage bool
	PreferredAudioLanguages        []string
	PreferredSubtitlesLanguages    []string
	preferredLanguages             []string
}

// PreferredLanguages returns a comma-separated list of preferred languages
// as combined view of PreferredAudioLanguage and PreferredSubtitlesLanguage
func (lp *LanguagePreferences) PreferredLanguages() []string {
	if len(lp.preferredLanguages) == 0 {
		// slices.Concat, not append: appending onto PreferredAudioLanguages writes
		// into its backing array whenever it has spare capacity. That slice can come
		// straight from the cached application group defaults, so the append would
		// corrupt what every later request in this pod reads.
		lp.preferredLanguages = lo.Uniq(slices.Concat(lp.PreferredAudioLanguages, lp.PreferredSubtitlesLanguages))
	}

	return lp.preferredLanguages
}

func (lp *LanguagePreferences) String() string {
	return fmt.Sprintf("contentonly_%v_audio_%s_subs_%s",
		lp.ContentOnlyInPreferredLanguage,
		strings.Join(lp.PreferredAudioLanguages, ","),
		strings.Join(lp.PreferredSubtitlesLanguages, ","),
	)
}

// GetLanguagePreferencesFromCtx returns the language preferences from the context
// This is normally set by the middleware from the headers,
// but if the headers do not exist we fall back to the application group, and hardcoded defaults
// from there
func GetLanguagePreferencesFromCtx(ctx *gin.Context) LanguagePreferences {
	if langPrefs := ctx.Value(CtxLanguagePreferences); langPrefs != nil {
		return langPrefs.(LanguagePreferences)
	}

	return LanguagePreferences{
		ContentOnlyInPreferredLanguage: false,
		PreferredAudioLanguages:        []string{"no"},
		PreferredSubtitlesLanguages:    []string{"no"},
	}

}
