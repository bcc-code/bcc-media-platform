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
func EpisodeFromSQL(ctx context.Context, row sqlc.GetEpisodesWithTranslationsByIDRow) Episode {
	titleMap := common.Translations{}
	descriptionMap := common.Translations{}
	extraDescriptionMap := common.Translations{}

	_ = json.Unmarshal(row.Title, &titleMap)
	_ = json.Unmarshal(row.Description, &descriptionMap)
	_ = json.Unmarshal(row.ExtraDescription, &extraDescriptionMap)

	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return Episode{
		Chapters:         []*Chapter{}, // Currently not supported
		ID:               fmt.Sprintf("%d", row.ID),
		Title:            titleMap.GetTranslation(languages),
		Description:      descriptionMap.GetTranslation(languages),
		ExtraDescription: extraDescriptionMap.GetTranslation(languages),
	}
}
