package search

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/mediabank-bridge/log"
)

const visibilityContextKey = "visibility"

func getVisibilityDict(ctx context.Context) map[string]common.Visibility {
	dict := ctx.Value(visibilityContextKey)
	if dict == nil {
		return map[string]common.Visibility{}
	}
	return dict.(map[string]common.Visibility)
}

func (handler *RequestHandler) getVisibilityForShow(ctx context.Context, id int32) common.Visibility {
	if val, ok := getVisibilityDict(ctx)[getCacheKeyForModel("show", id)]; ok {
		return val
	}
	service := handler.service
	row, err := service.queries.GetVisibilityForShow(ctx, id)
	if err != nil {
		log.L.Error().Err(err)
		return common.Visibility{}
	}
	return row.ToVisibility()
}

func (handler *RequestHandler) getVisibilityForSeason(ctx context.Context, id int32) common.Visibility {
	if val, ok := getVisibilityDict(ctx)[getCacheKeyForModel("season", id)]; ok {
		return val
	}
	service := handler.service
	row, err := service.queries.GetVisibilityForSeason(ctx, id)
	if err != nil {
		log.L.Error().Err(err)
		return common.Visibility{}
	}
	v := row.ToVisibility()
	return v.Merge(handler.getVisibilityForShow(ctx, row.ShowID))
}

func (handler *RequestHandler) getVisibilityForEpisode(ctx context.Context, id int32) common.Visibility {
	if val, ok := getVisibilityDict(ctx)[getCacheKeyForModel("episode", id)]; ok {
		return val
	}
	service := handler.service
	row, err := service.queries.GetVisibilityForEpisode(ctx, id)
	if err != nil {
		log.L.Error().Err(err)
		return common.Visibility{}
	}
	v := row.ToVisibility()
	if row.SeasonID.Valid {
		return v.Merge(handler.getVisibilityForSeason(ctx, int32(row.SeasonID.ValueOrZero())))
	}
	return v
}
