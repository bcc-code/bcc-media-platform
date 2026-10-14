package graph

import (
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/admin/model"
	"github.com/stretchr/testify/assert"
)

func TestStatusFrom(t *testing.T) {
	for in, want := range map[common.Status]model.Status{
		common.StatusDraft:     model.StatusDraft,
		common.StatusPublished: model.StatusPublished,
		common.StatusUnlisted:  model.StatusUnlisted,
		common.StatusArchived:  model.StatusArchived,
		"bogus":                model.StatusArchived,
	} {
		assert.Equal(t, want, statusFrom(in), in)
	}
}
