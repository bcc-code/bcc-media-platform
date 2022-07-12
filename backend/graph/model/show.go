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

// ShowFromSQL coverts a SQL row into an GQL episode type
func ShowFromSQL(ctx context.Context, row *sqlc.ShowExpanded) *Show {
	titleMap := common.LocaleString{}
	descriptionMap := common.LocaleString{}

	_ = json.Unmarshal(row.Title, &titleMap)
	_ = json.Unmarshal(row.Description, &descriptionMap)

	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &Show{
		ID:          strconv.Itoa(int(row.ID)),
		Title:       titleMap.Get(languages),
		Description: descriptionMap.Get(languages),
	}
}
