package externalevents_test

import (
	"encoding/json"
	"io"
	"os"
	"testing"
	"time"

	externalevents "github.com/bcc-code/bcc-media-platform/backend/external-events"
	"github.com/stretchr/testify/assert"
)

func TestEventParsing(t *testing.T) {
	files, _ := os.ReadDir("./testdata")
	for _, fileName := range files {
		jsonFile, err := os.Open("./testdata/" + fileName.Name())
		assert.NoError(t, err)
		byteValue, _ := io.ReadAll(jsonFile)

		_, err = externalevents.ParseEvent(byteValue)
		assert.NoError(t, err)

		_ = jsonFile.Close()
	}
}

func TestBibleParsing(t *testing.T) {
	type Test struct {
		file     string
		expected *externalevents.Event
	}

	t1, _ := time.Parse(time.RFC3339, "2009-11-11T08:00:00+09:00")

	tests := []Test{
		{
			file: "bible.json",
			expected: &externalevents.Event{
				Timestamp: t1,
				Source:    "some-system",
				Data:      json.RawMessage{},
				Type:      externalevents.TypeBibleVerse,
				BibleData: &externalevents.BibleEvent{
					Edition: "NKJV",
					Verse:   "Psa 1/2-3",
					Text:    "I begynnelsen skapte Gud himmelen og jorden. Og jorden var øde og tom, og det var mørke over det store dyp, og Guds Ånd svevde over vannene. Da sa Gud: Det bli lys! Og det blev lys.",
					ReadBy:  "Max Mustermann",
				},
			},
		},
	}

	for _, test := range tests {
		jsonFile, err := os.Open("./testdata/" + test.file)
		assert.NoError(t, err)
		byteValue, _ := io.ReadAll(jsonFile)

		e, err := externalevents.ParseEvent(byteValue)
		e.Data = json.RawMessage{} // We don't care about the raw message and it makes tests annoying

		assert.NoError(t, err)
		assert.Equal(t, test.expected, e)
	}
}

func TestSongParsing(t *testing.T) {
	type Test struct {
		file     string
		expected *externalevents.Event
	}

	t1, _ := time.Parse(time.RFC3339, "2009-11-11T08:00:00+09:00")

	tests := []Test{
		{
			file: "song.json",
			expected: &externalevents.Event{
				Timestamp: t1,
				Source:    "some-system",
				Data:      json.RawMessage{},
				Type:      externalevents.TypeSong,
				SongData: &externalevents.SongEvent{
					ID:    "HV123",
					Title: "The title of the song",
					People: map[string][]string{
						"textAuthors":   {"Text Textington"},
						"melodyAuthors": {"Old Kligon folk melody"},
						"solists":       {"Vocal: Sven Singer", "Piano: Kacey Keys"},
						"arrangedBy":    {"Arry Arranger"},
					},
				},
			},
		},
	}

	for _, test := range tests {
		jsonFile, err := os.Open("./testdata/" + test.file)
		assert.NoError(t, err)
		byteValue, _ := io.ReadAll(jsonFile)

		e, err := externalevents.ParseEvent(byteValue)
		e.Data = json.RawMessage{} // We don't care about the raw message and it makes tests annoying

		assert.NoError(t, err)
		assert.Equal(t, test.expected, e)
	}
}
