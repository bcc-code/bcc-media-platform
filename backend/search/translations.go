package search

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/mediabank-bridge/log"
)

const translationContextKey = "translations"

func getTranslationsDict(ctx context.Context) map[string][]common.Translation {
	dict := ctx.Value(translationContextKey)
	if dict == nil {
		return map[string][]common.Translation{}
	}
	return dict.(map[string][]common.Translation)
}

type translationSource interface {
	ToTranslation() common.Translation
}

func getTranslationsForModel[TSource translationSource](ctx context.Context, model string, id int32, factory func(ctx context.Context, id int32) ([]TSource, error)) (translations []common.Translation) {
	dict := getTranslationsDict(ctx)
	var cacheKey = getCacheKeyForModel(model, id)
	if val, ok := dict[cacheKey]; ok {
		return val
	}
	rows, err := factory(ctx, id)
	if err != nil {
		log.L.Error().Err(err).Str("model", model).Msg("Failed to retrieve translations")
		return []common.Translation{}
	}
	translations = []common.Translation{}
	for _, row := range rows {
		translations = append(translations, row.ToTranslation())
	}
	dict[cacheKey] = translations
	return
}

func (handler *RequestHandler) getTranslationsForShow(ctx context.Context, id int32) (translations []common.Translation) {
	return getTranslationsForModel(ctx, "show", id, handler.service.queries.GetTranslationsForShow)
}

func (handler *RequestHandler) getTranslationsForSeason(ctx context.Context, id int32) (translations []common.Translation) {
	return getTranslationsForModel(ctx, "season", id, handler.service.queries.GetTranslationsForSeason)
}

func (handler *RequestHandler) getTranslationsForEpisode(ctx context.Context, id int32) (translations []common.Translation) {
	return getTranslationsForModel(ctx, "episode", id, handler.service.queries.GetTranslationsForEpisode)
}
