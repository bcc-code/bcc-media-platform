package gqlmodel

import (
	"context"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// SeasonFrom coverts a common.Season into an GQL episode type
func SeasonFrom(ctx context.Context, s *common.Season) *Season {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)
	show := Show{
		ID: strconv.Itoa(s.ShowID),
	}

	var legacyID *string
	if s.LegacyID.Valid {
		strID := strconv.Itoa(int(s.LegacyID.Int64))
		legacyID = &strID
	}

	return &Season{
		ID:          strconv.Itoa(s.ID),
		LegacyID:    legacyID,
		Title:       s.Title.Get(languages),
		Description: s.Description.Get(languages),
		Number:      s.Number,
		Show:        &show,
	}
}

// SeasonItemFrom returns a SeasonItem from a common.Season
func SeasonItemFrom(ctx context.Context, row *common.Season) *SeasonItem {
	season := SeasonFrom(ctx, row)

	return &SeasonItem{
		ID:     season.ID,
		Season: season,
		Title:  season.Title,
	}
}
