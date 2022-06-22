package utils

import "time"

func LargestTime(timeStamps ...time.Time) time.Time {
	var largest time.Time
	for _, stamp := range timeStamps {
		if stamp.After(largest) {
			largest = stamp
		}
	}
	return largest
}

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
