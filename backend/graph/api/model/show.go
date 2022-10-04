package model

import (
	"context"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// ShowFrom coverts a common.Show into an GQL episode type
func ShowFrom(ctx context.Context, s *common.Show) *Show {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	var legacyID *string
	if s.LegacyID.Valid {
		strID := strconv.Itoa(int(s.LegacyID.Int64))
		legacyID = &strID
	}

	var image *string
	if s.Image.Valid {
		image = &s.Image.String
	}

	return &Show{
		ID:          strconv.Itoa(s.ID),
		LegacyID:    legacyID,
		Title:       s.Title.Get(languages),
		Description: s.Description.Get(languages),
		ImageURL:    image,
	}
}

// ShowItemFrom returns a ShowItem from a sql row
func ShowItemFrom(ctx context.Context, s *common.Show, sort int) *ShowItem {
	show := ShowFrom(ctx, s)

	return &ShowItem{
		ID:       show.ID,
		Show:     show,
		Title:    show.Title,
		ImageURL: show.ImageURL,
		Sort:     sort,
	}
}
