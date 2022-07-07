package common

import (
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/davecgh/go-spew/spew"
	null_v4 "gopkg.in/guregu/null.v4"
)

// DefaultLanguages is the order of languages if none is defined by the user
var DefaultLanguages = []string{"en", "no"}

// LocaleString is a map of strings to nullable strings
type LocaleString map[string]null_v4.String

// Get from a translation map based on the fallbacks
func (localeString LocaleString) Get(languages []string) string {
	languages = append(languages, DefaultLanguages...) // We force the DefaultLanguages as the last languages regardless if they have been specified before already
	for _, l := range languages {
		if val, ok := localeString[l]; ok && val.Valid {
			return val.String
		}
	}

	log.L.Warn().
		Strs("languages", languages).
		Str("localeString", spew.Sdump(localeString)).
		Msg("Failed to find any localeString for specified languages")

	return ""
}
