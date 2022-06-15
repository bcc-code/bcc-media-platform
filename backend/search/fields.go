package search

import (
	"fmt"
)

const (
	idField          = "objectID"
	imageField       = "image"
	descriptionField = "description"
	titleField       = "title"
	headerField      = "header"
	publishedAtField = "publishedAt"
	createdAtField   = "createdAt"
	updatedAtField   = "updatedAt"
	showIDField      = "showID"
	showTitleField   = "showTitle"
	seasonIDField    = "seasonID"
	seasonTitleField = "seasonTitle"
)

// TODO: move this to a global parameter
const defaultLanguage = "no"

type localeString map[string]string

func (dict localeString) get(language string) string {
	if value := dict[language]; value != "" {
		return value
	}
	return dict[defaultLanguage]
}

func (service *Service) getFields() []string {
	return append(service.getTextFields(), service.getFunctionalFields()...)
}

func (service *Service) getFunctionalFields() []string {
	return []string{publishedAtField, createdAtField, updatedAtField, headerField}
}

func (service *Service) getTextFields() []string {
	return []string{descriptionField, titleField, showTitleField, seasonTitleField}
}

func getUrl(model string, id int) string {
	return fmt.Sprintf("/%s/%d", model, id)
}
