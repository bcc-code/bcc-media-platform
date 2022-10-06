package push

import (
	"context"
	"firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/davecgh/go-spew/spew"
)

// Service is the struct containing the firebase app and methods for interacting with messaging
type Service struct {
	app *firebase.App
}

// NewService returns a new instance of the push service
func NewService(ctx context.Context, firebaseProjectID string) (*Service, error) {
	app, err := firebase.NewApp(ctx, &firebase.Config{
		ProjectID: firebaseProjectID,
	})
	if err != nil {
		return nil, err
	}
	return &Service{
		app,
	}, nil
}

// SendPushNotification sends a push notification to the specified tokens
func (s *Service) SendPushNotification(ctx context.Context, tokens []string) {
	// TODO: actually implement notifications, not this placeholder things
	client, err := s.app.Messaging(ctx)
	if err != nil {
		return
	}

	var messages []*messaging.Message

	for _, t := range tokens {
		messages = append(messages, &messaging.Message{
			Data: nil,
			Notification: &messaging.Notification{
				Title: "Notification title",
				Body:  "This is the content for this notification",
			},
			Android:    nil,
			Webpush:    nil,
			APNS:       nil,
			FCMOptions: nil,
			Token:      t,
			Topic:      "",
			Condition:  "",
		})
	}

	res, err := client.SendAll(ctx, messages)
	log.L.Debug().Str("result", spew.Sdump(res)).Msg("notification sent result")
}
