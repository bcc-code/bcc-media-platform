package server

import (
	"net/http"

	"github.com/ansel1/merry"
	"github.com/bcc-code/brunstadtv/backend/asset"
	"github.com/bcc-code/brunstadtv/backend/events"
	"github.com/bcc-code/brunstadtv/backend/pubsub"
	"github.com/bcc-code/mediabank-bridge/log"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/davecgh/go-spew/spew"
	"github.com/gin-gonic/gin"
	"go.opencensus.io/trace"
)

var (
	errUndefinedHandler = merry.New("Handler for this message type is not defined")
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
	ctx, span := trace.StartSpan(ctx, "ProcessMessage")
	defer span.End()

	msg, err := pubsub.MessageFromCtx(c)
	span.AddMessageReceiveEvent(msg.Message.PublishTime.UnixMilli(), c.Request.ContentLength, 0)
	if err != nil {
		log.L.Error().Err(err).Msgf("Could not extract message from context")
		c.Status(http.StatusOK)
		return
	}

	e := cloudevents.NewEvent()
	err = pubsub.ExtractData(*msg, &e)
	if err != nil {
		log.L.Error().
			Err(err).
			Str("msg", spew.Sdump(msg)).
			Msgf("Could not create could event. Likely bad format")
		c.Status(http.StatusOK)
		return
	}

	switch e.Type() {
	case events.TypeAssetDelivered:
		err = asset.Ingest(ctx, s.services, s.config, e)
	default:
		err = errUndefinedHandler.Here()
	}

	if err != nil {
		log.L.Error().
			Err(err).
			Str("msg", spew.Sdump(msg)).
			Msgf("Error procesing message. See log for more details")
		c.Status(http.StatusOK)
		return
	}
}
