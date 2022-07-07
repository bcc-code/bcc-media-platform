package utils

import (
	"strings"
)

// Adapted from http://siongui.github.io/2015/02/22/go-parse-accept-language/

// ParseAcceptLanguage HTTP header
func ParseAcceptLanguage(acptLang string) []string {
	var lqs []string

	langQStrs := strings.Split(acptLang, ",")
	for _, langQStr := range langQStrs {
		trimedLangQStr := strings.Trim(langQStr, " ")
		langQ := strings.Split(trimedLangQStr, ";")
		lq := langQ[0]
		lq2 := strings.Split(lq, "-")
		lqs = append(lqs, lq2[0])
	}

	return lqs
}
