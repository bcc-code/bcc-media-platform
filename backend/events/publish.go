package events

import (
	"context"
	firebase "firebase.google.com/go"
	"time"
)

// Service contains multiple functions for handling and publishing events
type Service struct {
	app *firebase.App
}

// NewService returns a new service
func NewService(ctx context.Context, projectID string) (*Service, error) {
	app, err := firebase.NewApp(ctx, &firebase.Config{
		ProjectID: projectID,
	})
	if err != nil {
		return nil, err
	}
	return &Service{
		app,
	}, nil
}

// HandleModelUpdate handles updates
func (s *Service) HandleModelUpdate(ctx context.Context, collection string, id int) error {
	return s.publishUpdate(ctx, collection)
}

func getEventNameFromCollection(collection string) (string, bool) {
	switch collection {
	case "globalconfig":
		return "config-global", true
	case "webconfig":
		return "config-web", true
	case "appconfig":
		return "config-app", true
	case "maintenancemessage":
		return "messages-maintenance", true
	}
	return "", false
}

func (s *Service) publishUpdate(ctx context.Context, collection string) error {
	event, ok := getEventNameFromCollection(collection)
	if !ok {
		return nil
	}

	date := time.Now().Truncate(time.Second * 1)
	dateString := date.Format(time.RFC3339)

	return s.publishToFirestore(ctx, event, firestoreEvent{
		Updated: dateString,
	})
}

type firestoreEvent struct {
	Updated string `json:"updated"`
}

func (s *Service) publishToFirestore(ctx context.Context, key string, value firestoreEvent) error {
	client, err := s.app.Firestore(ctx)
	if err != nil {
		return err
	}

	_, err = client.Collection("events").Doc(key).Set(ctx, value)

	if err != nil {
		return err
	}

	return client.Close()
}
