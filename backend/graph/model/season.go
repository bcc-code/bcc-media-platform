package gqlmodel

import (
	"context"
	"encoding/json"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// SeasonFromSQL coverts a SQL row into an GQL episode type
func SeasonFromSQL(ctx context.Context, row *sqlc.SeasonExpanded) *Season {
	titleMap := common.LocaleString{}
	descriptionMap := common.LocaleString{}

	_ = json.Unmarshal(row.Title, &titleMap)
	_ = json.Unmarshal(row.Description, &descriptionMap)

	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)
	show := Show{
		ID: strconv.Itoa(int(row.ShowID)),
	}

	return &Season{
		ID:          strconv.Itoa(int(row.ID)),
		Title:       titleMap.Get(languages),
		Description: descriptionMap.Get(languages),
		Number:      int(row.SeasonNumber),
		Show:        &show,
	}
}
