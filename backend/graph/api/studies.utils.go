package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
)

func isLessonLockedByPrevious(ctx context.Context, r *lessonResolver, obj *model.Lesson) (bool, error) {
	pr, err := r.Previous(ctx, obj)
	if err != nil {
		return false, err
	}
	if pr == nil {
		return false, nil
	}
	prCompleted, err := r.Completed(ctx, pr)
	if err != nil {
		return false, err
	}
	return !prCompleted, nil
}

func isLessonLockedByEpisode(ctx context.Context, r *lessonResolver, lesson *model.Lesson) (bool, error) {
	episode, err := r.DefaultEpisode(ctx, lesson)
	if err != nil {
		return false, err
	}
	if episode == nil {
		return false, nil
	}
	return r.Episode().Locked(ctx, episode)
}
