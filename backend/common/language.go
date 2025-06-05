package common

import (
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
		l := append(lp.PreferredAudioLanguages, lp.PreferredSubtitlesLanguages...)
		lp.preferredLanguages = lo.Uniq(l)
	}

	return lp.preferredLanguages
}

// GetLanguagePreferencesFromCtx returns the language preferences from the context
// This is normally set by the middleware from the headers,
// but if the headers do not exist we fall back to the application group, and hardcoded defaults
// from there
func GetLanguagePreferencesFromCtx(ctx *gin.Context) LanguagePreferences {
	if langPrefs := ctx.Value(CtxLanguagePreferences); langPrefs != nil {
		return langPrefs.(LanguagePreferences)
	}

	// TODO: Change to application group
	return LanguagePreferences{
		ContentOnlyInPreferredLanguage: false,
		PreferredAudioLanguages:        []string{"no"},
		PreferredSubtitlesLanguages:    []string{"no"},
	}

}
