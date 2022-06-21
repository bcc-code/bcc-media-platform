package search

import (
	"context"
	"github.com/bcc-code/mediabank-bridge/log"
	"gopkg.in/guregu/null.v4"
)

const rolesContextKey = "roles"

func (handler *RequestHandler) getRolesDict() map[string][]string {
	dict := handler.context.Value(rolesContextKey).(map[string][]string)
	return dict
}

func getRolesForModel(handler *RequestHandler, model string, id int32, factory func(ctx context.Context, id int32) ([]string, error)) []string {
	dict := handler.getRolesDict()
	cacheKey := getCacheKeyForModel(model, id)
	if val, ok := dict[cacheKey]; ok {
		return val
	}
	roles, err := factory(handler.context, id)
	if err != nil {
		log.L.Error().Err(err)
		return []string{}
	}
	if roles == nil {
		roles = []string{}
	}
	dict[cacheKey] = roles
	return dict[cacheKey]
}

func (handler *RequestHandler) getRolesForEpisode(id int32) (roles []string) {
	return getRolesForModel(handler, "episode", id, handler.service.queries.GetRolesForEpisode)
}

func (handler *RequestHandler) getRolesForSeason(id int32) (roles []string) {
	return getRolesForModel(handler, "season", id, func(ctx context.Context, id int32) ([]string, error) {
		return handler.service.queries.GetRolesForSeason(ctx, null.IntFrom(int64(id)))
	})
}

func (handler *RequestHandler) getRolesForShow(id int32) (roles []string) {
	return getRolesForModel(handler, "show", id, handler.service.queries.GetRolesForShow)
}
