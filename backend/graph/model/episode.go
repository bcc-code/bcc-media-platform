package gqlmodel

import (
	"context"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// EpisodeFrom coverts a common.Episode into an GQL episode type
func EpisodeFrom(ctx context.Context, e *common.Episode) *Episode {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)
	var season *Season
	if e.SeasonID.Valid {
		season = &Season{
			ID: strconv.Itoa(int(e.SeasonID.Int64)),
		}
	}

	var extraDescription string
	if v := e.ExtraDescription.GetValueOrNil(languages); v != nil {
		extraDescription = *v
	}

	var legacyID *string
	if e.LegacyID.Valid {
		strID := strconv.Itoa(int(e.LegacyID.Int64))
		legacyID = &strID
	}

	var legacyProgramID *string
	if e.LegacyProgramID.Valid {
		strID := strconv.Itoa(int(e.LegacyProgramID.Int64))
		legacyProgramID = &strID
	}

	episode := &Episode{
		Chapters:         []*Chapter{}, // Currently not supported
		ID:               strconv.Itoa(e.ID),
		LegacyID:         legacyID,
		LegacyProgramID:  legacyProgramID,
		Title:            e.Title.Get(languages),
		Description:      e.Description.Get(languages),
		ExtraDescription: extraDescription,
		Season:           season,
		Duration:         e.Duration,
		AgeRating:        e.AgeRating,
	}

	if e.Number.Valid {
		num := int(e.Number.Int64)
		episode.Number = &num
	}

	return episode
}

// EpisodeItemFrom converts a common.Episode into a GQL Episode Item
func EpisodeItemFrom(ctx context.Context, e *common.Episode) *EpisodeItem {
	episode := EpisodeFrom(ctx, e)

	return &EpisodeItem{
		ID:      episode.ID,
		Title:   episode.Title,
		Episode: episode,
	}
}
