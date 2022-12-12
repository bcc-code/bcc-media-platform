package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
	"strconv"
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

func getEpisode(ctx context.Context, resolver *Resolver, episodeID string) (*common.Episode, error) {
	id, err := strconv.ParseInt(episodeID, 10, 64)
	if err != nil {
		return nil, err
	}
	episode, err := batchloaders.GetByID(ctx, resolver.Loaders.EpisodeLoader, int(id))
	if err != nil {
		return nil, err
	}
	if episode == nil {
		return nil, ErrItemNotFound
	}
	return episode, nil
}
