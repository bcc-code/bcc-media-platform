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

func (service *Service) getTranslatedFields() []string {
	translatableFields := []string{description, title}

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
	queries := sqlc.New(service.DB)
	languageKeys, err := queries.GetLanguageKeys(ctx)

	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve languages")
		return nil
	}

	return languageKeys
}
