package loaders

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/google/uuid"
)

// LoadersWithPermissions contains loaders that will be filtered by permissions.
type LoadersWithPermissions struct {
	Key string

	EpisodeFilterLoader     *Loader[int, *int]
	EpisodeUUIDFilterLoader *Loader[uuid.UUID, *uuid.UUID]
	EpisodesLoader          *Loader[int, []*int]
	SeasonFilterLoader      *Loader[int, *int]
	SeasonsLoader           *Loader[int, []*int]
	ShowFilterLoader        *Loader[int, *int]
	ShowUUIDFilterLoader    *Loader[uuid.UUID, *uuid.UUID]
	SectionsLoader          *Loader[int, []*int]
	CalendarEntryLoader     *Loader[int, *common.CalendarEntry]
	StudyTopicFilterLoader  *Loader[uuid.UUID, *uuid.UUID]
	StudyLessonsLoader      *Loader[uuid.UUID, []*uuid.UUID]
	StudyLessonFilterLoader *Loader[uuid.UUID, *uuid.UUID]
	StudyTasksLoader        *Loader[uuid.UUID, []*uuid.UUID]
	StudyTaskFilterLoader   *Loader[uuid.UUID, *uuid.UUID]
	SurveyQuestionsLoader   *Loader[uuid.UUID, []*uuid.UUID]

	FAQQuestionsLoader *Loader[uuid.UUID, []*uuid.UUID]

	//Relations
	StudyLessonEpisodesLoader *Loader[uuid.UUID, []*int]
	EpisodeStudyLessonsLoader *Loader[int, []*uuid.UUID]
	StudyLessonLinksLoader    *Loader[uuid.UUID, []*int]
	LinkStudyLessonsLoader    *Loader[int, []*uuid.UUID]

	// Lists
	PromptIDsLoader       func(ctx context.Context) ([]uuid.UUID, error)
	FAQCategoryIDsLoader  func(ctx context.Context) ([]uuid.UUID, error)
	ShortIDsLoader        func(ctx context.Context) ([][]uuid.UUID, error)
	ShortWithScoresLoader func(ctx context.Context) ([]common.ShortIDWithMeta, error)
}
