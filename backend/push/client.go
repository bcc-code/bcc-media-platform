package push

import (
	"context"
	"firebase.google.com/go"
)

type Service struct {
	app *firebase.App
}

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

func (s *Service) SendPushNotification(ctx context.Context) {
	//client, err := s.app.Messaging(ctx)
	//if err != nil {
	//	return
	//}
	//message :=
}
