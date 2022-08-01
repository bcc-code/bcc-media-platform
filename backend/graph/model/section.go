package gqlmodel

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"strconv"
)

// SectionFromSQL converts sqlc.SectionExpanded to Section
func SectionFromSQL(ctx context.Context, item *sqlc.SectionExpanded) Section {
	title := common.LocaleString{}
	description := common.LocaleString{}

	if item.Title.Valid {
		_ = json.Unmarshal(item.Title.RawMessage, &title)
	}
	if item.Description.Valid {
		_ = json.Unmarshal(item.Description.RawMessage, &description)
	}

	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	id := strconv.Itoa(int(item.ID))

	return &ItemSection{
		ID:    id,
		Title: title.Get(languages),
		Type:  ItemSectionType(item.Style.ValueOrZero()),
		Page: &Page{
			ID: strconv.Itoa(int(item.PageID.ValueOrZero())),
		},
	}
}
