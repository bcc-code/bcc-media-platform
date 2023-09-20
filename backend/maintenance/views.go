package maintenance

import (
	"context"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/events"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"go.opentelemetry.io/otel"
)

// Sentinel errors
var (
	// ErrUnknownView is an error for unknown views
	ErrUnknownView = merry.Sentinel("Refresh of unknown view requested")
)

type services interface {
	GetQueries() *sqlc.Queries
}

// RefreshView event handler
func RefreshView(ctx context.Context, s services, event cloudevents.Event) error {
	ctx, span := otel.Tracer("maintenance").Start(ctx, "RefreshView")
	defer span.End()
	//q := s.GetQueries()
	msg := events.RefreshView{}
	err := event.DataAs(&msg)
	if err != nil {
		return merry.Wrap(err)
	}

	log.L.Debug().Str("ViewName", msg.ViewName).Msg("RefreshView")
	switch msg.ViewName {
	case "filter_dataset":
		err = s.GetQueries().RefreshView(ctx, msg.ViewName)
	default:
		err = merry.Wrap(ErrUnknownView)
	}

	return merry.Wrap(err)
}
