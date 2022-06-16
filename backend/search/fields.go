package search

import (
	"fmt"
	"time"
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
	return []string{createdAtField, updatedAtField, headerField}
}

func (service *Service) getTextFields() []string {
	return []string{descriptionField, titleField, showTitleField, seasonTitleField}
}

func (service *Service) getFilterFields() []string {
	return []string{rolesField, typeField, statusField, publishedAtField}
}

func getUrl(model string, id int) string {
	return fmt.Sprintf("/%s/%d", model, id)
}

func largestTime(timeStamps ...time.Time) time.Time {
	var largest time.Time
	for _, stamp := range timeStamps {
		if stamp.After(largest) {
			largest = stamp
		}
	}
	return largest
}

func smallestTime(timeStamps ...time.Time) time.Time {
	var smallest time.Time
	for _, stamp := range timeStamps {
		if !stamp.IsZero() &&
			(smallest.IsZero() || stamp.Before(smallest)) {
			smallest = stamp
		}
	}
	return smallest
}
