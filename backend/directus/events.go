package directus

import (
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"github.com/samber/lo"
	"strconv"
)

type Event struct {
	Event          string        `json:"event"`
	Accountability any           `json:"accountability"`
	Payload        any           `json:"payload"`
	Collection     string        `json:"collection"`
	Keys           []interface{} `json:"keys"`
	Key            int           `json:"key"`
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

var itemsEvents = map[string][]func(model string, id int){}

func (handler *EventHandler) On(events []string, callback func(model string, id int)) {
	for _, event := range events {
		switch event {
		case EventItemsUpdate, EventItemsCreate, EventItemsDelete:
			log.L.Debug().Msgf("Registering Directus webhook-listener for event: \"%s\"", event)
			itemsEvents[event] = append(itemsEvents[event], callback)
		}
	}
}

func (handler *EventHandler) Execute(c *gin.Context) {
	var event Event
	err := c.BindJSON(&event)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to bind JSON to event")
		return
	}

	log.L.Debug().Msgf("Processing event: %s\nCollection: %s\n", event.Event, event.Collection)

	model := getModelFromCollectionName(event.Collection)
	if model == "" {
		log.L.Debug().Msg("Collection not supported yet")
		return
	}

	var ids []int
	if !(len(event.Keys) > 0) && event.Key != 0 {
		ids = []int{event.Key}
	} else {
		// Directus returns either floats or strings in the same array... weird?
		ids = lo.Map(event.Keys, func(entry interface{}, _ int) int {
			var id int
			switch v := entry.(type) {
			case int:
				id = v
			case float64:
				id = int(v)
			case string:
				num, _ := strconv.ParseInt(v, 0, 64)
				id = int(num)
			}
			return id
		})
	}

	for _, id := range ids {
		switch event.Event {
		case EventItemsUpdate, EventItemsCreate, EventItemsDelete:
			for i, callback := range itemsEvents[event.Event] {
				log.L.Debug().Msgf("Executing callback #%d for event %s", i, event.Event)
				callback(model, id)
			}
		}
	}
}

func NewEventHandler() *EventHandler {
	return &EventHandler{}
}
