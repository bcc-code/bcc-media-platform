package phrase

import (
	"encoding/json"
	"fmt"
	"time"
)

// Datetime is a custom JSON date parser that supports "Z" and "+0000" suffix
// as Phrase can't decide what to use.
type Datetime time.Time

const phraseTimeFormat = "2006-01-02T15:04:05-0700"

func (r Datetime) MarshalJSON() ([]byte, error) {
	t := (time.Time)(r)
	formatted := t.Format(phraseTimeFormat)
	return json.Marshal(formatted)
}

func (d *Datetime) UnmarshalJSON(b []byte) error {
	var s string

	err := json.Unmarshal(b, &s)
	if err != nil {
		return fmt.Errorf("failed to unmarshal to a string: %w", err)
	}

	if s == "" {
		return nil
	}

	layouts := []string{
		"2006-01-02T15:04:05Z",     // For "Z" suffix
		"2006-01-02T15:04:05-0700", // For "+0000" format
	}

	var t time.Time

	for _, layout := range layouts {
		t, err = time.Parse(layout, s)
		if err == nil {
			d = (*Datetime)(&t)
			return nil
		}
	}

	return fmt.Errorf("failed to parse time: %v", err)
}
