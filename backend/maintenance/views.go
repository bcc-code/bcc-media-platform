package maintenance

import (
	"context"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/events"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"go.opentelemetry.io/otel"
)

// Sentinel errors
var (
	ErrUnknownView = merry.Sentinel("Refresh of unknown view requested")
)

type services interface {
	GetQueries() *sqlc.Queries
}

// RefreshView event handler
func RefreshView(ctx context.Context, s services, event cloudevents.Event) error {
	ctx, span := otel.Tracer("maintenance").Start(ctx, "RefreshView")
	defer span.End()
	q := s.GetQueries()

	defer span.End()
	msg := events.RefreshView{}
	err := event.DataAs(&msg)
	if err != nil {
		return merry.Wrap(err)
	}

	log.L.Debug().Str("ViewName", msg.ViewName).Msg("RefreshView")
	if msg.ViewName == "episodes_access" {
		_, err := q.RefreshAccessView(ctx)
		return merry.Wrap(err)
	}

	return merry.Wrap(ErrUnknownView)
}
