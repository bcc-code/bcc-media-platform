package search

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
)

const (
	description = "description"
	title       = "title"
	publishedAt = "publishedAt"
	createdAt   = "createdAt"
)

func (service *Service) getFields() []string {
	return append(service.getTranslatedFields(), service.getFunctionalFields()...)
}

func (service *Service) getFunctionalFields() []string {
	return []string{publishedAt, createdAt}
}

func (service *Service) getTranslatableFields() []string {
	return []string{description, title}
}

func (service *Service) getTranslatedFields() []string {
	translatableFields := service.getTranslatableFields()
	var allFields []string

	for _, languageKey := range service.getLanguageKeys() {
		for _, field := range translatableFields {
			allFields = append(allFields, field+"_"+languageKey)
		}
	}

	return allFields
}

func (service *Service) getLanguageKeys() []string {
	ctx := context.Background()
	queries := sqlc.New(service.db)
	languageKeys, err := queries.GetLanguageKeys(ctx)

	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve languages")
		return nil
	}

	return languageKeys
}

func mapToSearchObjects[T any](items []T, getValues func(T) searchObject) []searchObject {
	var objects []searchObject
	for _, item := range items {
		objects = append(objects, getValues(item))
	}
	return objects
}

func mapTranslationsToSearchObject[T any](item searchObject, translations []T, getLanguage func(T) string, getTitle func(T) string, getDescription func(T) string) {
	for _, translation := range translations {
		translatedValues := map[string]string{
			description: getDescription(translation),
			title:       getTitle(translation),
		}
		language := getLanguage(translation)
		for field, value := range translatedValues {
			if value != "" {
				item[field+"_"+language] = value
			}
		}
	}
}
