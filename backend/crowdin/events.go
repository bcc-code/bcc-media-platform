package crowdin

import (
	"context"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/events"
	cloudevents "github.com/cloudevents/sdk-go/v2"
)

var (
	// ErrEventNotSupported error for event key not yet supported
	ErrEventNotSupported = merry.Sentinel("event not supported")
)

type services interface {
	GetCrowdinClient() *Client
}

// HandleEvent for events from PubSub (or other CloudEvent source)
func HandleEvent(ctx context.Context, services services, event cloudevents.Event) (err error) {
	client := services.GetCrowdinClient()
	switch event.Type() {
	case events.TypeTranslationsSync:
		return client.Sync(ctx)
	}
	return merry.Wrap(ErrEventNotSupported)
}
