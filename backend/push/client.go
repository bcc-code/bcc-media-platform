package push

import (
	"context"
	"os"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/messaging"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
)

// Service is the struct containing the firebase app and methods for interacting with messaging
type Service struct {
	app     *firebase.App
	queries *sqlc.Queries
	dryRun  bool
}

// NewService returns a new instance of the push service
func NewService(ctx context.Context, firebaseProjectID string, queries *sqlc.Queries) (*Service, error) {
	app, err := firebase.NewApp(ctx, &firebase.Config{
		ProjectID: firebaseProjectID,
	})

	if err != nil {
		return nil, err
	}

	dryRun := os.Getenv("PUSH_DRY_RUN") == "true"

	service := &Service{
		app:     app,
		queries: queries,
		dryRun:  dryRun,
	}

	return service, nil
}

type failedToken struct {
	Error error
	Token string
}

func (s *Service) batchSendMessages(ctx context.Context, r []*messaging.Message) ([]failedToken, error) {
	client, err := s.app.Messaging(ctx)
	if err != nil {
		return nil, err
	}
	sendF := client.SendEach
	if s.dryRun {
		sendF = client.SendEachDryRun
	}

	res, err := sendF(ctx, r)
	if err != nil {
		return nil, err
	}

	var failedTokens []failedToken
	for index, sr := range res.Responses {
		if sr.Error != nil {
			failedTokens = append(failedTokens, failedToken{
				Error: sr.Error,
				Token: r[index].Token,
			})
		}
	}

	return failedTokens, nil
}

func (s *Service) pushMessages(ctx context.Context, messages []*messaging.Message) error {

	const maxConcurrent = 450

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

	var unregisterTokens []string

	for _, r := range ranges {
		failedTokens, err := s.batchSendMessages(ctx, r)
		if err != nil {
			log.L.Error().Err(err).Send()
		}
		for _, t := range failedTokens {
			if messaging.IsUnregistered(t.Error) {
				unregisterTokens = append(unregisterTokens, t.Token)
			} else {
				log.L.Warn().Err(t.Error).Send()
			}
		}
	}

	if len(unregisterTokens) > 0 {
		return s.queries.DeleteDevices(ctx, unregisterTokens)
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

	androidPriority := "normal"
	if notification.HighPriority {
		androidPriority = "high"
	}

	for _, d := range devices {
		messages = append(messages, &messaging.Message{
			Data: data,
			//APNS: &messaging.APNSConfig{
			//	Headers: apnsHeaders,
			//},
			Android: &messaging.AndroidConfig{
				Priority: androidPriority,
			},
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
