package common

import (
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/davecgh/go-spew/spew"
	null_v4 "gopkg.in/guregu/null.v4"
)

// DefaultLangs is the order of lanuages if none is defined by the user
var DefaultLangs = []string{"en", "no"}

// Translations is a map of strings to nullable strings
type Translations map[string]null_v4.String

// GetTranslation from a translation map based on the fallbacks
func GetTranslation(langs []string, trans Translations) string {
	langs = append(langs, DefaultLangs...) // We force the DefaultLangs as the last languages regardless if they have been specified before already
	for _, l := range langs {
		if val, ok := trans[l]; ok {
			if val.Valid {
				return val.String
			}
		}
	}

	log.L.Warn().
		Strs("lanuages", langs).
		Str("translations", spew.Sdump(trans)).
		Msg("Failed to find any translations for specified languages")

	return ""
}
