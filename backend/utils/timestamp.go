package utils

import "time"

// TimestampFromString returns a validated time from a string
func TimestampFromString(timestamp *string) (*time.Time, error) {
	var r *time.Time
	if timestamp != nil {
		t, err := time.Parse(time.RFC3339, *timestamp)
		if err != nil {
			return nil, err
		}
		r = &t
	}
	return r, nil
}
