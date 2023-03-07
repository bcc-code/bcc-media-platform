package utils

import (
	"github.com/goodsign/monday"
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

var locales = map[string]monday.Locale{
	"en": monday.LocaleEnGB,
	"no": monday.LocaleNbNO,
	"nl": monday.LocaleNlNL,
	"fr": monday.LocaleFrFR,
}
