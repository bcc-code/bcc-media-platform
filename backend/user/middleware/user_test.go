package middleware

import (
	"fmt"
	"testing"
	"time"
)

func TestAgeFromBirthDate(t *testing.T) {
	now := time.Now()

	// Dates are derived from "now" so the expectations hold whenever the suite runs.
	born := func(yearsAgo int, monthOffset int) string {
		d := now.AddDate(-yearsAgo, monthOffset, 0)
		return d.Format(time.DateOnly)
	}

	tests := []struct {
		name      string
		birthDate string
		want      int
	}{
		{
			name: "birthday already passed this year",
			// Two months ago, 30 years back.
			birthDate: born(30, -2),
			want:      30,
		},
		{
			name: "birthday has not happened yet this year",
			// Two months ahead, 30 years back: still 29 until it comes around.
			birthDate: born(30, 2),
			want:      29,
		},
		{
			name:      "birthday is today",
			birthDate: born(18, 0),
			want:      18,
		},
		{
			name:      "unparseable input yields zero",
			birthDate: "not-a-date",
			want:      0,
		},
		{
			name:      "empty input yields zero",
			birthDate: "",
			want:      0,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := ageFromBirthDate(tt.birthDate); got != tt.want {
				t.Errorf("ageFromBirthDate(%q) = %d, want %d", tt.birthDate, got, tt.want)
			}
		})
	}
}

// The layout used to be "2006-04-02", where 04 is Go's minute placeholder rather
// than the month. That parsed without error but pinned every birth month to
// January, so ages were wrong for most of the year.
func TestAgeFromBirthDateParsesMonthNotMinute(t *testing.T) {
	for month := 1; month <= 12; month++ {
		t.Run(fmt.Sprintf("month-%02d", month), func(t *testing.T) {
			birth := time.Date(1990, time.Month(month), 15, 0, 0, 0, 0, time.UTC)

			now := time.Now()
			want := now.Year() - birth.Year()
			if now.Month() < birth.Month() || (now.Month() == birth.Month() && now.Day() < birth.Day()) {
				want--
			}

			if got := ageFromBirthDate(birth.Format(time.DateOnly)); got != want {
				t.Errorf("ageFromBirthDate(%q) = %d, want %d", birth.Format(time.DateOnly), got, want)
			}
		})
	}
}
