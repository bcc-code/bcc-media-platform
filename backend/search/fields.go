package search

import (
	"context"
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/mitchellh/mapstructure"
	"github.com/samber/lo"
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

const defaultLanguage = "no"

type localeString map[string]string

func (dict localeString) get(language string) string {
	if value := dict[language]; value != "" {
		return value
	}
	return dict[defaultLanguage]
}

func (service *Service) getFields() ([]string, error) {
	translated, err := service.getTranslatedFields()
	return append(translated, getFunctionalFields()...), err
}

// Fields which can be used for something
func getFunctionalFields() []string {
	return []string{createdAtField, updatedAtField, headerField}
}

func getRelationalTranslatableFields() []string {
	return []string{showTitleField, seasonTitleField}
}

func getPrimaryTranslatableFields() []string {
	return []string{titleField, descriptionField}
}

// Searchable fields
func (service *Service) getTextFields() []string {
	return []string{descriptionField, titleField, showTitleField, seasonTitleField}
}

// These are the fields which we use to filter for permissions
func (service *Service) getFilterFields() []string {
	return []string{rolesField, typeField, statusField, publishedAtField}
}

func (service *Service) getPrimaryTranslatedFields() ([]string, error) {
	var fields []string
	ls, err := service.getLanguageKeys()
	if err != nil {
		return nil, err
	}
	for _, field := range getPrimaryTranslatableFields() {
		for _, language := range ls {
			fields = append(fields, field+"_"+language)
		}
	}
	return fields, nil
}

func (service *Service) getRelationalTranslatedFields() ([]string, error) {
	var fields []string
	ls, err := service.getLanguageKeys()
	if err != nil {
		return nil, err
	}
	for _, field := range getRelationalTranslatableFields() {
		for _, language := range ls {
			fields = append(fields, field+"_"+language)
		}
	}
	return fields, nil
}

func (service *Service) getTranslatedFields() ([]string, error) {
	primary, err := service.getPrimaryTranslatedFields()
	if err != nil {
		return nil, err
	}
	relational, err := service.getRelationalTranslatedFields()
	if err != nil {
		return nil, err
	}
	return append(primary, relational...), nil
}

var allLanguages []string

func (service *Service) getLanguageKeys() ([]string, error) {
	if allLanguages == nil {
		// TODO: Remove this filter after cleaning up database
		languages, err := service.queries.GetLanguageKeys(context.Background())
		if err != nil {
			return []string{}, err
		}
		allLanguages = lo.Filter(languages, func(lang string, _ int) bool {
			return len(lang) == 2
		})
	}
	return allLanguages, nil
}

func getUrl(model string, id int) string {
	return fmt.Sprintf("/%s/%d", model, id)
}

func (object *searchObject) mapFromLocaleString(field string, dict localeString) {
	for key, value := range dict {
		(*object)[field+"_"+key] = value
	}
}

func (object *searchObject) getLocaleString(field string, languages []string) (dict localeString) {
	dict = localeString{}
	for _, language := range languages {
		if value := (*object)[field+"_"+language]; value != nil && value != "" {
			dict[language] = value.(string)
		}
	}
	return
}

func (service *Service) convertToSearchHit(object searchObject) (searchHit, error) {
	languages, err := service.getLanguageKeys()
	if err != nil {
		return searchHit{}, err
	}
	var item searchHit
	item.ID = object[idField].(string)
	item.Title = object.getLocaleString(titleField, languages)
	delete(object, titleField)
	item.Description = object.getLocaleString(descriptionField, languages)
	delete(object, descriptionField)
	item.ShowTitle = object.getLocaleString(showTitleField, languages)
	delete(object, showTitleField)
	item.SeasonTitle = object.getLocaleString(seasonTitleField, languages)
	delete(object, seasonTitleField)
	err = mapstructure.Decode(object, &item)
	return item, err
}

func toLocaleStrings(translations []common.Translation) (title localeString, description localeString) {
	title = localeString{}
	description = localeString{}
	for _, translation := range translations {
		title[translation.Language] = translation.Title
		if val := translation.Description; val != "" {
			description[translation.Language] = val
		}
		if val := translation.Details; val != "" {
			if description[translation.Language] != "" {
				description[translation.Language] += "\n"
			}
			description[translation.Language] += val
		}
	}
	return
}
