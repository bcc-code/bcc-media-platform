package utils

import (
	"github.com/goodsign/monday"
	"github.com/samber/lo"
	"strings"
	"time"
)

// LargestTime returns the largest time of the alternatives
func LargestTime(timeStamps ...time.Time) time.Time {
	var largest time.Time
	for _, stamp := range timeStamps {
		if stamp.After(largest) {
			largest = stamp
		}
	}
	return largest
}

// SmallestTime returns the smallest time of the alternatives
func SmallestTime(timeStamps ...time.Time) time.Time {
	var smallest time.Time
	for _, stamp := range timeStamps {
		if !stamp.IsZero() &&
			(smallest.IsZero() || stamp.Before(smallest)) {
			smallest = stamp
		}
	}
	return smallest
}

// FormatInLocale formats timestamp in locale
func FormatInLocale(timeStamp time.Time, languages []string) string {
	locales := monday.ListLocales()

	var locale monday.Locale
	for _, lang := range languages {
		if lang == "no" {
			lang = "nb"
		}
		l, found := lo.Find(locales, func(i monday.Locale) bool {
			return strings.HasPrefix(string(i), lang)
		})
		if found {
			locale = l
			break
		}
	}

	if locale == "" {
		locale = monday.LocaleEnUS
	}

	return monday.Format(timeStamp, "2. January", locale)
}
