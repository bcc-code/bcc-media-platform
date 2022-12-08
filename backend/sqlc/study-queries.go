package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
	"strconv"
)

// GetTopics returns studies
func (q *Queries) GetTopics(ctx context.Context, ids []uuid.UUID) ([]common.StudyTopic, error) {
	topics, err := q.getTopics(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(topics, func(t getTopicsRow, _ int) common.StudyTopic {
		var title = common.LocaleString{}
		_ = json.Unmarshal(t.Title.RawMessage, &title)

		if t.OriginalTitle != "" {
			title["no"] = null.StringFrom(t.OriginalTitle)
		}

		return common.StudyTopic{
			ID:    t.ID,
			Title: title,
		}
	}), nil
}

// GetLessons returns lessons by ids
func (q *Queries) GetLessons(ctx context.Context, ids []uuid.UUID) ([]common.Lesson, error) {
	lessons, err := q.getLessons(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(lessons, func(l getLessonsRow, _ int) common.Lesson {
		var title = common.LocaleString{}
		_ = json.Unmarshal(l.Title.RawMessage, &title)

		if l.OriginalTitle != "" {
			title["no"] = null.StringFrom(l.OriginalTitle)
		}

		return common.Lesson{
			ID:      l.ID,
			TopicID: l.TopicID,
			Title:   title,
		}
	}), nil
}

// GetTasks returns tasks by ids
func (q *Queries) GetTasks(ctx context.Context, ids []uuid.UUID) ([]common.Task, error) {
	tasks, err := q.getTasks(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(tasks, func(l getTasksRow, _ int) common.Task {
		var title = common.LocaleString{}
		_ = json.Unmarshal(l.Title.RawMessage, &title)

		if l.OriginalTitle.Valid {
			title["no"] = l.OriginalTitle
		}

		var multiSelect null.Bool
		if l.AlternativesMultiselect.Valid {
			multiSelect.SetValid(l.AlternativesMultiselect.Bool)
		}

		return common.Task{
			ID:           l.ID,
			LessonID:     l.LessonID,
			Title:        title,
			QuestionType: l.QuestionType.String,
			Type:         l.Type,
			MultiSelect:  multiSelect,
		}
	}), nil
}

// GetQuestionAlternatives returns alternatives for the specified questions
func (q *Queries) GetQuestionAlternatives(ctx context.Context, ids []uuid.UUID) ([]common.QuestionAlternative, error) {
	alts, err := q.getQuestionAlternatives(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(alts, func(alt getQuestionAlternativesRow, _ int) common.QuestionAlternative {
		var title = common.LocaleString{}
		_ = json.Unmarshal(alt.Title.RawMessage, &title)

		if alt.OriginalTitle.Valid {
			title["no"] = alt.OriginalTitle
		}

		return common.QuestionAlternative{
			Title:     title,
			TaskID:    alt.TaskID.UUID,
			ID:        alt.ID,
			IsCorrect: alt.IsCorrect,
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

// GetLessonIDsForEpisodes returns lessons for episodes
func (rq *RoleQueries) GetLessonIDsForEpisodes(ctx context.Context, ids []int) ([]batchloaders.Relation[uuid.UUID, int], error) {
	rows, err := rq.queries.getLessonsForItemsInCollection(ctx, getLessonsForItemsInCollectionParams{
		Collection: null.StringFrom("episodes"),
		Column2: lo.Map(ids, func(i int, _ int) string {
			return strconv.Itoa(i)
		}),
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getLessonsForItemsInCollectionRow, _ int) batchloaders.Relation[uuid.UUID, int] {
		p, _ := strconv.ParseInt(i.ParentID.String, 10, 64)
		return relation[uuid.UUID, int]{
			ID:       i.ID.UUID,
			ParentID: int(p),
		}
	}), nil
}

// GetEpisodeIDsForLessons returns episodes for lessons
func (rq *RoleQueries) GetEpisodeIDsForLessons(ctx context.Context, ids []uuid.UUID) ([]batchloaders.Relation[int, uuid.UUID], error) {
	rows, err := rq.queries.getEpisodesForLessons(ctx, getEpisodesForLessonsParams{
		Column1: ids,
		Column2: rq.roles,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getEpisodesForLessonsRow, _ int) batchloaders.Relation[int, uuid.UUID] {
		p, _ := strconv.ParseInt(i.ID.String, 10, 64)
		return relation[int, uuid.UUID]{
			ID:       int(p),
			ParentID: i.ParentID.UUID,
		}
	}), nil
}
