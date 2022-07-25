package gqlmodel

import (
	"context"
	"encoding/json"
	"fmt"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// EpisodeFromSQL coverts a SQL row into an GQL episode type
func EpisodeFromSQL(ctx context.Context, row *sqlc.EpisodeExpanded) *Episode {
	titleMap := common.LocaleString{}
	descriptionMap := common.LocaleString{}
	extraDescriptionMap := common.LocaleString{}

	_ = json.Unmarshal(row.Title, &titleMap)
	_ = json.Unmarshal(row.Description, &descriptionMap)
	_ = json.Unmarshal(row.ExtraDescription, &extraDescriptionMap)

	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)
	var season *Season
	if row.SeasonID.Valid {
		season = &Season{
			ID: strconv.Itoa(int(row.SeasonID.Int64)),
		}
	}

	var extraDescription string
	if v := extraDescriptionMap.GetValueOrNil(languages); v != nil {
		extraDescription = *v
	}

	episode := &Episode{
		Chapters:         []*Chapter{}, // Currently not supported
		ID:               fmt.Sprintf("%d", row.ID),
		Title:            titleMap.Get(languages),
		Description:      descriptionMap.Get(languages),
		ExtraDescription: extraDescription,
		Season:           season,
	}

	if row.EpisodeNumber.Valid {
		num := int(row.EpisodeNumber.Int64)
		episode.EpisodeNumber = &num
	}

	return episode
}

// EpisodeItemFromSQL converts a SQL row into a GQL Episode Item
func EpisodeItemFromSQL(ctx context.Context, row *sqlc.EpisodeExpanded) *EpisodeItem {
	episode := EpisodeFromSQL(ctx, row)

	return &EpisodeItem{
		ID:      episode.ID,
		Title:   episode.Title,
		Episode: episode,
	}
}
