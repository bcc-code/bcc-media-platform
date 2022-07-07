package gqlmodel

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// EpisodeFromSQL coverts a SQL row into an GQL episode type
func EpisodeFromSQL(ctx context.Context, row *sqlc.GetEpisodesWithTranslationsByIDRow) *Episode {
	titleMap := common.LocaleString{}
	descriptionMap := common.LocaleString{}
	extraDescriptionMap := common.LocaleString{}

	_ = json.Unmarshal(row.Title, &titleMap)
	_ = json.Unmarshal(row.Description, &descriptionMap)
	_ = json.Unmarshal(row.ExtraDescription, &extraDescriptionMap)

	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &Episode{
		Chapters:         []*Chapter{}, // Currently not supported
		ID:               fmt.Sprintf("%d", row.ID),
		Title:            titleMap.Get(languages),
		Description:      descriptionMap.Get(languages),
		ExtraDescription: extraDescriptionMap.Get(languages),
	}
}
