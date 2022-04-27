package server

import (
	"context"
	"database/sql"
	"fmt"
	"net/http"

	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/bcc-code/brunstadtv/backend/asset"
	"github.com/bcc-code/brunstadtv/backend/events"
	"github.com/bcc-code/brunstadtv/backend/pubsub"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/gin-gonic/gin"
)

var (
	errUndefinedHandler = fmt.Errorf("Handler for this message type is not defined")
)

type eventHandler func(context.Context, cloudevents.Event) error

// NewServer returns a new server for handling the HTTP requests
// Yes, go, I know it's "annoying to work with" but in this case you will have to deal with it
func NewServer(db *sql.DB) *server {
	return &server{
		rawDB:      db,
		db:         sqlc.New(db),
		awsSession: session.Must(session.NewSession()),
		eventHandlers: map[string]eventHandler{
			events.TypeAssetDelivered: asset.Ingest,
		},
	}
}

// Server is the base for all HTTP handler
type server struct {
	rawDB      *sql.DB
	db         *sqlc.Queries
	awsSession *session.Session

	eventHandlers map[string]eventHandler
}

// IngestVod processes the message for ingesting a VOD asset
func (s server) ProcessMessage(c *gin.Context) {
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

	if f, ok := s.eventHandlers[e.Type()]; ok {
		err = f(c.Request.Context(), e)
	} else {
		err = errUndefinedHandler
	}

	if err != nil {
		// TODO
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}
}
