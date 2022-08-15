package externalevents

import (
	"encoding/json"
	"time"

	"github.com/ansel1/merry/v2"
)

// Based on https://github.com/bcc-code/brunstadtv/blob/ad2e2942eaff5530830fb6a3a3ed5ee449a71cfd/backend/cmd/events/Readme.md
/*
{
	"timestamp": "2009-11-11T08:00:00+09:00", // RFC3339 formatted
	"source": "some-system", // Arbitrary string identifying the source of the message, Informative
	"type": "event.happened", // Arbitrary string, identifying the format of the data sent
	"data": {"A": "B", "C": 99 }, // Arbitrary json object containing the actual data
}
*/

// Event is the base event wihth data represented as raw json
type Event struct {
	Timestamp  time.Time
	Source     string
	Type       EventType
	Data       json.RawMessage
	BibleData  *BibleEvent  `json:"-"`
	SongData   *SongEvent   `json:"-"`
	SpeechData *SpeechEvent `json:"-"`
	TextData   *TextEvent   `json:"-"`
}

// EventType is the type of the event.
// Some values have a special meaning, others will just be ingested as-is
type EventType string

// S converts to string
func (t EventType) S() string {
	return string(t)
}

// Special event types
var (
	TypeSong       EventType = "song"
	TypeSpeech     EventType = "speech"
	TypeBibleVerse EventType = "bibleverse"
	TypeText       EventType = "text"
)

// TextFormat identifies a text format
type TextFormat string

// Known text formats
var (
	FormatPlain TextFormat = "plain"
	FormatMD    TextFormat = "markdown"
	FormatHTML  TextFormat = "html"
)

// BibleEvent contains data for the event related to a bible verse
type BibleEvent struct {
	Edition string
	Verse   string
	Text    string
	ReadBy  string
}

// SongEvent contains data for the event related to a song
type SongEvent struct {
	ID     string
	Title  string
	People map[string]([]string)
}

// PersonLite is a super compact person representation
type PersonLite struct {
	FullName string
	PersonID string
	Church   string
}

// SpeechEvent contains data for the event related to the speech
type SpeechEvent struct {
	Speaker    PersonLite
	Translator *PersonLite
}

// TextEvent contains data for the event related to a simple text message
type TextEvent struct {
	Text   string
	Format TextFormat
}

// ParseEvent from the json bytes
func ParseEvent(data []byte) (*Event, error) {
	e := &Event{}
	err := json.Unmarshal(data, e)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	switch e.Type {
	case TypeSong:
		s := &SongEvent{}
		err = json.Unmarshal(e.Data, s)
		e.SongData = s
	case TypeSpeech:
		s := &SpeechEvent{}
		err = json.Unmarshal(e.Data, s)
		e.SpeechData = s
	case TypeBibleVerse:
		s := &BibleEvent{}
		err = json.Unmarshal(e.Data, s)
		e.BibleData = s
	case TypeText:
		s := &TextEvent{}
		err = json.Unmarshal(e.Data, s)
		e.TextData = s
	}

	return e, err
}
