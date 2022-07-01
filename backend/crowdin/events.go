package crowdin

import (
	"context"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/brunstadtv/backend/events"
	"github.com/bcc-code/mediabank-bridge/log"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/go-resty/resty/v2"
	"github.com/samber/lo"
)

type PubSubEvent struct {
	Type string `json:"type"`
}

type services interface {
	GetDirectusClient() *resty.Client
}

type config interface {
	GetCrowdinToken() string
	GetCrowdinProjectIDs() []int
}

func HandleEvent(ctx context.Context, services services, config config, event cloudevents.Event) (err error) {
	client := New(config.GetCrowdinToken(), ClientConfig{
		ProjectIDs: config.GetCrowdinProjectIDs(),
	})
	switch event.Type() {
	case events.TypeTranslationsSync:
		handler := directus.NewHandler(ctx, services.GetDirectusClient())
		client.Sync(handler)
	default:
		err = merry.New("Unsupported event")
	}
	return
}

func (client *Client) HandleModelUpdate(directusHandler *directus.Handler, collection string, id int) {
	language := ""
	var translations []TranslationSource
	switch collection {
	case "shows":
		i := directusHandler.GetShow(id)
		if i.Status != "published" {
			return
		}
		translations = lo.Map(
			directusHandler.ListShowTranslations(language, false, id),
			func(t directus.ShowsTranslation, _ int) TranslationSource {
				return t
			})
	case "seasons":
		i := directusHandler.GetSeason(id)
		if i.Status != "published" {
			return
		}
		translations = lo.Map(
			directusHandler.ListSeasonTranslations(language, false, id),
			func(t directus.SeasonsTranslation, _ int) TranslationSource {
				return t
			})
	case "episodes":
		i := directusHandler.GetEpisode(id)
		if i.Status != "published" {
			return
		}
		translations = lo.Map(
			directusHandler.ListEpisodeTranslations(language, false, id),
			func(t directus.EpisodesTranslation, _ int) TranslationSource {
				return t
			})
	}
	if translations != nil {
		err := client.SaveTranslations(translations)
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to insert translations")
		}
	}
}

func (client *Client) HandleModelDelete(collection string, id int) {
	log.L.Debug().Str("collection", collection).Int("id", id).Msg("deleting translations")
	// TODO: implement deletion of translations
}
