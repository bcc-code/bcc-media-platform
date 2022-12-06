package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/studies"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// GetTopics returns studies
func (q *Queries) GetTopics(ctx context.Context, ids []uuid.UUID) ([]studies.Topic, error) {
	topics, err := q.getTopics(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(topics, func(t getTopicsRow, _ int) studies.Topic {
		var title common.LocaleString
		_ = json.Unmarshal(t.Title.RawMessage, &title)
		return studies.Topic{
			ID:    t.ID,
			Title: title,
		}
	}), nil
}

// GetLessons returns lessons by ids
func (q *Queries) GetLessons(ctx context.Context, ids []uuid.UUID) ([]studies.Lesson, error) {
	lessons, err := q.getLessons(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(lessons, func(l getLessonsRow, _ int) studies.Lesson {
		return studies.Lesson{
			ID:      l.ID,
			TopicID: l.TopicID,
		}
	}), nil
}

// GetTasks returns tasks by ids
func (q *Queries) GetTasks(ctx context.Context, ids []uuid.UUID) ([]studies.Task, error) {
	tasks, err := q.getTasks(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(tasks, func(l getTasksRow, _ int) studies.Task {
		return studies.Task{
			ID:       l.ID,
			LessonID: l.LessonID,
		}
	}), nil
}

type relation[K comparable, KR comparable] struct {
	ID       K
	ParentID KR
}

// GetKey returns key
func (r relation[K, KR]) GetKey() K {
	return r.ID
}

// GetRelationID returns the related id
func (r relation[K, KR]) GetRelationID() KR {
	return r.ParentID
}

// GetTaskIDsForLessons retrieves related ids
func (rq *RoleQueries) GetTaskIDsForLessons(ctx context.Context, ids []uuid.UUID) ([]batchloaders.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := rq.queries.getTasksForLessons(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(r getTasksForLessonsRow, _ int) batchloaders.Relation[uuid.UUID, uuid.UUID] {
		return relation[uuid.UUID, uuid.UUID](r)
	}), nil
}

// GetLessonIDsForTopics retrieves related ids
func (rq *RoleQueries) GetLessonIDsForTopics(ctx context.Context, ids []uuid.UUID) ([]batchloaders.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := rq.queries.getLessonsForTopics(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(r getLessonsForTopicsRow, _ int) batchloaders.Relation[uuid.UUID, uuid.UUID] {
		return relation[uuid.UUID, uuid.UUID](r)
	}), nil
}

// GetTaskIDsWithRoles filters the specified IDs with roles
func (rq *RoleQueries) GetTaskIDsWithRoles(ctx context.Context, ids []uuid.UUID) ([]uuid.UUID, error) {
	// TODO: implement filtering
	return ids, nil
}

// GetTopicIDsWithRoles filters the specified IDs with roles
func (rq *RoleQueries) GetTopicIDsWithRoles(ctx context.Context, ids []uuid.UUID) ([]uuid.UUID, error) {
	// TODO: implement filtering
	return ids, nil
}

// GetLessonIDsWithRoles filters the specified IDs with roles
func (rq *RoleQueries) GetLessonIDsWithRoles(ctx context.Context, ids []uuid.UUID) ([]uuid.UUID, error) {
	// TODO: implement filtering
	return ids, nil
}
