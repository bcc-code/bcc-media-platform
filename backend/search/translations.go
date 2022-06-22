package search

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/mediabank-bridge/log"
)

const translationContextKey = "translations"

func (handler *RequestHandler) getTranslationsDict() map[string][]common.Translation {
	dict := handler.context.Value(translationContextKey)
	return dict.(map[string][]common.Translation)
}

type translationSource interface {
	ToTranslation() common.Translation
}

func getTranslationsForModel[TSource translationSource](handler *RequestHandler, model string, id int32, factory func(ctx context.Context, id int32) ([]TSource, error)) (translations []common.Translation) {
	dict := handler.getTranslationsDict()
	var cacheKey = getCacheKeyForModel(model, id)
	if val, ok := dict[cacheKey]; ok {
		return val
	}
	rows, err := factory(handler.context, id)
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

func (handler *RequestHandler) getTranslationsForShow(id int32) (translations []common.Translation) {
	return getTranslationsForModel(handler, "show", id, handler.service.queries.GetTranslationsForShow)
}

func (handler *RequestHandler) getTranslationsForSeason(id int32) (translations []common.Translation) {
	return getTranslationsForModel(handler, "season", id, handler.service.queries.GetTranslationsForSeason)
}

func (handler *RequestHandler) getTranslationsForEpisode(id int32) (translations []common.Translation) {
	return getTranslationsForModel(handler, "episode", id, handler.service.queries.GetTranslationsForEpisode)
}
