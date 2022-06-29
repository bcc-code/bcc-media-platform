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
	Ids        []int  `json:"ids"`
}

const (
	EventItemsCreate = "items.create"
	EventItemsUpdate = "items.update"
	EventItemsDelete = "items.delete"
)

type EventHandler struct {
}

func getModelFromCollectionName(collection string) string {
	switch collection {
	case "episode", "episodes":
		return "episode"
	case "season", "seasons":
		return "season"
	case "show", "shows":
		return "show"
	}
	return ""
}

var itemsEvents = map[string][]func(ctx context.Context, model string, id int){}

func (handler *EventHandler) On(event string, callback func(ctx context.Context, model string, id int)) {
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

	model := getModelFromCollectionName(event.Collection)
	if model == "" {
		return nil
	}

	var ids = event.Ids
	for _, id := range ids {
		switch event.Event {
		case EventItemsUpdate, EventItemsCreate, EventItemsDelete:
			for i, callback := range itemsEvents[event.Event] {
				log.L.Debug().Msgf("Executing callback #%d for event %s", i, event.Event)
				callback(ctx, model, id)
			}
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

func NewEventHandler() *EventHandler {
	return &EventHandler{}
}
