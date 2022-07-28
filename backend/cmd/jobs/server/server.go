package server

import (
	"net/http"
	"time"

	"github.com/bcc-code/brunstadtv/backend/crowdin"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/asset"
	"github.com/bcc-code/brunstadtv/backend/events"
	"github.com/bcc-code/brunstadtv/backend/maintenance"
	"github.com/bcc-code/brunstadtv/backend/pubsub"
	"github.com/bcc-code/mediabank-bridge/log"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/davecgh/go-spew/spew"
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/codes"
)

var (
	errUndefinedHandler = merry.New("Handler for this message type is not defined")
)

var (
	messageCache = cache.New[string, bool]()
)

var (
	runOnceOnNode = map[string]struct{}{
		events.TypeSearchReindex:    {},
		events.TypeTranslationsSync: {},
		events.TypeDirectusEvent:    {},
	}
)

// NewServer returns a new server for handling the HTTP requests
// Yes, go, I know it's "annoying to work with" but in this case you will have to deal with it
func NewServer(s ExternalServices, c ConfigData) *server {
	return &server{
		services: s,
		config:   c,
	}
}

// Server is the base for all HTTP handler
type server struct {
	services ExternalServices
	config   ConfigData
}

// IngestVod processes the message for ingesting a VOD asset
func (s server) ProcessMessage(c *gin.Context) {
	ctx := c.Request.Context()
	ctx, span := otel.Tracer("jobs/core").Start(ctx, "ProcessMessage")
	defer span.End()

	msg, err := pubsub.MessageFromCtx(c)
	if err != nil {
		span.SetStatus(codes.Error, err.Error())
		log.L.Error().Err(err).Msgf("Could not extract message from context")
		c.Status(http.StatusOK)
		return
	}
	span.AddEvent("message extracted from ctx")

	e := cloudevents.NewEvent()
	err = pubsub.ExtractData(*msg, &e)
	if err != nil {
		span.SetStatus(codes.Error, err.Error())
		log.L.Error().
			Err(err).
			Str("msg", spew.Sdump(msg)).
			Msgf("Could not create cloud event. Likely bad format")
		c.Status(http.StatusOK)
		return
	}
	span.AddEvent("extracted event data")

	span.SetAttributes(attribute.String("MsgId", e.ID()), attribute.String("MessageSource", e.Source()))

	log.L.Debug().
		Str("MsgId", e.ID()).
		Str("Source", e.Source()).
		Msg("processing message")

	// Mostly for local development. Run exactly once is enabled in cloud
	if _, ok := runOnceOnNode[e.Type()]; ok {
		if messageCache.Contains(e.ID()) {
			log.L.Debug().Str("MsgId", e.ID()).Msg("ignoring processed message")
			c.Status(http.StatusOK)
			return
		} else {
			messageCache.Set(e.ID(), true, cache.WithExpiration(time.Minute*5))
		}
	}

	switch e.Type() {
	case events.TypeAssetDelivered:
		err = asset.Ingest(ctx, s.services, s.config, e)
	case events.TypeRefreshView:
		err = maintenance.RefreshView(ctx, s.services, e)
	case events.TypeDirectusEvent:
		err = s.services.GetDirectusEventHandler().ProcessCloudEvent(ctx, e)
	case events.TypeSearchReindex:
		err = s.services.GetSearchService().Reindex(ctx)
	case events.TypeTranslationsSync:
		err = crowdin.HandleEvent(ctx, s.services, e)
	default:
		err = merry.Wrap(errUndefinedHandler)
	}

	if err != nil {
		log.L.Error().
			Err(err).
			Str("msg", spew.Sdump(msg)).
			Msgf("Error processing message. See log for more details")
		c.Status(http.StatusOK)
		return
	}
}
