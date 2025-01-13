package phrase_test

import (
	"context"
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/translations/phrase"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/assert"
)

func init() {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)
}

func newClient(t *testing.T) *phrase.Client {
	t.Helper()

	url := "" // Default
	userName := "<REPLACE>"
	password := "<REPLACE>"
	projectUID := "<REPLACE>"

	c := phrase.NewClient(url, userName, password, projectUID)
	err := c.Authenticate()
	assert.NoError(t, err)
	return c
}

func Test_ListJobs(t *testing.T) {
	c := newClient(t)

	res, err := c.GetJobs("data.json")
	assert.NoError(t, err)
	assert.NotNil(t, res)

	// spew.Dump(res)
}

func Test_SubmitData(t *testing.T) {
	c := newClient(t)

	data := []common.TranslationData{
		common.TranslationData{
			ID:       "show.123",
			Language: "en",
			Value:    []byte(`{"title": "This is a title", "description": "Yay, it's a description"}`),
		},
		common.TranslationData{
			ID:       "show.456",
			Language: "en",
			Value:    []byte(`{"title": "Dobbelglede", "decription": "Stuff and things", "@context": "<a href=\"https://app.bcc.media/shows/123\">https://app.bcc.media/shows/123</a>"}`),
		},
	}
	err := c.SendToTranslation(context.Background(), "shows2", data)
	assert.NoError(t, err)
}
