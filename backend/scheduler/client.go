package scheduler

import (
	cloudtasks "cloud.google.com/go/cloudtasks/apiv2"
	"cloud.google.com/go/cloudtasks/apiv2/cloudtaskspb"
	"context"
	"encoding/json"
	"errors"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"google.golang.org/api/iterator"
	"google.golang.org/protobuf/types/known/timestamppb"
	"strings"
	"time"
)

// ItemCallback is the type of the callback functions
type ItemCallback func(ctx context.Context, item QueuedItem) error

// Service contains the base url for the endpoints
type Service struct {
	queueID  string
	endpoint string

	onRequest []ItemCallback
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
	Collection string `json:"collection"`
	ID         string `json:"id"`
}

// Queue a specific message
func (s *Service) Queue(ctx context.Context, collection string, id string, at time.Time) error {
	client, _ := cloudtasks.NewClient(ctx)

	it := client.ListTasks(ctx, &cloudtaskspb.ListTasksRequest{
		Parent: s.queueID,
	})

	taskName := s.queueID + "/tasks/" + collection + "-" + id

	for {
		resp, err := it.Next()
		if errors.Is(err, iterator.Done) {
			break
		}
		if err != nil {
			log.L.Error().Err(err).Send()
			break
		}
		if !strings.HasPrefix(resp.GetName(), taskName) {
			log.L.Debug().Str("name", resp.GetName()).Msg("Ignoring existing task")
			continue
		}
		if resp.ScheduleTime.AsTime().Equal(at) {
			return nil
		}
		log.L.Debug().Str("name", resp.GetName()).Msg("Deleting existing task")
		err = client.DeleteTask(ctx, &cloudtaskspb.DeleteTaskRequest{
			Name: resp.Name,
		})
		if err != nil {
			return err
		}
	}

	task := &cloudtaskspb.CreateTaskRequest{
		Parent: s.queueID,
		Task: &cloudtaskspb.Task{
			Name: taskName + "-" + utils.GenerateRandomSecureString(6),
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
	log.L.Debug().Str("name", task.Task.Name).Msg("Creating task")

	body, err := json.Marshal(QueuedItem{Collection: collection, ID: id})

	if err != nil {
		return err
	}

	task.Task.GetHttpRequest().Body = body

	_, err = client.CreateTask(ctx, task)

	return err
}

// OnRequest register a callback to trigger when the task is returned
func (s *Service) OnRequest(callback ItemCallback) {
	s.onRequest = append(s.onRequest, callback)
}

// HandleRequest handles the request after it has been returned
func (s *Service) HandleRequest(ctx *gin.Context) []error {
	var body QueuedItem
	err := ctx.BindJSON(&body)
	if err != nil {
		return []error{err}
	}

	var errors []error
	for _, cb := range s.onRequest {
		err = cb(ctx, body)
		if err != nil {
			errors = append(errors, err)
		}
	}
	return errors
}
