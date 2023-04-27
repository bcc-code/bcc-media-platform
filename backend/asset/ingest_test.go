package asset

import (
	"encoding/json"
	"os"
	"testing"

	"github.com/bcc-code/brunstadtv/backend/asset/smil"
	"github.com/bcc-code/brunstadtv/backend/directus"
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
		a := assetIngestJSONMeta{
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
	assert.Equal(t, []directus.AssetStreamLanguage{
		{
			AssetStreamID: "+",
			LanguagesCode: directus.LanguagesCode{
				Code: "it",
			},
		},
		{
			AssetStreamID: "+",
			LanguagesCode: directus.LanguagesCode{
				Code: "de",
			},
		},
		{
			AssetStreamID: "+",
			LanguagesCode: directus.LanguagesCode{
				Code: "fr",
			},
		},
	}, langs)

	langs = GetLanguagesFromVideoElement(smilObj.Body.Switch.Videos[1])
	assert.Equal(t, []directus.AssetStreamLanguage{
		{
			AssetStreamID: "+",
			LanguagesCode: directus.LanguagesCode{
				Code: "no",
			},
		},
		{
			AssetStreamID: "+",
			LanguagesCode: directus.LanguagesCode{
				Code: "fi",
			},
		},
		{
			AssetStreamID: "+",
			LanguagesCode: directus.LanguagesCode{
				Code: "sv",
			},
		},
	}, langs)

	langs = GetLanguagesFromVideoElement(smilObj.Body.Switch.Videos[2])
	assert.Equal(t, []directus.AssetStreamLanguage{}, langs)

	langs = GetLanguagesFromVideoElement(smilObj.Body.Switch.Videos[3])
	assert.Equal(t, []directus.AssetStreamLanguage{}, langs)
}

func TestParseJson(t *testing.T) {
	bytes, err := os.ReadFile("./testdata/001.json")
	assert.NoError(t, err)
	obj := assetIngestJSONMeta{}
	err = json.Unmarshal(bytes, &obj)
	assert.NoError(t, err)
}
