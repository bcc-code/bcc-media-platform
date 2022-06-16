package search

import (
	"fmt"
	"gopkg.in/guregu/null.v4"
)

const (
	idField            = "objectID"
	statusField        = "status"
	typeField          = "type"
	rolesField         = "roles"
	imageField         = "image"
	descriptionField   = "description"
	titleField         = "title"
	headerField        = "header"
	availableFromField = "availableFrom"
	availableToField   = "availableTo"
	publishedAtField   = "publishedAt"
	createdAtField     = "createdAt"
	updatedAtField     = "updatedAt"
	showIDField        = "showID"
	showTitleField     = "showTitle"
	seasonIDField      = "seasonID"
	seasonTitleField   = "seasonTitle"
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

func (service *Service) getFilterFields() []string {
	return []string{rolesField, typeField, statusField}
}

func getUrl(model string, id int) string {
	return fmt.Sprintf("/%s/%d", model, id)
}

func largestTime(timeStamps ...null.Time) null.Time {
	var largest null.Time
	for _, stamp := range timeStamps {
		if stamp.ValueOrZero().After(largest.ValueOrZero()) {
			largest = stamp
		}
	}
	return largest
}

func smallestTime(timeStamps ...null.Time) null.Time {
	var smallest null.Time
	for _, stamp := range timeStamps {
		if value := stamp.ValueOrZero(); !value.IsZero() &&
			(smallest.IsZero() || value.Before(smallest.ValueOrZero())) {
			smallest = stamp
		}
	}
	return smallest
}
