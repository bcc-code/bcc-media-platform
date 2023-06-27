package utils

import (
	"testing"
	"time"
)

func TestLargestTime(t *testing.T) {
	now := time.Now()
	t1 := now.Add(time.Second * 100)
	t2 := now.Add(time.Second * -100)
	t3 := time.Time{}

	largest := LargestTime(t1, t2, t3)
	if largest != t1 {
		t.Fatalf("Largest time wrong. Got %T, expected %T", largest, t1)
	}

	smallest := SmallestTime(t1, t2, t3)
	if smallest != t2 {
		t.Fatalf("Smallest time wrong. Got %T, expected %T", smallest, t2)
	}
}

func TestFormatInLocale(t *testing.T) {
	date, _ := time.Parse("2006-01-02", "2000-06-27")
	dateStr := FormatInLocale(date, []string{"no"})

	if dateStr != "27. juni" {
		t.Fatalf("Invalid format on date: %s", date)
	}
}
