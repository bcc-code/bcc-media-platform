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

// Save translations to directus
func (d *directusDestination) Save(ctx context.Context, translations []Translation) error {
	var directusTs = map[string][]directus.DSItem{}

	for _, t := range translations {
		if _, ok := directusTs[t.Collection]; !ok {
			switch t.Collection {
			case "sections":
				ts, err := directus.ListItems[directus.SectionsTranslation](ctx, d.client, getDirectusCollection(t.Collection), nil)
				if err != nil {
					return err
				}
			}
		}
	}
}

func toDirectusDestination() {

}
