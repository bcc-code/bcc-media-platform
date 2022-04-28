package server

import (
	"fmt"
	"net/http"

	"github.com/bcc-code/brunstadtv/backend/asset"
	"github.com/bcc-code/brunstadtv/backend/events"
	"github.com/bcc-code/brunstadtv/backend/pubsub"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/gin-gonic/gin"
)

var (
	errUndefinedHandler = fmt.Errorf("Handler for this message type is not defined")
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

	msg, err := pubsub.MessageFromCtx(c)
	if err != nil {
		// TODO
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}

	e := cloudevents.NewEvent()
	err = pubsub.ExtractData(*msg, &e)
	if err != nil {
		// TODO
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}

	switch e.Type() {
	case events.TypeAssetDelivered:
		err = asset.Ingest(ctx, s.services, s.config, e)
	default:
		err = errUndefinedHandler
	}

	if err != nil {
		// TODO
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}
}
