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
	return &Service{
		app,
		queries,
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
func (s *Service) SendNotificationToDevices(ctx context.Context, deviceTokens []string, notification common.Notification) error {
	var messages []*messaging.Message

	data := notificationToPayload(notification)

	for _, t := range deviceTokens {
		messages = append(messages, &messaging.Message{
			Data:  data,
			Token: t,
		})
	}

	return s.pushMessages(ctx, messages)
}

// SendNotificationToTopic sends a notification to devices subscribed to a topic
func (s *Service) SendNotificationToTopic(ctx context.Context, topic string, notification common.Notification) error {
	return s.pushMessage(ctx, &messaging.Message{
		Data:  notificationToPayload(notification),
		Topic: topic,
	})
}

func (s *Service) pushNotification(ctx context.Context, notification common.Notification) {
	tokens, err := s.queries.ListDeviceTokens(ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Error occurred trying to fetch device tokens")
		return
	}
	err = s.SendNotificationToDevices(ctx, tokens, notification)
	if err != nil {
		log.L.Error().Err(err).Msg("Error occurred pushing notifications")
	}
}

// HandleModelUpdate handles model updates
func (s *Service) HandleModelUpdate(ctx context.Context, collection string, key int) error {
	switch collection {
	case "notifications":
		ns, err := s.queries.GetNotifications(ctx, []int{key})
		if err != nil {
			return err
		}
		for _, n := range ns {
			if n.Status != common.StatusPublished {
				continue
			}
			s.pushNotification(ctx, n)
		}
	}

	return nil
}
