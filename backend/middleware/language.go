package middleware

import (
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/gin-gonic/gin"
)

// LanguagePreferencesMiddleware extracts language preferences from headers and puts them into context
// Note that this uses the ApplicationMiddleware so it needs to be called after
func LanguagePreferencesMiddleware(loaders *common.BatchLoaders) func(*gin.Context) {
	return func(ctx *gin.Context) {
		// In longer term we probably want to store this on the profile in the DB
		preferredOnly := ctx.GetHeader("X-Only-Preferred-Languages-Content") == "true"
		audioLangs := ctx.GetHeader("X-Accept-Audio-Language")
		subsLangs := ctx.GetHeader("X-Accept-Subtitles-Language")

		lp := common.LanguagePreferences{}

		if audioLangs == "" && subsLangs == "" {
			// Assume no language preferences and fall back to defaults
			app, err := common.GetApplicationFromCtx(ctx)
			if err != nil {
				log.L.Error().Err(err).Msg("Failed to get application from context")
				return
			}

			appGroup, _ := loaders.ApplicationGroupLoader.Get(ctx, app.GroupID)
			lp = common.LanguagePreferences{
				ContentOnlyInPreferredLanguage: appGroup.DefaultLanguagePreferences.ContentOnlyInPreferredLanguage,
				PreferredAudioLanguages:        appGroup.DefaultLanguagePreferences.PreferredAudioLanguages,
				PreferredSubtitlesLanguages:    appGroup.DefaultLanguagePreferences.PreferredSubtitlesLanguages,
			}
		} else {
			lp = common.LanguagePreferences{
				PreferredAudioLanguages:        utils.ParseAcceptLanguage(audioLangs),
				PreferredSubtitlesLanguages:    utils.ParseAcceptLanguage(subsLangs),
				ContentOnlyInPreferredLanguage: preferredOnly,
			}
		}

		ctx.Set(common.CtxLanguagePreferences, lp)
	}
}
