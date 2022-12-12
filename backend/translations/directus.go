package translations

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/go-resty/resty/v2"
	"github.com/samber/lo"
)

type directusDestination struct {
	client *resty.Client
}

func getDirectusCollection(col string) string {
	switch col {
	case "sections", "shows", "episodes", "seasons":
		return col + "_translations"
	}
	return col
}

type hasSourceLang interface {
	GetSourceLanguage() string
}

func asDSItems[T directus.DSItem](items []T) []directus.DSItem {
	return lo.Map(items, func(i T, _ int) directus.DSItem {
		return i
	})
}

func (d *directusDestination) getExistingMap(ctx context.Context, translations []Translation) (map[string]any, error) {
	var directusTs = map[string]any{}

	for _, t := range translations {
		if _, ok := directusTs[t.Collection]; !ok {
			var items any
			var err error
			switch t.Collection {
			case "sections":
				items, err = directus.ListItems[directus.SectionsTranslation](ctx, d.client, getDirectusCollection(t.Collection), nil)
			case "shows":
				items, err = directus.ListItems[directus.ShowsTranslation](ctx, d.client, getDirectusCollection(t.Collection), nil)
			case "seasons":
				items, err = directus.ListItems[directus.SeasonsTranslation](ctx, d.client, getDirectusCollection(t.Collection), nil)
			case "episodes":
				items, err = directus.ListItems[directus.EpisodesTranslation](ctx, d.client, getDirectusCollection(t.Collection), nil)
			case "pages":
				items, err = directus.ListItems[directus.PagesTranslation](ctx, d.client, getDirectusCollection(t.Collection), nil)
			}
			if err != nil {
				return nil, err
			}
			directusTs[t.Collection] = items
		}
	}

	return directusTs, nil
}

// Save translations to directus
func (d *directusDestination) Save(ctx context.Context, translations []Translation) error {
	directusTs, err := d.getExistingMap(ctx, translations)
	if err != nil {
		return err
	}
	return nil
}

func toDirectusDestination() {

}
