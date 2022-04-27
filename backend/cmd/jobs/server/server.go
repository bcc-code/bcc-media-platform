package server

import (
	"database/sql"
	"net/http"

	"github.com/bcc-code/brunstadtv/backend/events"
	"github.com/bcc-code/brunstadtv/backend/pubsub"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/davecgh/go-spew/spew"
	"github.com/gin-gonic/gin"
)

// NewServer returns a new server for handling the HTTP requests
// Yes, go, I know it's "annoying to work with" but in this case you will have to deal with it
func NewServer(db *sql.DB) *server {
	return &server{
		rawDB: db,
		db:    sqlc.New(db),
	}
}

// Server is the base for all HTTP handler
type server struct {
	rawDB *sql.DB
	db    *sqlc.Queries
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

	d := &events.VODUpdated{}
	err = e.DataAs(d)

	spew.Dump(err, d)
}
