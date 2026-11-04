package model

import (
	"context"
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func TestSectionFrom_Live(t *testing.T) {
	ctx := utils.ContextWithGinContext(context.Background(), &gin.Context{})
	s := SectionFrom(ctx, &common.Section{ID: 1, Type: "live"})
	l, ok := s.(*LiveSection)
	assert.True(t, ok)
	assert.Equal(t, "1", l.ID)
}
