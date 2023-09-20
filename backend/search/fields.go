package search

import (
	"context"
	"fmt"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/mitchellh/mapstructure"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
	"strings"
	"time"
)

const (
	idField            = "objectID"
	legacyIDField      = "legacyID"
	publishedField     = "published"
	typeField          = "type"
	rolesField         = "roles"
	tagsField          = "tags"
	imageField         = "image"
	descriptionField   = "description"
	titleField         = "title"
	headerField        = "header"
	durationField      = "duration"
	ageRatingField     = "ageRating"
	availableFromField = "availableFrom"
	availableToField   = "availableTo"
	showIDField        = "showID"
	showTitleField     = "showTitle"
	seasonIDField      = "seasonID"
	seasonTitleField   = "seasonTitle"
)

type searchItem struct {
	ID            string
	LegacyID      *int
	Published     bool
	Type          string
	Roles         []string
	Tags          []string
	Image         *string
	Title         common.LocaleString
	Description   common.LocaleString
	Header        *string
	AgeRating     *string
	Duration      *int
	AvailableFrom int
	AvailableTo   int
	ShowID        *int
	ShowTitle     *common.LocaleString
	SeasonID      *int
	SeasonTitle   *common.LocaleString
}

func (object searchObject) toSearchHit() (searchHit, error) {
	var item searchHit
	item.ID = object[idField].(string)
	item.Title = object.getLocaleString(titleField)
	delete(object, titleField)
	item.Description = object.getLocaleString(descriptionField)
	delete(object, descriptionField)
	showTitle := object.getLocaleString(showTitleField)
	if len(showTitle) > 0 {
		item.ShowTitle = showTitle
	}
	delete(object, showTitleField)
	seasonTitle := object.getLocaleString(seasonTitleField)
	if len(seasonTitle) > 0 {
		item.SeasonTitle = seasonTitle
	}
	delete(object, seasonTitleField)
	if object["_highlightResult"] != nil {
		if r, ok := object["_highlightResult"].(map[string]any); ok {
			item.HighlightResult = r
		}
	}
	object["rankingInfo"] = object["_rankingInfo"]
	err := mapstructure.Decode(object, &item)
	return item, err
}

func (i *searchItem) toSearchObject() searchObject {
	object := searchObject{}
	object[idField] = i.ID
	if i.LegacyID != nil {
		object[legacyIDField] = i.LegacyID
	}
	object[publishedField] = i.Published
	object[typeField] = i.Type
	object[rolesField] = i.Roles
	object[tagsField] = i.Tags
	object[durationField] = i.Duration
	object[ageRatingField] = i.AgeRating
	if i.Image != nil {
		object[imageField] = i.Image
	}
	object.mapFromLocaleString(titleField, i.Title)
	object.mapFromLocaleString(descriptionField, i.Description)
	if i.Header != nil {
		object[headerField] = i.Header
	}
	object[availableFromField] = i.AvailableFrom
	object[availableToField] = i.AvailableTo
	if i.ShowID != nil {
		object[showIDField] = i.ShowID
	}
	if i.ShowTitle != nil {
		object.mapFromLocaleString(showTitleField, *i.ShowTitle)
	}
	if i.SeasonID != nil {
		object[seasonIDField] = i.SeasonID
	}
	if i.SeasonTitle != nil {
		object.mapFromLocaleString(seasonTitleField, *i.SeasonTitle)
	}
	return object
}

func (i *searchItem) assignRoles(r common.Roles) {
	i.Roles = r.Access
}

func (i *searchItem) assignVisibility(a common.Availability) {
	i.Published = a.Published
	if a.From.IsZero() {
		i.AvailableFrom = 0
	} else {
		i.AvailableFrom = int(a.From.Unix())
	}
	if a.To.IsZero() {
		i.AvailableTo = 0
	} else {
		i.AvailableTo = int(a.To.Unix())
	}
}

type hasTags interface {
	GetTagIDs() []int
}

func (i *searchItem) assignTags(ctx context.Context, loaders batchLoaders, source hasTags) error {
	tagIds := source.GetTagIDs()
	if len(tagIds) > 0 {
		tags, errs := loaders.TagLoader.LoadMany(ctx, tagIds)()
		if len(errs) > 0 {
			return errs[0]
		}
		i.Tags = lo.Map(tags, func(t *common.Tag, _ int) string {
			return t.Code
		})
	}
	return nil
}

func (service *Service) getFields() ([]string, error) {
	translated, err := service.getTranslatedFields()
	return append(translated, getFunctionalFields()...), err
}

// Fields which can be used for something
func getFunctionalFields() []string {
	return []string{headerField}
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
	return []string{rolesField, tagsField, typeField, publishedField}
}

func (service *Service) getTranslatedTitleFields() ([]string, error) {
	var fields []string
	ls, err := service.getLanguageKeys()
	if err != nil {
		return nil, err
	}
	for _, language := range ls {
		fields = append(fields, titleField+"_"+language)
	}
	return fields, nil
}

func (service *Service) getTranslatedDescriptionFields() ([]string, error) {
	var fields []string
	ls, err := service.getLanguageKeys()
	if err != nil {
		return nil, err
	}
	for _, language := range ls {
		fields = append(fields, descriptionField+"_"+language)
	}
	return fields, nil
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

var languageCache = cache.New[string, []string]()

func (service *Service) getLanguageKeys() ([]string, error) {
	languages, ok := languageCache.Get("languages")
	if ok {
		return languages, nil
	}
	languages, err := service.queries.GetLanguageKeys(context.Background())
	if err != nil {
		return []string{}, err
	}
	// TODO: Remove this filter after cleaning up database
	languages = lo.Filter(languages, func(lang string, _ int) bool {
		return len(lang) == 2
	})
	languageCache.Set("languages", languages, cache.WithExpiration(time.Minute*10))
	return languages, nil
}

func getUrl(model string, id int) string {
	return fmt.Sprintf("/%s/%d", model, id)
}

func (object *searchObject) mapFromLocaleString(field string, dict common.LocaleString) {
	for key, value := range dict {
		if value.Valid {
			(*object)[field+"_"+key] = value.String
		}
	}
}

func (object *searchObject) getLocaleString(field string) common.LocaleString {
	dict := common.LocaleString{}
	for key, value := range *object {
		if strings.HasPrefix(key, field+"_") {
			parts := strings.Split(key, "_")
			if len(parts) == 2 {
				lang := parts[1]
				dict[lang] = null.StringFrom(value.(string))
			}
		}
	}
	return dict
}
