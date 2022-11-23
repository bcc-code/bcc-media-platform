package model

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/common"
)

// CollectionFrom converts common.Collection to Collection
func CollectionFrom(ctx context.Context, s *common.Collection) *Collection {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &Collection{
		ID:   strconv.Itoa(s.ID),
		Slug: s.Slugs.GetValueOrNil(languages),
	}
}
