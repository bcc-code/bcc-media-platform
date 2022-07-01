package search

import (
	"context"
	"github.com/bcc-code/mediabank-bridge/log"
	"gopkg.in/guregu/null.v4"
)

const rolesContextKey = "roles"

func getRolesDict(ctx context.Context) map[string][]string {
	dict := ctx.Value(rolesContextKey)
	if dict == nil {
		return map[string][]string{}
	}
	return dict.(map[string][]string)
}

func getRolesForModel(ctx context.Context, model string, id int32, factory func(ctx context.Context, id int32) ([]string, error)) []string {
	dict := getRolesDict(ctx)
	cacheKey := getCacheKeyForModel(model, id)
	if val, ok := dict[cacheKey]; ok {
		return val
	}
	roles, err := factory(ctx, id)
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

func (handler *RequestHandler) getRolesForEpisode(ctx context.Context, id int32) (roles []string) {
	return getRolesForModel(ctx, "episode", id, handler.service.queries.GetRolesForEpisode)
}

func (handler *RequestHandler) getRolesForSeason(ctx context.Context, id int32) (roles []string) {
	return getRolesForModel(ctx, "season", id, func(ctx context.Context, id int32) ([]string, error) {
		return handler.service.queries.GetRolesForSeason(ctx, null.IntFrom(int64(id)))
	})
}

func (handler *RequestHandler) getRolesForShow(ctx context.Context, id int32) (roles []string) {
	return getRolesForModel(ctx, "show", id, handler.service.queries.GetRolesForShow)
}
