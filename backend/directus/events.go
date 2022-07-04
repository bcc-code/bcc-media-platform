package directus

import (
	"context"

	"github.com/bcc-code/mediabank-bridge/log"
	cevent "github.com/cloudevents/sdk-go/v2/event"
	"github.com/gin-gonic/gin"
)

type Event struct {
	Event      string `json:"event"`
	Collection string `json:"collection"`
	Id         int    `json:"id"`
}

const (
	EventItemsCreate = "items.create"
	EventItemsUpdate = "items.update"
	EventItemsDelete = "items.delete"
)

type EventHandler struct {
}

func NewEventHandler() *EventHandler {
	return &EventHandler{}
}

var itemsEvents = map[string][]func(ctx context.Context, collection string, id int){}

func (handler *EventHandler) On(event string, callback func(ctx context.Context, collection string, id int)) {
	switch event {
	case EventItemsUpdate, EventItemsCreate, EventItemsDelete:
		log.L.Debug().Str("event", event).Msg("Registering Directus webhook-listener for event")
		itemsEvents[event] = append(itemsEvents[event], callback)
	}
}

func (handler *EventHandler) ProcessCloudEvent(ctx context.Context, e cevent.Event) error {
	var event Event
	err := e.DataAs(&event)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to bind to event struct")
		return err
	}
	return handler.Process(ctx, event)
}

func (handler *EventHandler) Process(ctx context.Context, event Event) error {
	log.L.Debug().Str("event", event.Event).Str("collection", event.Collection).Msg("Processing event")

	var id = event.Id
	if id == 0 {
		return nil
	}
	switch event.Event {
	case EventItemsUpdate, EventItemsCreate, EventItemsDelete:
		for i, callback := range itemsEvents[event.Event] {
			log.L.Debug().Msgf("Executing callback #%d for event %s", i, event.Event)
			callback(ctx, event.Collection, id)
		}
	}

	return nil
}

func (handler *EventHandler) Execute(c *gin.Context) error {
	var event Event
	err := c.BindJSON(&event)
	if err != nil {
		return err
	}
	return handler.Process(c, event)
}
