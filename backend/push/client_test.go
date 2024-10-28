package push

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"gopkg.in/guregu/null.v4"
	"os"
	"testing"
)

func TestSendMessage(t *testing.T) {

	if os.Getenv("FIREBASE_PROJECT_ID") == "" {
		t.Skip("FIREBASE_PROJECT_ID not set. Not attempting to send message")
	}

	if os.Getenv("DEVICE_PUSH_TOKEN") == "" {
		t.Skip("DEVICE_PUSH_TOKEN not set. Not attempting to send message")
	}

	ctx := context.Background()
	service, err := NewService(ctx, os.Getenv("FIREBASE_PROJECT_ID"), &sqlc.Queries{})

	if err != nil {
		t.Fatal(err)
	}

	err = service.SendNotificationToDevices(ctx, []common.Device{
		common.Device{
			Token: os.Getenv("DEVICE_PUSH_TOKEN"),
		},
	}, common.Notification{
		Title: map[string]null.String{
			"en": null.StringFrom("test"),
		},
	})

	if err != nil {
		t.Fatal(err)
	}
}
