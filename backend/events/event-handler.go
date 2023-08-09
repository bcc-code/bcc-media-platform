package events

import (
	"context"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/mediabank-bridge/log"
	cevent "github.com/cloudevents/sdk-go/v2/event"
)

// Event represents a payload from the directus hook
type Event struct {
	Event      string `json:"event"`
	Collection string `json:"collection"`
	ID         string `json:"id"`
}

const (
	// EventItemsCreate items.create
	EventItemsCreate = "items.create"
	// EventItemsUpdate items.update
	EventItemsUpdate = "items.update"
	// EventItemsDelete items.delete
	EventItemsDelete = "items.delete"
)

// Handler for handling directus events
type Handler struct {
}

// NewHandler returns a new Handler
func NewHandler() *Handler {
	return &Handler{}
}

var itemsEvents = map[string][]EventHandlerFunc{}

// EventHandlerFunc is a function that can process a directus event
type EventHandlerFunc func(ctx context.Context, collection string, id string) error

// On event, do this:
func (handler *Handler) On(events []string, callback EventHandlerFunc) {
	for _, event := range events {
		switch event {
		case EventItemsUpdate, EventItemsCreate, EventItemsDelete:
			log.L.Debug().Str("event", event).Msg("Registering webhook-listener for event")
			itemsEvents[event] = append(itemsEvents[event], callback)
		}
	}
}

// Sentinel errors
var (
	// ErrErrorDuringProcessing returns a sentinel error for processing errors
	ErrErrorDuringProcessing = merry.Sentinel("Error while processing event")
)

// ProcessCloudEvent creates an Event from CloudEvent
func (handler *Handler) ProcessCloudEvent(ctx context.Context, e cevent.Event) error {
	var event Event
	err := e.DataAs(&event)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to bind to event struct")
		return err
	}

	errors := handler.Process(ctx, event)
	if len(errors) > 0 {
		log.L.Error().Errs("directus handler errors", errors).Msg("Errors while processing event")
		return merry.Wrap(ErrErrorDuringProcessing)
	}

	return nil
}

// Process Event
func (handler *Handler) Process(ctx context.Context, event Event) []error {
	log.L.Debug().Str("event", event.Event).Str("collection", event.Collection).Msg("Processing event")
	var errors []error

	var id = event.ID
	if id == "" {
		return errors
	}

	switch event.Event {
	case EventItemsUpdate, EventItemsCreate, EventItemsDelete:
		for i, handlerFunc := range itemsEvents[event.Event] {
			log.L.Debug().Msgf("Executing callback #%d for event %s", i, event.Event)
			err := handlerFunc(ctx, event.Collection, id)
			if err != nil {
				errors = append(errors, err)
			}
		}
	}

	return errors
}
