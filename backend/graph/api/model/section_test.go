package model

import (
	"context"
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/gin-gonic/gin"
	"github.com/samber/lo"
	"github.com/stretchr/testify/assert"
	"gopkg.in/guregu/null.v4"
)

func TestSectionFrom_BannerSource(t *testing.T) {
	ctx := utils.ContextWithGinContext(context.Background(), &gin.Context{})

	cases := []struct {
		name   string
		source null.String
		want   *BannerSource
	}{
		{name: "live", source: null.StringFrom("live"), want: lo.ToPtr(BannerSourceLive)},
		{name: "unknown source", source: null.StringFrom("other"), want: nil},
		{name: "no source", want: nil},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			s := SectionFrom(ctx, &common.Section{ID: 1, Type: "banner", BannerSource: tc.source})
			b, ok := s.(*BannerSection)
			assert.True(t, ok)
			assert.Equal(t, tc.want, b.Source)
		})
	}
}
