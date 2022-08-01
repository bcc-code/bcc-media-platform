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

// PageFromSQL converts sqlc.PageExpanded to Page
func PageFromSQL(ctx context.Context, item *sqlc.PageExpanded) *Page {
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
	code := item.Code.String

	return &Page{
		ID:          id,
		Code:        code,
		Title:       title.Get(languages),
		Description: description.GetValueOrNil(languages),
	}
}

// PageItemFromSQL returns a PageItem from sql row
func PageItemFromSQL(ctx context.Context, item *sqlc.PageExpanded) *PageItem {
	page := PageFromSQL(ctx, item)

	return &PageItem{
		ID:    page.ID,
		Title: page.Title,
		Page:  page,
	}
}
