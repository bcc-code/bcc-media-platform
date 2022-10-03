package common

import (
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/davecgh/go-spew/spew"
	"gopkg.in/guregu/null.v4"
)

// LocaleString is a map of strings to nullable strings
type LocaleString LocaleMap[null.String]

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

// GetValueOrNil returns either the value for selected languages or nil
func (localeString LocaleString) GetValueOrNil(languages []string) *string {
	languages = append(languages, DefaultLanguages...) // We force the DefaultLanguages as the last languages regardless if they have been specified before already
	for _, l := range languages {
		if val, ok := localeString[l]; ok && val.Valid {
			return &val.String
		}
	}

	return nil
}
