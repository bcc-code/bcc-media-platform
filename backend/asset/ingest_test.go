package asset

import (
	"encoding/json"
	"os"
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/asset/smil"
	"github.com/stretchr/testify/assert"
)

func TestSafeString(t *testing.T) {
	pairs := map[string]string{
		"":                 "",
		"918237981273":     "918237981273",
		":":                "_",
		"		InTrO S01:E033": "INTRO_S01_E033",
		"INTRO_S01_E033":   "INTRO_S01_E033",
		"INTR😄O_S01_E033":  "INTRO_S01_E033",
		"😄😄😄😄😄":            "",
	}

	for in, out := range pairs {
		res := SafeString(in)
		assert.Equal(t, res, out)
	}
}

func TestCalculateDuration(t *testing.T) {
	testData := map[string]int64{
		"lakjdwlkd":   0,
		"00:00:00:00": 0,
		"00:01:00:23": 60,
		"02:00:00:23": 2 * 60 * 60,
		"02:04:99:23": 2*60*60 + 4*60 + 99,
		"2:4:9:3":     2*60*60 + 4*60 + 9,
	}

	for in, out := range testData {
		a := IngestJSONMeta{
			Duration: in,
		}

		a.CalculateDuration()
		assert.Equal(t, out, a.DurationInS, in)
	}
}

func TestGetLanguagesFromVideoElement(t *testing.T) {
	bytes, err := os.ReadFile("./smil/testdata/smil2.xml")
	assert.NoError(t, err)

	smilObj, err := smil.Unmarshall(bytes)
	assert.NoError(t, err)

	langs := GetLanguagesFromVideoElement(smilObj.Body.Switch.Videos[0])
	assert.Equal(t, []string{"it", "de", "fr"}, langs)

	langs = GetLanguagesFromVideoElement(smilObj.Body.Switch.Videos[1])

	assert.Equal(t, []string{"no", "fi", "sv"}, langs)

	langs = GetLanguagesFromVideoElement(smilObj.Body.Switch.Videos[2])
	assert.Equal(t, 0, len(langs))

	langs = GetLanguagesFromVideoElement(smilObj.Body.Switch.Videos[3])
	assert.Equal(t, 0, len(langs))
}

func TestParseJson(t *testing.T) {
	bytes, err := os.ReadFile("./testdata/001.json")
	assert.NoError(t, err)
	obj := IngestJSONMeta{}
	err = json.Unmarshal(bytes, &obj)
	assert.NoError(t, err)
}

func TestParseJson2(t *testing.T) {
	bytes, err := os.ReadFile("./testdata/002.json")
	assert.NoError(t, err)
	obj := IngestJSONMeta{}
	err = json.Unmarshal(bytes, &obj)
	assert.NoError(t, err)

	for _, file := range obj.Files {
		assert.Equal(t, "1920x1080", file.Resolution)
		assert.NotEmpty(t, file.AudioLanguage)
	}
}
