package model

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"strconv"
)

// SectionFrom converts common.Page to Section
func SectionFrom(ctx context.Context, s *common.Section) Section {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	id := strconv.Itoa(s.ID)

	var title *string
	if s.ShowTitle {
		title = s.Title.GetValueOrNil(languages)
	}

	switch s.Type {
	case "item":
		switch s.Style {
		case "featured":
			return &FeaturedSection{
				ID:    id,
				Title: title,
				Size:  SectionSize(s.Size),
			}
		case "default":
			return &DefaultSection{
				ID:    id,
				Title: title,
				Size:  SectionSize(s.Size),
			}
		case "posters":
			return &PosterSection{
				ID:    id,
				Title: title,
				Size:  SectionSize(s.Size),
			}
		case "grid":
			return &GridSection{
				ID:    id,
				Title: title,
				Size:  GridSectionSize(s.Size),
			}
		}
	case "link":
		switch s.Style {
		case "icons":
			return &IconSection{
				ID:    id,
				Title: title,
			}
		case "labels":
			return &LabelSection{
				ID:    id,
				Title: title,
			}
		}
	}

	return &DefaultSection{
		ID:    id,
		Title: title,
		Size:  SectionSizeMedium,
	}
}
