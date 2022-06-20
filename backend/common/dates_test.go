package common

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
