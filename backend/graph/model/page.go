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
func PageFromSQL(ctx context.Context, item *sqlc.PageExpanded) Page {
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

	if item.Type.Valid {
		switch item.Type.String {
		case "default":
			return &DefaultPage{
				ID:          id,
				Code:        code,
				Title:       title.GetValueOrNil(languages),
				Description: title.GetValueOrNil(languages),
				Collection:  item.Collection.ValueOrZero(),
			}
		case "custom":
			return &CustomPage{
				ID:          id,
				Code:        code,
				Title:       title.GetValueOrNil(languages),
				Description: title.GetValueOrNil(languages),
			}
		case "show":
			return &ShowPage{
				ID:          id,
				Code:        code,
				Title:       title.GetValueOrNil(languages),
				Description: title.GetValueOrNil(languages),
				Show: &Show{
					ID: strconv.Itoa(int(item.ShowID.ValueOrZero())),
				},
			}
		case "season":
			return &SeasonPage{
				ID:          id,
				Code:        code,
				Title:       title.GetValueOrNil(languages),
				Description: title.GetValueOrNil(languages),
				Season: &Season{
					ID: strconv.Itoa(int(item.SeasonID.ValueOrZero())),
				},
			}
		case "episode":
			return &EpisodePage{
				ID:          strconv.Itoa(int(item.ID)),
				Code:        code,
				Title:       title.GetValueOrNil(languages),
				Description: title.GetValueOrNil(languages),
				Episode: &Episode{
					ID: strconv.Itoa(int(item.EpisodeID.ValueOrZero())),
				},
			}
		}
	}
	return nil
}
