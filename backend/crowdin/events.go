package crowdin

import (
	"context"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
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
		handler := directus.NewHandler(services.GetDirectusClient())
		go client.Sync(ctx, handler)
	default:
		err = merry.New("Unsupported event")
	}
	return
}

func toTranslationSources[t TranslationSource](items []t) []TranslationSource {
	return lo.Map(items, func(i t, _ int) TranslationSource {
		return i
	})
}

func getStatusForItem(ctx context.Context, d *directus.Handler, collection string, id int) string {
	switch collection {
	case "shows":
		return d.GetShow(ctx, id).GetStatus()
	case "seasons":
		return d.GetSeason(ctx, id).GetStatus()
	case "episodes":
		return d.GetEpisode(ctx, id).GetStatus()
	}
	return ""
}

func getTranslationsForItem(ctx context.Context, d *directus.Handler, collection string, id int, language string) []TranslationSource {
	switch collection {
	case "shows":
		return toTranslationSources(d.ListShowTranslations(ctx, language, false, id))
	case "seasons":
		return toTranslationSources(d.ListSeasonTranslations(ctx, language, false, id))
	case "episodes":
		return toTranslationSources(d.ListEpisodeTranslations(ctx, language, false, id))
	}
	return nil
}

func (client *Client) HandleModelUpdate(ctx context.Context, directusHandler *directus.Handler, collection string, id int) {
	if getStatusForItem(ctx, directusHandler, collection, id) != common.StatusPublished {
		return
	}
	translations := getTranslationsForItem(ctx, directusHandler, collection, id, "")
	if len(translations) == 0 {
		return
	}
	err := client.SaveTranslations(translations)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to insert translations")
	}
}

func (client *Client) HandleModelDelete(collection string, id int) {
	log.L.Debug().Str("collection", collection).Int("id", id).Msg("deleting translations")
	// TODO: implement deletion of translations
}
