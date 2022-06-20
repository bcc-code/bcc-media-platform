package search

import "github.com/bcc-code/brunstadtv/backend/common"

const translationContextKey = "translations"

func (handler *RequestHandler) getTranslationsDict() map[string][]common.Translation {
	dict := handler.context.Value(translationContextKey)
	return dict.(map[string][]common.Translation)
}
