package push

import (
	"context"
	"firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/samber/lo"
	"github.com/samber/lo/parallel"
)

// Service is the struct containing the firebase app and methods for interacting with messaging
type Service struct {
	app     *firebase.App
	queries *sqlc.Queries
}

// NewService returns a new instance of the push service
func NewService(ctx context.Context, firebaseProjectID string, queries *sqlc.Queries) (*Service, error) {
	app, err := firebase.NewApp(ctx, &firebase.Config{
		ProjectID: firebaseProjectID,
	})
	if err != nil {
		return nil, err
	}

	service := &Service{
		app,
		queries,
	}

	return service, nil
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
	for lan, val := range notification.Images {
		if val.Valid {
			payload["image_"+lan] = val.String
		}
	}
	return payload
}

func (s *Service) pushMessages(ctx context.Context, messages []*messaging.Message) error {
	client, err := s.app.Messaging(ctx)
	if err != nil {
		return err
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
		if r == 0 {
			break
		}
		ranges = append(ranges, messages[i:r])
	}

	errors := parallel.Map(ranges, func(r []*messaging.Message, _ int) []error {
		res, err := client.SendAll(ctx, r)
		//TODO: Implement error handling
		if err != nil {
			return []error{err}
		}
		// Just return errors for now. This part filters the responses and only returns errors that arent nil.
		return lo.Map(lo.Filter(res.Responses, func(r *messaging.SendResponse, _ int) bool {
			return r.Error != nil
		}), func(r *messaging.SendResponse, _ int) error {
			return r.Error
		})
	})

	for _, errs := range errors {
		if len(errs) > 0 {
			log.L.Error().Errs("errors", errs).Msg("Errors occurred when sending messages")
		}
	}

	return nil
}

func (s *Service) pushMessage(ctx context.Context, message *messaging.Message) error {
	return s.pushMessages(ctx, []*messaging.Message{message})
}

// SendNotificationToDevices sends a push notification to the specified tokens
func (s *Service) SendNotificationToDevices(ctx context.Context, devices []common.Device, notification common.Notification) error {
	var messages []*messaging.Message

	var data = map[string]string{}

	if notification.Action.Valid {
		data["action"] = notification.Action.String
		switch notification.Action.String {
		case "deep_link":
			data["deep_link"] = notification.DeepLink.String
		}
	}

	for _, d := range devices {
		messages = append(messages, &messaging.Message{
			Data: data,
			Notification: &messaging.Notification{
				Title:    notification.Title.Get(d.Languages),
				Body:     notification.Description.Get(d.Languages),
				ImageURL: notification.Images.Get(d.Languages).ValueOrZero(),
			},
			Token: d.Token,
		})
	}

	return s.pushMessages(ctx, messages)
}

// PushNotificationToEveryone pushes a notification to every registered device
func (s *Service) PushNotificationToEveryone(ctx context.Context, notification common.Notification) error {
	devices, err := s.queries.ListDevices(ctx)
	if err != nil {
		return err
	}
	return s.SendNotificationToDevices(ctx, devices, notification)
}
