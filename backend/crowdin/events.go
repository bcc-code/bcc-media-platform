package crowdin

import (
	"context"
	"github.com/ansel1/merry"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/brunstadtv/backend/events"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/go-resty/resty/v2"
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
	client := New("https://api.crowdin.com/api/v2/", config.GetCrowdinToken(), ClientConfig{
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
