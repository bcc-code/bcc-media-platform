package events

import (
	"context"
	"strconv"
	"time"

	firebase "firebase.google.com/go/v4"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/samber/lo"
)

// Service contains multiple functions for handling and publishing events
type Service struct {
	app     *firebase.App
	queries *sqlc.Queries
}

// NewService returns a new service
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

// HandleModelUpdate handles updates
func (s *Service) HandleModelUpdate(ctx context.Context, collection string, key string) error {
	realItems, err := s.getEventItems(ctx, collection, key)
	if err != nil {
		return err
	}
	for _, ri := range realItems {
		err = s.publishModelUpdate(ctx, ri.Collection, ri.ID)
		if err != nil {
			return err
		}
	}
	return nil
}

type realItem struct {
	ID         string
	Collection string
}

func (s *Service) getEventItems(ctx context.Context, collection string, id string) ([]*realItem, error) {
	switch collection {
	case "sections":
		return []*realItem{{ID: id, Collection: collection}}, nil
	case "surveys":
		return []*realItem{{ID: id, Collection: collection}}, nil
	case "surveyquestions":
		surveyID, err := s.queries.GetSurveyIDFromQuestionID(ctx, utils.AsUuid(id))
		if err != nil {
			return nil, err
		}
		return []*realItem{{ID: surveyID.String(), Collection: "surveys"}}, nil
	case "messages":
		ids, err := s.queries.GetSectionIDsWithMessageIDs(ctx, []int32{int32(utils.AsInt(id))})
		if err != nil {
			return nil, err
		}
		return lo.Map(ids, func(i int32, _ int) *realItem {
			return &realItem{
				ID:         strconv.Itoa(int(i)),
				Collection: "sections",
			}
		}), nil
	case "prompts":
		return []*realItem{{ID: id, Collection: collection}}, nil
	case "applicationgroups":
		// map applicationgroups to applications
		applications, err := s.queries.ListApplications(ctx)
		if err != nil {
			return nil, err
		}
		uid := utils.AsUuid(id)
		var realItems []*realItem
		for _, app := range applications {
			if app.GroupID == uid {
				realItems = append(realItems, &realItem{
					Collection: "applications",
					ID:         app.Code,
				})
			}
		}
		return realItems, nil
	default:
		return nil, nil
	}
}

func (s *Service) publishModelUpdate(ctx context.Context, collection string, id string) error {
	date := time.Now().Truncate(time.Second * 1)
	dateString := date.Format(time.RFC3339)

	return s.publishModelUpdateToFirestore(ctx, collection, id, firestoreEvent{
		Updated: dateString,
	})
}

type firestoreEvent struct {
	Updated string `json:"updated"`
}

func (s *Service) publishModelUpdateToFirestore(ctx context.Context, collection string, key string, value firestoreEvent) error {
	client, err := s.app.Firestore(ctx)
	if err != nil {
		return err
	}

	_, err = client.Collection("updates:"+collection).Doc(key).Set(ctx, value)

	if err != nil {
		return err
	}

	return client.Close()
}
