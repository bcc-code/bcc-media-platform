package search

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/mediabank-bridge/log"
)

const visibilityContextKey = "visibility"

func (handler *RequestHandler) getVisibilityDict() map[string]common.Visibility {
	dict := handler.context.Value(visibilityContextKey)
	return dict.(map[string]common.Visibility)
}

func (handler *RequestHandler) getVisibilityForShow(id int32) common.Visibility {
	if val, ok := handler.getVisibilityDict()[getCacheKeyForModel("show", id)]; ok {
		return val
	}
	service := handler.service
	row, err := service.queries.GetVisibilityForShow(handler.context, id)
	if err != nil {
		log.L.Error().Err(err)
		return common.Visibility{}
	}
	return row.ToVisibility()
}

func (handler *RequestHandler) getVisibilityForSeason(id int32) common.Visibility {
	if val, ok := handler.getVisibilityDict()[getCacheKeyForModel("season", id)]; ok {
		return val
	}
	service := handler.service
	row, err := service.queries.GetVisibilityForSeason(handler.context, id)
	if err != nil {
		log.L.Error().Err(err)
		return common.Visibility{}
	}
	v := row.ToVisibility()
	return v.Merge(handler.getVisibilityForShow(row.ShowID))
}

func (handler *RequestHandler) getVisibilityForEpisode(id int32) common.Visibility {
	if val, ok := handler.getVisibilityDict()[getCacheKeyForModel("episode", id)]; ok {
		return val
	}
	service := handler.service
	row, err := service.queries.GetVisibilityForEpisode(handler.context, id)
	if err != nil {
		log.L.Error().Err(err)
		return common.Visibility{}
	}
	v := row.ToVisibility()
	if row.SeasonID.Valid {
		return v.Merge(handler.getVisibilityForSeason(int32(row.SeasonID.ValueOrZero())))
	}
	return v
}
