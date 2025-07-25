package sqlc

import (
	"context"
	"encoding/json"
	"strconv"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

// GetTopics returns studies
func (q *Queries) GetTopics(ctx context.Context, ids []uuid.UUID) ([]common.StudyTopic, error) {
	topics, err := q.getTopics(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(topics, func(t getTopicsRow, _ int) common.StudyTopic {
		var title = common.LocaleString{}
		var description = common.LocaleString{}
		_ = json.Unmarshal(t.Title.RawMessage, &title)
		_ = json.Unmarshal(t.Description.RawMessage, &description)

		if t.OriginalTitle != "" {
			title["no"] = null.StringFrom(t.OriginalTitle)
		}
		if t.OriginalDescription.String != "" {
			description["no"] = t.OriginalDescription
		}

		return common.StudyTopic{
			ID:          t.ID,
			Title:       title,
			Description: description,
			Images:      q.getImages(t.Images.RawMessage),
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
		var description = common.LocaleString{}
		_ = json.Unmarshal(l.Title.RawMessage, &title)
		_ = json.Unmarshal(l.Description.RawMessage, &description)

		if l.OriginalTitle != "" {
			title["no"] = null.StringFrom(l.OriginalTitle)
		}
		if l.OriginalDescription.Valid {
			description["no"] = l.OriginalDescription
		}

		return common.Lesson{
			ID:              l.ID,
			TopicID:         l.TopicID,
			Title:           title,
			Description:     description,
			Images:          q.getImages(l.Images.RawMessage),
			IntroScreenCode: l.IntroScreenCode,
			ShowDiscover:    l.ShowDiscoverPage,
		}
	}), nil
}

func localeStringOrFallback(marshalled json.RawMessage, fallback null.String) common.LocaleString {
	var localeString = common.LocaleString{}
	_ = json.Unmarshal(marshalled, &localeString)

	if fallback.Valid {
		localeString["no"] = fallback
	}

	return localeString
}

// GetTasks returns tasks by ids
func (q *Queries) GetTasks(ctx context.Context, ids []uuid.UUID) ([]common.Task, error) {
	tasks, err := q.getTasks(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(tasks, func(l getTasksRow, _ int) common.Task {
		title := localeStringOrFallback(l.Title.RawMessage, l.OriginalTitle)
		secondaryTitle := localeStringOrFallback(l.SecondaryTitle.RawMessage, l.OriginalSecondaryTitle)
		description := localeStringOrFallback(l.Description.RawMessage, l.OriginalDescription)

		var images = common.LocaleMap[string]{}
		_ = json.Unmarshal(l.Images.RawMessage, &images)

		imagesWithUrl := common.LocaleMap[string]{}
		for key, value := range images {
			imagesWithUrl[key] = q.filenameToImageURL(value)
		}

		var multiSelect null.Bool
		if l.AlternativesMultiselect.Valid {
			multiSelect.SetValid(l.AlternativesMultiselect.Bool)
		}

		return common.Task{
			ID:              l.ID,
			LessonID:        l.LessonID,
			Title:           title,
			SecondaryTitle:  secondaryTitle,
			Description:     description,
			QuestionType:    l.QuestionType.String,
			ImageType:       l.ImageType.String,
			Images:          imagesWithUrl,
			EpisodeID:       l.EpisodeID,
			LinkID:          l.LinkID,
			Type:            l.Type,
			MultiSelect:     multiSelect,
			ShowAnswer:      l.ShowAnswer,
			LockAnswer:      l.LockAnswer,
			CompetitionMode: (!l.ShowAnswer) && (l.LockAnswer),
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
func (rq *RoleQueries) GetTaskIDsForLessons(ctx context.Context, ids []uuid.UUID) ([]common.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := rq.queries.getTasksForLessons(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(r getTasksForLessonsRow, _ int) common.Relation[uuid.UUID, uuid.UUID] {
		return relation[uuid.UUID, uuid.UUID](r)
	}), nil
}

// GetLessonIDsForTopics retrieves related ids
func (rq *RoleQueries) GetLessonIDsForTopics(ctx context.Context, ids []uuid.UUID) ([]common.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := rq.queries.getLessonsForTopics(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(r getLessonsForTopicsRow, _ int) common.Relation[uuid.UUID, uuid.UUID] {
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
func (rq *RoleQueries) GetLessonIDsForEpisodes(ctx context.Context, ids []int) ([]common.Relation[uuid.UUID, int], error) {
	rows, err := rq.queries.getLessonsForItemsInCollection(ctx, getLessonsForItemsInCollectionParams{
		Collection: "episodes",
		Column2: lo.Map(ids, func(i int, _ int) string {
			return strconv.Itoa(i)
		}),
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getLessonsForItemsInCollectionRow, _ int) common.Relation[uuid.UUID, int] {
		p, _ := strconv.ParseInt(i.ParentID, 10, 64)
		return relation[uuid.UUID, int]{
			ID:       i.ID,
			ParentID: int(p),
		}
	}), nil
}

// GetLessonIDsForLinks returns lessons for episodes
func (rq *RoleQueries) GetLessonIDsForLinks(ctx context.Context, ids []int) ([]common.Relation[uuid.UUID, int], error) {
	rows, err := rq.queries.getLessonsForItemsInCollection(ctx, getLessonsForItemsInCollectionParams{
		Collection: "links",
		Column2: lo.Map(ids, func(i int, _ int) string {
			return strconv.Itoa(i)
		}),
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getLessonsForItemsInCollectionRow, _ int) common.Relation[uuid.UUID, int] {
		p, _ := strconv.ParseInt(i.ParentID, 10, 64)
		return relation[uuid.UUID, int]{
			ID:       i.ID,
			ParentID: int(p),
		}
	}), nil
}

// GetEpisodeIDsForLessons returns episodes for lessons
func (rq *RoleQueries) GetEpisodeIDsForLessons(ctx context.Context, ids []uuid.UUID) ([]common.Relation[int, uuid.UUID], error) {
	rows, err := rq.queries.getEpisodesForLessons(ctx, getEpisodesForLessonsParams{
		Column1: ids,
		Column2: rq.roles,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getEpisodesForLessonsRow, _ int) common.Relation[int, uuid.UUID] {
		p, _ := strconv.ParseInt(i.ID, 10, 64)
		return relation[int, uuid.UUID]{
			ID:       int(p),
			ParentID: i.ParentID,
		}
	}), nil
}

// GetLinkIDsForLessons returns episodes for lessons
func (rq *RoleQueries) GetLinkIDsForLessons(ctx context.Context, ids []uuid.UUID) ([]common.Relation[int, uuid.UUID], error) {
	rows, err := rq.queries.getLinksForLessons(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getLinksForLessonsRow, _ int) common.Relation[int, uuid.UUID] {
		p, _ := strconv.ParseInt(i.ID, 10, 64)
		return relation[int, uuid.UUID]{
			ID:       int(p),
			ParentID: i.ParentID,
		}
	}), nil
}

// GetCompletedTasks for profiles
func (q *Queries) GetCompletedTasks(ctx context.Context, profileIDs []uuid.UUID) ([]common.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := q.getCompletedTasks(ctx, profileIDs)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getCompletedTasksRow, _ int) common.Relation[uuid.UUID, uuid.UUID] {
		return relation[uuid.UUID, uuid.UUID](i)
	}), nil
}

// GetCompletedAndLockedTasks for profiles
func (q *Queries) GetCompletedAndLockedTasks(ctx context.Context, profileIDs []uuid.UUID) ([]common.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := q.getCompletedAndLockedTasks(ctx, profileIDs)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getCompletedAndLockedTasksRow, _ int) common.Relation[uuid.UUID, uuid.UUID] {
		return relation[uuid.UUID, uuid.UUID](i)
	}), nil
}

// GetCompletedLessons for profiles
func (q *Queries) GetCompletedLessons(ctx context.Context, profileIDs []uuid.UUID) ([]common.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := q.getCompletedLessons(ctx, profileIDs)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getCompletedLessonsRow, _ int) common.Relation[uuid.UUID, uuid.UUID] {
		return relation[uuid.UUID, uuid.UUID](i)
	}), nil
}

// GetCompletedTopics for profiles
func (q *Queries) GetCompletedTopics(ctx context.Context, profileIDs []uuid.UUID) ([]common.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := q.getCompletedTopics(ctx, profileIDs)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getCompletedTopicsRow, _ int) common.Relation[uuid.UUID, uuid.UUID] {
		return relation[uuid.UUID, uuid.UUID](i)
	}), nil
}

// GetSelectedAlternatives returns the alternatives a user selected on a given questions
func (pq *ProfileQueries) GetSelectedAlternatives(ctx context.Context, ids []uuid.UUID) ([]common.SelectedAlternatives, error) {
	rows, err := pq.queries.GetSelectedAlternativesAndLockStatus(ctx, GetSelectedAlternativesAndLockStatusParams{
		ProfileID: pq.profileID,
		TaskIds:   ids,
	})

	if err != nil {
		return nil, err
	}

	return lo.Map(rows, func(i GetSelectedAlternativesAndLockStatusRow, _ int) common.SelectedAlternatives {
		return common.SelectedAlternatives{
			ID:       i.TaskID,
			Selected: i.SelectedAlternatives,
			Locked:   i.Locked,
		}
	}), nil
}

func (pq *ProfileQueries) GetTaskAlternativesAnswersCount(ctx context.Context, ids []uuid.UUID) ([]common.AlternativesTasksProgress, error) {
	rows, err := pq.queries.CountAlternativesAnswers(ctx, CountAlternativesAnswersParams{
		ProfileID: pq.profileID,
		LessonIds: ids,
	})

	if err != nil {
		return nil, err
	}

	return lo.Map(rows, func(i CountAlternativesAnswersRow, _ int) common.AlternativesTasksProgress {
		return common.AlternativesTasksProgress{
			ID:             i.ID,
			TotalTasks:     int(i.CountAll),
			CompletedTasks: int(i.Answered),
			CorrectTasks:   int(i.Correct),
		}
	}), nil
}

// GetDefaultLessonIDForTopicIDs returns the default lessonID
func (pq *ProfileQueries) GetDefaultLessonIDForTopicIDs(ctx context.Context, ids []uuid.UUID) ([]common.Conversion[uuid.UUID, uuid.UUID], error) {
	rows, err := pq.queries.getDefaultLessonIDForTopicIDs(ctx, getDefaultLessonIDForTopicIDsParams{
		ProfileID: pq.profileID,
		TopicIds:  ids,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(row getDefaultLessonIDForTopicIDsRow, _ int) common.Conversion[uuid.UUID, uuid.UUID] {
		return conversion[uuid.UUID, uuid.UUID]{
			source: row.Source,
			result: row.Result,
		}
	}), nil
}
