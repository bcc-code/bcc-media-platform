package queue

import (
	cloudtasks "cloud.google.com/go/cloudtasks/apiv2"
	"cloud.google.com/go/cloudtasks/apiv2/cloudtaskspb"
	"context"
	"encoding/json"
	"google.golang.org/protobuf/types/known/timestamppb"
	"time"
)

// Service contains the base url for the endpoints
type Service struct {
	queueID  string
	endpoint string
}

// New returns a new Service
func New(endpoint string, queueID string) *Service {
	return &Service{
		queueID:  queueID,
		endpoint: endpoint,
	}
}

// QueuedItem contains basic data
type QueuedItem struct {
	Collection string
	ID         string
}

// Queue a specific message
func (s *Service) Queue(collection string, id string, at time.Time) error {
	ctx := context.Background()

	client, _ := cloudtasks.NewClient(ctx)

	task := &cloudtaskspb.CreateTaskRequest{
		Parent: s.queueID,
		Task: &cloudtaskspb.Task{
			Name: "Notification",
			ScheduleTime: &timestamppb.Timestamp{
				Seconds: at.Unix(),
			},
			MessageType: &cloudtaskspb.Task_HttpRequest{
				HttpRequest: &cloudtaskspb.HttpRequest{
					HttpMethod: cloudtaskspb.HttpMethod_POST,
					Url:        s.endpoint,
				},
			},
		},
	}

	body, err := json.Marshal(QueuedItem{Collection: collection, ID: id})

	if err != nil {
		return err
	}

	task.Task.GetHttpRequest().Body = body

	_, err = client.CreateTask(ctx, task)

	return err
}
