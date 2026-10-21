package graph

import (
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	apimodel "github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/stretchr/testify/assert"
)

func TestStatusFrom(t *testing.T) {
	for in, want := range map[common.Status]apimodel.Status{
		common.StatusDraft:     apimodel.StatusDraft,
		common.StatusPublished: apimodel.StatusPublished,
		common.StatusUnlisted:  apimodel.StatusUnlisted,
		common.StatusArchived:  apimodel.StatusArchived,
		"bogus":                apimodel.StatusArchived,
	} {
		assert.Equal(t, want, statusFrom(in), in)
	}
}

func TestWebAppURL(t *testing.T) {
	assert.Equal(t, "https://app.bcc.media/show/12", webAppURL("https://app.bcc.media", "/show/12"))
	assert.Equal(t, "https://app.bcc.media/show/12", webAppURL("https://app.bcc.media/", "/show/12"))
}
