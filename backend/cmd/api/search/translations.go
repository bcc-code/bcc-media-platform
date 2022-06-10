package search

import "github.com/bcc-code/brunstadtv/backend/sqlc"

func mapTranslationToObject(translation sqlc.ITranslation, object searchObject) {
	values := map[string]string{
		title:       translation.GetTitle(),
		description: translation.GetDescription(),
	}
	for key, value := range values {
		if value != "" {
			object[key+"_"+translation.GetLanguage()] = value
		}
	}
}
