package common

import (
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/davecgh/go-spew/spew"
)

// DefaultLanguages is the order of languages if none is defined by the user
var DefaultLanguages = []string{"en", "no"}

// LocaleMap is a map of strings to nullable strings
type LocaleMap[T any] map[string]T

// Get from a translation map based on the fallbacks
func (localeMap LocaleMap[T]) Get(languages []string) T {
	languages = append(languages, DefaultLanguages...) // We force the DefaultLanguages as the last languages regardless if they have been specified before already
	for _, l := range languages {
		if val, ok := localeMap[l]; ok {
			return val
		}
	}

	log.L.Warn().
		Strs("languages", languages).
		Str("localeString", spew.Sdump(localeMap)).
		Msg("Failed to find any localeString for specified languages")

	var r T
	return r
}

// GetValueOrNil returns either the value for selected languages or nil
func (localeMap LocaleMap[T]) GetValueOrNil(languages []string) *T {
	languages = append(languages, DefaultLanguages...) // We force the DefaultLanguages as the last languages regardless if they have been specified before already
	for _, l := range languages {
		if val, ok := localeMap[l]; ok && val != nil {
			return &val
		}
	}

	return nil
}
