package push

import (
	"context"
	"firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo/parallel"
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

func notificationToPayload(notification common.Notification) map[string]string {
	var payload = map[string]string{}
	for lan, val := range notification.Title {
		if val.Valid {
			payload["title_"+lan] = val.ValueOrZero()
		}
	}
	for lan, val := range notification.Description {
		if val.Valid {
			payload["description_"+lan] = val.ValueOrZero()
		}
	}
	for lan, val := range notification.Image {
		if val != "" {
			payload["image_"+lan] = val
		}
	}
	return payload
}

// SendNotificationToDevices sends a push notification to the specified tokens
func (s *Service) SendNotificationToDevices(ctx context.Context, deviceTokens []string, notification common.Notification) error {
	// TODO: actually implement notifications, not this placeholder things
	client, err := s.app.Messaging(ctx)
	if err != nil {
		return err
	}

	var messages []*messaging.Message

	data := notificationToPayload(notification)

	for _, t := range deviceTokens {
		messages = append(messages, &messaging.Message{
			Data:  data,
			Token: t,
		})
	}

	const maxConcurrent = 200

	var ranges [][]*messaging.Message

	for i := 0; i < len(messages); i += maxConcurrent {
		var r int
		if i+maxConcurrent > len(messages) {
			r = len(messages)
		} else {
			r = i + maxConcurrent
		}
		ranges = append(ranges, messages[i:r])
	}

	errors := parallel.Map(ranges, func(r []*messaging.Message, _ int) error {
		res, err := client.SendAll(ctx, r)
		//TODO: Implement error checking
		if err != nil {
			return err
		}
		if res.FailureCount > 0 {
			return merry.New("Failure-count is not zero")
		}
		return nil
	})

	if len(errors) > 0 {
		return errors[0]
	}
	return nil
}
