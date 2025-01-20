package phrase_test

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/translations"
	"os"
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
	userName := os.Getenv("PHRASE_USERNAME")
	password := os.Getenv("PHRASE_PASSWORD")
	projectUID := os.Getenv("PHRASE_PROJECT_ID")

	if userName == "" || password == "" || projectUID == "" {
		t.Skip("Skipping test because PHRASE_USERNAME, PHRASE_PASSWORD and PHRASE_PROJECT_ID are not set")
	}

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

func TestWebhook(t *testing.T) {
	jsonData := `{
  "jobParts": [
    {
      "id": 510003672,
      "uid": "ARoIoAOOiNra6dTWpmjRQ1",
      "internalId": "295",
      "task": "rYRRmO69OaNVWzUp_dc7",
      "fileName": "surveys.json",
      "targetLang": "de",
      "workflowLevel": 1,
      "status": "COMPLETED_BY_LINGUIST",
      "wordsCount": 96,
      "beginIndex": 0,
      "endIndex": 17,
      "isParentJobSplit": false,
      "dateCreated": "2025-01-16T12:26:15Z",
      "project": {
        "id": 31397450,
        "uid": "dUYuK9apYTbr0Ww5Av1W0b",
        "lastWorkflowLevel": 1
      },
      "assignedTo": []
    }
  ],
  "metadata": {
    "project": {
      "id": 31397450,
      "uid": "dUYuK9apYTbr0Ww5Av1W0b",
      "name": "TestProject1",
      "sourceLang": "en",
      "status": "NEW",
      "createdBy": {
        "id": 1439918,
        "uid": "1Lv9r0Q9evyCvQicVdYlhb",
        "username": "matjaz+phrase4"
      },
      "owner": {
        "id": 1439918,
        "uid": "1Lv9r0Q9evyCvQicVdYlhb",
        "username": "matjaz+phrase4"
      }
    }
  },
  "event": "JOB_STATUS_CHANGED",
  "timestamp": 1737036746,
  "eventUid": "hXnaybvsW4qWep1D2z0R6c"
}`

	ctx := context.Background()
	c := newClient(t)
	collection, data, err := c.ProcessWebhook(ctx, "/not/important/here/for/phrase", []byte(jsonData))
	assert.NoError(t, err)

	assert.Equal(t, &translations.CollectionSurveys, collection)
	assert.Equal(t, 3, len(data))
}
