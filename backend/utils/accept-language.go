package utils

import (
	"strings"
)

// Adapted from http://siongui.github.io/2015/02/22/go-parse-accept-language/

// ParseAcceptLanguage HTTP header
func ParseAcceptLanguage(acceptLanguage string) []string {
	var lqs []string

	langQStrings := strings.Split(acceptLanguage, ",")
	for _, langQStr := range langQStrings {
		trimmedLangQStr := strings.Trim(langQStr, " ")
		langQ := strings.Split(trimmedLangQStr, ";")
		lq := langQ[0]
		lq2 := strings.Split(lq, "-")
		lqs = append(lqs, lq2[0])
	}

	return lqs
}
