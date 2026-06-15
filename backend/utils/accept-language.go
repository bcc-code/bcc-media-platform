package utils

import (
	"strings"
)

// Adapted from http://siongui.github.io/2015/02/22/go-parse-accept-language/

func parseLanguageCode(code string) string {
	switch code {
	case "nb", "nn":
		return "no"
	default:
		return code
	}
}

// ParseAcceptLanguage HTTP header
func ParseAcceptLanguage(acceptLanguage string) []string {
	var lqs []string

	langQStrings := strings.Split(acceptLanguage, ",")
	for _, langQStr := range langQStrings {
		trimmedLangQStr := strings.Trim(langQStr, " ")
		langQ := strings.Split(trimmedLangQStr, ";")

		lq := langQ[0]
		lq2 := strings.FieldsFunc(lq, func(char rune) bool {
			return char == '-' || char == '_'
		})
		if len(lq2) == 0 {
			// Empty/malformed segment (e.g. a stray comma) - skip it instead
			// of abandoning the languages that follow.
			continue
		}
		lqs = append(lqs, parseLanguageCode(lq2[0]))
	}

	if len(lqs) == 0 {
		// No valid language was parsed (empty or fully malformed header);
		// fall back to english so callers always get a non-empty list.
		lqs = append(lqs, "en")
	}

	return lqs
}
