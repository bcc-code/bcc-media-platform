package crowdin

import (
	"context"
	"github.com/ansel1/merry"
	"github.com/bcc-code/brunstadtv/backend/cmd/jobs/server"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/brunstadtv/backend/events"
	cloudevents "github.com/cloudevents/sdk-go/v2"
)

type PubSubEvent struct {
	Type string `json:"type"`
}

func HandleEvent(ctx context.Context, services server.ExternalServices, event cloudevents.Event) (err error) {
	switch event.Type() {
	case events.TypeTranslationsSync:
		handler := directus.NewHandler(ctx, services.GetDirectusClient())
		client := services.GetCrowdinClient()
		client.Sync(handler)
	default:
		err = merry.New("Unsupported event")
	}
	return
}
