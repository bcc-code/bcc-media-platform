package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
)

func getTask(ctx context.Context, resolver *Resolver, taskID string) (*common.Task, error) {
	uid, err := uuid.Parse(taskID)
	if err != nil {
		return nil, err
	}
	task, err := resolver.Loaders.StudyTaskLoader.Get(ctx, uid)
	if err != nil {
		return nil, err
	}
	if task == nil {
		return nil, ErrItemNotFound
	}
	return task, nil
}
